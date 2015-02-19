require ("lib.lclass")

class "Planet"

function Planet:Planet (x, y)
  self.gfx = {
-- TODO use planet graphic
--    ship = love.graphics.newImage ("gfx/schiff.png"),
  }
  self.r = 255
  self.g = 255
  self.b = 255
  self.x = x
  self.y = y

  self.radius = 5
  self.segments = 10

  self.scale = 1

end

function Planet:onUpdate (dt)
end

function Planet:onRender ()
  love.graphics.setColor (self.r, self.g, self.b, 255)
  love.graphics.push ()
  love.graphics.circle(
    "fill",
    self.x,
    self.y, 
    self.radius,
    self.segments
  )
--    love.graphics.draw (
--      self.gfx.ship,
--      self.x, self.y
--    )
  love.graphics.pop()
  love.graphics.setColor (255, 255, 255, 255)
end

function Planet:handle (event)
end
