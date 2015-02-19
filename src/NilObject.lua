require ("lib.lclass")

class "NilObject"

function NilObject:NilObject (x, y)
end

function NilObject:onUpdate (dt)
end

function NilObject:onRender ()
end

function NilObject:handle (event)
end

function NilObject:hasHitboxIn (position)
  return false
end

function NilObject:onClick ()
end

function NilObject:onRelease ()
end
