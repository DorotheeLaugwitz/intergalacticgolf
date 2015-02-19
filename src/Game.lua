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
require ("src.Connection")

class "Game"

-- Constructs a new game
function Game:Game ()
  self.eventManager = EventManager ()

  self.eventManager:subscribe ("FocusGainedEvent", self)
  self.eventManager:subscribe ("FocusLostEvent", self)
  self.eventManager:subscribe ("KeyboardKeyDownEvent", self)
  self.eventManager:subscribe ("KeyboardKeyUpEvent", self)
  self.eventManager:subscribe ("MouseButtonDownEvent", self)
  self.eventManager:subscribe ("MouseButtonUpEvent", self)
  self.eventManager:subscribe ("ResizeEvent", self)

  self.commands = {}

  self.bg = love.graphics.newImage("gfx/background.png")

  self.log = {}

  self.planets = {
    Planet (400, 200),
    Planet (450, 300),
    Planet (500, 200)
  }

  self.lines = {}

  self.mouseX = 0
  self.mouseY = 0

--  self.eventManager:subscribe ("KeyboardKeyUpEvent", self.shipoflife)

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
    end,

    MouseButtonDownEvent = function (event)
      self:onClick(event.position)

      self.mouseX = event:x()
      self.mouseY = event:y()
    end,

    MouseButtonUpEvent = function (event)
      self:onRelease(event.position)
    end
  }

end

-- Raises (queues) a new event
function Game:raise (event)
  self.eventManager:push (event)
end

-- Callback used by EventManager
function Game:handle (event)
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

  for _, line in pairs(self.lines) do
    line:onUpdate (dt)
  end

  for _, planet in pairs(self.planets) do
    planet:onUpdate (dt)
  end

  if self.line then
    self.line:onUpdate (dt)
  end
end

-- Renders stuff onto the screen
function Game:onRender ()
  love.graphics.setColor (255, 255, 255, 255)
  local width = love.graphics.getWidth()
  local height = love.graphics.getHeight()
--  local scaleX = width / self.bg:getWidth()
--  local scaleY = height / self.bg:getHeight()
  love.graphics.draw(self.bg, 0, 0, 0, scaleX, scaleY)

  if self.line then
    self.line:onRender ()
  end

  for _, line in pairs(self.lines) do
    line:onRender ()
  end

  for _, planet in pairs(self.planets) do
    planet:onRender ()
  end

  love.graphics.push()
  love.graphics.setColor (255, 0, 0, 255)
  str = "x: " .. self.mouseX .. ", y: " .. self.mouseY
  love.graphics.print (str, 100, 100)
  love.graphics.pop()

end

-- Gets called when game exits. May be used to do some clean up.
function Game:onExit ()
  --
end

function Game:onClick (position)
  planet = self:planetWithHitboxIn (position)

  if planet and not self.line then
    self.line = Connection (planet, position)
    self.line.dragging = true
  end
end

function Game:onRelease (position)
  for _, planet in pairs (self.planets) do
    planet:onRelease ()
  end

  if self.line then
    planet = self:planetWithHitboxIn (position)
    if planet then
      self.line:onRelease (planet)
      self.lines[#self.lines + 1] = self.line:copy()
    end
    self.line = nil
  end
end

function Game:planetWithHitboxIn (position)
  for _, planet in pairs (self.planets) do
    if planet:hasHitboxIn (position) then
      return planet
    end
  end
  return nil
end

function Game:issueCommand (command)
  table.insert (self.commands, command)
end
