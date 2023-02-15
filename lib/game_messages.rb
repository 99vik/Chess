# frozen_string_literal: true

require_relative 'colorize'

module GameMessages
  def wrong_input_msg
    puts 'Wrong input!'.red
  end

  def wrong_choosen_color_field_msg
    puts "Opponent's piece on a choosen field!".red
    puts 'Please choose another.'.red
  end

  def empty_choosen_field_msg
    puts 'Choosen field is empty!'.red
    puts 'Please choose another.'.red
  end

  def your_own_piece_on_moveto_msg
    puts 'Your own piece is on the field your have chosen to move!'.red
    puts 'Please choose another.'.red
  end

  def cannot_move_to_a_field_msg
    puts 'Cannot move to selected field!'.red
    puts 'Enter correct field you want to move your piece.'.red
  end
end
