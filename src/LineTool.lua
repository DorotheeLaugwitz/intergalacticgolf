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
