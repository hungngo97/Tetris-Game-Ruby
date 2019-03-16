# University of Washington, Programming Languages, Homework 6, hw6runner.rb

# This is the only file you turn in, so do not modify the other files as
# part of your solution.
class MyPiece < Piece
  # The constant All_My_Pieces should be declared here
  All_My_Pieces = All_Pieces + [
                    rotations([[0, 0], [1, 0], [0, 1], [1, 1], [0,2]]), #Square with extra box
                    [[[0, 0], [-1, 0], [1, 0], [2, 0], [3,0]], #Long shape
                    [[0, 0], [0, -1], [0, 1], [0, 2], [0, 3]]],
                    rotations([[0,0], [1,0], [0,1], [0,0]]) #L shape
                  ]
                  
  def self.Cheat_Piece (board)
    MyPiece.new([[[0,0], [0,0], [0,0], [0,0]]], board)
  end

  # class method to choose the next piece
  def self.next_piece (board)
    MyPiece.new(All_My_Pieces.sample, board)
  end
end

class MyBoard < Board
  # your enhancements here
  attr_accessor :isCheat
  def initialize (game)
    @grid = Array.new(num_rows) {Array.new(num_columns)}
    @current_block = MyPiece.next_piece(self)
    @score = 0
    @game = game
    @delay = 500
    @isCheat = false
  end
  # rotates the current piece counterclockwise
  def rotate_180
    if !game_over? and @game.is_running?
      @current_block.move(0, 0, 2)
    end
    draw
  end

  # gets the next piece
  def next_piece
    if isCheat
      @isCheat = false
      @current_block = MyPiece.Cheat_Piece(self)
      @score -= 100
    else
      @current_block = MyPiece.next_piece(self)
    end
    @current_pos = nil
  end

end

class MyTetris < Tetris
  # creates a canvas and the board that interacts with it
  def set_board
    @canvas = TetrisCanvas.new
    @board = MyBoard.new(self)
    @canvas.place(@board.block_size * @board.num_rows + 3,
                  @board.block_size * @board.num_columns + 6, 24, 80)
    @board.draw
  end
  def onCheat 
    if !@board.isCheat && @board.score >= 100 
      @board.isCheat = true
    end
  end
  def key_bindings 
    super
    @root.bind('c', proc {self.onCheat}) 
    @root.bind('u', proc {@board.rotate_180})
  end
end


