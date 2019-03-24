// fix hold and next
// add game over condition 
// move piece with down arrow
// limit on how often you can hold
// add score/labels 
// instructions?

import java.util.Random;

int frame = 0;
int TETRIS_FRAMES = 20;

Random rng = new Random();
Grid grid;
boolean delay = false;

// the main grid we're drawing
// deals with all the primary functions of the game including 
//generating new pieces and clearing lines
class Grid {
  // width and height are expressed in # of blocks
  int[][] spaces = new int[GRID_WIDTH][GRID_HEIGHT];
  // all the blocks that are no longer being controlled by the player
  ArrayList<Block> allBlocks;
  // lines to be cleared
  ArrayList<Integer> toBeCleared;
  // the falling tetra piece
  ATetra activeTetra;
  // the next tetra piece
  ATetra nextTetra;
  // the held tetra piece
  ATetra heldTetra;
  
  Grid() {
    allBlocks = new ArrayList<Block>();
    toBeCleared = new ArrayList<Integer>();
    nextTetra = null;
    heldTetra = null;
    generateTetra();
  }
  
  // generates next two Tetra pieces
  void generateTetra() {
    if (nextTetra == null) {
      activeTetra = generateRandomTetra();
      nextTetra = generateRandomTetra();
    }
    else {
      activeTetra = generateTetraByType(nextTetra.blocks[0].tetraType);
      nextTetra = generateRandomTetra();
    }
  }
  
  ATetra generateTetraByType(TetraType tetraType) {
    switch(tetraType) {
      case I:
        return new LineTetra();
      case O:
        return new SquareTetra();
      case T:
        return new TTetra();
      case S:
        return new STetra();
      case Z:
        return new ZTetra();
      case J: 
        return new JTetra();
      case L:
        return new LTetra();
      default:
         throw new IllegalArgumentException("Invalid Tetra Type");
    }
  }
  
  // generates a random tetra piece. 
  ATetra generateRandomTetra() {
    int rand = rng.nextInt(7);
    switch (rand) {
      case 0: 
         return new LineTetra();
      case 1: 
         return new SquareTetra();
      case 2: 
         return new STetra();
      case 3: 
         return new ZTetra();
      case 4: 
         return new LTetra();
      case 5:
         return new JTetra();
      case 6:
         return new TTetra();
      default:
         throw new IllegalStateException("Something went wrong generating tetra");
    }
  }
  
  // checks if the active tetra has either hit the ground
  // or other fallen blocks
  boolean tetraStopped() {
    for (int i = 0; i < activeTetra.blocks.length; i++) {
      int block_x = activeTetra.blocks[i].x;
      int block_y = activeTetra.blocks[i].y;
      
      // tetra is touching bottom of grid
      if (block_y == (ADJ_GRID_HEIGHT - 1)) {
        addBlocks(activeTetra);
        generateTetra();
        return true;
      }
      // if tetra is touching other blocks
      for (Block b : allBlocks) {
        if (block_x == b.x && (block_y + 1) == b.y) {
          addBlocks(activeTetra);
          generateTetra();
          return true;
        }    
      }
    }
    return false;
  }
  
  // checks if the active tetra is overlapping any blocks
  boolean blocksOverlapping() {
    for (int i = 0; i < activeTetra.blocks.length; i++) {
      int xcoor = activeTetra.blocks[i].x;
      int ycoor = activeTetra.blocks[i].y;
      
      if (xcoor < ADJ || xcoor >= ADJ_GRID_WIDTH) {
        return true;
      }
      if (ycoor >= ADJ_GRID_HEIGHT) {
        return true;
      }
      for (Block b : allBlocks) {
        if (b.x == xcoor && b.y == ycoor) {
          return true;
        }
      }
    }
    return false;
  }
  
  // drops the block to the lowest possible y value from current position
  void dropBlock() {
    while(!tetraStopped()) {
      moveTetraDown();
    }
  }
  
  // what should happen every frame
  void moveTetraDown() {
    activeTetra.moveTetra("DOWN");
  }
  
  // add blocks to populate the bottom of the grid
  // when blocks are added, we also do some cleanup
  void addBlocks(ATetra tetra) {
    for (int i = 0; i < tetra.blocks.length; i++) {
      allBlocks.add(tetra.blocks[i]);
    }
    clearLines(); //<>//
  }
  
  // clears lines that are full, then adjusts entire board 
  void clearLines() {
    for (int y = ADJ; y < ADJ_GRID_HEIGHT; y++) {
      if (lineFull(y)) { //<>//
        toBeCleared.add(y);
      }
    } //<>//
  }
  
  // clear line at given y
  void clearLine(int y) {
    // removes block on line
    for (int x = ADJ; x < ADJ_GRID_WIDTH; x++) { //<>//
      allBlocks.remove(blockExists(x, y));
    }
  }
  
  // checks if line at given y has a block at every x
  boolean lineFull(int y) {
    for (int x = ADJ; x < ADJ_GRID_WIDTH; x++) {
      if (blockExists(x, y) == null) {
        return false;
      }
    }
    return true;
  }
  
