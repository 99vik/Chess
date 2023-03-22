# CLI Ruby Chess Game
This is the last ruby project from Odin Project's course on ruby. Takes all the learned concepts and sums it into a single most extensive project 
of the course.

## Features
Fully functional chess game for Human VS. HUman or Human VS. Bot.
Bot chooses random possible moves, not based on any logic.

Any types of illegal moves which are not allowed within standard game rules, or any moves that leave king opened, are automatically detected and prohibited.
The game winning algorithm automatically detects when the king is pinned and if there are no possible moves to protect him, the game is finished and the winner is announced.¸

Enabled special moves :
- Possible 2 field jump for pawn's first move

Special moves that need to get implemented:
- En passant
- Pawn promotion
- Castling

### Game saving and loading
Anytime during the game, players can save the game by typing 'save' in the console and enter a name for the current save, after which all current important variables are formatted and stored  in json file.

At the beginning player can choose an option to load previously saved games, that displays the names of all currently saved json files. Typing the name of the selected save loads json file and continues the game from the moment it was saved.

## How to play
The oard consists of horizontal rows labeled with numbers from 1 to 8 and vertical columns labeled with letters from a to b.
The player can choose his move by first writing a value of row and column of the piece he wishes to move, then writing row and column of the field he wants to move the piece to.
Examples: "2a 3a", "4D6F"
The player can type 'help' during game to show the instructions.

## Future improvements
- Implementing all previously mentioned special moves
- Adding some logic to the BOT player
