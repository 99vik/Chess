require_relative '../pieces'

class Bishop < Piece
    def initialize(color)
      @color = color
      @symbol = UNICODE_PIECES[:bishop][color]
      @unlimited_move = true
      @move_directions = [[1, 1], [-1, 1], [-1, -1], [1 , -1]]
    end
end
  