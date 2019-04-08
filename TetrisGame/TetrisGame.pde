import java.util.Random;
import java.util.Map;
import processing.sound.*;
SoundFile file;

int frame = 0;
int TETRIS_FRAMES = 30;
// amount of lines to clear before personalites are determined
int DIFFICULTY = 10;

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
  // the tetra types mapped to their personalities
  // will be a treepmap
  Map<TetraType, Personality> personalities;
  // lines to be cleared
  ArrayList<Integer> toBeCleared;
  // the falling tetra piece
  ATetra activeTetra;
  // the next tetra piece
  ATetra nextTetra;
  // the held tetra piece
  ATetra heldTetra;
  int linesCleared;
  boolean justHeld;
  TetraStats tetraStats;
  boolean personalityMode;
  boolean refusalMode;
  
  Grid() {
    allBlocks = new ArrayList<Block>();
    personalities = new TreeMap<TetraType, Personality>();
    toBeCleared = new ArrayList<Integer>();
    nextTetra = null;
    heldTetra = null;
    linesCleared = 0;
    justHeld = false;
    tetraStats = new TetraStats();
    personalityMode = false;
    refusalMode = false;
    generateTetra();
  }
  
  // resets the game
  void reset() {
    allBlocks = new ArrayList<Block>();
    personalities = new TreeMap<TetraType, Personality>();
    toBeCleared = new ArrayList<Integer>();
    nextTetra = null;
    heldTetra = null;
    linesCleared = 0;
    justHeld = false;
    tetraStats.reset();
    personalityMode = false;
    refusalMode = false;
    generateTetra();
  }
  
  // generates tetra depending on conditions
  void generateTetra() {
    if (linesCleared < DIFFICULTY) {
      generateTetraNormal();
    }
    else {
      if (!personalityMode) {
        personalities = tetraStats.getPieceData();
      }
      personalityMode = true;
      generateTetraPersonality();
    }
  }
  // generates next two Tetra pieces
  void generateTetraNormal() {
    if (nextTetra == null) {
      activeTetra = generateRandomTetra();
      nextTetra = generateRandomTetra();
    }
    else {
      activeTetra = generateTetraByType(nextTetra.blocks[0].tetraType);
      nextTetra = generateRandomTetra();
    }
  }
  
  // generates tetra based on personality traits
  void generateTetraPersonality() {
    // this shouldn't ever be true but it's here for posterity
    if (nextTetra == null) {
      activeTetra = generateRandomTetra();
      nextTetra = generateRandomTetra();
    }
    else {
      activeTetra = generateTetraByType(nextTetra.blocks[0].tetraType);
      nextTetra = generateRandomTetra();
      Personality p = personalities.get(nextTetra.blocks[0].tetraType);
      while (p == Personality.WONT_APPEAR && refusalMode) {
        nextTetra = generateRandomTetra();
        p = personalities.get(nextTetra.blocks[0].tetraType);
      }
    }
  }
  
  ATetra generateTetraByType(TetraType tetraType) {
    Personality p = personalities.get(tetraType);
    if (p == Personality.TRANSFORM) {
      return new UglyTetra(tetraType);
    }
    
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
    int rand = 0;
    if (!personalityMode) {
      rand = rng.nextInt(7);
    }
    else {
      rand = rng.nextInt(12);
    }
    ATetra result = new LineTetra();
    switch (rand) {
      case 0: 
         result = new LineTetra();
         break;
      case 1: 
         result = new SquareTetra();
         break;
      case 2: 
         result = new STetra();
         break;
      case 3: 
         result = new ZTetra();
         break;
      case 4: 
         result = new LTetra();
         break;
      case 5:
         result = new JTetra();
         break;
      case 6:
         result = new TTetra();
         break;
      default:
        if (personalityMode) {
          for (Map.Entry<TetraType, Personality> item : personalities.entrySet()) {
            if (item.getValue() == Personality.APPEAR_MORE) {
              return generateTetraByType(item.getKey());
            }
          }
        }
        else {
          throw new IllegalStateException("Something went wrong generating tetra");
        }
    }
    
    Personality p = personalities.get(result.blocks[0].tetraType);
    if (personalityMode && p == Personality.TRANSFORM) {
      return new UglyTetra(result.blocks[0].tetraType);
    }
    return result;
  }
  
  // checks if the highest y is larger than the board
  boolean isGameOver() {
    for (Block b : allBlocks) {
      if (b.y <= ADJ) {
        return true;
      }
    }
    return false;
  }
  
  // checks if the active tetra has either hit the ground
  // or other fallen blocks
  boolean tetraStopped() {
    for (int i = 0; i < activeTetra.blocks.length; i++) {
      int block_x = activeTetra.blocks[i].x;
      int block_y = activeTetra.blocks[i].y;
      
      // tetra is touching bottom of grid
      if (block_y == (ADJ_GRID_HEIGHT - 1)) {
        justHeld = false;
        addBlocks(activeTetra);
        generateTetra();
        return true;
      }
      // if tetra is touching other blocks
      for (Block b : allBlocks) {
        if (block_x == b.x && (block_y + 1) == b.y) {
          justHeld = false;
          updateWhiteSpace();
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
  
  // checks if the given tetra is above whitespace and updates the stats
  void updateWhiteSpace() {
    ArrayList<Block> includeActive = new ArrayList<Block>();
    includeActive.addAll(allBlocks);
    
    for (int i = 0; i < activeTetra.blocks.length; i++) {
      includeActive.add(activeTetra.blocks[i]);
    }
    for (int i = 0; i < activeTetra.blocks.length; i++) {
      int xcoor = activeTetra.blocks[i].x;
      int ycoor = activeTetra.blocks[i].y;
      
      if (ycoor == (ADJ_GRID_HEIGHT - 1)) {
        continue;
      }
      
      boolean hasWhiteSpace = false;
      for (Block b : includeActive) {
        if (b.x == xcoor && b.y == (ycoor + 1)) {
          hasWhiteSpace = true;
        }
      }
      if (hasWhiteSpace) {
        tetraStats.updateOnWhiteSpace(activeTetra);
      }
    }
  }
  
  //drop block to the lowest possible y value from current position
  void dropBlock() {
    if (personalityMode) {
      Personality p = personalities.get(activeTetra.blocks[0].tetraType);
      if (p == Personality.REFUSE_LISTEN) {
        rotateActiveTetra(true);
      }
    }
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
    clearLines(tetra);
  }
  
  // clears lines that are full, then adjusts entire board 
  void clearLines(ATetra tetra) {
    for (int y = ADJ; y < ADJ_GRID_HEIGHT; y++) {
      if (lineFull(y)) {
        tetraStats.updateClearedLines(tetra);
        toBeCleared.add(y);
      }
    }
  }
  
  // clear line at given y
  void clearLine(int y) {
    // removes block on line
    for (int x = ADJ; x < ADJ_GRID_WIDTH; x++) {
      allBlocks.remove(blockExists(x, y));
    }
    linesCleared += 1;
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
    boolean wontListen = false;
    if (personalityMode) {
      Personality p = personalities.get(activeTetra.blocks[0].tetraType);
      if (p == Personality.REFUSE_LISTEN) {
        wontListen = true;
      }
    }
    if (!wontListen) {
      if (left && canMoveLeft()) {
        activeTetra.moveTetra("LEFT");
      }
      else if (!left && canMoveRight()) {
        activeTetra.moveTetra("RIGHT");
      }
    }
    else {
      if (!left && canMoveLeft()) {
        activeTetra.moveTetra("LEFT");
      }
      else if (left && canMoveRight()) {
        activeTetra.moveTetra("RIGHT");
      }
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
    if (personalityMode) {
      Personality p = personalities.get(activeTetra.blocks[0].tetraType);
      if (p == Personality.REFUSE_ROTATE) {
        return;
      }
    }
    activeTetra.rotateTetra(left);
    if (blocksOverlapping()) {
      activeTetra.rotateTetra(!left);
    }
    else {
      // rotation was successful
      tetraStats.updateRotated(activeTetra);
    }
  }
  
  // holds the block until later
  void holdTetra() {
    if (justHeld) {
      return;
    }
    if (personalityMode) {
      Personality p = personalities.get(activeTetra.blocks[0].tetraType);
      if (p == Personality.REFUSE_SUB) {
        return;
      }
      else if (p == Personality.WONT_APPEAR) {
        refusalMode = true;
      }
    }
    justHeld = true;
    tetraStats.updateSubOuts(activeTetra);
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
    if (isGameOver()) {
      String msg = "GAME OVER! FINAL SCORE IS " + linesCleared + "\nPress R to Reset";
      fill(0, 0, 0);
      textSize(30);
      text(msg, 100, 50);
      return;
    }
    if (personalityMode) {
      fill(0, 0, 0); 
      textSize(10);
      int counter = ADJ + 10;
      for (Map.Entry<TetraType, Personality> item : personalities.entrySet()) {
        String name = item.getKey().name();
        String val = item.getValue().name();
        text(name + " " + val, BLOCK_SIZE, counter * BLOCK_SIZE);
        counter++;
      }
    }
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
    fill(0, 0, 0);
    textSize(20);
    text("NEXT", (ADJ_GRID_WIDTH + 1) * BLOCK_SIZE, ADJ * BLOCK_SIZE);
    
    if (heldTetra != null) {
      // draws blocks in heldTetra
      heldTetra.drawTetra(true, false);
    }
    fill(0, 0, 0);
    textSize(20);
    text("HOLD", BLOCK_SIZE, ADJ * BLOCK_SIZE);
    
    fill(0, 0, 0);
    textSize(12);
    text("LINES CLEARED: " + linesCleared, 10, (ADJ_GRID_HEIGHT - 3) * BLOCK_SIZE);
    
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
  file = new SoundFile(this, "Tetris99Theme.mp3");
  file.play();
  file.loop();
}

// generates the drawing
// takes advantage of draw being called every frame and calls
// new pieces to be generated or moving the active tetra down
void draw() {
  clear();
  background(128, 128, 128);
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
    else if (keyCode == DOWN) {
      if (!grid.tetraStopped()) {
        grid.moveTetraDown();
      }
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
  else if (key == 'r') {
    grid.reset();
  }
}
