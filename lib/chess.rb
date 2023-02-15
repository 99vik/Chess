# frozen_string_literal: true

require_relative 'board'
require_relative 'player'
require_relative 'pieces'
require_relative 'game_messages'

# main class for the chess game, unifies all other classes to make working game
class Chess
  include GameMessages
  attr_reader :board, :current_player, :opponent

  # game initialization

  def initialize
    @board = Board.new
    @player_black = Player.new(:black)
    @player_white = Player.new(:white)
    @current_player = @player_white
    @opponent = @player_black
    initialize_board_values
    initialize_players_pieces
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
    until game_over?
      board.draw_board
      display_current_player_move
      player_move
      switch_player
    end
  end

  def switch_player
    if current_player.eql?(@player_black)
      @current_player = @player_white
      @opponent = @player_black
    else
      @current_player = @player_black
      @opponent = @player_white
    end
  end

  # player pieces

  def initialize_players_pieces
    board.values.reject { |_key, value| value.nil? }
         .select { |_key, value| value.color == :white }
         .each { |_key, value| current_player.pieces << value }

    board.values.reject { |_key, value| value.nil? }
         .select { |_key, value| value.color == :black }
         .each { |_key, value| opponent.pieces << value }
  end

  def remove_piece_from_player(field)
    opponent.pieces.delete(board.values[field])
  end

  # player moves

  def player_move
    move = format_input(input_move)
    return player_move if invalid_move?(move)

    board.values[move[0]].first_move = false if board.values[move[0]].instance_of?(Pawn)
    remove_piece_from_player(move[1]) if opponents_piece_on_field?(move[1])
    move_piece(move)
  end

  def attack_move?(field); end

  def move_piece(move)
    board.values[move[1]] = board.values[move[0]].dup
    board.values[move[0]] = nil
  end

  def invalid_move?(move)
    return true if wrong_piece_on_movefrom?(move[0])
    return true if cannot_reach_moveto?(move)
    return true if own_piece_on_moveto?(move[1])
  end

  def cannot_reach_moveto?(move)
    piece = board.values[move[0]]
    possible_moves = generate_all_possible_moves(move[0], piece)
    return false if possible_moves.include?(move[1])

    cannot_move_to_a_field_msg
    true
  end

  def generate_all_possible_moves(start_position, piece)
    if !piece.unlimited_move
      generate_moves_for_limited_direction(start_position, piece)
    else
      generate_moves_for_unlimited_direction(start_position, piece)
    end
  end

  def generate_moves_for_unlimited_direction(start_position, piece)
    moves = []
    piece.move_directions.each { |direction| moves << generate_moves_in_direction(start_position, direction) }
    moves.flatten!(1)
    moves
  end

  def generate_moves_in_direction(current_position, direction, moves = [])
    current_position = [current_position[0] + direction[0], current_position[1] + direction[1]]
    return moves unless current_position.all? { |i| i.between?(1, 8) }

    moves << current_position
    return moves unless board.values[current_position].nil?

    generate_moves_in_direction(current_position, direction, moves)
  end

  def generate_moves_for_limited_direction(start_position, piece)
    moves = []
    piece.move_directions.each do |i|
      move = [start_position[0] + i[0], start_position[1] + i[1]]
      moves << move if move.all? { |j| j.between?(1, 8) }
    end
    if piece.instance_of?(Pawn)
      moves = modify_pawn_moves(moves)
      (moves = pawn_first_move_option(piece, start_position, moves)) if piece.first_move
    end
    moves
  end

  def pawn_first_move_option(piece, start_position, moves)
    (moves << [start_position[0] + (2 * piece.move_directions[0][0]), start_position[1]]) if board.values[[
      start_position[0] + 2 * piece.move_directions[0][0], start_position[1]
    ]].nil? && board.values[[
      start_position[0] + piece.move_directions[0][0], start_position[1]
    ]].nil?
    moves
  end

  def modify_pawn_moves(moves)
    wrong_diagonal_moves = moves[1..(moves.length - 1)]
    wrong_diagonal_moves.each do |i|
      wrong_diagonal_moves.delete(i) if opponents_piece_on_field?(i)
    end
    wrong_diagonal_moves.each do |j|
      moves.delete(j)
    end
    moves.delete_at(0) if opponents_piece_on_field?(moves[0])
    moves
  end

  def own_on_field(field)
    if board.values[field].nil?
      false
    else
      board.values[field].color == current_player.color
    end
  end

  def opponents_piece_on_field?(field)
    if board.values[field].nil?
      false
    else
      board.values[field].color != current_player.color
    end
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
    [[input[0].to_i, turn_char_in_i(input[1])], [input[2].to_i, turn_char_in_i(input[3])]]
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
