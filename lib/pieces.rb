require_relative 'pieces_classes/pieces_unicode'

class Piece
  include PiecesUnicode

  attr_reader :color, :move_directions, :symbol, :unlimited_move

end

require_relative 'pieces_classes/pawn'
require_relative 'pieces_classes/king'
require_relative 'pieces_classes/bishop'
require_relative 'pieces_classes/knight'
require_relative 'pieces_classes/queen'
require_relative 'pieces_classes/rook'