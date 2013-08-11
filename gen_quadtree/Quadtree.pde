class QuadTree {
  Boundary bound;
  QuadTree[] children;
  
  PImage img;
  
  int level;
  static final int maxLevel = 6;

  // Constructor
  // Receives a boundary object
  QuadTree(Boundary b) {
    this.bound = b;
    children = null;
    this.level = 0;
    this.img = b.img;
  } 

  // Constructor
  // Receives the image representing the map.
  // Will generate a boundary object to the size of the image
  QuadTree(PImage img) {
    this.bound = new Boundary(img);
    children = null;
    this.level = 0;
    this.img = img;
  } 
  
  // Constructor, takes a boundary object and the maxLevel 
  // maxLevel is the resolution, how deep we want to divide the quad
  QuadTree(Boundary b, int level) {
    this.bound = b;
    children = null;
    this.level = level;
    this.img = b.img;
  }
  
  // Divide a given Boundary into 4 smaller quadtrees
  QuadTree[] divide() {
    if (children == null && level < maxLevel) {
      
      children = new QuadTree[4];
      //println("created the following" + level);
      
      //Divide current Boundary into 4
      Boundary[] childs_b = bound.quarter();
      
      for (int i = 0; i < 4; ++i) {
        children[i] = new QuadTree(childs_b[i], level + 1);
      }
    }
    
    if (!(level < maxLevel))
      println ("Max resolution reached");
      
    return children;
  }
  
  void drawQuad(PImage img1) {
    //println ("Drawing . . .");
    if (bound.is_empty(img1))
      bound.drawMe();
      
    if (children == null) return;
    for (int i = 0; i < 4; ++i) {
      children[i].drawQuad(img1);
    }
  }
   
  void generateNodes(PImage img) {
    if (bound.is_mixed(img)) {
      // If current area has an obstacle divide it into 4
      divide();
      
      // If current Quad has no child, then generate children
      // It will recursively create children to this Quad
      // until max resolution reached or boundary is empty. 
      if (children != null) {
        for (int i = 0; i < children.length; ++i) {
          children[i].generateNodes(img);
        }
      }
    }
  }

  // getFinalNodes will generate a final list of Quads
  // Final list will only include boundaries that are completely empty
  void getFinalNodes(ArrayList<QuadTree> finalTree, PImage img) {
    if (this.bound.is_empty(img)) {
      // Add to finalTree
      finalTree.add(this);
      //println("Added");
    }
    
    if (children != null){
      //println ("here " + this.children.length);
      for (int i=0; i<this.children.length; ++i){
        children[i].getFinalNodes(finalTree, img);
      }
    }
  }
}
    
