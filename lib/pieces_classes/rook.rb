# frozen_string_literal: true

require_relative '../pieces'
class Rook < Piece
  def initialize(color)
    @color = color
    @symbol = UNICODE_PIECES[:rook][color]
    @unlimited_move = true
    @move_directions = [[1, 0], [-1, 0], [0, 1], [0, -1]]
  end
end