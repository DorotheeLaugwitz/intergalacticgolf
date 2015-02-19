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
  self.segments = 5

  self.scale = 1

  self.dragging = false
end

function Planet:onUpdate (dt)
  if self.dragging then
    mx, my = love.mouse.getPosition()
    self.x = mx
    self.y = my
  end
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

function Planet:hasHitboxIn (position)
  if position.x - self.x <= 5
    and position.x - self.x >= -5
    and position.y - self.y <= 5
    and position.y - self.y >= -5 then

    return true
  end
  return false
end

function Planet:onClick ()
  self.dragging = true
end

function Planet:onRelease ()
  self.dragging = false
end
