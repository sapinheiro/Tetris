# Tetris

INSTRUCTIONS:
-Play the game until 10 lines are cleared (can be changed with DIFFICULTY variable. The game keeps track of movements, placements, rotations, substitutions, and cleared lines.

PERSONALITY KEY:
NONE - Normal behavior.
REFUSE_SUB - Will not allow itself to be subbed out.
REFUSE_LISTEN - Will do the opposite of what the player asks. Clicking SHIFT will rotate the block once then slam it down.
REFUSE_ROTATE - Will refuse to rotate.
APPEAR_MORE - Will appear almost twice as likely as any other piece.
WONT_APPEAR - If the player ever subs this piece out, it won't appear again.
TRANSFORM - The piece will... we'll it'll be obvious :p.

Additional personality ideas are welcome!

CONTROLS:
-Arrow keys to move block
-Shift to drop block
-Z and X to rotate
-Space to hold block
-R to reset game

NOTE ABOUT DECISION TREE:
-There's an implicit condition in each branch. For the "most" and "least" conditions, it only checks among the pieces that have yet to have an assigned personality.