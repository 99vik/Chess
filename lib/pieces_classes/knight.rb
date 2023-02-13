# frozen_string_literal: true

require_relative '../pieces'
class Knight < Piece
  def initialize(color)
    @color = color
    @symbol = UNICODE_PIECES[:knight][color]
    @unlimited_move = false
    @move_directions = [[1, 2], [-1, 2], [1, -2], [-1, -2], [2, 1], [-2, 1], [2, -1], [-2, -1]]
  end
end
