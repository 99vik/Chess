def play_again?
    puts "Enter 1 if you want to play again, or ENTER if you want to exit."
    play_again = gets.strip.downcase.delete(' ')
    if play_again == "1"
      return true
    else
      return false
    end
end

begin
  puts "hello"
end while play_again?

