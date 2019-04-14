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
  
  void animateTetra(Personality p, int frame) {
    switch(p) {
      case NONE:
        animateNormalTetra(frame);
        break;
      case REFUSE_SUB:
        animateRefuseSub(frame);
        break;
      case REFUSE_LISTEN:
        animateRefuseListen(frame);
        break;
      case REFUSE_ROTATE:
        animateRefuseRotate(frame);
        break;
      case APPEAR_MORE:
        animateAppearMore(frame);
        break;
      case WONT_APPEAR:
        animateWontAppear(frame);
        break;
      case TRANSFORM:
        animateTransform(frame);
        break;
      default:
        throw new IllegalArgumentException("This should not happen");
    }
  }
  
  // animate normal tetra
  void animateNormalTetra(int frame) {
    // might have to adjust x and y of blocks
    drawTetra(false, false);
  }
  
  // animate a tetra being pulled out of the game, then very quickly going back to its place
  void animateRefuseSub(int frame) {
    if (frame < 10) {
      moveTetra("LEFT");
      drawTetra(false, false);
    }
    else if (frame == 10) {
      delay(500);
    }
    else if (frame < 21) {
      moveTetra("RIGHT");
      drawTetra(false, false);
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
  void animateRefuseListen(int frame) {
    switch (frame) {
      case 0:
        drawCockyPiece();
        return;
      case 1: 
        drawTetra(false, false);
        return;
      case 2: 
        drawCockyPiece();
        return;
      case 3:
        drawTetra(false, false);
        return;
      case 4:
        drawCockyPiece();
        return;
      case 5:
        drawTetra(false, false);
        return;
      case 6:
         moveTetra("LEFT");
         drawTetra(false, false);
         return;
      case 7: 
         moveTetra("RIGHT");
         drawTetra(false, false);
         return;
      case 8:
         rotateTetra(true);
         drawTetra(false, false);
         return;
      default:
         return;
      
    }
  }
  
  // animate piece rotating faster and faster then suddenly stopping
  void animateRefuseRotate(int frame) {
    if (frame < 5) {
      rotateTetra(true);
      delay(250);
      drawTetra(false, false);
    }
    else if (frame >=5 && frame < 10) {
      rotateTetra(true);
      delay(150);
      drawTetra(false, false);
    }
    else if (frame >=10 && frame < 15) {
      rotateTetra(true);
      delay(100);
      drawTetra(false, false);
    }
    else if (frame >= 15) {
      rotateTetra(true);
      delay(50);
      drawTetra(false, false);
    }
    else if (frame == 20) {
      drawTetra(false, false);
    }
  }
  
  // animate multiple copies of the piece flooding the screen
  void animateAppearMore(int frame) {
    animateNormalTetra(frame);
  }
  
  // animate a "cocky" piece being slowly pulled out and then leaving quickly on its own
  void animateWontAppear(int frame) {
    if (frame < 10) {
      moveTetra("LEFT");
      drawTetra(false, false);
      delay(250);
    }
    else if (frame == 10) {
      delay(500);
    }
    else if (frame < 21) {
      moveTetra("LEFT");
      drawTetra(false, false);
      delay(50);
    }
  }
  
  // animate the piece transforming
  void animateTransform(int frame) {
    animateNormalTetra(frame);
  }
}
