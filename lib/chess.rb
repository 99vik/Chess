# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'pieces'
require_relative 'game_messages'

# main class for the chess game, unifies all other classes to make working game
class Chess
  include GameMessages
  attr_reader :board, :current_player

  # game initialization
  def initialize
    @board = Board.new
    @player_black = Player.new(:black)
    @player_white = Player.new(:white)
    @current_player = @player_white
    initialize_board_values
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
    (1..8).each do |i|
      board.values[[7, i]] = Pawn.new(:black)
      board.values[[2, i]] = Pawn.new(:white)
    end
  end
  
  def initialize_bishops
    [3, 6].each do |i|
      board.values[[8, i]] = Bishop.new(:black)
      board.values[[1, i]] = Bishop.new(:white)
    end
  end
  
  def initialize_knights
    [2, 7].each do |i|
      board.values[[8, i]] = Knight.new(:black)
      board.values[[1, i]] = Knight.new(:white)
    end
  end

  def initialize_rooks
    [1, 8].each do |i|
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

  # game loop

  def play
    until game_over? do
    board.draw_board
    display_current_player_move
    player_move
    switch_player
    end
  end

  def switch_player
    if current_player.eql?(@player_black)
      @current_player = @player_white
    else
      @current_player = @player_black
    end
  end

  # player moves
  def player_move
    move = format_input(input_move)
    return player_move if invalid_move?(move)
    p board.values[move[0]]
    print move[1]
    p board.values[move[1]]
  end

  def invalid_move?(move)
    return true if wrong_piece_on_movefrom?(move[0])
    return true if own_piece_on_moveto?(move[1])
  end

  def wrong_piece_on_movefrom?(move_from)
    if board.values[move_from].nil?
      empty_choosen_field_msg
      true
    elsif board.values[move_from].color != current_player.color
      wrong_choosen_color_field_msg
      true
    else
      false
    end
  end

  def own_piece_on_moveto?(move_to)
    if board.values[move_to].nil?
      false
    elsif board.values[move_to].color == current_player.color
      your_own_piece_on_moveto_msg
      true
    else
      false
    end
  end

  def input_move
    move = gets.strip.downcase.delete(' ').split('')
    return move if valid_input?(move)
    wrong_input_msg
    input_move
  end

  def valid_input?(move)
    move.length == 4 && (1..8).to_a.include?(move[0].to_i) && (1..8).to_a.include?(move[2].to_i) && ('a'..'h').to_a.include?(move[1]) && ('a'..'h').to_a.include?(move[3])
  end

  def format_input(input)
    [[input[0].to_i, turn_char_in_i(input[1])], [input[2].to_i, turn_char_in_i(input[3])] ]
  end

  def turn_char_in_i(char)
    ('a'..'h').to_a.index(char) + 1
  end

  def game_over?
    false
  end

  def display_current_player_move
    puts
    puts "#{current_player.color.capitalize}'s turn!"
  end
end
