# CLI Ruby Chess Game
This is the last ruby project from Odin Project's course on ruby. Takes all the learned concepts and sums it into a single most extensive project 
of the course.

## Features
Fully functional chess game for Human VS HUman or Human VS Bot.
Bot chooses random possible moves, not based on any logic.

Any types of illegal moves which are not allowed within standard game rules, or any moves that leave king opened, are automatically detected and prohibited.
Game winning algorithm automatically detects when king is pinned and if there are no possible moves to protect him, game is finished and winner is announced.¸

Enabled special moves :
- possible 2 field jump for pawn's first move

Special moves that need to get implemented:
- en passant
- pawn promotion
- castling

## How to play
Board consists of horizontal rows labeled with numbers from 1 to 8 and vertical columns labeled with letters from a to b.
Play can choose his move by first writing a value of row and column of piece he wishes to move, then writing row and coluwm of the field he want to move piece to.
Examples: "2a 3a", "4D6F"