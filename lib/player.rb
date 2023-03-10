# frozen_string_literal: true

class Player
  attr_accessor :pieces
  attr_reader :color

  def initialize(color)
    @color = color
    @pieces = []
  end
end
