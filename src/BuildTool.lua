require ("lib.lclass")

class "BuildTool"

function BuildTool:BuildTool (game)
  self.game = game
end

function BuildTool:onClick (position)
  planet = self.game:planetWithHitboxIn (position)

  if planet then
    if planet:build () then
      self.game:smokeAt (planet.clubLocation.x, planet.clubLocation.y, 50)
    end
  end
end
