require './display'

class Game
  include Display
  MAX_ATTEMPTS = 12
  attr_accessor :player, :board
  attr_reader :computer_score, :human_score

  def initialize
    @board = Board.new
    @computer_score = 0
    @human_score = 0
    main_menu
  end

  def main_menu
    print display_main_menu
    continue = true
    input = gets.chomp.to_i
    until input.between?(1,6)
      puts display_error_invalid_input
      input = gets.chomp.to_i
    end
    case input
    when 1
      puts display_rules
      game_rules_submenu
    when 2
      create_computer_player
      play_game
    when 3
      puts "\e[H\e[2J"
      @player = Human.new
      play_game
    when 4
      puts display_score_table
      input = gets.chomp
      main_menu
    when 5
      reset_score
      puts display_score_reset
      input = gets.chomp
      main_menu
    when 6
      continue = false
    end
  end

  def game_rules_submenu
    input = gets.chomp.to_i
    until input.between?(1, 4)
      puts display_error_invalid_input
      input = gets.chomp.to_i
    end
    case input
    when 1
      create_computer_player
      play_game
    when 2
      puts "\e[H\e[2J"
      @player = Human.new
      play_game
    when 3
      puts display_history_mastermind
      input = gets.chomp.to_i
      main_menu
    when 4
      main_menu
    end
  end

  def create_computer_player
    print display_ai_level
    input = gets.chomp.to_i
    until input.between?(1, 5)
      puts display_error_invalid_input
      input = gets.chomp.to_i
    end
    case input
    when 1
      @player = Stubborn.new(@board)
    when 2
      @player = Scatterbrain.new
    when 3
      @player = Methodical.new(@board)
    when 4
      @player = Knuth.new(@board)
    when 5
      @player = Cheater.new
    end
  end

  def play_game
    @board = Board.new
    @board.create_secret_code(@player)
    (1..MAX_ATTEMPTS).each do
      player.make_guess(@board)
      feedback
      @board.show(@player)
      break if cracked?
    end
    count_score(board)
    game_over
    repeat_game
  end

  def exact_match
    exact_match = []
    index = 0
    @board.secret_code.each do |item|
      if item == @player.guess[index]
        exact_match.push(item)
      end
      index += 1
    end
    return exact_match
  end

  def color_match
    matches = @player.guess & @board.secret_code
    color_match = matches - exact_match
  end

  def feedback
    @feedback = []
    @exact_match = exact_match.map { |item| item = "\u25CF".red }
    @color_match = color_match.map { |item| item = "\u25CF".gray }
    @placeholder = ["\u25CB".gray, "\u25CB".gray, "\u25CB".gray, "\u25CB".gray]
    @feedback = @feedback.push(@exact_match, @color_match, @placeholder).flatten.take(4)
    @board.small_holes_set << @feedback
  end

  def cracked?
    @board.secret_code.eql?(@player.guess)
  end

  def count_score(board)
    if player.class.eql?(Human)
      @computer_score += board.playboard.size
      @computer_score += 1 unless cracked?
    else
      @human_score += board.playboard.size
      @human_score += 1 unless cracked?
    end
  end

  def reset_score
    @computer_score = 0
    @human_score = 0
  end

  def game_over
    if cracked?
      if player.class.eql?(Human)
        human_won
      elsif player.class != Human
        computer_won
      end
    else
      if player.class.eql?(Human)
        puts display_human_lost
        puts display_secret_code(board)
      else
        puts display_computer_lost
      end
    end
  end

  def human_won
    puts display_human_won('unbelievable') if board.playboard.size <= 6
    puts display_human_won('good job') if board.playboard.size.between?(7, 11)
    puts display_human_won('last chance') if board.playboard.size.eql?(12)
  end

  def computer_won
    puts display_computer_won(player.class.to_s)
  end

  def repeat_game
    print display_play_again
    input = gets.chomp
    input.downcase.eql?('y') ? main_menu : (puts display_closing_greeting)
  end
end
