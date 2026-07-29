--!strict

--[[
	Main.client.lua

	Ponto de entrada do cliente.

	Responsabilidades:
	- Inicializar controllers do cliente na ordem correta
	- Sem lógica de gameplay
]]

local InputController = require(script.Parent.InputController)
local MovementController = require(script.Parent.MovementController)
local SprintController = require(script.Parent.SprintController)

local function init(): ()
	InputController.init()
	MovementController.init()
	SprintController.init()
end

init()
