--!strict

--[[
	Main.client.lua

	Ponto de entrada do cliente.

	Responsabilidades:
	- Inicializar controllers do cliente na ordem correta
	- Sem lógica de gameplay
]]

local MovementController = require(script.Parent.MovementController)
local SprintController = require(script.Parent.SprintController)
local PunchController = require(script.Parent.PunchController)
local InputController = require(script.Parent.InputController)

local function init(): ()
	MovementController.init()
	SprintController.init()
	PunchController.init()

	-- O Input fica por último para garantir que todos os
	-- controllers já estejam escutando os sinais.
	InputController.init()
end

init()