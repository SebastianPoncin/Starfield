boolean[] keys = {false, false, false, false};
int[] keylockout = {0, 0, 0, 0};
int num = 100;
int interval = 20;
//Particle[] particles = new Particle[num];
ArrayList<Particle> particles = new ArrayList<Particle>();


int score = 0;


void setup() {
  rectMode(CENTER);
  size(720, 720);
  for(int i = 0; i < num; i++) {
    if((int)(Math.random()*20) == 17) {
      particles.add(new OddBall((int)(Math.random()*4), (int)(Math.random()*100)*-1*interval-100, 1, 15));
    } else {
      particles.add(new Particle((int)(Math.random()*4), (int)(Math.random()*100)*-1*interval-100, 0, 30));
    }
  }
}

void draw() {
  background(0);
  stroke(255);
  strokeWeight(1);
  for (int i =0; i < 5; i++) {
    line(i*width/8+width/4, 0, i*width/4, height);
  }
 
  // keypress stuff
  for (int i = 0; i < 4; i++) {
    if(keys[i] && keylockout[i] == 0) {
        keylockout[i] = 3;
    }
  }
  line(10, 680, 710, 680);
  line(30, 600, 690, 600);
  if (keylockout[0] != 0) {
    keylockout[0] -= 1;
    fill(200);
    beginShape();
    vertex(30, 600);
    vertex(195, 600);
    vertex(185, 680);
    vertex(10, 680);
    vertex(30, 600);
    endShape();
  }
  if (keylockout[1] != 0) {
    keylockout[1] -= 1;
    fill(200);
    beginShape();
    vertex(195, 600);
    vertex(185, 680);
    vertex(360, 680);
    vertex(360, 600);
    vertex(195, 600);
    endShape();
  }
  if (keylockout[2] != 0) {
    keylockout[2] -= 1;
    fill(200);
    beginShape();
    vertex(360, 680);
    vertex(360, 600);
    vertex(525, 600);
    vertex(535, 680);
    vertex(360, 680);
    endShape();
  }
  if (keylockout[3] != 0) {
    keylockout[3] -= 1;
    fill(200);
    beginShape();
    vertex(525, 600);
    vertex(535, 680);
    vertex(710, 680);
    vertex(690, 600);
    vertex(525, 600);
    endShape();
  }
  
  for(int i = 0; i < particles.size(); i++) {
    Particle part = particles.get(i);
    if (part.y < 720) {
      part.update();
    }
    // kill detection
    for(int j = 0; j < 4; j++) {
      if (part.l == j && keylockout[j] > 0 && part.y <= 680 && part.y >= 600) {
        if (part instanceof OddBall) {
          score += 5; 
          //part.splode();
        } else {
          score += 1;
        }
        particles.remove(i);
        i -= 1;
      }
    }
  }
  
  
  
  fill(255);
  textSize(20);
  text(score, 20, 20);
}  

// keypress stuff
void keyPressed() {
  if (keyCode == 87) { // w
    keys[1] = true;
  }
  if (keyCode == 81) { // q
    keys[0] = true;
  }
  if (keyCode == 69) { // e
    keys[2] = true;
  }
  if (keyCode == 82) { // r
    keys[3] = true;
  }
}

void keyReleased() {
  if (keyCode == 87) { // w
    keys[1] = false;
  }
  if (keyCode == 81) { // q
    keys[0] = false;
  }
  if (keyCode == 69) { // e
    keys[2] = false;
  }
  if (keyCode == 82) { // r
    keys[3] = false;
  }
}



int topWidth = width/8;
int bottomWidth = width/4;

class OddBall extends Particle {
  OddBall(int lane, float ypos, int col, int high) {
    super(lane, ypos, col, high);
  }
  void splode() {
    fill(255, 255, 120);
    rect(0, 0, 720, 720);
  }
}




class Particle {
  float x, y, v, l, tw, bw, h, a; // x, y, speed, lane, topWidth, bottomWidth, height, angle
  int c;
  Particle(int lane, float ypos, int col, float high) {
    y = ypos;
    v = 3;
    l = lane;
    x = 180+lane*90; // topleft corner of lane at y
    tw = 40;
    bw = 80;
    h = high;
    a = 0;
    c = col;
  }
  void update() {
    
    // Top and bottom x-coordinates of each lane at `yPos`
    float laneTopX1 = 180 + l * 90;
    float laneTopX2 = laneTopX1 + 90;
    float laneBottomX1 = l * 180;
    float laneBottomX2 = laneBottomX1 + 180;
  
    // Interpolate the top and bottom x-coordinates for the note
    float topX1 = lerp(laneTopX1, laneBottomX1, y / 720.0);
    float topX2 = lerp(laneTopX2, laneBottomX2, y / 720.0);
    float bottomX1 = lerp(laneTopX1, laneBottomX1, (y + h) / 720.0);
    float bottomX2 = lerp(laneTopX2, laneBottomX2, (y + h) / 720.0);
  
    // y-coordinates for top and bottom of the note
    float topY = y;
    float bottomY = y + h;
    
    if (c == 0) {
      fill(100, 150, 250);
    } else {
      fill(250, 250, 120);
    }
    quad(topX1, topY, topX2, topY, bottomX2, bottomY, bottomX1, bottomY);
    
  
    float speedFactor;
    if (y > -50) {
      speedFactor = map(y, 0, height, v, v * 2.0);
    }  else {
      speedFactor = 1;
    }

    y += speedFactor;

  }
}

