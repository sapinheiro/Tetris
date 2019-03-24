// an individual block of a tetra
class Block {
  int x;
  int y;
  // need to keep track of initial positions for drawing
  int initial_x;
  int initial_y;
  TetraType tetraType;
  
  Block(int x, int y, TetraType tetraType) {
    this.initial_x = x;
    this.initial_y = y;
    this.x = x;
    this.y = y;
    this.tetraType = tetraType;
  }
  
  // the different types of blocks 
  void drawBlock(boolean held, boolean next) {
    switch(tetraType) {
      case I:
        // draws cyan block
        drawColoredBlock(0, 255, 255, held, next);
        break;
      case O:
        // draws yellow block
        drawColoredBlock(255, 255, 0, held, next);
        break;
      case T:
        // draws violet block
        drawColoredBlock(145, 0, 255, held, next);
        break;
      case S:
        // draws green block
        drawColoredBlock(0, 255, 0, held, next);
        break;
      case Z:
        // draws red block
        drawColoredBlock(255, 0, 0, held, next);
        break;
      case J: 
        // draws blue block
        drawColoredBlock(0, 0, 255, held, next);
        break;
      case L:
        // draws orange block
        drawColoredBlock(255, 155, 0, held, next);
        break;
      default:
         return;
    }
  }
  
  // draws a block by its natural color
  void drawColoredBlock(int r, int g, int b, boolean held, boolean next) {
    int xval;
    int yval;
    if (!held && !next) {
      stroke(0);
      fill(r, g, b);
      rect(x * BLOCK_SIZE, y * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE);
    }
    else if (next) {
      xval = initial_x + 6;
      yval = initial_y;
      stroke(0);
      fill(r, g, b);
      rect(xval * BLOCK_SIZE, yval * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE);
    }
    else if (held) {
      xval = initial_x + 6;
      yval = ADJ_GRID_HEIGHT - initial_y;
      stroke(0);
      fill(r, g, b);
      rect(xval * BLOCK_SIZE, yval * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE);
    } }
  
  // moves block in given direction
  void move(String direction) {
    switch(direction) {
      case "LEFT":
        moveLeft();
        break;
      case "RIGHT":
        moveRight();
        break;
      case "DOWN":
        moveDown();
        break;
      default:
        return;
    }
  }
  
  // adjusts x value to the left
  void moveLeft() {
    this.x = this.x - 1;
  }
  
  // adjusts x value to the right
  void moveRight() {
    this.x = this.x + 1;
  }
  
  // adjusts y value down (increasing it)
  void moveDown() {
    this.y = this.y + 1;
  }
}
