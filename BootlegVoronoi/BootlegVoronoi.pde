// The Nature of Code
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// A blob skeleton
// Could be used to create blobbly characters a la Nokia Friends
// http://postspectacular.com/work/nokia/friends/start

import pbox2d.*;

import org.jbox2d.common.*;
import org.jbox2d.collision.shapes.*;
import org.jbox2d.collision.shapes.Shape;
import org.jbox2d.dynamics.*;
import org.jbox2d.dynamics.joints.*;

// A reference to our box2d world
PBox2D box2d;

// A list we'll use to track fixed objects
ArrayList boundaries;

// Our "blob" object
ArrayList blobs;

Ball bullet;

void setup() {
  size(400,300);
  smooth();

  // Initialize box2d physics and create the world
  box2d = new PBox2D(this);
  box2d.createWorld();

  // Add some boundaries
  boundaries = new ArrayList();
  boundaries.add(new Boundary(width/2,height-5,width,10));   //bottom wall
  //  boundaries.add(new Boundary(width/2,5,width,10));          //top wall
  boundaries.add(new Boundary(width-5,height/2,10,height));  //right wall
  boundaries.add(new Boundary(5,height/2,10,height));        //left wall

  // Make a new blob
  blobs = new ArrayList();
  bullet = new Ball(width/2, -height, 25);
  bullet.killBody(); //don't just fall out of the sky.

  for(int i = 0; i < random(1,5); i++) {
    blobs.add(new Blob(new Vec2(random(30, width-30), random(30, height-30))));
  }
}

void draw() {
  background(255);

  // We must always step through time!
  box2d.step();

  // Show the blob!
  for (int i = 0; i < blobs.size();i++) {
    Blob blob = (Blob) blobs.get(i);
    blob.display();
  }


  // Show the boundaries!
  for (int i = 0; i < boundaries.size(); i++) {
    Boundary wall = (Boundary) boundaries.get(i);
    wall.display();
  }
  
  bullet.display();

  //WAY TOO MESSY!

  //  // Here we create a dynamic gravity vector based on the location of our mouse
  //  PVector g = new PVector(mouseX-width/2,mouseY-height/2);
  //  g.normalize();
  //  g.mult(10);
  //  box2d.setGravity(g.x, -g.y);
}

void keyPressed() {
  switch(key) {
  case 'r':
    setup();
    break;
  case ' ':
    bullet.killBody(); //if it's there, kill it
    bullet.makeBody( new Vec2(width/2, -height), 25); //make a fresh body
    bullet.body.setLinearVelocity( new Vec2( 0, -200f) ); //bombs away!
    break;
  }
}

void mousePressed() {
  blobs.add( new Blob( new Vec2(mouseX, mouseY) ) );
}




