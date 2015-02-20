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

require ("src.GreenPlanet")
require ("src.BluePlanet")
require ("src.RedPlanet")
require ("src.Planet")
require ("src.LineTool")
require ("src.BuildTool")
require ("src.Connection")

require ("src.Wallet")

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

  self.bg = love.graphics.newImage("gfx/background2.png")

  self.log = {}

  self.font = love.graphics.newFont("gfx/font2.ttf", 42)
  love.graphics.setFont(self.font)

  self.planets = {
    GreenPlanet (400, 200),
    RedPlanet (600, 400),
    BluePlanet (800, 200)
  }

  self.wallet = Wallet ()

  self.lines = {}

  self.mouseX = 0
  self.mouseY = 0

  self.reactions = {
    KeyboardKeyUpEvent = function (event)
      local switch = {
        ['1'] = function ()
          self.tool = LineTool (self)
        end,
        ['2'] = function ()
          self.tool = BuildTool (self)
        end,
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
      self:onRelease (event.position)
    end
  }

  self.tool = LineTool (self)

  self.smoke = love.graphics.newParticleSystem(
    love.graphics.newImage("gfx/particle.png"),
    1000
  )
  self.smoke:setEmitterLifetime(2)
  self.smoke:setParticleLifetime(2, 3)
  self.smoke:setEmissionRate(100)
  self.smoke:setSizeVariation(1)
  self.smoke:setLinearAcceleration(
    -20,
    -20,
    20,
    20
  )
  self.smoke:setColors(255, 255, 255, 255, 255, 255, 255, 0)
  self.smoke:stop()

  self.particles = {}
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

  self.wallet:add(1 * dt)

  self.eventManager:update (dt)

  for _, line in pairs(self.lines) do
    line:onUpdate (dt)
  end

  self:highlightHovered()

  for _, planet in pairs(self.planets) do
    planet:onUpdate (dt)
  end

  if self.line then
    self.line:onUpdate (dt)
  end

  for _, p in pairs(self.particles) do
    p:update (dt)
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

  for _, line in pairs(self.lines) do
    line:onRender ()
  end

  if self.line then
    self.line:onRender ()
  end

  for _, planet in pairs(self.planets) do
    planet:onRender ()
  end

  for _, p in pairs(self.particles) do
    love.graphics.draw(p)
  end
  width, height = love.window.getDesktopDimensions(1)

  love.graphics.push()
  love.graphics.setColor (255, 0, 0, 255)
  str = "x: " .. self.mouseX .. ", y: " .. self.mouseY
  love.graphics.print (str, 100, 100)
  love.graphics.setColor (255, 255, 255, 255)
  love.graphics.print (self.wallet:balanceAsString(), width-100, height-100)
  love.graphics.pop()

end

-- Gets called when game exits. May be used to do some clean up.
function Game:onExit ()
  --
end

function Game:onClick (position)
  self.tool:onClick (position)
end

function Game:onRelease (position)
  for _, planet in pairs (self.planets) do
    planet:onRelease ()
  end

  if self.line then
    self.hasline = true
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

function Game:highlightHovered ()
  mx, my = love.mouse.getPosition()

  position = {x = mx, y = my}

  for _, planet in pairs (self.planets) do
    if planet:hasHitboxIn (position) then
      planet.isHighlighted = true
    else
      planet.isHighlighted = false
    end
  end
end

function Game:issueCommand (command)
  table.insert (self.commands, command)
end

function Game:smokeAt (x, y, radius)
  p = self.smoke:clone()
  p:setPosition(x, y)
  p:start()
  self.particles[#self.particles+1] = p
end
