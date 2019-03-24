class LineTetra extends ATetra {
  
  LineTetra() {
    super();
  }
  
  void init() {
    for (int i = 0; i < blocks.length; i++) {
      int block_x = START_X + i;
      int block_y = START_Y;
      blocks[i] = new Block(block_x, block_y, TetraType.I);
    }
  }
  
  void reposition(boolean left) {
    if (left) {
      repositionLeft();
    }
    else {
      repositionRight();
    }
  }
  
  // rotation has decreased from previous value 
  void repositionLeft() {
    int block_x;
    int block_y;
    
    switch(rotation) {
      case 0:
        block_x = blocks[1].x;
        block_y = blocks[1].y;
        
        blocks[0].x = block_x - 2;
        blocks[0].y = block_y;
        blocks[1].x = block_x - 1;
        blocks[1].y = block_y;
        blocks[2].x = block_x;
        blocks[2].y = block_y;
        blocks[3].x = block_x + 1;
        blocks[3].y = block_y;
        break;
      case 1:
        block_x = blocks[2].x;
        block_y = blocks[2].y;
        
        blocks[0].x = block_x;
        blocks[0].y = block_y - 2;
        blocks[1].x = block_x;
        blocks[1].y = block_y - 1;
        blocks[3].x = block_x;
        blocks[3].y = block_y + 1;
        break;
      case 2: 
        block_x = blocks[2].x;
        block_y = blocks[2].y;
        
        blocks[0].x = block_x - 1;
        blocks[0].y = block_y;
        blocks[1].x = block_x;
        blocks[1].y = block_y;
        blocks[2].x = block_x + 1;
        blocks[2].y = block_y;
        blocks[3].x = block_x + 2;
        blocks[3].y = block_y;
        break;
      case 3:
        block_x = blocks[1].x;
        block_y = blocks[1].y;
        
        blocks[0].x = block_x;
        blocks[0].y = block_y - 1;
        blocks[2].x = block_x;
        blocks[2].y = block_y + 1;
        blocks[3].x = block_x;
        blocks[3].y = block_y + 2;
        break;
      default:
        return;
    }
  }
  
  // rotation has increased from previous value 
  void repositionRight() {
    int block_x;
    int block_y;
    
    switch(rotation) {
      case 0:
        block_x = blocks[1].x;
        block_y = blocks[1].y;
        
        blocks[0].x = block_x - 1;
        blocks[0].y = block_y;
        blocks[2].x = block_x + 1;
        blocks[2].y = block_y;
        blocks[3].x = block_x + 2;
        blocks[3].y = block_y;
        break;
      case 1:
        block_x = blocks[2].x;
        block_y = blocks[2].y;
        
        blocks[0].x = block_x;
        blocks[0].y = block_y - 1;
        blocks[1].x = block_x;
        blocks[1].y = block_y;
        blocks[2].x = block_x;
        blocks[2].y = block_y + 1;
        blocks[3].x = block_x;
        blocks[3].y = block_y + 2;
        break;
      case 2: 
        block_x = blocks[2].x;
        block_y = blocks[2].y;
        
        blocks[0].x = block_x - 2;
        blocks[0].y = block_y;
        blocks[1].x = block_x - 1;
        blocks[1].y = block_y;
        blocks[3].x = block_x + 1;
        blocks[3].y = block_y;
        break;
      case 3:
        block_x = blocks[1].x;
        block_y = blocks[1].y;
        
        blocks[0].x = block_x;
        blocks[0].y = block_y - 2;
        blocks[1].x = block_x;
        blocks[1].y = block_y - 1;
        blocks[2].x = block_x;
        blocks[2].y = block_y;
        blocks[3].x = block_x;
        blocks[3].y = block_y + 1;
        break;
      default:
        return;
    }
  }
  
}
