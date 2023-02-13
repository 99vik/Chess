# frozen_string_literal: true

require_relative '../pieces'
class King < Piece
  def initialize(color)
    @color = color
    @symbol = UNICODE_PIECES[:king][color]
    @unlimited_move = false
    @move_directions = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [-1, -1], [1, -1]]
  end
end
