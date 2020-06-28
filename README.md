# Project: Mastermind

[![Run on Repl.it](https://repl.it/badge/github/Pandenok/mastermind)](http://mastermind.pandenok.repl.run/)

I made this project while running through the Ruby Programming course (Intermediate Ruby: OOP) at The Odin Project. 

The final (for now) result can be viewed [here](http://mastermind.pandenok.repl.run/). 

Mastermind, a game where you have to guess your opponent’s secret code within a certain number of turns. Each turn you get some feedback about how good your guess was – whether it was exactly correct or just the correct color but in the wrong space.

### User interface

- CLI — Command Line Applications/Interface

![Mastermind in action](img/mastermind.gif)

### Pseudocode

Generic building blocks are `Board`, `Player` and `Game`. 

`Board` class has colour pegs, decoding board to put the pegs on and a set of small holes for hints after each guess. It does very little itself: just keeps a secret code (generated by human player or randomly by computer player), shows player's guesses and keeps a full history of guesses and hints.

`Game` class is used to structure the game through various menus (game mode, AI level, etc.), to control the game flow, keep scores and guard the rules, which consists in giving  feedback on the guess (i.e. check matches) and stop the game when the code was broken. The game needs a board and a player in order to play.

`Player` class just need to respond to the message `guess`. It makes sense to create various player classes that either take user input (e.g. Human) or use any algorithm (e.g. Knuth). Player obviously uses board to put his guesses on.

# What I learned

### Set intersection `&` and difference `-` operators
Spent a lot of time on finding the right approach for the feedback part after guessing. Tried with `reduce`, and `reduce` mixed with `select`. Then only with `intersection`, but was not able to find matches with duplicates and then found the actual approach that you can see in the code: kinda a mix of array set operators (`intersection` and `difference`) and simple interaction.

### Random number pick up
```ruby
choice = colors.sample(4)
```
Calling `sample` with a number will cause it to pick n unique elements from the array. I.e. the code can never be "R,R,G,O" because a color can't repeat. This cuts the possible codes from 1296 color combinations to just 360, if my math is correct.
The eventual solution is making `rand` for every peg in the code.

### Create an array with `*`
```ruby
a = [1, 2]
b = [3, 4]
[*a, *b]
=> [1, 2, 3, 4]
```
the `splat` operator (`*`) explodes the array into elements thus creating a single-dimension array in the last line.

### Knuth algorithm
It's a naïve implementation that doesn't sort the possibilities and sometimes goes over the 5 turns.

In order to guess in 5 turns or less the minimax technique to find a next guess should be applied. I just don't get the step 6 of worst-case scenario.  

### Squiggly `<<~HEREDOC`

### `chomp` on `HEREDOC`

Avoid last `\n` character in heredoc by using `chomp` along with heredoc like this
```ruby
<<~HEREDOC.chomp
```

### Clear the terminal screen
`system 'clear'` (maybe only for linux systems) or 
`puts "\e[H\e[2J"`

## Eventual Improvements List

- [ ] finish Knuth algorithm with minmax sorting from step 6

- [ ] refactor spaghetti code of Methodical Player algorithm

- [ ] difficulty levels for the game itself: more colours, less attempts, double colours, empty spaces instead of colours, etc.

- [ ] create Tournament of X number of alternating rounds

## Q's

- [ ] `@code_pegs` or colours should be a constant or generated on `Board` class creation? How to understand when to use what?

- [ ] to control the game flow is it preferable to use `case`- `when`  or `if` `else` statements?

- [ ] still don't understand very well `private` and `public` methods



