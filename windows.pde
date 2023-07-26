
AEC aec;

Window window;
Window window2;


float counterMaxMS = 5000;
int counter = 0;
float t = 0;
int counterMaxFrames;





Life life;
Facade facade;


void setup() {

  noiseDetail(1,0.5);



  frameRate(25);
  size(1200, 400);
  
  PVector size = new PVector(10, 23);
  PVector origin = new PVector(30, 2);
  PVector spacing = new PVector(1,1);
  window = new Window(spacing,2, size, origin);
        
  size = new PVector(5, 5);
  origin = new PVector(20, 2);
  spacing = new PVector(1,1);
  window2 = new Window(spacing,5, size, origin);

  aec = new AEC();
  aec.init();


  counterMaxFrames = toFrames(counterMaxMS);

  // window.shiftGradient(CLOSE);

  PVector lifeOrigin = new PVector(10,10);
  PVector circleDist = new PVector(5,5);
  life = new Life(lifeOrigin, circleDist);

  facade = new Facade();
  facade.fill();


}




PVector faceSize = new PVector(10,24);




void draw() {
  aec.beginDraw();  
  background(0, 0,0);
  noStroke();


  if (counter == 0) {
    life.begin();
  }


  facade.animate();
  facade.draw();

  // life.draw();

  noFill();
  rect(10,10,1,1);


  // window._fill(255,0,0);


  float level = map(counter, 0, counterMaxFrames, 10, 1);
  // int spacingY = int(map(counter, 0, counterMaxFrames, 1, 0.0));
  // println(spacingY);
  // window.updateLevels(int(level));
  window.updateSpacing(1,2);
  window2.updateSpacing(1,2);


  t = easeInOutSine(t);

  aec.endDraw();
  aec.drawSides();

  t++;
  counter++;
}


float noiseLoop(float x,float y,float theta) {
  float rad = 1;
  float sc = 1; 
  float offset = 10; // parameters for the noise
  return noise(
    x*sc,
    y*sc+counter*.01
  );

}

// from easings.net
float easeInOutSine(float x) {
	return -(cos(PI * x) - 1) / 2;
}

void keyPressed() {
  aec.keyPressed(key);
}
