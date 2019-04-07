import java.util.TreeMap;

class TetraStats {
  TreeMap<TetraType, Integer> clearedLines;
  TreeMap<TetraType, Integer> subOuts;
  TreeMap<TetraType, Integer> rotated;
  TreeMap<TetraType, Integer> onWhiteSpace;
  
  TetraStats() {
    clearedLines = new TreeMap<TetraType, Integer>();
    subOuts = new TreeMap<TetraType, Integer>();
    rotated = new TreeMap<TetraType, Integer>();
    onWhiteSpace = new TreeMap<TetraType, Integer>(); 
  }
  
  void reset() {
    for (TetraType type : TetraType.values()) {
      clearedLines.put(type, 0);
      subOuts.put(type, 0);
      rotated.put(type, 0);
      onWhiteSpace.put(type, 0);
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
  
  TetraType mostClearedLines() {
    TetraType result = TetraType.I;
    int maxCleared = clearedLines.get(result);
    for (TetraType type : TetraType.values()) {
      int val = clearedLines.get(type);
      if (val > maxCleared) {
        maxCleared = val;
        result = type;
      }
    }
    return result;
  }
  
  TetraType getMostSubOuts() {
    return findInMap(subOuts, TetraType.Z, true);
  }
  
  TetraType getLeastSubOuts() {
    return findInMap(subOuts, TetraType.Z, false);
  }
  
  TetraType findInMap(TreeMap<TetraType, Integer> checkMap, TetraType initial, boolean max) {
    TetraType result = initial;
    if (max) {
      int maxVal = checkMap.get(result);
      for (TetraType type : TetraType.values()) {
        int val = checkMap.get(type);
        if (val > maxVal) {
          maxVal = val;
          result = type;
        }
      }
    }
    else {
      int minVal = checkMap.get(result);
      for (TetraType type : TetraType.values()) {
        int val = checkMap.get(type);
        if (val < minVal) {
          minVal = val;
          result = type;
        }
      }
    }
    return result;
  }
}
