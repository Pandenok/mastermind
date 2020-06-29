require './display'
require './colorable'

class Game
  include Colorable
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
    until input.between?(1, 6)
      puts display_error_invalid_input
      input = gets.chomp.to_i
    end
    main_menu_options(input)
  end

  def main_menu_options(input)
    case input
    when 1
      menu_rules
    when 2
      menu_codemaker
    when 3
      menu_codebreaker
    when 4
      menu_scores
    when 5
      menu_reset_scores
    when 6
      menu_quit
    end
  end

  def menu_rules
    puts display_rules
    game_rules_submenu
  end

  def menu_codemaker
    create_computer_player
    play_game
  end

  def menu_codebreaker
    puts "\e[H\e[2J"
    @player = Human.new
    play_game
  end

  def menu_scores
    puts display_score_table
    input = gets.chomp
    main_menu
  end

  def menu_reset_scores
    reset_score
    puts display_score_reset
    input = gets.chomp
    main_menu
  end

  def menu_quit
    continue = false
  end

  def menu_history
    puts display_history_mastermind
    input = gets.chomp.to_i
    main_menu
  end

  def game_rules_submenu
    input = gets.chomp.to_i
    until input.between?(1, 4)
      puts display_error_invalid_input
      input = gets.chomp.to_i
    end
    game_rules_submenu_options(input)
  end

  def game_rules_submenu_options(input)
    case input
    when 1
      menu_codemaker
    when 2
      menu_codebreaker
    when 3
      menu_history
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
    computer_player_options(input)
  end

  def computer_player_options(input)
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

  def convert_matches_to_symbols
    @exact_match = exact_match.map { |item| item = red("\u25CF") }
    @color_match = color_match.map { |item| item = gray("\u25CF") }
  end

  def feedback
    @feedback = []
    convert_matches_to_symbols
    @placeholder = [gray("\u25CB"), gray("\u25CB"), gray("\u25CB"), gray("\u25CB")]
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
      game_over_code_broken
    else
      game_over_no_attempts
    end
  end

  def game_over_code_broken
    if player.class.eql?(Human)
      human_won
    else
      computer_won
    end
  end

  def game_over_no_attempts
    if player.class.eql?(Human)
      puts display_human_lost
      puts display_secret_code(board)
    else
      puts display_computer_lost
    end
  end

  def human_won
    puts display_human_won('unbelievable') if board.playboard.size <= 6
    puts display_human_won('good job') if board.playboard.size.between?(7, 11)
    puts display_human_won('last chance') if board.playboard.size.eql?(12)
  end

  def computer_won
    puts display_computer_won(player.class.name)
  end

  def repeat_game
    print display_play_again
    input = gets.chomp
    input.downcase.eql?('y') ? main_menu : (puts display_closing_greeting)
  end
end
