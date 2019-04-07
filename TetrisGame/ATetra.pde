// the main tetra class that holds our common functionality
abstract class ATetra implements ITetra {
  // the position the block is in with regards to rotation
  int rotation;
  Block[] blocks;
  Personality personality;
  
  ATetra() {
    this.rotation = 0;
    this.personality = Personality.NONE;
    blocks = new Block[4];
    init();
  }
  
  ATetra(Personality personality, TetraType tetraType) {
    this.rotation = 0;
    this.personality = personality;
    blocks = new Block[4];
    initPersonality(tetraType);
  }
  
  void initPersonality(TetraType tetraType) {
    if (this.personality != Personality.TRANSFORM) {
      init();
    }
    else {
      blocks[0] = new Block(START_X, START_Y, tetraType);
      blocks[1] = new Block(START_X - 1, START_Y - 1, tetraType);
      blocks[2] = new Block(START_X - 1, START_Y + 1, tetraType);
      blocks[3] = new Block(START_X + 2, START_Y, tetraType);
    }
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
