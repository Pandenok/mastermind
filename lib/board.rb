class Board
  include Colorable
  include Display

  attr_accessor :playboard, :code_pegs, :small_holes_set
  attr_reader :secret_code

  CODE_LENGTH = 4

  def initialize
    @playboard = []
    @code_pegs = { 'r' => bg_red(' r '),
                   'b' => bg_blue(' b '),
                   'g' => bg_green(' g '),
                   'c' => bg_cyan(' c '),
                   'm' => bg_magenta(' m '),
                   'o' => bg_orange(' o ') }
    @small_holes_set = []
  end

  def show(player)
    print show_attempt_number
    print show_guess(player)
    puts show_feedback
  end

  def show_attempt_number
    bold("\n  #{@playboard.size}. ").ljust(18)
  end

  def show_guess(player)
    if player.class.eql?(Human)
      'You tried: ' + @playboard.last { |hole| hole }.join(' | ')
    else
      "#{player.name} tried: ".ljust(8) + @playboard.last { |hole| hole }.join(' | ')
    end
  end

  def show_feedback
    'and got'.rjust(10).ljust(12) + @small_holes_set.last.join('  ')
  end

  def create_secret_code(player)
    if player.class.eql?(Human)
      print display_announce_codebreaker
      @secret_code = @code_pegs.values.sample(CODE_LENGTH)
    else
      puts display_announce_codemaker(player)
      alphabetic_input
      convert_letters_to_colours
      show_secret_code
    end
  #   puts "The secret code is #{@secret_code.join(' | ')}"
  end

  def alphabetic_input
    puts display_code_example
    print display_code_prompt
    @player_code = gets.chomp.split('')
    validate_player_code_input
  end

  def convert_letters_to_colours
    @secret_code = @player_code.map do |letter|
      @code_pegs.each do |key, color|
        letter = color if key.eql?(letter)
      end
      letter
    end
  end

  def show_secret_code
    puts "\nThe secret code is #{@secret_code.join(' | ')}"
  end

  def validate_player_code_input
    until @player_code.all? { |letter| letter.match?(/[rgbcmo]+/) } &&
          @player_code.size.eql?(CODE_LENGTH)
      puts display_error_invalid_input
      puts display_code_example
      @player_code = gets.chomp.split('')
    end
  end
end
