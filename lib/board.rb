# frozen_string_literal: true

require_relative 'colorize'

# used to display board, includes values for each field of the board
class Board
  attr_accessor :values

  def initialize
    initialize_values
  end

  # board display
  def draw_board
    puts
    (1..8).to_a.reverse.each do |i|
      row = values.select { |j| j[0] == i }
      draw_row(row)
    end
    puts '    a  b  c  d  e  f  g  h'
  end

  def draw_row(row)
    print "#{row.first[0][0]}  "
    row.each { |i| print_cell(i) }
    puts
  end

  def print_cell(cell)
    if (cell[0][0].even? && cell[0][1].odd?) || (cell[0][0].odd? && cell[0][1].even?)
      if !cell[1].nil?
        print cell[1].symbol.to_s.brown_bg
      else
        print '   '.brown_bg
      end
    elsif !cell[1].nil?
      print cell[1].symbol.to_s.gray_bg
    else
      print '   '.gray_bg
    end
  end

  def initialize_values
    @values = {}
    (1..8).to_a.each do |i|
      (1..8).to_a.each do |j|
        @values[[i, j]] = nil
      end
    end
  end
end
