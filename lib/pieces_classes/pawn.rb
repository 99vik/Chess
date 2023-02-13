# frozen_string_literal: true

require_relative '../pieces'

class Pawn < Piece
  def initialize(color)
    @color = color
    @symbol = UNICODE_PIECES[:pawn][color]
    @unlimited_move = false
    create_move_direction
  end

  def create_move_direction
    @move_directions = if color == :black
                         [[-1, 0]]
                       else
                         [[1, 0]]
                       end
  end
end
