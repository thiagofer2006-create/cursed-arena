--!strict

--[[
	Config.lua

	Fonte única de verdade para valores numéricos e parâmetros de gameplay.

	Responsabilidades:
	- Centralizar constantes de movimento, combate e dano
	- Evitar números mágicos espalhados pelo código
	- Facilitar balanceamento sem alterar lógica de sistemas
]]

local Config = {}

-- Movimento
Config.WalkSpeed = 16
Config.SprintSpeed = 28

-- Combate
Config.ComboResetTime = 1.2
Config.PunchDamage = 8

return Config
