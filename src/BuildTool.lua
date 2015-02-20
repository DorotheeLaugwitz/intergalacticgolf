require ("lib.lclass")

class "BuildTool"

function BuildTool:BuildTool (game)
  self.game = game
end

function BuildTool:onClick (position)
end

function BuildTool:onRelease (position)
  planet = self.game:planetWithHitboxIn (position)

  if planet then
    cost = planet.buildingCost
    if self.game.wallet:getBalance () >= cost then
      if planet:build () then
        self.game.wallet:withdraw (cost)
        self.game:smokeAt (planet.clubLocation.x, planet.clubLocation.y, 50)
      end
    end
  end
end
