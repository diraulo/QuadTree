class Boundary {
  int Xl, Yl;    // X_low, Y_low
  int Xh, Yh;    // X_high, Y_high  
 
  // Boundary Mid-point coordinates
  int X_m; 
  int Y_m; 

  PImage img;
  
  color white = color(255, 255, 255);
  color black = color(0, 0, 0);
  
  Boundary (int x1, int y1, int x2, int y2) {
    Xl = (int)min(x1, x2);
    Xh = (int)max(x1, x2);
    
    Yl = (int)min(y1, y2);
    Yh = (int)max(y1, y2);
    
    midPoint();
  }
  
  Boundary (PImage img) {
    Xl = 0;
    Xh = img.width;
    
    Yl = 0;
    Yh = img.height;
    
    midPoint();
    this.img = img;
  }
  
  boolean pointInside(int x, int y) {
    return x > Xl && x < Xh && y > Yl && y < Yh;
  }  
  
  // Set the mid-point of a boundary
  void midPoint() {
    X_m = (Xl + Xh) / 2;
    Y_m = (Yl + Yh) / 2; 
  }
  
  // Check if a given boundary is empty
  boolean is_empty(PImage img1) {
    img1.loadPixels();
    
    for (int y = Yl; y < Yh; ++y) {
      for (int x = Xl; x < Xh; ++x) {      
        int pos = x + y * (img1.width);

        if (img1.pixels[pos] == color(0)) {
          //println("not empty boundary");
          return false;
        }
      }
    }
    return true;
  }
  
  // Check if a given boudary is full
  boolean is_full(PImage img1) {
    img1.loadPixels();

    for (int y = Yl; y < Yh; ++y) {
      for (int x = Xl; x < Xh; ++x) {      
        int pos = x + y * (img1.width);
        if ((int)img1.pixels[pos] == color(255)){
          //println ("boundary Not full");
          return false;
        }
      }
    }
    return true;
  }  
  
  // Check for mixed boundary
  boolean is_mixed(PImage img1) {
    return !(is_full(img1)) && !(is_empty(img1));
  } 
  
  Boundary[] quarter() {
    return quarter(0);
  }
  
  // Divide a boundary in 4
  Boundary[] quarter(int d) {
    int X_mid = (Xl + Xh) / 2;
    int Y_mid = (Yl + Yh) / 2;
    
    Boundary quads_child[] = new Boundary[4];
    
    quads_child[0] = new Boundary(X_mid-d, Yh+d, Xh+d, Y_mid-d);
    quads_child[1] = new Boundary(Xl-d, Yh+d, X_mid+d, Y_mid-d);
    quads_child[2] = new Boundary(Xl-d, Y_mid+d, X_mid+d, Yl-d);
    quads_child[3] = new Boundary(X_mid-d, Y_mid+d, Xh+d, Yl-d);
    
    return quads_child;
  }
  
  // Draw the boundries of the Quad
  void drawMe() {
    rect(Xl, Yl, Xh-Xl, Yh-Yl);
    
    // Place a point at the center of the Quad representing a node
    fill(color(0,255,0));
    noSmooth();
    point(X_m, Y_m); 
    noFill();  
  }
  
}
