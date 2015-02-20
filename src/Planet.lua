require ("lib.lclass")

class "Planet"

function Planet:Planet (x, y)
  self.gfx = {
-- TODO use planet graphic
    planet = love.graphics.newImage ("gfx/splanet.png"),
  }
  self.r = 255
  self.g = 255
  self.b = 255
  self.x = x
  self.y = y

  self.radius = 50
  self.segments = 10

  self.scale = 1

  self.isClicked = false
  self.dragging = false

  local pixelcode = [[
  vec4 resultCol;
  extern vec2 stepSize;

  number alpha;

  vec4 effect( vec4 col, Image texture, vec2 texturePos, vec2 screenPos )
  {
    // get color of pixels:
    number alpha = 4*texture2D( texture, texturePos ).a;
    alpha -= texture2D( texture, texturePos + vec2( stepSize.x, 0.0f ) ).a;
    alpha -= texture2D( texture, texturePos + vec2( -stepSize.x, 0.0f ) ).a;
    alpha -= texture2D( texture, texturePos + vec2( 0.0f, stepSize.y ) ).a;
    alpha -= texture2D( texture, texturePos + vec2( 0.0f, -stepSize.y ) ).a;
    // calculate resulting color
    resultCol = vec4( 1.0f, 1.0f, 1.0f, alpha );
    // return color for current pixel
    return resultCol;
  }
  ]]

  self.shader = love.graphics.newShader(pixelcode)
  self.shader:send( "stepSize",{30/love.graphics.getWidth(),30/love.graphics.getHeight()} )

  self.reactions = {
    KeyboardKeyDownEvent = function (event)
      local switch = {
        h = function ()
          self.isClicked = not self.isClicked
        end
      }

      local case = switch[event:Key ()]
      if case then
        case()
      end
    end

  }
end

function Planet:onUpdate (dt)
  if self.dragging then
    mx, my = love.mouse.getPosition()
    self.x = mx
    self.y = my
  end
end

function Planet:onRender ()
  love.graphics.push ()
  love.graphics.setColor (self.r, self.g, self.b, 255)

  love.graphics.draw (
    self.gfx.planet,
    self.x, self.y
   )

  if self.isClicked then
    love.graphics.setShader(self.shader)
    love.graphics.draw (
    self.gfx.planet,
    self.x, self.y
    )
    love.graphics.setShader()
  end

--  love.graphics.circle(
--    "fill",
--    self.x,
--    self.y,
--    self.radius,
--    self.segments
--  )


--    love.graphics.draw (
--      self.gfx.planet,
--      self.x, self.y
--    )
  love.graphics.pop()
end

function Planet:handle (event)
  local reaction = self.reactions[event:getClass()]
  if reaction then
    reaction (event)
  end
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
