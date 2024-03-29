# frozen_string_literal: true

class String
  # colorization
  def colorize(color_code)
    "\e[#{color_code}m#{self}\e[0m"
  end

  def white_bg
    colorize(107)
  end

  
  def gray_bg
    colorize(100)
  end
  
  def brown_bg
    colorize(43)
  end
  
  def green
    colorize(32)
  end
  
  def brown
    colorize(33)
  end

  def blue
    colorize(34)
  end

  def black
    colorize(30)
  end

  def red
    colorize(31)
  end
end
