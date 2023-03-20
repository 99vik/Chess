# frozen_string_literal: true

require 'erb'
require 'json'
require_relative 'board'
require_relative 'player'
require_relative 'bot'
require_relative 'pieces'
require_relative 'game_messages'

# main class for the chess game, unifies all other classes to make working game
class Chess
  include GameMessages
  attr_reader :board, :current_player, :opponent, :last_move, :check

  # game initialization

  def initialize
    @board = Board.new
    @player_white = Player.new(:white)
    choose_game_mode
    @current_player = @player_white
    @opponent = @player_black
    initialize_board_values
    initialize_players_pieces
    @check = false
  end
  
  def choose_game_mode
    choose_game_mode_msg
    gm_input = gets.strip.downcase.delete(' ')
    if gm_input == '1'
      @player_black = Player.new(:black)
    elsif gm_input == '2'
      @player_black = Bot.new(:black)
    else
      wrong_input_msg
      return choose_game_mode
    end
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

  # game saving

  def save_game
    begin
      path = "./saves/#{choose_save_name}.json"
      file = File.open(path, 'w')
    rescue Exception => e
      choose_different_save_name_msg
      save_game
    else
      save_template = ERB.new File.read('./lib/save_template.erb')
      save = save_template.result(binding)
      file.write(save)
      game_saved_msg
      exit
    end
  end

  def choose_save_name
    choose_save_name_msg
    name = gets.strip
    name
  end

  # game loop

  def play
    until game_over?
      board.draw_board
      display_current_player_move
      player_move
      switch_player
    end
    board.draw_board
    announce_winner
  end

  def announce_winner
    switch_player
    winner = current_player.color.capitalize
    announce_winner_msg(winner) 
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

  # bot move

  def generate_random_move(all_values)
    pieces = all_values.reject { |_key, value| value.nil? || value.color != :black}
    all_possible_move_fields = []
    pieces.each { |start_position, piece| all_possible_move_fields << [start_position, generate_all_possible_moves(start_position, piece)] }
    move = all_possible_move_fields.sample
    [move[0], move[1].sample]
  end

  # player moves

  def player_move
    if current_player.instance_of?(Player)
      move = format_input(input_move)
    else
      move = generate_random_move(board.values)
    end
    return player_move if invalid_move?(move)

    check_for_first_move(move)
    remove_piece_from_player(move[1]) if opponents_piece_on_field?(move[1])
    move_piece(move)
    check_for_check(move[1])
    @last_move = move[1]
  end

  def check_for_check(position)
    @check = false
    return if !generate_all_possible_moves(position, board.values[position]).include?(find_opponent_king_position) 
    check_msg
    @check = true
  end

  def find_opponent_king_position
    board.values.reject { |_key, value| value.nil? }
         .select { |_key, value| value.color == opponent.color }
         .select { |_key, value| value.instance_of?(King) }.keys.flatten(1)
  end

  def find_player_king_position
    board.values.reject { |_key, value| value.nil? }
         .select { |_key, value| value.color == current_player.color }
         .select { |_key, value| value.instance_of?(King) }.keys.flatten(1)
  end

  def check_for_first_move(move)
    board.values[move[0]].first_move = false if board.values[move[0]].instance_of?(Pawn)
  end

  def move_piece(move)
    board.values[move[1]] = board.values[move[0]].dup
    board.values[move[0]] = nil
  end

  def invalid_move?(move)
    return true if wrong_piece_on_movefrom?(move[0])
    return true if cannot_reach_moveto?(move)
    return true if own_piece_on_moveto?(move[1])
    return true if king_to_move_invalid?(move)
    return true if leaving_king_unprotected?(move)
  end

  def leaving_king_unprotected?(move)
    temp_second_piece = board.values[move[1]]
    move_piece(move)
    invalid = opponents_all_possible_move_fields.include?(find_player_king_position)
    move_piece(move.reverse)
    board.values[move[1]] = temp_second_piece
    return false unless invalid

    leaving_king_unprotected_msg if current_player.instance_of?(Player)
    true
  end

  def king_to_move_invalid?(move)
    return false if !board.values[move[0]].instance_of?(King)
    return false if !opponents_all_possible_move_fields.include?(move[1])

    wrong_king_field_move_msg if current_player.instance_of?(Player)
    true
  end

  def opponents_all_possible_move_fields
    pieces = board.values.reject { |_key, value| value.nil? }
                  .select { |_key, value| value.color == opponent.color }
    all_possible_move_fields = []
    pieces.each { |start_position, piece| all_possible_move_fields << generate_all_possible_moves(start_position, piece) }
    all_possible_move_fields.flatten(1)
  end

  def cannot_reach_moveto?(move)
    piece = board.values[move[0]]
    possible_moves = generate_all_possible_moves(move[0], piece)
    return false if possible_moves.include?(move[1])

    cannot_move_to_a_field_msg if current_player.instance_of?(Player)
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
      wrong_choosen_color_field_msg if current_player.instance_of?(Player)
      true
    else
      false
    end
  end

  def own_piece_on_moveto?(move_to)
    if board.values[move_to].nil?
      false
    elsif board.values[move_to].color == current_player.color
      your_own_piece_on_moveto_msg if current_player.instance_of?(Player)
      true
    else
      false
    end
  end

  def input_move
    move = STDIN.gets.strip.downcase.delete(' ').split('')
    return save_game if move.join('') == 'save'
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
    return false if check == false
    return true if cannot_protect_king?

    false
  end

  def cannot_protect_king?
    return true if king_cant_move_to_safe_field? && cannot_attack_last_position? && cannot_block_last_position?

    false
  end

  def king_cant_move_to_safe_field?
    moves = generate_all_possible_moves(find_player_king_position, board.values[find_opponent_king_position])
    moves = remove_same_color_pieces_positions(moves, current_player.color)
    moves.all? { |position| opponents_all_possible_move_fields.include?(position) }
  end

  def remove_same_color_pieces_positions(positions, color)
    positions = positions.select do |position|
      board.values[position].nil? || board.values[position].color != color
    end
    positions
  end

  def cannot_attack_last_position?
    generate_all_player_moves_without_king.none? { |piece_and_moves| check_if_attack_is_possible_if_king_is_unprotected(piece_and_moves[0], piece_and_moves[1]) }
  end

  def check_if_attack_is_possible_if_king_is_unprotected(start_position, moves)
    return true if move_possible_and_doesnt_open_king?(start_position, moves)

    false
  end

  def move_possible_and_doesnt_open_king?(start_position, moves)
    return false if !moves.include?(last_move)

    start_position_piece = board.values[start_position]
    last_move_piece = board.values[last_move]
    move = [start_position, last_move]
    move_piece(move)
    king_opened = opponents_all_possible_move_fields.include?(find_player_king_position)
    board.values[start_position] = start_position_piece
    board.values[last_move] = last_move_piece
    !king_opened
  end 

  def generate_all_player_moves_without_king
    pieces = board.values.reject { |_key, value| value.nil? || value.instance_of?(King) }
                  .select { |_key, value| value.color == current_player.color }
    all_possible_move_fields = []
    pieces.each { |start_position, piece| all_possible_move_fields << [start_position, generate_all_possible_moves(start_position, piece)] }
    all_possible_move_fields
  end

  def cannot_block_last_position?
    return true if board.values[last_move].unlimited_move == false

    generate_fields_between_piece_and_king(last_move, board.values[last_move]).none? { |field_between| can_move_your_piece_on_it?(field_between) } 
  end

  def can_move_your_piece_on_it?(field)
    generate_all_player_moves_without_king.any? do |start_pos_and_moves|
    start_position = start_pos_and_moves[0]
    moves = start_pos_and_moves[1]
    moves.include?(field) && can_move_on_field_without_opening_king?(start_position, field)
    end
  end

  def can_move_on_field_without_opening_king?(start_position, field)
    move = [start_position, field]
    move_piece(move)
    king_opened = opponents_all_possible_move_fields.include?(find_player_king_position)
    move_piece(move.reverse)
    !king_opened
  end

  def generate_fields_between_piece_and_king(start_position, piece)
    moves = []
    piece.move_directions.each { |direction| moves << generate_moves_in_direction(start_position, direction) }
    moves = moves.select { |fields_array| fields_array.include?(find_player_king_position) }
                 .flatten(1) 
    moves.delete(find_player_king_position)
    moves                  
  end

  def display_current_player_move
    puts
    puts "#{current_player.color.capitalize}'s turn!"
  end
end
