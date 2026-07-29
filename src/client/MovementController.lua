--!strict

--[[
	MovementController.lua

	Gerencia a velocidade de movimento do personagem local.

	Responsabilidades:
	- Escutar mudanças de sprint via Signals.SprintChanged
	- Aplicar WalkSpeed no Humanoid com base no estado do SprintController
	- Gerenciar ciclo de vida do personagem (spawn, respawn, cleanup)
]]

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Config = require(ReplicatedStorage.Shared.Config)
local Signals = require(script.Parent.Signals)
local SprintController = require(script.Parent.SprintController)

type SignalConnection = { Disconnect: (self: SignalConnection) -> () }

local MovementController = {}

local player = Players.LocalPlayer
local currentHumanoid: Humanoid? = nil

local sprintChangedConnection: SignalConnection? = nil
local characterAddedConnection: RBXScriptConnection? = nil
local characterRemovingConnection: RBXScriptConnection? = nil

-- Consulta o SprintController e aplica a velocidade correspondente.
local function applyWalkSpeed(): ()
	local humanoid = currentHumanoid
	if not humanoid then
		return
	end

	humanoid.WalkSpeed = if SprintController.isSprinting() then Config.SprintSpeed else Config.WalkSpeed
end

local function onSprintChanged(_isSprinting: boolean): ()
	applyWalkSpeed()
end

local function onCharacterAdded(character: Model): ()
	local humanoid = character:WaitForChild("Humanoid") :: Humanoid
	currentHumanoid = humanoid
	applyWalkSpeed()
end

local function onCharacterRemoving(_character: Model): ()
	currentHumanoid = nil
end

function MovementController.init(): ()
	sprintChangedConnection = Signals.SprintChanged:Connect(onSprintChanged)

	characterAddedConnection = player.CharacterAdded:Connect(onCharacterAdded)
	characterRemovingConnection = player.CharacterRemoving:Connect(onCharacterRemoving)

	if player.Character then
		onCharacterAdded(player.Character)
	end
end

function MovementController.destroy(): ()
	if sprintChangedConnection then
		sprintChangedConnection:Disconnect()
		sprintChangedConnection = nil
	end

	if characterAddedConnection then
		characterAddedConnection:Disconnect()
		characterAddedConnection = nil
	end

	if characterRemovingConnection then
		characterRemovingConnection:Disconnect()
		characterRemovingConnection = nil
	end

	currentHumanoid = nil
end

return MovementController
