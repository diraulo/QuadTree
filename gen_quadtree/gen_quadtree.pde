Boundary b;
QuadTree q;

QuadTree[] terminalNodes; 
boolean drawn = false;
PImage img;
ArrayList<QuadTree> finalTree;
int[][] distanceGraph;

PrintWriter output;

void setup() {
  // Load the Map image
  img = loadImage("./maps/obstacles.jpg");
  size(img.width, img.height);
  frameRate(10);
  b = new Boundary(img);
  q = new QuadTree(b);

  q.generateNodes(img);
  
  // 1. Create a table of final Nodes
  println("Generating final Nodes");
  finalTree = new ArrayList<QuadTree>();
  q.getFinalNodes(finalTree, img);
  println("Final nodes generated, size is " + finalTree.size());
  int n = finalTree.size();
  
  // 2. Calculate Distances from each node
  //    to generate a Distance Graph
  distanceGraph = new int[n][n];
  getDistanceGraph(finalTree, distanceGraph, img);
  
  // Create a file to records distanceGraph
  output = createWriter("data/distGraph2.csv");
  for (int i=0; i<finalTree.size(); ++i){
    for (int j=0; j<finalTree.size(); ++j){
      println(distanceGraph[i][j]);
      output.print(distanceGraph[i][j] + ",");     
    }
    output.println();
  }
  
  output.flush();   // 
  output.close();   // Close file
}

void draw() {
  image(img, 0, 0);

  q.drawQuad(img);

  noFill();
  stroke(255, 0, 0);
}

void getDistanceGraph(ArrayList<QuadTree> finalTree,
                        int[][] distGraph, PImage img){
  for (int i=0; i<finalTree.size(); ++i){
    float x1 = finalTree.get(i).bound.X_m;
    float y1 = finalTree.get(i).bound.Y_m;
    
    for (int j=0; j<finalTree.size(); ++j){        
      float x2 = finalTree.get(j).bound.X_m;
      float y2 = finalTree.get(j).bound.Y_m;
      Boundary b = new Boundary(int(x1), int(y1), int(x2), int(y2));
        
      if (b.is_empty(img)){
        distGraph[i][j] = int(dist(x1, y1, x2, y2));
      } else {
        distGraph[i][j] = -1;
      }
    }
  }
}
