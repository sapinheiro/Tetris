// the main tetra class that holds our common functionality
abstract class ATetra implements ITetra {
  // the position the block is in with regards to rotation
  int rotation;
  Block[] blocks;
  
  ATetra() {
    this.rotation = 0;
    this.blocks = new Block[4];
    init();
  }
  
  ATetra(int x, int y) {
    this.rotation = 0;
    this.blocks = new Block[4];
    init(x, y);
  }
  
  abstract void init();
  
  abstract void init(int x, int y);
  
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
    for (int i = 0; i < blocks.length; i++) {
      blocks[i].drawBlock(held, next);
    }
  }
  
  void animateTetra(Personality p) {
    switch(p) {
      case NONE:
        animateNormalTetra();
        break;
      case REFUSE_SUB:
        animateRefuseSub();
        break;
      case REFUSE_LISTEN:
        animateRefuseListen();
        break;
      case REFUSE_ROTATE:
        animateRefuseRotate();
        break;
      case APPEAR_MORE:
        animateAppearMore();
        break;
      case WONT_APPEAR:
        animateWontAppear();
        break;
      case TRANSFORM:
        animateTransform();
        break;
      default:
        throw new IllegalArgumentException("This should not happen");
    }
  }
  
  // animate normal tetra
  void animateNormalTetra() {
    // might have to adjust x and y of blocks
    drawTetra(false, false);
  }
  
  // animate a tetra being pulled out of the game, then very quickly going back to its place
  void animateRefuseSub() {
    for (int i = 0; i < 10; i++) {
      moveTetra("LEFT");
      drawTetra(false, false);
      delay(250);
    }
    delay(500);
    for (int i = 0; i < 10; i++) {
      moveTetra("RIGHT");
      drawTetra(false, false);
      delay(50);
    }
  }
  
  // draws a piece a golden color
  // put in a method since this will need to be flashing
  void drawCockyPiece() {
    for (int i = 0; i < blocks.length; i++) {
      stroke(0);
      fill(229, 209, 29);
      rect(blocks[i].x * BLOCK_SIZE, blocks[i].y * BLOCK_SIZE, BLOCK_SIZE, BLOCK_SIZE);
    }
  }
  
  // animate a "cocky" piece doing several excited movements on its own
  void animateRefuseListen() {
    drawCockyPiece();
    delay(100);
    drawTetra(false, false);
    drawCockyPiece();
    delay(100);
    drawTetra(false, false);
    drawCockyPiece();
    delay(100);
    drawTetra(false, false);
    moveTetra("LEFT");
    drawTetra(false, false);
    delay(100);
    moveTetra("RIGHT");
    drawTetra(false, false);
    delay(100);
    rotateTetra(true);
    drawTetra(false, false);
  }
  
  // animate piece rotating faster and faster then suddenly stopping
  void animateRefuseRotate() {
    for (int i = 0; i < 20; i++) {
      if (i < 5) {
        rotateTetra(true);
        delay(250);
        drawTetra(false, false);
      }
      else if (i >=5 && i < 10) {
        rotateTetra(true);
        delay(150);
        drawTetra(false, false);
      }
      else if (i >=10 && i < 15) {
        rotateTetra(true);
        delay(100);
        drawTetra(false, false);
      }
      else if (i >= 15) {
        rotateTetra(true);
        delay(50);
        drawTetra(false, false);
      }
    }
    drawTetra(false, false);
    delay(500);
  }
  
  // animate multiple copies of the piece flooding the screen
  void animateAppearMore() {
    animateNormalTetra();
  }
  
  // animate a "cocky" piece being slowly pulled out and then leaving quickly on its own
  void animateWontAppear() {
    for (int i = 0; i < 10; i++) {
      moveTetra("LEFT");
      drawTetra(false, false);
      delay(250);
    }
    delay(500);
    for (int i = 0; i < 10; i++) {
      moveTetra("LEFT");
      drawTetra(false, false);
      delay(50);
    }
  }
  
  // animate the piece transforming
  void animateTransform() {
    animateNormalTetra();
  }
}
