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
    if (frame < 3) {
      moveTetra("LEFT");
      drawTetra(false, false);
    }
    else if (frame == 3) {
      drawTetra(false, false);
      delay(250);
    }
    else if (frame < 8) {
      moveTetra("RIGHT");
      drawTetra(false, false);
    }
    else if (frame < 12) {
      moveTetra("LEFT");
      drawTetra(false, false);
    }
    else if (frame < 15) {
      moveTetra("RIGHT");
      drawTetra(false, false);
    }
    delay(150);
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
        delay(500);
        return;
      case 1: 
        drawTetra(false, false);
        delay(250);
        return;
      case 2: 
        drawCockyPiece();
        delay(500);
        return;
      case 3:
        drawTetra(false, false);
        delay(250);
        return;
      case 4:
        drawCockyPiece();
        delay(500);
        return;
      case 5:
        drawTetra(false, false);
        delay(250);
        return;
      case 6:
         moveTetra("LEFT");
         drawTetra(false, false);
         delay(250);
         return;
      case 7: 
         moveTetra("RIGHT");
         drawTetra(false, false);
         delay(250);
         return;
      case 8: 
         moveTetra("RIGHT");
         drawTetra(false, false);
         delay(250);
         return;
      case 9:
         rotateTetra(true);
         drawTetra(false, false);
         delay(250);
         return;
      default:
         return;
      
    }
  }
  
  // animate piece rotating faster and faster then suddenly stopping
  void animateRefuseRotate(int frame) {
    if (frame < 3) {
      rotateTetra(true);
      delay(250);
      drawTetra(false, false);
    }
    else if (frame >=3 && frame < 6) {
      rotateTetra(true);
      delay(150);
      drawTetra(false, false);
    }
    else if (frame >= 6) {
      rotateTetra(true);
      delay(50);
      drawTetra(false, false);
    }
    else if (frame == 9) {
      drawTetra(false, false);
      delay(1000);
    }
  }
  
  // animate multiple copies of the piece flooding the screen
  void animateAppearMore(int frame) {
    Grid g = new Grid();
    int offset = 2;
    ATetra tetra1 = (g.generateTetraByType(this.blocks[0].tetraType, this.blocks[0].x + offset, this.blocks[0].y + offset));
    ATetra tetra2 = (g.generateTetraByType(this.blocks[0].tetraType, this.blocks[0].x + offset, this.blocks[0].y - offset));
    ATetra tetra3 = (g.generateTetraByType(this.blocks[0].tetraType, this.blocks[0].x - offset, this.blocks[0].y + offset));
    ATetra tetra4 = (g.generateTetraByType(this.blocks[0].tetraType, this.blocks[0].x - offset, this.blocks[0].y - offset));
    ATetra tetra5 = (g.generateTetraByType(this.blocks[0].tetraType, this.blocks[0].x , this.blocks[0].y - (offset * 3)));
    
    tetra1.drawTetra(false, false);
    tetra2.drawTetra(false, false);
    tetra3.drawTetra(false, false);
    tetra4.drawTetra(false, false);
    tetra5.drawTetra(false, false);
    delay(250);
  }
  
  // animate a piece being slowly pulled out and then leaving quickly on its own
  void animateWontAppear(int frame) {
    if (frame < 3) {
      moveTetra("LEFT");
      drawCockyPiece();
      delay(250);
    }
    else if (frame == 3) {
      drawCockyPiece();
      delay(500);
    }
    else if (frame < 8) {
      moveTetra("LEFT");
      drawCockyPiece();
      delay(50);
    }
  }
  
  // animate the piece transforming
  void animateTransform(int frame) {
    animateNormalTetra(frame);
    delay(50);
  }
}
