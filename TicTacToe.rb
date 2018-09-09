class TicTacToe 

  def run
    puts "Welcome to Tic Tac Toe!"
    puts

    # Get player names
    puts "Enter Player O's name:"
    player_1 = gets.chomp
    puts "Enter Player X's name:"
    player_2 = gets.chomp

    # Print some instructions
    puts 
    puts "Instructions:"
    puts "- Enter your move as two numbers (row and column) separated by a space"
    puts "- Note: rows and column numbering starts at 0"
    puts 

    # Setup the game
    print_gameboard
    turn = player_1 
    piece = @PLAYER_1_PIECE
    game_state = :game_notover

    # Run the game until it finishes
    while game_state == :game_notover
      puts "#{turn}'s move:"
      move_row, move_column = get_move

      if invalid_move?(move_row, move_column) 
        puts "Invalid move! Please try again..."
        next
      else
        make_move(move_row, move_column, piece) 
        print_gameboard
      end

      # Check the game state and respond
      game_state = update_game_state
      case game_state
      when :player_1_win
        puts "Game over. #{player_1} won!"
      when :player_2_win
        puts "Game over. #{player_2} won!"
      when :draw
        puts "Game over. It was a draw!"
      end

      # End turn and switch players
      turn, piece = (turn == player_1) ? [player_2, @PLAYER_2_PIECE] : [player_1, @PLAYER_1_PIECE] 
    end
  end

  def invalid_move?(move_row, move_column) 
    if move_row >= @BOARD_SIZE || move_column >= @BOARD_SIZE
      true
    elsif move_row < 0 || move_column < 0
      true
    elsif @gameboard[move_row][move_column] != @EMPTY_POSITION
      true
    else 
      false
    end
  end

  def get_move 
    move = gets.split
    move_row = move[0].to_i
    move_column = move[1].to_i
    return move_row, move_column
  end

  def make_move(move_row, move_column, piece)  
    @gameboard[move_row][move_column] = piece 
  end

  def print_gameboard
    @gameboard.each.with_index do |row, row_index|
      row.each.with_index do |piece, column_index|
        print piece
        print "|" unless column_index == @BOARD_SIZE - 1 
      end

      puts 
      puts "-----" unless row_index == @BOARD_SIZE - 1
    end
  end

  def update_game_state
    # Check each row for win
    @gameboard.each.with_index do |row|
      if winning_move?(row) 
        row[0] == @PLAYER_1_PIECE ? (return :player_1_win) : (return :player_2_win)
      end
    end

    # Check each column for win
    @gameboard.transpose.each do |column|
      if winning_move?(column)
        column[0] == @PLAYER_1_PIECE ? (return :player_1_win) : (return :player_2_win)
      end
    end

    # Check each diagonal for win
    left_diagonal, right_diagonal = extract_diagonals

    if winning_move?(left_diagonal)
      left_diagonal[0] == @PLAYER_1_PIECE ? (return :player_1_win) : (return :player_2_win)
    elsif winning_move?(right_diagonal)
      right_diagonal[0] == @PLAYER_1_PIECE ? (return :player_1_win) : (return :player_2_win)
    end

    # Not a win, check if any moves left to play
    @gameboard.each { |row| return :game_notover if row.include?(@EMPTY_POSITION) }

    # No moves left to play
    :draw
  end

  
  def winning_move?(arr) 
    arr.each.with_index do |piece, index|
      return false if piece == @EMPTY_POSITION
      return false if piece != arr[index+1] && index < @BOARD_SIZE - 1
    end

    true
  end

  def extract_diagonals 
    left_diagonal = []
    @gameboard.each.with_index do |row, row_index| 
      row.each.with_index do |piece, column_index|
        left_diagonal.push(piece) if row_index == column_index
      end
    end

    right_diagonal = []
    @gameboard.reverse.each.with_index do |row, row_index| 
      row.each.with_index do |piece, column_index|
        right_diagonal.push(piece) if row_index == column_index
      end
    end

    return left_diagonal, right_diagonal
  end

  def initialize
    @BOARD_SIZE = 3
    @PLAYER_1_PIECE = "O"
    @PLAYER_2_PIECE = "X"
    @EMPTY_POSITION = " "

    @gameboard = Array.new(@BOARD_SIZE) { Array.new(@BOARD_SIZE) {@EMPTY_POSITION} }
  end

end