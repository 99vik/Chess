# frozen_string_literal: true

require_relative '../pieces'

class Pawn < Piece
  attr_accessor :first_move

  def initialize(color)
    @color = color
    @symbol = UNICODE_PIECES[:pawn][color]
    @unlimited_move = false
    @first_move = true
    create_move_direction
  end

  def create_move_direction
    @move_directions = if color == :black
                         [[-1, 0], [-1, -1], [-1, 1]]
                       else
                         [[1, 0], [1, 1], [1, -1]]
                       end
  end
end
