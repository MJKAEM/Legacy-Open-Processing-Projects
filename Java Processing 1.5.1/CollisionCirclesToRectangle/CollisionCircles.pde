import java.awt.Color;

/**
 * Hello! In case you've decided to read my source code, you are in luck. I've
 * formatted it to help you understand part of the code so that you could learn
 * from it. Of course, there are many people on here who won't do this, but I
 * will do it for this one.<br/>
 * <br/>
 * Please feel free to use my code, but don't claim everything here belongs 
 * to you!<br/>
 * <br/>
 * By the way, if you don't know what this is, it is a Javadoc comment.<br/>
 * <br/>
 * If you hate these comments, switch to the uncommented ones.
 *
 * @author Martino Kuan
 * 
 */
 
private Circle centerCircle;
private Circle movableCircle;

/**
 * The '@Override' on top of void setup() is an annotation. I put that
 * there so you would know that it overrides PApplet.setup().
 */
@Override
public void setup()
{
  size(640, 480);

  // Places the 'centerCircle' circle in the center. 
  // (Good use of meaningful names)
  //
  centerCircle = new Circle(this, new PVector(320, 240), Color.WHITE);
}

@Override
public void draw()
{
  background(0);

  // Sets the 'movableCircle' center position to that of the mouse.
  //
  movableCircle = new Circle(this, new PVector(mouseX, mouseY), Color.RED);

  // If the two circles collide, change the 'centerCircle' color ring to blue.
  // Otherwise, keep it blue.
  //
  if (centerCircle.DetectCollide(movableCircle))
  {
    centerCircle.SetColor(Color.BLUE);
  }
  else
  {
    centerCircle.SetColor(Color.WHITE);
  }

  // Displays the two circles.
  //
  centerCircle.Show();
  movableCircle.Show();
}