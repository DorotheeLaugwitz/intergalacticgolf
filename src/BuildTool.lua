require ("lib.lclass")

class "BuildTool"

function BuildTool:BuildTool (game)
  self.game = game
end

function BuildTool:onClick (position)
  planet = self.game:planetWithHitboxIn (position)

  if planet then
    planet:build ()
  end
end
