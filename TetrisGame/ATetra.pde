// the main tetra class that holds our common functionality
abstract class ATetra implements ITetra {
  // the position the block is in with regards to rotation
  int rotation;
  Block[] blocks;
  
  ATetra() {
    this.rotation = 0;
    blocks = new Block[4];
    init();
  }
  
  abstract void init();
  
  // moves the tetra in the given direction
  void moveTetra(String direction) {
    for (int i = 0; i < blocks.length; i++) {
      blocks[i].move(direction);
    }
  }
  
  // rotates the tetra in the given direction
  void rotateTetra(boolean left) {
    if (left) {
      rotateTetraLeft();
    }
    else {
      rotateTetraRight();
    }
  }
  
  // adjusts rotation of tetra c-clockwise and repositions it
  void rotateTetraLeft() {
    rotation = rotation - 1;
    if (rotation < 0) {
      rotation = 3;
    }
    reposition(true);
  }
  
  // adjusts rotation of tetra clockwise and repositions it
  void rotateTetraRight() {
    rotation = rotation + 1;
    if (rotation > 3) {
      rotation = 0;
    }
    reposition(false);
  }
  
  abstract void reposition(boolean left);
  
  // draws the tetra
  void drawTetra(boolean held, boolean next) {
    for (int i = 0; i < blocks.length; i++) { //<>//
      blocks[i].drawBlock(held, next);
    }
  }
}