  // does a block exist at this position
  Block blockExists(int x, int y) {
    for (Block b : allBlocks) {
      if (b.x == x && b.y == y) {
        return b;
      }
    }
    return null;
  }
  
  // moves the active tetra left or right, if it can
  void moveActiveTetra(boolean left) {
    if (left && canMoveLeft()) {
      activeTetra.moveTetra("LEFT");
    }
    else if (!left && canMoveRight()) {
      activeTetra.moveTetra("RIGHT");
    }
  }
  
  // checks if the tetra can move to the left
  boolean canMoveLeft() {
    for (int i = 0; i < activeTetra.blocks.length; i++) {
      int block_x = activeTetra.blocks[i].x;
      int block_y = activeTetra.blocks[i].y;
      
      // tetra is touching bottom of grid
      if (block_x == ADJ) {
        return false;
      }
      // tetra touching another block
      for (Block b: allBlocks) {
        if (block_y == b.y && (block_x - 1) == b.x) {
          return false;
        }    
      }
    }
    return true;
  }
  
  // checks if the tetra can move right
  boolean canMoveRight() {
    for (int i = 0; i < activeTetra.blocks.length; i++) {
      int block_x = activeTetra.blocks[i].x;
      int block_y = activeTetra.blocks[i].y;
      
      // tetra is touching bottom of grid
      if (block_x == (ADJ_GRID_WIDTH - 1)) {
        return false;
      }
      // tetra is touching another block
      for (Block b: allBlocks) {
        if (block_y == b.y && (block_x + 1) == b.x) {
          return false;
        }    
      }
    }
    return true;
  }
  
  // rotate tetra in given direction
  void rotateActiveTetra(boolean left) {
    activeTetra.rotateTetra(left);
    if (blocksOverlapping()) {
      activeTetra.rotateTetra(!left);
    }
  }
  
  // holds the block until later
  void holdTetra() {
    if (heldTetra == null) {
      heldTetra = generateTetraByType(activeTetra.blocks[0].tetraType);
      activeTetra = generateTetraByType(nextTetra.blocks[0].tetraType);
      nextTetra = generateRandomTetra();
    }
    else {
      ATetra tempTetra = generateTetraByType(heldTetra.blocks[0].tetraType);
      heldTetra = generateTetraByType(activeTetra.blocks[0].tetraType);
      activeTetra = generateTetraByType(tempTetra.blocks[0].tetraType);
    }
  }
  
  // draws the grid including the active tetra and fallen blocks
  void drawGrid() {
    if (delay) {
      delay(250);
      delay = false;
    }
    // draws empty grid
    for (int i = ADJ; i < ADJ_GRID_WIDTH; i++) {
      for (int j = ADJ; j < ADJ_GRID_HEIGHT; j++) {
        stroke(0);
        fill(255, 255, 255);
        rect(i * BLOCK_SIZE, j * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE);
      }
    }
    
    // draws blocks in activeTetra
    activeTetra.drawTetra(false, false);
    
    // draws blocks in nextTetra
    nextTetra.drawTetra(false, true);
    
    if (heldTetra != null) {
      // draws blocks in heldTetra
      heldTetra.drawTetra(true, false);
    }
    
    // draws blocks on top of grid
    for (Block b : allBlocks) {
      b.drawBlock(false, false);
    }
    for (Integer y : toBeCleared) {
      for (int x = ADJ; x < ADJ_GRID_WIDTH; x++) {
        stroke(0);
        fill(229, 209, 29);
        rect(x * BLOCK_SIZE, y * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE);
      }
    }
    for (Integer y : toBeCleared) {
      clearLine(y);
      for (Block b : allBlocks) {
        if (b.y < y) {
          b.y = b.y + 1;
        }
      }
    }
    if (toBeCleared.size() > 0) {
      delay = true;
      toBeCleared.clear();
    }
  }
}

void setup() {
  size(600, 750);
  smooth();
  grid = new Grid();
}

// generates the drawing
// takes advantage of draw being called every frame and calls
// new pieces to be generated or moving the active tetra down
void draw() {
  frame++;
  grid.drawGrid();
  if (frame % TETRIS_FRAMES == 0) {
    if (!grid.tetraStopped()) {
      grid.moveTetraDown();
    }
  }
}

// the controls for the game
// left and right move the piece
// z and x rotate
void keyPressed() {
  if (key == CODED) {
    if (keyCode == LEFT) {
      grid.moveActiveTetra(true);
    }
    else if (keyCode == RIGHT) {
      grid.moveActiveTetra(false);
    }
    else if (keyCode == SHIFT) {
      grid.dropBlock();
    }
  }
  if (key == 'z') {
    grid.rotateActiveTetra(true);
  }
  else if (key == 'x') {
    grid.rotateActiveTetra(false);
  }  
  else if (key == ' ') {
    grid.holdTetra();
  }
}
