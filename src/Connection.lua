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
  if self.dragging then
    width, height = love.window.getDesktopDimensions(1)
    love.graphics.setColor (255, 0, 0, 255)
    love.graphics.print(
      tostring(math.floor(self:getLength()/2)),
      width-250,
      height - 100
    )
  end
  love.graphics.pop()
end

function Connection:onRelease (toPlanet)
  self.dragging = false

  if toPlanet then
    self.to = toPlanet
    self.buildingCost = self:getBuildingCost()
  end
end

function Connection:handle (event)
end

function Connection:copy ()
  return Connection(self.from, self.to)
end

function Connection:getLength ()
  a = self.to.x - self.from.x
  b = self.to.y - self.from.y

  return math.sqrt(a^2 + b^2)
end


function Connection:getBuildingCost ()
  -- based on line length
  if not self.buildingCost then
    return self:getLength () / 2
  else
    return self.buildingCost
  end
end

function Connection:income ()
  if self.dragging then
    return 0
  else
    return self:getBuildingCost() / 100
  end
end
