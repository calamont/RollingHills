//draws a rolling green hill with blue sky

import megamu.mesh.*;

Delaunay myNetwork;
float[][] points;
float[][] hill;
ArrayList<PVector> starts, ends, triangle, hillStarts, hillEnds, hillTriangle;;
int vertices, counter;
color g1, g2, white;

void setup() {
  smooth();
  size(2800,1800);
  vertices = 1000;
  counter = 0;
  
  points = new float[vertices][2];
  hill = new float[vertices][2];
  starts = new ArrayList<PVector>();
  ends = new ArrayList<PVector>();
  triangle = new ArrayList<PVector>();
  
  hillStarts = new ArrayList<PVector>();
  hillEnds = new ArrayList<PVector>();
  hillTriangle = new ArrayList<PVector>();
  
  g1 = color(0,153,0);
  g2 = color(205,255,204);
  white = color(255);
  
  //initialising surface points for the hill
  for (int i=1; i<(width/40)+1; i++) {
   counter++;
   hill[i-1][0] = i*40;
   hill[i-1][1] = (3.3*height)/4-(50000*sin((i*40)*0.004)/(i*40));
  }

  //initialising bulk points for the hill
  for (int i=counter; i<vertices; i++) {
   hill[i][0] = random(0,width);
   hill[i][1] = random(0,height);
  }
    
}

void draw() {
  noLoop();
  background(255);
  myNetwork = new Delaunay(points);
  Delaunay myHill = new Delaunay(hill);
  float[][] myEdges = myNetwork.getEdges();
  float[][] HillEdges = myHill.getEdges();
  
  for (int i=0; i<100; i++) {
    triangle.add(new PVector(-1,-1));
    hillTriangle.add(new PVector(-1,1));
  }  
   
   for (int i=0; i<HillEdges.length; i++) {
    float startX = HillEdges[i][0];
    float startY = HillEdges[i][1];
    float endX = HillEdges[i][2];
    float endY = HillEdges[i][3];
    hillStarts.add(new PVector(startX,startY));
    hillEnds.add(new PVector(endX,endY));
  }
  
  findTriag(hillStarts,hillEnds,hillTriangle, new PVector(0,0), new PVector(0,0), -1); 
  save("hills2.png");
}

void findTriag(ArrayList<PVector> startPoints, ArrayList<PVector> endPoints, ArrayList<PVector> triagPoints, PVector start, PVector point, int n) {
  if (n==-1) {
    for(int i=0; i<startPoints.size(); i++) {
      PVector startPoint = startPoints.get(i);
      PVector endPoint = endPoints.get(i);
      triagPoints.set(0,startPoint);
      triagPoints.set(1,endPoint);
      findTriag(startPoints,endPoints,triagPoints, startPoint, endPoint, 0);
    }
  }
  else if (n>-1 && n<2) {
    for(int i=0; i<startPoints.size(); i++) {
      if (PVector.dist(point, startPoints.get(i)) == 0) {
        PVector newPoint = endPoints.get(i);
        triagPoints.set((n+2),newPoint);
        findTriag(startPoints, endPoints, triagPoints, start, newPoint, n+1);
      } else if (PVector.dist(point, endPoints.get(i)) == 0) {
        PVector newPoint = startPoints.get(i);
        triagPoints.set((n+2),newPoint);
        findTriag(startPoints, endPoints, triagPoints, start, newPoint, n+1);
      }
    }
  } else if (PVector.dist(start,triagPoints.get(3)) == 0) {
    float centre_x = (triagPoints.get(0).x+triagPoints.get(1).x+triagPoints.get(2).x)/3;
    float centre_y = (triagPoints.get(0).y+triagPoints.get(1).y+triagPoints.get(2).y)/3;
    float centre_line1 = ((3.3*height)/4-(50000*sin(centre_x*0.004)/centre_x));
 
    float centre_line2 = ((3.3*height)/4-(8500*sin(centre_x*0.01)/centre_x));
    float centre_line3 = ((3.4*height)/4-(7000*sin(centre_x*0.01)/centre_x));
    float centre_line4 = ((3.6*height)/4-(5500*sin(centre_x*0.01)/centre_x));
    float centre_line5 = ((3.8*height)/4-(4000*sin(centre_x*0.01)/centre_x));
 
    if (centre_y<centre_line1) {
      float dist = 0.2*(centre_line1-centre_y)/(centre_line1);
      dist = lerp(0,255,dist);
      fill(random(0,255),255,255,dist);
      noStroke();
    } else {
      color greenShade = lerpColor(g1,g2,(centre_x/width));
      fill(greenShade,random(0,155));
      noStroke();
      strokeWeight(2);
      if (dist(centre_x,centre_y,centre_x,centre_line1+randomGaussian()*100)<50) {
       stroke(g1);
      } else {
      noStroke();
      }
    }
    if (dist(centre_x,centre_y,1.2*width+randomGaussian()*500,randomGaussian()*100)<1000) {
     stroke(255);
     strokeWeight(3);
     line(triagPoints.get(0).x, triagPoints.get(0).y,triagPoints.get(1).x, triagPoints.get(1).y);
     line(triagPoints.get(1).x, triagPoints.get(1).y,triagPoints.get(2).x, triagPoints.get(2).y);
     line(triagPoints.get(2).x, triagPoints.get(2).y,triagPoints.get(0).x, triagPoints.get(0).y);
    }
   
    beginShape();
    vertex(triagPoints.get(0).x, triagPoints.get(0).y);
    vertex(triagPoints.get(1).x, triagPoints.get(1).y);
    vertex(triagPoints.get(2).x, triagPoints.get(2).y);
    vertex(triagPoints.get(3).x, triagPoints.get(3).y);
    endShape(CLOSE);
    

  }
}
    
      
        