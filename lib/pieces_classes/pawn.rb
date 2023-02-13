require_relative '../pieces'

class Pawn < Piece
  def initialize(color)
    @color = color
    @symbol = UNICODE_PIECES[:pawn][color]
    @unlimited_move = false
    create_move_direction
  end

def create_move_direction
    if color == :black
      @move_directions = [[-1, 0]]
    else
      @move_directions = [[1, 0]]
    end
  end
end