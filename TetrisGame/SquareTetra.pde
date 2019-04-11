class SquareTetra extends ATetra {
  
  SquareTetra() {
    super();
  }
  
  SquareTetra(int x, int y) {
    super(x, y);
  }
  
  void init() {
    blocks[0] = new Block(START_X, START_Y, TetraType.O);
    blocks[1] = new Block(START_X + 1, START_Y, TetraType.O);
    blocks[2] = new Block(START_X, START_Y + 1, TetraType.O);
    blocks[3] = new Block(START_X + 1, START_Y + 1, TetraType.O);
  }
  
  void init(int x, int y) {
    blocks[0] = new Block(x, y, TetraType.O);
    blocks[1] = new Block(x + 1, y, TetraType.O);
    blocks[2] = new Block(x, y + 1, TetraType.O);
    blocks[3] = new Block(x + 1, y + 1, TetraType.O);
  }
  
  void reposition(boolean left) {
    return;
  }
}
