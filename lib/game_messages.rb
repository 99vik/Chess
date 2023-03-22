# frozen_string_literal: true

require_relative 'colorize'

module GameMessages
  def choose_game_mode_msg
    puts "Type 1 for HUMAN VS HUMAN."
    puts "Type 2 for HUMAN VS BOT."
    puts "Type 3 to load previous game."
  end

  def instructions
    puts "\nHOW TO PLAY\n".blue
    puts "Player can choose his move by first writing a value of row and column of the piece he wishes to move,\nthen writing row and coluwm of the field he wants to move piece to.\nFor example: '2a 3a', '4D6F'"
    puts "You can save and quit anytime during the game by typing 'save'."
    puts "To display instructions during game, type 'help'."
    puts "\nPress enter to continue.."
    gets
  end

  def choose_save_msg
    print "\nChoose name of a file to load:"
  end

  def game_loaded_msg
    puts "Game loaded!\n".green
  end

  def announce_winner_msg(winner)
    puts 
    puts "#{winner} wins!".green
    puts
  end

  def wrong_input_msg
    puts 'Wrong input!'.red
  end

  def wrong_choosen_color_field_msg
    puts "Opponent's piece on a choosen field!".red
    puts 'Please choose another.'.red
  end

  def choose_different_save_name_msg
    puts
    puts "Error creating save.".red
    puts "Please choose different save name."
  end

  def game_saved_msg
    puts "\nGame successfully saved!\n".green
  end

  def choose_save_name_msg
    print "\nEnter save name:"
  end

  def check_msg
    puts
    puts 'Check!'.red
  end

  def wrong_king_field_move_msg
    puts "Can't move king to a chosen field!".red
    puts 'Please choose another.'.red
  end

  def empty_choosen_field_msg
    puts 'Choosen field is empty!'.red
    puts 'Please choose another.'.red
  end

  def leaving_king_unprotected_msg
    puts 'Invalid move, protect your king!'.red
  end

  def your_own_piece_on_moveto_msg
    puts 'Your own piece is on the field your have chosen to move!'.red
    puts 'Please choose another.'.red
  end

  def cannot_move_to_a_field_msg
    puts "Can't move to selected field!".red
    puts 'Enter correct field you want to move your piece.'.red
  end
end
