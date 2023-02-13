require_relative '../colorize'

module PiecesUnicode
  UNICODE_PIECES = {
    :king => {
        :black => " ♔ ".black,
        :white => " ♔ "
    },
    :queen => {
        :black => " ♕ ".black,
        :white => " ♕ "
    },
    :pawn => {
        :black => " ♙ ".black,
        :white => " ♙ "
    },
    :bishop => {
        :black => " ♗ ".black,
        :white => " ♗ "
    },
    :rook => {
        :black => " ♖ ".black,
        :white => " ♖ "
    },
    :knight => {
        :black => " ♘ ".black,
        :white => " ♘ "
    }
  }
end