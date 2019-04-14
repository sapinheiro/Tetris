interface ITetra {
  void init();
  
  void init(int x, int y);
  
  void moveTetra(String direction);
  
  void rotateTetra(boolean left);
  
  void drawTetra(boolean held, boolean next);
  
  void reposition(boolean left);
  
  void animateTetra(Personality p, int frame);
}
