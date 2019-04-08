import java.util.TreeMap;

class TetraStats {
  TreeMap<TetraType, Integer> clearedLines;
  TreeMap<TetraType, Integer> subOuts;
  TreeMap<TetraType, Integer> rotated;
  TreeMap<TetraType, Integer> onWhiteSpace;
  TreeMap<TetraType, Personality> personalities;
  
  TetraStats() {
    clearedLines = new TreeMap<TetraType, Integer>();
    subOuts = new TreeMap<TetraType, Integer>();
    rotated = new TreeMap<TetraType, Integer>();
    onWhiteSpace = new TreeMap<TetraType, Integer>(); 
    personalities = new TreeMap<TetraType, Personality>();
    reset();
  }
  
  void reset() {
    for (TetraType type : TetraType.values()) {
      clearedLines.put(type, 0);
      subOuts.put(type, 0);
      rotated.put(type, 0);
      onWhiteSpace.put(type, 0);
      personalities.put(type, Personality.NONE);
    }
  }
  
  void updateClearedLines(ATetra tetra) {
    TetraType type = tetra.blocks[0].tetraType;
    int val = clearedLines.get(type);
    clearedLines.put(type, val + 1);
    
  }
  
  void updateSubOuts(ATetra tetra) {
    TetraType type = tetra.blocks[0].tetraType;
    int val = subOuts.get(type);
    subOuts.put(type, val + 1);
  }
  
  void updateRotated(ATetra tetra) {
    TetraType type = tetra.blocks[0].tetraType;
    int val = rotated.get(type);
    rotated.put(type, val + 1);
  }
  
  void updateOnWhiteSpace(ATetra tetra) {
    TetraType type = tetra.blocks[0].tetraType;
    int val = onWhiteSpace.get(type);
    onWhiteSpace.put(type, val + 1);
  }
  
  // get the most lines cleared
  TetraType getMostLinesCleared(TetraType initial, ArrayList<TetraType> typesList) {
    return findInMap(clearedLines, initial, typesList, true);
  }
  
  // get the least lines cleared
  TetraType getLeastLinesCleared(TetraType initial, ArrayList<TetraType> typesList) {
    return findInMap(clearedLines, initial, typesList, false);
  }
  
  // get the most substitutions
  TetraType getMostSubOuts(TetraType initial, ArrayList<TetraType> typesList) {
    return findInMap(subOuts, initial, typesList, true);
  }
  
  // get the least substitutions
  TetraType getLeastSubOuts(TetraType initial, ArrayList<TetraType> typesList) {
    return findInMap(subOuts, initial, typesList, false);
  }
  
  // get the most rotations
  TetraType getMostRotations(TetraType initial, ArrayList<TetraType> typesList) {
    return findInMap(rotated, initial, typesList, true);
  }
  
  // get the most rotations
  TetraType getMostWhiteSpace(TetraType initial, ArrayList<TetraType> typesList) {
    return findInMap(onWhiteSpace, initial, typesList, true);
  }
  
  TetraType findInMap(TreeMap<TetraType, Integer> checkMap, TetraType initial, ArrayList<TetraType> typesList, boolean max) {
    TetraType result = initial;
    if (max) {
      int maxVal = checkMap.get(result);
      for (TetraType type : typesList) {
        int val = checkMap.get(type);
        if (val > maxVal) {
          maxVal = val;
          result = type;
        }
      }
    }
    else {
      int minVal = checkMap.get(result);
      for (TetraType type : typesList) {
        int val = checkMap.get(type);
        if (val < minVal) {
          minVal = val;
          result = type;
        }
      }
    }
    return result;
  }
  
  // this is where the "decision tree" logic and determinations are made
  TreeMap<TetraType, Personality> getPieceData() {
    ArrayList<TetraType> remainingTypes = new ArrayList<TetraType>();
    for (TetraType type : TetraType.values()) {
      remainingTypes.add(type);
    }
    // find out the most lines cleared
    TetraType initial = TetraType.I;
    TetraType mostClears = getMostLinesCleared(initial, remainingTypes);
    personalities.put(mostClears, Personality.REFUSE_SUB);
    remainingTypes.remove(mostClears);
    
    // find out the least lines cleared
    initial = remainingTypes.get(0);
    TetraType leastClears = getLeastLinesCleared(initial, remainingTypes);
    personalities.put(leastClears, Personality.REFUSE_LISTEN);
    remainingTypes.remove(leastClears);
    
    // find out the most rotations
    initial = remainingTypes.get(0);
    TetraType mostRotations = getMostRotations(initial, remainingTypes);
    personalities.put(mostRotations, Personality.REFUSE_ROTATE);
    remainingTypes.remove(mostRotations);
    
    // find out the most substitutions
    initial = remainingTypes.get(0);
    TetraType mostSubs = getMostSubOuts(initial, remainingTypes);
    personalities.put(mostSubs, Personality.APPEAR_MORE);
    remainingTypes.remove(mostSubs);
    
    // find out the least substitutions
    initial = remainingTypes.get(0);
    TetraType leastSubs = getLeastSubOuts(initial, remainingTypes);
    personalities.put(leastSubs, Personality.WONT_APPEAR);
    remainingTypes.remove(leastSubs);
    
    // find out the most whitespace
    initial = remainingTypes.get(0);
    TetraType mostWhiteSpace = getMostWhiteSpace(initial, remainingTypes);
    personalities.put(mostWhiteSpace, Personality.TRANSFORM);
    remainingTypes.remove(mostWhiteSpace);
    
    // for any remaining types we'll 
    for (TetraType type : remainingTypes) {
      personalities.put(type, Personality.NONE);
    }
    return personalities;
  }
}
