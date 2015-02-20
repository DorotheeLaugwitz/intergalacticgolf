require ("lib.lclass")

class "LineTool"

function LineTool:LineTool (game)
  self.game = game
end

function LineTool:onClick (position)
  planet = self.game:planetWithHitboxIn (position)

  if planet and not self.game.line then
    self.game.line = Connection (planet, position)
    self.game.line.dragging = true
  end
end

function LineTool:onRelease (position)
       -- self.game:smokeAt (planet.clubLocation.x, planet.clubLocation.y, 50)
  if self.game.line then
    planet = self.game:planetWithHitboxIn (position)
    cost = self.game.line:getBuildingCost ()
    if planet and (self.game.wallet:getBalance () >= cost) then
      self.game.wallet:withdraw (cost)
      self.game.line:onRelease (planet)
      self.game.lines[#self.game.lines + 1] = self.game.line:copy()
    end
    self.game.line = nil
  end
end
