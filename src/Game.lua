require ("lib.lclass")

require ("src.EventManager")

require ("src.data.PositionData")

require ("src.events.FocusGainedEvent")
require ("src.events.FocusLostEvent")
require ("src.events.KeyboardKeyDownEvent")
require ("src.events.KeyboardKeyUpEvent")
require ("src.events.MouseButtonDownEvent")
require ("src.events.MouseButtonUpEvent")
require ("src.events.ResizeEvent")

require ("src.Planet")

class "Game"

-- Constructs a new game
function Game:Game ()
	--
	self.eventManager = EventManager ()

	self.eventManager:subscribe ("FocusGainedEvent", self)
	self.eventManager:subscribe ("FocusLostEvent", self)
	self.eventManager:subscribe ("KeyboardKeyDownEvent", self)
	self.eventManager:subscribe ("KeyboardKeyUpEvent", self)
	self.eventManager:subscribe ("MouseButtonDownEvent", self)
	self.eventManager:subscribe ("MouseButtonUpEvent", self)
	self.eventManager:subscribe ("ResizeEvent", self)

	self.commands = {}

--	self.bg = love.graphics.newImage("gfx/bg.png")

	self.log = {}
  self.planet = Planet (200, 200)
  self.planet2 = Planet (300, 200)
--	self.eventManager:subscribe ("KeyboardKeyUpEvent", self.shipoflife)

	self.reactions = {
		KeyboardKeyUpEvent = function (event)
			local switch = {
				escape = function ()
					love.event.quit()
				end,
				q = function ()
					love.event.quit()
				end
			}

			local case = switch[event:Key ()]
			if case then
				case ()
			end
		end
	}

end

-- Raises (queues) a new event
function Game:raise (event)
	--
	self.eventManager:push (event)
end

-- Callback used by EventManager
function Game:handle (event)
	--
	local reaction = self.reactions[event:getClass()]
	if reaction then
		reaction (event)
	end
end

-- Updates game logic
function Game:onUpdate (dt)
	for _, command in pairs (self.commands) do
		command:execute (dt)
	end
	self.commands = {}

	self.eventManager:update (dt)
--	self.shipoflife:onUpdate (dt)
end

-- Renders stuff onto the screen
function Game:onRender ()
	--
	local width = love.graphics.getWidth()
	local height = love.graphics.getHeight()
--	local scaleX = width / self.bg:getWidth()
--	local scaleY = height / self.bg:getHeight()
--	love.graphics.draw(self.bg, 0, 0, 0, scaleX, scaleY)

  self.planet:onRender()
  self.planet2:onRender()
end

-- Gets called when game exits. May be used to do some clean up.
function Game:onExit ()
	--
end

function Game:issueCommand (command)
	table.insert (self.commands, command)
end
