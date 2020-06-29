module Display
  include Colorable

  def display_main_menu
    system 'clear'
    <<~HEREDOC.chomp
      Welcome to the famous #{underline("MASTERMIND")} game!

        #{red("1.")} See Rules

        #{green("2.")} Play game as #{bold("Codemaker")}
      
        #{magenta("3.")} Play game as #{bold("Codebreaker")}
      
        #{blue("4.")} Score Table
      
        #{orange("5.")} Reset all the scores
      
        #{cyan("6.")} Quit

      Please, make your choice: 
    HEREDOC
  end
    # puts "\e[H\e[2J"

  def display_rules
    system 'clear'
    <<~HEREDOC

      Although the rules of Mastermind are as simple as they come, yet don’t let that fool you. 
      Actually winning requires a huge amount of brain power.
  
      The game is limited to two players.
  
      Player one (aka code-#{bold("maker")}) picks four coloured pegs and creates (i.e. #{italic('makes')}) a secret master code.
      Player two (aka code-#{bold("breaker")}) then has to work out (i.e. #{italic('break')}) the sequence of pegs that player one has picked. 
  
      There are six available peg colours:
  
      #{bg_red(" red ")} #{bg_blue(" blue ")} #{bg_green(" green ")} #{bg_cyan(" cyan ")} #{bg_magenta(" magenta ")} #{bg_orange(" orange ")}
  
      Codemaker’s combination (#{italic('master code')}) could be 
      
        four of the same colour: #{bg_blue(" b ")} #{bg_blue(" b ")} #{bg_blue(" b ")} #{bg_blue(" b ")}
        
                    two of each: #{bg_green(" g ")} #{bg_green(" g ")} #{bg_red(" r ")} #{bg_red(" r ")}
        
         four different colours: #{bg_magenta(" m ")} #{bg_orange(" o ")} #{bg_cyan(" c ")} #{bg_red(" r ")}
      
                              or any other combination.
  
      In order to win, the Codebreaker needs to guess the 'master code' in 12 or less turns.
  
      After each guess, there will be up to four hints to help crack the code.
  
        #{red("\u25CF")} (red marker) - Codebreaker has picked the correct colour AND has it in the correct position 
        #{gray("\u25CF")} (white marker) - Codebreaker has used a correct peg colour but placed it in the wrong position
        #{gray("\u25CB")} (empty slot) - Codebreaker has done a wrong choice of colour
  
      The markers are placed in no particular order so Codebreaker does not know which peg a marker refers to.
      Codebreaker then has to think logically to deduce the correct sequence by moving pegs around and checking the markers after each turn.
      Previous guesses and their markers are left on the board after each go to allow the players to refer to them.
      The winner is the player who identifies the other’s sequence in the shortest number of guesses.
      
      Mastermind is a tricky game that looks much easier than it really is, but is a lot of fun (until your brain begins to physically ache).
  
      1. Give it a try as a Codemaker
      2. Give it a try as a Codebreaker
      3. Continue to read the history of Mastermind Game
      4. Back to Main Menu
    HEREDOC
  end

  def display_ai_level
    system 'clear'
    <<~HEREDOC.chomp
          
      How smart do you want your opponent?

        1. #{bold("Stubborn")} - #{italic("one day, it'll win in 1 guess")} :)

        2. #{bold("Scatterbrain")} - #{italic("it tries hard but with no much luck")} 
        
        3. #{bold("Methodical")} - #{italic("if you don't give it hard tasks, it will make it")}
        
        4. #{bold("Knuth")} - #{italic("will beat your ass in 5 moves or less")}

        5. #{bold("Cheater")} - #{italic("well... you'll see... real cheater")}
        
      Please choose who do you wanna play with: 
    HEREDOC
  end

  def display_history_mastermind
    system 'clear'
    <<~HEREDOC

      #{bold("C'mon!")} Seriously?! 
      
      Are you #{underline("really")} here to read the history of Mastermind Game?!
      
      #{underline(green("It's time to play now!!!"))}

      Press any key to go back to the main menu...
    HEREDOC
  end

  def display_code_example
    <<~HEREDOC
    There are six available peg colours:
  
    #{bg_red(" red ")} #{bg_blue(" blue ")} #{bg_green(" green ")} #{bg_cyan(" cyan ")} #{bg_magenta(" magenta ")} #{bg_orange(" orange ")}
    
    A secret pattern should be composed of 4 code pegs.
    Digit the first letter of the colour to pick it up. 
    E.g., the sequence #{underline("omcr")} will produce the following combination:

    #{bg_orange(" o ")} #{bg_magenta(" m ")} #{bg_cyan(" c ")} #{bg_red(" r ")}

    HEREDOC
  end

  def display_announce_codebreaker
    system 'clear'
    print "Computer is generating a master code "
    12.times do
      sleep(0.2)
      print "."
    end
    puts "#{green("Done!")} "
    sleep(0.5)
    <<~HEREDOC

      Computer has generated a sequence with four elements made up of:

      #{bg_red(" red ")} #{bg_blue(" blue ")} #{bg_green(" green ")} #{bg_cyan(" cyan ")} #{bg_magenta(" magenta ")} #{bg_orange(" orange ")}

      You have #{Game::MAX_ATTEMPTS} attempts to break it.
      
      Digit the first letter of the colour to pick it up (i.g. #{red("r")}#{green("g")}#{orange("o")}#{magenta("m")})

      #{bold("It's play time!")}
    HEREDOC
  end

  def display_announce_codemaker(player)
    system 'clear'
    puts "You are playing as a Codemaker against #{player.to_s} player ..."
  end

  def display_code_prompt
    print "Please create a secret code and don't tell it to anybody: "
  end

  def display_guess_prompt(attempts_left)
    print "\n#{attempts_left} attempts left... What's your guess? "
  end

  def display_score_table
    system 'clear'
    <<~HEREDOC.chomp
      
      Traditionally, players can only earn points when playing as the codemaker. 

      The codemaker gets one point for each guess the codebreaker makes. 
      
      An extra point is earned if the codebreaker is unable to guess the exact pattern within the given number of turns. 
      
      The winner is the one who has the most points after the agreed-upon number of games are played. 

            #{orange("Your score is: ")}  #{bold("#{human_score}")}
        #{orange("Computer score is: ")}  #{bold("#{computer_score}")}

      Press any key to go back to Main Menu...
    HEREDOC
  end

  def display_score_reset
    system 'clear'
    <<~HEREDOC
      All the scores were resetted

            #{orange("Your score is: ")}  #{bold("#{human_score}")}
        #{orange("Computer score is: ")}  #{bold("#{computer_score}")}

      Press any key to go back to Main Menu...
    HEREDOC
  end

  def display_human_won(message)
    {'unbelievable' => "\nWOW! #{green("Congratulations!")}\nYou’re the world’s greatest! You are the master of this game!\nEven Knuth player couldn't do better!",
    'good job' => "\n#{green("Congratulations")} on your fabulous victory!\nI always knew you are different from others.\nSo, keep up the good work. Congrats again!",
    'last chance' => "\nThe harder the battle the sweeter the victory, eh? :)\n#{green("Congratulations!")} for your fabulous victory! You deserve it every bit!",
    } [message]
  end

  def display_computer_won(message)
    {'Stubborn' => "\n#{player.to_s} has successfully cracked your secret code!\nWow! This day arrived! Run to buy a lottery! NOOOOW!",
    'Scatterbrain' => "\n#{player.to_s} has successfully cracked your secret code!\nA winner never stops trying!",
    'Methodical' => "\n#{player.to_s} has successfully cracked your secret code!\nNothing is born into this world without labor.",
    'Knuth' => "\nEasy peasy!\n#{player.to_s} has successfully cracked your secret code!\nIf you think you can win, you can win. Faith is necessary to victory.",
    'Cheater' => "\n#{player.to_s} has successfully cracked your secret code!\nNo comments... I would prefer even to fail with honor than to win by cheating.",
    } [message]
  end

  def display_human_lost
    <<~HEREDOC

    Do it again.
    Play it again. 
    Sing it again. 
    Read it again. 
    Write it again. 
    Sketch it again.
    Rehearse it again.
    Run it again. 
    Try it again.
    Because again is #{underline("practice")}, 
      and practice is #{underline("improvement")}, 
        and improvement only leads to #{underline("perfection")}.
    HEREDOC
  end

  def display_secret_code(board)
    puts "\nThe secret code was #{board.secret_code.join(' | ')}"
  end

  def display_computer_lost
    puts "\n#{green("Congratulations!")}\n#{player.to_s} ran out of all the available attemps.\nThat was a hard code to crack!\nYou earn extra point!"
  end

  def display_error_invalid_input
    puts "#{bg_red("ERROR")}: #{red("invalid input")}"
  end

  def display_play_again
    print "\nOne more round?\nPress 'y' for yes (or any other key for no): "
  end

  def display_closing_greeting
    puts "\nThanks and have a nice day!"
  end
end
