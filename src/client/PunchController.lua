--!strict

--[[
	PunchController.lua

	Responsabilidades:
	- Receber solicitações de Punch.
	- Centralizar a lógica do sistema de socos.
]]

local Signals = require(script.Parent.Signals)

local PunchController = {}

local connection = nil

function PunchController.init(): ()
	print("PunchController iniciado")

	connection = Signals.PunchRequested:Connect(function()
		print("Punch!")
	end)
end

function PunchController.destroy(): ()
	if connection then
		connection:Disconnect()
		connection = nil
	end
end

return PunchController