require './colorable'
require './display'

class Human
  include Display
  include Colorable

  attr_reader :guess

  def initialize; end

  def make_guess(board)
    attempts_left = Game::MAX_ATTEMPTS - board.playboard.size
    print display_guess_prompt(attempts_left)
    @player_input = gets.chomp.split('')
    valid_input?
    convert_letters_to_colours(board)
    board.playboard << @guess
  end

  def convert_letters_to_colours(board)
    @guess = @player_input.map do |letter|
      board.code_pegs.each do |key, color|
        if key.eql?(letter)
          letter = color
        end
      end
      letter
    end
  end

  def valid_input?
    until @player_input.all? { |letter| letter.match?(/[rgbcmo]+/) } &&
          @player_input.size == 4
      puts display_error_invalid_input
      puts display_code_example
      @player_input = gets.chomp.split('')
    end
  end
end

class Stubborn
  attr_reader :guess

  def initialize(board)
    @guess = board.code_pegs.values.take(4)
  end

  def make_guess(board)
    board.playboard << @guess
  end

  def to_s
    'The stubborn player'
  end
end

class Cheater
  attr_reader :guess

  def initialize
    @guess = guess
  end

  def make_guess(board)
    @guess = board.secret_code
    board.playboard << @guess
  end

  def to_s
    'The Cheater'
  end
end

class Scatterbrain
  attr_reader :guess

  def make_guess(board)
    @guess = board.code_pegs.values.sample(4)
    board.playboard << @guess
  end

  def to_s
    'The Scatterbrain'
  end
end

class Methodical
  include Colorable
  attr_reader :guess

  def initialize(board)
    @guess = Array.new(4, board.code_pegs['b'])
    @idea = Array.new(4)
    @last_guess = []
  end

  def to_s
    'The Methodical'
  end

  def make_guess(board)
    if first_move?(board)
      put_on(board)
    elsif idea_ready?
      work_with_idea(board)
      put_on(board)
    elsif check_for_bluee(board)
      @guess = [board.code_pegs['b'], board.code_pegs['b'], board.code_pegs['g'], board.code_pegs['g']]
      analyse_feedback(board)
      put_on(board)
    elsif check_for_green(board)
      @guess = [board.code_pegs['b'], board.code_pegs['b'], board.code_pegs['r'], board.code_pegs['r']]
      analyse_feedback(board)
      put_on(board)
    elsif check_for_red(board)
      @guess = [board.code_pegs['b'], board.code_pegs['b'], board.code_pegs['m'], board.code_pegs['m']]
      analyse_feedback(board)
      put_on(board)
    elsif check_for_magenta(board)
      @guess = [board.code_pegs['b'], board.code_pegs['b'], board.code_pegs['c'], board.code_pegs['c']]
      analyse_feedback(board)
      put_on(board)
    elsif check_for_cyan(board)
      @guess = [board.code_pegs['b'], board.code_pegs['b'], board.code_pegs['o'], board.code_pegs['o']]
      analyse_feedback(board)
      put_on(board)
    elsif check_for_orange(board)
      @guess = [board.code_pegs['b'], board.code_pegs['b'], board.code_pegs['o'], board.code_pegs['o']]
      analyse_feedback(board)
      put_on(board)
    end
  end

  def analyse_feedback(board)
    @white_pegs = board.small_holes_set.last.count(gray("\u25CF"))
    @red_pegs = board.small_holes_set.last.count(red("\u25CF"))

    if (@red_pegs == 1 && @white_pegs.zero? && @idea.include?(blue(" b ")))
      @idea.delete_at(@idea.index("\e[44m b \e[0m"))
      @idea.unshift("\e[44m b \e[0m")
    elsif (@white_pegs == 1 && @red_pegs.zero? && @idea.include?(blue(" b ")))
    elsif @white_pegs == 2 && @idea.include?(blue(" b "))
      @idea.unshift(@last_guess.last)
    elsif @white_pegs.nonzero?
      @idea.unshift(@last_guess.last)
    elsif @red_pegs.nonzero?
      @idea.push(@last_guess.last)
    end
  end

  def idea_ready?
    @idea.compact.size.eql?(4)
  end

  def work_with_idea(board)
    if board.small_holes_set.last.count(gray("\u25CF")) == 4
      @guess[0], @guess[1] = @guess[1], @guess[0]
    elsif (board.small_holes_set.last.count(red("\u25CF")) == 2) && !(@idea.include?(nil))
      @guess[2], @guess[3] = @guess[3], @guess[2]
    else
      @idea = @idea.compact
      @guess = @idea
    end
  end

  def first_move?(board)
    board.small_holes_set.last.eql?(nil)
  end

  def check_for_bluee(board)
    @last_guess.eql?([board.code_pegs['b'], board.code_pegs['b'], board.code_pegs['b'], board.code_pegs['b']])
  end

  def check_for_green(board)
    @last_guess.eql?([board.code_pegs['b'], board.code_pegs['b'], board.code_pegs['g'], board.code_pegs['g']])
  end

  def check_for_magenta(board)
    @last_guess.eql?([board.code_pegs['b'], board.code_pegs['b'], board.code_pegs['m'], board.code_pegs['m']])
  end

  def check_for_cyan(board)
    @last_guess.eql?([board.code_pegs['b'], board.code_pegs['b'], board.code_pegs['c'], board.code_pegs['c']])
  end

  def check_for_orange(board)
    @last_guess.eql?([board.code_pegs['b'], board.code_pegs['b'], board.code_pegs['o'], board.code_pegs['o']])
  end

  def check_for_red(board)
    @last_guess.eql?([board.code_pegs['b'], board.code_pegs['b'], board.code_pegs['r'], board.code_pegs['r']])
  end

  def put_on(board)
    @last_guess = @guess
    board.playboard << @guess
  end
end

class Knuth
  include Colorable
  attr_reader :guess

  def initialize(board)
    @possibilities = board.code_pegs.values.repeated_permutation(4).to_a
    @guess = @possibilities[1122]
  end

  def to_s
    'The Knuth'
  end

  def make_guess(board)
    if board.small_holes_set.eql?([])
      board.playboard << @guess
    else
      algorithm(board)
      index = rand(0...@possibilities.count)
      @guess = @possibilities.delete_at(index)
      board.playboard << @guess
    end
  end

  def algorithm(board)
    @possibilities.select! { |possible| feedback(possible) == board.small_holes_set.last }
  end

  def feedback(possible)
    matches = @guess & possible
    exact_match = []
    index = 0
    possible.each do |item|
      if item == @guess[index]
        exact_match.push(item)
      end
      index += 1
    end
    color_match = matches - exact_match
    exact_match = exact_match.map { |item| item = red("\u25CF") }
    color_match = color_match.map { |item| item = gray("\u25CF") }
    placeholder = [gray("\u25CB"), gray("\u25CB"), gray("\u25CB"), gray("\u25CB")]
    @feedback = []
    @feedback = @feedback.push(exact_match, color_match, placeholder).flatten.take(4)
  end
end