require ("lib.lclass")

class "Connection"

function Connection:Connection (fromPlanet, toPlanet)
  self.gfx = {
-- TODO use planet graphic
--    ship = love.graphics.newImage ("gfx/schiff.png"),
  }
  self.r = 255
  self.g = 255
  self.b = 255

  self.start_x = fromPlanet.x
  self.start_y = fromPlanet.y

  self.end_x = toPlanet.x
  self.end_y = toPlanet.y
end

function Connection:onUpdate (dt)
end

function Connection:onRender ()
  love.graphics.setColor (self.r, self.g, self.b, 255)
  love.graphics.push ()
  love.graphics.line(
    self.start_x, self.start_y,
    self.end_x, self.end_y
  )
--    love.graphics.draw (
--      self.gfx.ship,
--      self.x, self.y
--    )
  love.graphics.pop()
  love.graphics.setColor (255, 255, 255, 255)
end

function Connection:handle (event)
end
