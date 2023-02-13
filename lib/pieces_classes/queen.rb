# frozen_string_literal: true

require_relative '../pieces'
class Queen < Piece
  def initialize(color)
    @color = color
    @symbol = UNICODE_PIECES[:queen][color]
    @unlimited_move = true
    @move_directions = [[1, 0], [-1, 0], [0, 1], [0, -1], [1, 1], [-1, 1], [-1, -1], [1, -1]]
  end
end
