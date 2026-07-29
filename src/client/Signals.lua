--!strict

--[[
	Signals.lua

	Registro central de sinais do cliente.

	Responsabilidades:
	- Implementar conexões desacopladas entre controllers
	- Expor instâncias nomeadas para input, sprint, movimento e futuros sistemas
	- Evitar callbacks diretos entre módulos
]]

export type Connection = {
	Disconnect: (self: Connection) -> (),
}

export type Signal<T...> = {
	Connect: (self: Signal<T...>, callback: (T...) -> ()) -> Connection,
	Fire: (self: Signal<T...>, T...) -> (),
	Destroy: (self: Signal<T...>) -> (),
}

type ConnectionEntry = {
	callback: (...any) -> (),
	connection: Connection,
}

local function createSignal<T...>(): Signal<T...>
	local connections: { ConnectionEntry } = {}

	local signal = {} :: Signal<T...>

	function signal:Connect(callback: (T...) -> ()): Connection
		local connection: Connection
		connection = {
			Disconnect = function()
				for index, entry in connections do
					if entry.connection == connection then
						table.remove(connections, index)
						break
					end
				end
			end,
		}

		table.insert(connections, {
			callback = callback,
			connection = connection,
		})

		return connection
	end

	function signal:Fire(...: T...)
		for _, entry in connections do
			entry.callback(...)
		end
	end

	function signal:Destroy(): ()
		table.clear(connections)
	end

	return signal
end

local Signals = {
	-- InputController → SprintController: intenção de sprint do jogador.
	SprintRequested = createSignal(),

	-- SprintController → MovementController: estado autoritativo de sprint.
	SprintChanged = createSignal(),

	-- InputController → PunchController: intenção de ataque do jogador.
	PunchRequested = createSignal(),
}

return Signals
