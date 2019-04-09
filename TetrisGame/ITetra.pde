interface ITetra {
  void init();
  
  void moveTetra(String direction);
  
  void rotateTetra(boolean left);
  
  void drawTetra(boolean held, boolean next);
  
  void reposition(boolean left);
  
  void animateTetra(Personality p);
}
