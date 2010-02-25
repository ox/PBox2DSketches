// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// Basic example of falling rectangles

import pbox2d.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.common.*;
import org.jbox2d.dynamics.*;

// A reference to our box2d world
PBox2D box2d;

// A list we'll use to track fixed objects
ArrayList boundaries;
Vec2 mda;
boolean debug;

// A list for all of our rectangles
ArrayList boxes;

void setup() {
  size(800,300);
  smooth();

  // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();
  // We are setting a custom gravity
  box2d.setGravity(0, -20);

  debug = true;

  // Create ArrayLists	
  boxes = new ArrayList();
  boundaries = new ArrayList();
  mda = new Vec2(0.001, 0.001);

  // Add a bunch of fixed boundaries
  boundaries.add(new Boundary(width/4,height-5,width/2-65,10));
  boundaries.add(new Boundary(3*width/4,height-5,width/2-5,10));
  boundaries.add(new Boundary(width-5,height/2,10,height));
  boundaries.add(new Boundary(5,height/2,10,height));
  boundaries.add(new Boundary(5, 100,150,10) );
}

void draw() {
  background(debug?230:255);

  // We must always step through time!
  box2d.step();

  // Only make more boxes if there are more then 500 living boxes
  //boxes.size() < 500 && (mousePressed && mouseButton == LEFT && debug) && 
  if (second() %3 == 0 || (mousePressed && mouseButton == LEFT && debug) ) {
    Box k;
    if(mousePressed&&mouseButton == LEFT) k = new Box(mouseX, mouseY); else k = new Box(width/2,50);
    boxes.add(k);
  }

  // Display all the boundaries
  for (int i = 0; i < boundaries.size(); i++) {
    Boundary wall = (Boundary) boundaries.get(i);
    wall.display();
  }

  // Display all the boxes
  for (int i = 0; i < boxes.size(); i++) {
    Box p = (Box) boxes.get(i);
    p.display();
  }

  // Boxes that leave the screen, we delete them
  // (note they have to be deleted from both the box2d world and our list
  for (int i = boxes.size()-1; i >= 0; i--) {
    Box p = (Box) boxes.get(i);
    if (p.done()) {
      boxes.remove(i);
    }
  }
  
  if(debug && mda.x != 0.001 && mda.y != 0.001) {
    //draw debug rect to show where the boundary will be
    pushStyle();
    color(30);
    rect(mda.x, mda.y, mouseX-mda.x, mouseY-mda.y);
    popStyle();
  }
  
}

void mousePressed() {
  if(mouseButton == RIGHT) {
    if( debug ) {
      mda.set(mouseX, mouseY);
      println(mda.x + ", " + mda.y);
    }
  }
}

void mouseReleased() {
  if(mouseButton == RIGHT) {
    if(debug) {
      boundaries.add( new Boundary(mda.x, mda.y, abs(mouseX-mda.x), abs(mouseY-mda.y) ) );
      mda.set(0.001, 0.001);
      println(mda.x + ", " + mda.y);
    }
  }
}

void keyPressed() {
  switch(key) {
    case 'r':
      setup();
      break;
    case 'd':
      debug = !debug;
      break;
  }
}





