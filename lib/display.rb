class String
  def black;      "\e[30m#{self}\e[0m" end
  def red;        "\e[31m#{self}\e[0m" end
  def green;      "\e[32m#{self}\e[0m" end
  def orange;     "\e[33m#{self}\e[0m" end
  def blue;       "\e[34m#{self}\e[0m" end
  def magenta;    "\e[35m#{self}\e[0m" end
  def cyan;       "\e[36m#{self}\e[0m" end
  def gray;       "\e[37m#{self}\e[0m" end

  def bg_black;   "\e[40m#{self}\e[0m" end
  def bg_red;     "\e[41m#{self}\e[0m" end
  def bg_green;   "\e[42m#{self}\e[0m" end
  def bg_orange;  "\e[43m#{self}\e[0m" end
  def bg_blue;    "\e[44m#{self}\e[0m" end
  def bg_magenta; "\e[45m#{self}\e[0m" end
  def bg_cyan;    "\e[46m#{self}\e[0m" end
  def bg_gray;    "\e[47m#{self}\e[0m" end

  def underline;  "\e[4;1m#{self}\e[0m" end
  def bold;       "\e[1;1m#{self}\e[0m" end
  def italic;     "\e[3m#{self}\e[23m" end
end

module Display

  def display_main_menu
    system 'clear'
    <<~HEREDOC.chomp
      Welcome to the famous #{"MASTERMIND".underline} game!

        #{"1.".red} See Rules

        #{"2.".green} Play game as #{"Codemaker".bold}
      
        #{"3.".magenta} Play game as #{"Codebreaker".bold}
      
        #{"4.".blue} Score Table
      
        #{"5.".orange} Reset all the scores
      
        #{"6.".cyan} Quit

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
  
      Player one (aka code-#{"maker".bold}) picks four coloured pegs and creates (i.e. #{'makes'.italic}) a secret master code.
      Player two (aka code-#{"breaker".bold}) then has to work out (i.e. #{'break'.italic}) the sequence of pegs that player one has picked. 
  
      There are six available peg colours:
  
      #{" red ".bg_red} #{" blue ".bg_blue} #{" green ".bg_green} #{" cyan ".bg_cyan} #{" magenta ".bg_magenta} #{" orange ".bg_orange}
  
      Codemaker’s combination (#{'master code'.italic}) could be 
      
        four of the same colour: #{" b ".bg_blue} #{" b ".bg_blue} #{" b ".bg_blue} #{" b ".bg_blue}
        
                    two of each: #{" g ".bg_green} #{" g ".bg_green} #{" o ".bg_orange} #{" o ".bg_orange}
        
         four different colours: #{" m ".bg_magenta} #{" o ".bg_orange} #{" c ".bg_cyan} #{" r ".bg_magenta}
      
                              or any other combination.
  
      In order to win, the Codebreaker needs to guess the 'master code' in 12 or less turns.
  
      After each guess, there will be up to four hints to help crack the code.
  
        #{"\u25CF".red} (red marker) - Codebreaker has picked the correct colour AND has it in the correct position 
        #{"\u25CF".gray} (white marker) - Codebreaker has used a correct peg colour but placed it in the wrong position
        #{"\u25CB".gray} (empty slot) - Codebreaker has done a wrong choice of colour
  
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

        1. #{"Stubborn".bold} - #{"one day, it'll win in 1 guess".italic} :)

        2. #{"Scatterbrain".bold} - #{"it tries hard but with no much luck".italic} 
        
        3. #{"Methodical".bold} - #{"if you don't give it hard tasks, it will make it".italic}
        
        4. #{"Knuth".bold} - #{"will beat your ass in 5 moves or less".italic}

        5. #{"Cheater".bold} - #{"well... you'll see... real cheater".italic}
        
      Please choose who do you wanna play with: 
    HEREDOC
  end

  def display_history_mastermind
    system 'clear'
    <<~HEREDOC

      #{"C'mon!".bold} Seriously?! 
      
      Are you #{"really".underline} here to read the history of Mastermind Game?!
      
      #{"It's time to play now!!!".underline.green}

      Press any key to go back to the main menu...
    HEREDOC
  end

  def display_code_example
    <<~HEREDOC
    There are six available peg colours:
  
    #{" red ".bg_red} #{" blue ".bg_blue} #{" green ".bg_green} #{" cyan ".bg_cyan} #{" magenta ".bg_magenta} #{" orange ".bg_orange}
    
    A secret pattern should be composed of 4 code pegs.
    Digit the first letter of the colour to pick it up. 
    E.g., the sequence #{"omcr".underline} will produce the following combination:

    #{" o ".bg_orange} #{" m ".bg_magenta} #{" c ".bg_cyan} #{" r ".bg_red}

    HEREDOC
  end

  def display_announce_codebreaker
    system 'clear'
    print "Computer is generating a master code "
    12.times do
      sleep(0.2)
      print "."
    end
    puts "#{"Done!".green} "
    sleep(0.5)
    <<~HEREDOC

      Computer has generated a sequence with four elements made up of:

      #{" red ".bg_red} #{" blue ".bg_blue} #{" green ".bg_green} #{" cyan ".bg_cyan} #{" magenta ".bg_magenta} #{" orange ".bg_orange}

      You have #{Game::MAX_ATTEMPTS} attempts to break it.
      
      Digit the first letter of the colour to pick it up (i.g. #{"r".red}#{"g".green}#{"o".orange}#{"m".magenta})

      #{"It's play time!".bold}
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

            #{"Your score is: ".orange}  #{"#{human_score}".bold}
        #{"Computer score is: ".orange}  #{"#{computer_score}".bold}

      Press any key to go back to Main Menu...
    HEREDOC
  end

  def display_score_reset
    system 'clear'
    <<~HEREDOC
      All the scores were resetted

            #{"Your score is: ".orange}  #{"#{human_score}".bold}
        #{"Computer score is: ".orange}  #{"#{computer_score}".bold}

      Press any key to go back to Main Menu...
    HEREDOC
  end

  def display_human_won(message)
    {'unbelievable' => "\nWOW! #{"Congratulations!".green}\nYou’re the world’s greatest! You are the master of this game!\nEven Knuth player couldn't do better!",
    'good job' => "\n#{"Congratulations".green} on your fabulous victory!\nI always knew you are different from others.\nSo, keep up the good work. Congrats again!",
    'last chance' => "\nThe harder the battle the sweeter the victory, eh? :)\n#{"Congratulations!".green} for your fabulous victory! You deserve it every bit!",
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
    Because again is #{"practice".underline}, 
      and practice is #{"improvement".underline}, 
        and improvement only leads to #{"perfection".underline}.
    HEREDOC
  end

  def display_secret_code(board)
    puts "\nThe secret code was #{board.secret_code.join(' | ')}"
  end

  def display_computer_lost
    puts "\n#{"Congratulations!".green}\n#{player.to_s} ran out of all the available attemps.\nThat was a hard code to crack!\nYou earn extra point!"
  end

  def display_error_invalid_input
    puts "#{"ERROR".bg_red}: #{"invalid input".red}"
  end

  def display_play_again
    print "\nOne more round?\nPress 'y' for yes (or any other key for no): "
  end

  def display_closing_greeting
    puts "\nThanks and have a nice day!"
  end
end
