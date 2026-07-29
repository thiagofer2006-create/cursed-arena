--!strict

--[[
	SprintController.lua

	Gerencia o estado de sprint no cliente.

	Responsabilidades:
	- Escutar intenção de sprint via Signals.SprintRequested
	- Manter o estado autoritativo de sprint (única fonte de verdade)
	- Disparar Signals.SprintChanged quando o estado mudar
	- Expor consulta de estado para outros controllers
]]

local Signals = require(script.Parent.Signals)

type SignalConnection = { Disconnect: (self: SignalConnection) -> () }

local SprintController = {}

local isSprinting = false
local sprintRequestedConnection: SignalConnection? = nil

local function setSprinting(active: boolean): ()
	if isSprinting == active then
		return
	end

	isSprinting = active
	Signals.SprintChanged:Fire(isSprinting)
end

local function onSprintRequested(isRequested: boolean): ()
	setSprinting(isRequested)
end

-- Retorna o estado autoritativo de sprint.
function SprintController.isSprinting(): boolean
	return isSprinting
end

function SprintController.init(): ()
	sprintRequestedConnection = Signals.SprintRequested:Connect(onSprintRequested)
end

function SprintController.destroy(): ()
	if sprintRequestedConnection then
		sprintRequestedConnection:Disconnect()
		sprintRequestedConnection = nil
	end

	isSprinting = false
end

return SprintController
