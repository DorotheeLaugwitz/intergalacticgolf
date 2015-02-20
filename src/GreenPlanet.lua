require ("lib.lclass")

class "GreenPlanet"

function GreenPlanet:GreenPlanet (x, y)
  self.gfx = {
    planet = love.graphics.newImage ("gfx/planet_green.png"),
  }


  self.radius = 50
  self.planet = Planet (x, y, self.radius)

  self.x = x
  self.y = y

  self.r = 255
  self.g = 255
  self.b = 255

  self.gfx_x = x - self.gfx.planet:getWidth() / 2
  self.gfx_y = y - self.gfx.planet:getHeight() / 2

  self.clubLocation = {
    x = self.x,
    y = self.y - 50
  }

  self.isHighlighted = false
  self.built = true

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
  self.shader:send(
    "stepSize",
    { 30/love.graphics.getWidth(),
      30/love.graphics.getHeight() }
  )
end

function GreenPlanet:onUpdate (dt)
  self.planet:onUpdate (dt)
end

function GreenPlanet:onRender ()
  love.graphics.push ()
  love.graphics.setColor (self.r, self.g, self.b, 255)

  love.graphics.draw (
    self.gfx.planet,
    self.gfx_x, self.gfx_y
   )

  if self.isHighlighted then
    love.graphics.setShader(self.shader)
    love.graphics.draw (
    self.gfx.planet,
    self.gfx_x, self.gfx_y
    )
    love.graphics.setShader()
  end

  love.graphics.pop()
end

function GreenPlanet:handle (event)
  self.planet:handle (event)
end

function GreenPlanet:hasHitboxIn (position)
  return self.planet:hasHitboxIn (position)
end

function GreenPlanet:onClick ()
  self.planet:onClick ()
end

function GreenPlanet:onRelease ()
  self.planet:onRelease ()
end

function GreenPlanet:build ()
  self.planet:build ()

  if self.planet.built then
    self.built = true
    self.gfx.planet = love.graphics.newImage ("gfx/planet_green_club.png")
    return true
  else
    return false
  end
end
