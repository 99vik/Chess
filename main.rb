# frozen_string_literal: true

require_relative './lib/chess'

def play_again?
  puts "Enter 1 if you want to play again, or ENTER if you want to exit."
  play_again = gets.strip.downcase.delete(' ')
  if play_again == "1"
    true
  else
    false
  end
end

begin
  game = Chess.new
  game.play
end while play_again?

