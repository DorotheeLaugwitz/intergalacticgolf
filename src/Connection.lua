require ("lib.lclass")

class "Connection"

function Connection:Connection (fromPlanet, toPlanet)
  self.r = 255
  self.g = 255
  self.b = 100

  self.width = 5

  self.from = fromPlanet
  self.to = toPlanet

  self.dragging = false
end

function Connection:onUpdate (dt)
  self.r = (self.r + dt * 100) % 255
  if self.dragging then
    mx, my = love.mouse.getPosition ()
    self.to = { x = mx, y = my }
  end
end

function Connection:onRender ()
  love.graphics.push ()
  love.graphics.setColor (self.r, self.g, self.b, 255)
  love.graphics.setLineWidth (self.width)
  love.graphics.line(
    self.from.x, self.from.y,
    self.to.x, self.to.y
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

function Connection:copy ()
  return Connection(self.from, self.to)
end
