class SquareTetra extends ATetra {
  
  SquareTetra() {
    super();
  }
  
  void init() {
    blocks[0] = new Block(START_X, START_Y, TetraType.O);
    blocks[1] = new Block(START_X + 1, START_Y, TetraType.O);
    blocks[2] = new Block(START_X, START_Y + 1, TetraType.O);
    blocks[3] = new Block(START_X + 1, START_Y + 1, TetraType.O);
  }
  
  void reposition(boolean left) {
    return;
  }
}
