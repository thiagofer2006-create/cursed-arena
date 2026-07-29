--!strict

--[[
	InputController.lua

	Camada central de input do cliente.

	Responsabilidades:
	- Escutar ações do jogador (teclado, gamepad, mobile)
	- Disparar sinais de input para outros controllers
	- Evitar duplicação de UserInputService/ContextActionService nos módulos
]]

local UserInputService = game:GetService("UserInputService")

local Signals = require(script.Parent.Signals)

local SPRINT_KEY = Enum.KeyCode.LeftShift

local InputController = {}

local inputBeganConnection: RBXScriptConnection? = nil
local inputEndedConnection: RBXScriptConnection? = nil

local function onInputBegan(input: InputObject, gameProcessed: boolean): ()
	if gameProcessed then
		return
	end

	if input.KeyCode == SPRINT_KEY then
		Signals.SprintRequested:Fire(true)
	end
end

local function onInputEnded(input: InputObject, _gameProcessed: boolean): ()
	-- Sempre processa o release do Shift para evitar sprint preso.
	if input.KeyCode == SPRINT_KEY then
		Signals.SprintRequested:Fire(false)
	end
end

function InputController.init(): ()
	inputBeganConnection = UserInputService.InputBegan:Connect(onInputBegan)
	inputEndedConnection = UserInputService.InputEnded:Connect(onInputEnded)
end

function InputController.destroy(): ()
	if inputBeganConnection then
		inputBeganConnection:Disconnect()
		inputBeganConnection = nil
	end

	if inputEndedConnection then
		inputEndedConnection:Disconnect()
		inputEndedConnection = nil
	end
end

return InputController
