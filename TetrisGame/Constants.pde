enum TetraType {
  I, O, T, S, Z, J, L;
}

// size of each block
int BLOCK_SIZE = 25;
// adjustment to where we draw the grid
int ADJ = 5;
// where each block starts on the screen when falling
int START_X = 5 + ADJ;
int START_Y = ADJ;
// width and height of the grid
int GRID_WIDTH = 10;
int GRID_HEIGHT = 20;
// adjusted width and height of the grid
int ADJ_GRID_WIDTH = GRID_WIDTH + ADJ;
int ADJ_GRID_HEIGHT = GRID_HEIGHT + ADJ;
