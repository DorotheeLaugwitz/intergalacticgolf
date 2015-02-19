require ("lib.lclass")

class "Connection"

function Connection:Connection (fromPlanet, toPlanet)
  self.r = 255
  self.g = 0
  self.b = 0

  self.from = fromPlanet
  self.to = toPlanet

  self.start_position = {
    x = fromPlanet.x,
    y = fromPlanet.y
  }

  self.end_position = {
    x = toPlanet.x,
    y = toPlanet.y
  }

  self.dragging = false
end

function Connection:onUpdate (dt)
  if self.dragging then
    mx, my = love.mouse.getPosition ()
    self.to = { x = mx, y = my }
  end
end

function Connection:onRender ()
  love.graphics.push ()
  love.graphics.setColor (self.r, self.g, self.b, 255)
  love.graphics.line(
    self.from.x, self.from.y,
    self.to.x, self.to.y
--    self.start_position.x, self.start_position.y,
--    self.end_position.x, self.end_position.y
  )
  love.graphics.pop()
end

function Connection:onRelease (toPlanet)
  self.dragging = false

  if toPlanet then
    self.to = toPlanet
  end
end

function Connection:handle (event)
end
