class ZTetra extends ATetra {
  
  ZTetra() {
    super();
  }
  
  ZTetra(int x, int y) {
    super(x, y);
  }
  
  void init() {
    blocks[0] = new Block(START_X, START_Y, TetraType.Z);
    blocks[1] = new Block(START_X + 1, START_Y, TetraType.Z);
    blocks[2] = new Block(START_X + 1, START_Y + 1, TetraType.Z);
    blocks[3] = new Block(START_X + 2, START_Y + 1, TetraType.Z);
  }
  
  void init(int x, int y) {
    blocks[0] = new Block(x, y, TetraType.Z);
    blocks[1] = new Block(x + 1, y, TetraType.Z);
    blocks[2] = new Block(x + 1, y + 1, TetraType.Z);
    blocks[3] = new Block(x + 2, y + 1, TetraType.Z);
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
        
        blocks[0].x = block_x - 1;
        blocks[0].y = block_y - 1;
        blocks[1].x = block_x;
        blocks[1].y = block_y - 1;
        blocks[2].x = block_x;
        blocks[2].y = block_y;
        blocks[3].x = block_x + 1;
        blocks[3].y = block_y;
        break;
      case 1:
        block_x = blocks[1].x;
        block_y = blocks[1].y;
        
        blocks[0].x = block_x;
        blocks[0].y = block_y + 1;
        blocks[2].x = block_x + 1;
        blocks[2].y = block_y;
        blocks[3].x = block_x + 1;
        blocks[3].y = block_y - 1;
        break;
      case 2: 
        block_x = blocks[2].x;
        block_y = blocks[2].y;
        
        blocks[0].x = block_x - 1;
        blocks[0].y = block_y;
        blocks[1].x = block_x;
        blocks[1].y = block_y;
        blocks[2].x = block_x;
        blocks[2].y = block_y + 1;
        blocks[3].x = block_x + 1;
        blocks[3].y = block_y + 1;
        break;
      case 3:
        block_x = blocks[2].x;
        block_y = blocks[2].y;
        
        blocks[0].x = block_x - 1;
        blocks[0].y = block_y + 1;
        blocks[1].x = block_x - 1;
        blocks[1].y = block_y;
        blocks[3].x = block_x;
        blocks[3].y = block_y - 1;
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
        block_x = blocks[2].x;
        block_y = blocks[2].y;
        
        blocks[0].x = block_x - 1;
        blocks[0].y = block_y - 1;
        blocks[1].x = block_x;
        blocks[1].y = block_y - 1;
        blocks[3].x = block_x + 1;
        blocks[3].y = block_y;
        break;
      case 1:
        block_x = blocks[2].x;
        block_y = blocks[2].y;
        
        blocks[0].x = block_x;
        blocks[0].y = block_y + 1;
        blocks[1].x = block_x;
        blocks[1].y = block_y;
        blocks[2].x = block_x + 1;
        blocks[2].y = block_y;
        blocks[3].x = block_x + 1;
        blocks[3].y = block_y - 1;
        break;
      case 2: 
        block_x = blocks[1].x;
        block_y = blocks[1].y;
        
        blocks[0].x = block_x - 1;
        blocks[0].y = block_y;
        blocks[2].x = block_x;
        blocks[2].y = block_y + 1;
        blocks[3].x = block_x + 1;
        blocks[3].y = block_y + 1;
        break;
      case 3:
        block_x = blocks[1].x;
        block_y = blocks[1].y;
        
        blocks[0].x = block_x - 1;
        blocks[0].y = block_y + 1;
        blocks[1].x = block_x - 1;
        blocks[1].y = block_y;
        blocks[2].x = block_x;
        blocks[2].y = block_y;
        blocks[3].x = block_x;
        blocks[3].y = block_y - 1;
        break;
      default:
        return;
    }
  }
  
}
