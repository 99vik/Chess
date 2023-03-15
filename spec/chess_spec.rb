require_relative '../lib/chess'
require_relative '../lib/pieces'

describe Chess do
  subject(:chess) { described_class.new }
  
  describe '#king_to_move_invalid?' do
    before do 
      (1..8).to_a.each do |i|
        (1..8).to_a.each do |j|
          chess.board.values[[i, j]] = nil
        end
      end
      chess.board.values[[2, 2]] = King.new(:white)
      chess.board.values[[8, 3]] = Queen.new(:black)
      chess.board.values[[2, 3]] = Bishop.new(:black)
    end

    context 'when it is valid move' do
      it 'move king on safe field 1' do
        move = [[2, 2], [2, 1]]
        expect(chess.king_to_move_invalid?(move)).to be false
      end
      it 'move king on safe field 2' do
        move = [[2, 2], [1, 3]]
        expect(chess.king_to_move_invalid?(move)).to be false
      end
    end

    context 'when it is invalid move' do
      it 'move king on unsafe field queen' do
        move = [[2, 2], [3, 3]]
        allow(chess).to receive(:puts)
        expect(chess.king_to_move_invalid?(move)).to be true
      end
      it 'move king on unsafe field bishop' do
        move = [[2, 2], [3, 2]]
        allow(chess).to receive(:puts)
        expect(chess.king_to_move_invalid?(move)).to be true
      end
      it 'move king on unsafe field when eats bishop' do
        move = [[2, 2], [3, 2]]
        allow(chess).to receive(:puts)
        expect(chess.king_to_move_invalid?(move)).to be true
      end
    end
  end

  describe 'situation testing' do
    before do 
      (1..8).to_a.each do |i|
        (1..8).to_a.each do |j|
          chess.board.values[[i, j]] = nil
        end
      end
      chess.board.values[[2, 2]] = King.new(:white)
      chess.board.values[[2, 4]] = Queen.new(:white)
      chess.board.values[[1, 8]] = Rook.new(:black)
      chess.board.values[[8, 1]] = Rook.new(:black)
      chess.board.values[[7, 6]] = Queen.new(:black)
      chess.board.values[[8, 8]] = King.new(:black)
      chess.board.values[[3, 5]] = Knight.new(:black)
      chess.board.values[[5, 3]] = Knight.new(:black)
      chess.switch_player
    end

    it 'play' do 
      chess.play
    end
  end
end
