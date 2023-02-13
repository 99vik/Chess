require_relative 'board'
require_relative 'player'
require_relative 'pieces'

class Chess
  attr_reader :board

  def initialize
    @board = Board.new
    @player_black = Player.new('black')
    @player_white = Player.new('white')
    initialize_board_values
    board.draw_board
  end

  def initialize_board_values
    initialize_pawns
    initialize_bishops
    initialize_kings
    initialize_knights
    initialize_queens
    initialize_rooks
  end

  def initialize_pawns
    for i in 1..8 do
      board.values[[7, i]] = Pawn.new(:black)
      board.values[[2, i]] = Pawn.new(:white)
    end
  end

  def initialize_bishops
    for i in [3, 6] do
      board.values[[8, i]] = Bishop.new(:black)
      board.values[[1, i]] = Bishop.new(:white)
    end
  end

  def initialize_knights
    for i in [2, 7] do
      board.values[[8, i]] = Knight.new(:black)
      board.values[[1, i]] = Knight.new(:white)
    end
  end

  def initialize_rooks
    for i in [1, 8] do
      board.values[[8, i]] = Rook.new(:black)
      board.values[[1, i]] = Rook.new(:white)
    end
  end

  def initialize_queens
    board.values[[8, 4]] = Queen.new(:black)
    board.values[[1, 4]] = Queen.new(:white)
  end

  def initialize_kings
    board.values[[8, 5]] = King.new(:black)
    board.values[[1, 5]] = King.new(:white)
  end
end