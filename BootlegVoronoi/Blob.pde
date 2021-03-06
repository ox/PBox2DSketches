// The Nature of Code (MODDD by Artem Titoulenko
// <http://www.shiffman.net/teaching/nature>
// Spring 2010
// PBox2D example

// A blob skeleton
// Could be used to create blobbly characters a la Nokia Friends
// http://postspectacular.com/work/nokia/friends/start

class Blob {

  // A list to keep track of all the points in our blob
  ArrayList skeleton;

  ArrayList balls;

  float bodyRadius;  // The radius of each body that makes up the skeleton
  float radius;      // The radius of the entire blob
  float totalPoints; // How many points make up the blob


  // We should modify this constructor to receive arguments
  // So that we can make many different types of blobs
  Blob(Vec2 pos) {

    // Create the empty 
    skeleton = new ArrayList();
    balls = new ArrayList();

    // Let's make a volume of joints!
    ConstantVolumeJointDef cvjd = new ConstantVolumeJointDef();

    // Where and how big is the blob
    Vec2 center = new Vec2(pos.x, pos.y);
    radius = 25;
    totalPoints = 25;
    bodyRadius = 3;

    for (int i = 0; i < 3; i++ ) {
      balls.add( new Ball(center.x + random(-radius*0.8, radius*0.8),center.y + random(-radius*0.8, radius*0.8), 4 ) );
    }


    // Initialize all the points
    for (int i = 0; i < totalPoints; i++) {
      // Look polar to cartesian coordinate transformation!
      float theta = PApplet.map(i, 0, totalPoints, 0, TWO_PI);
      float x = center.x + radius * sin(theta);
      float y = center.y + radius * cos(theta);

      // Make each individual body
      BodyDef bd = new BodyDef();
      bd.fixedRotation = false; // no rotation!
      bd.position.set(box2d.screenToWorld(x,y));
      Body body = box2d.createBody(bd);

      // The body is a circle
      CircleDef cd = new CircleDef();
      cd.radius = box2d.scaleScreenToWorld(bodyRadius);
      cd.density = 1.0f;
      //cd.filter.groupIndex = -2;  // What does this do?

      // Finalize the body
      body.createShape(cd);
      // Add it to the volume
      cvjd.addBody(body);
      // We always do this at the end
      body.setMassFromShapes();

      // Store our own copy for later rendering
      skeleton.add(body);
    }

    // These parameters control how stiff vs. jiggly the blob is
    cvjd.frequencyHz = 10.0f;
    cvjd.dampingRatio = 1.0f;

    // Put the joint thing in our world!
    box2d.world.createJoint(cvjd);

  }


  // Time to draw the blob!
  // Can you make it a cute character, a la http://postspectacular.com/work/nokia/friends/start
  void display() {

    // Draw the outline
    beginShape();
    noFill();
    stroke(0);
    strokeWeight(1);
    for (int i = 0; i < skeleton.size(); i++) {
      // We look at each body and get its screen position
      Body b = (Body) skeleton.get(i);
      Vec2 pos = box2d.getScreenPos(b);
      vertex(pos.x,pos.y);
    }
    endShape(CLOSE);

    // Display all the boxes
    for (int i = 0; i < balls.size(); i++) {
      Ball p = (Ball) balls.get(i);
      p.display();
    }
  }
}




