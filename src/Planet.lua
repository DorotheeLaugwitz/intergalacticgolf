require ("lib.lclass")

class "Planet"

function Planet:Planet (x, y, radius)
  self.x = x
  self.y = y

  self.radius = 50

  self.isClicked = false
  self.dragging = false

  self.built = false
end

function Planet:onUpdate (dt)
  -- TODO legacy crap
  if self.dragging then
    mx, my = love.mouse.getPosition()
    self.x = mx
    self.y = my
  end
end

function Planet:handle (event)
  local reaction = self.reactions[event:getClass()]
  if reaction then
    reaction (event)
  end
end

function Planet:hasHitboxIn (position)
  if position.x - self.x <= self.radius
    and position.x - self.x >= -self.radius
    and position.y - self.y <= self.radius
    and position.y - self.y >= -self.radius then

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

function Planet:build ()
-- TODO implement
  self.built = true
end
