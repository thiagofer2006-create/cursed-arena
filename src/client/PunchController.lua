--!strict

--[[
	PunchController.lua

	Responsabilidades:
	- Receber solicitações de Punch.
	- Centralizar a lógica do sistema de socos.
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")

local Signals = require(script.Parent.Signals)

local PunchController = {}

local connection = nil

function PunchController.init(): ()
	print("PunchController iniciado")

	connection = Signals.PunchRequested:Connect(function()
		local player = Players.LocalPlayer
		if not player then
			return
		end

		local character = player.Character
		if not character then
			return
		end

		local rootPart = character:FindFirstChild("HumanoidRootPart")
		if not rootPart then
			return
		end

		local overlapParams = OverlapParams.new()
		overlapParams.FilterType = Enum.RaycastFilterType.Exclude
		overlapParams.FilterDescendantsInstances = {character}

		local hitboxCFrame = rootPart.CFrame * CFrame.new(0, 0, -3)
		local parts = Workspace:GetPartBoundsInBox(hitboxCFrame, Vector3.new(4, 4, 4), overlapParams)

		for _, part in ipairs(parts) do
			local model = part:FindFirstAncestorOfClass("Model")
			if model and model ~= character and model:FindFirstChildOfClass("Humanoid") then
				print("Dummy atingido!")
				break
			end
		end
	end)
end

function PunchController.destroy(): ()
	if connection then
		connection:Disconnect()
		connection = nil
	end
end

return PunchController