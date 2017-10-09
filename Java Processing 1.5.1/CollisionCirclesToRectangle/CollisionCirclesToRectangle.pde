import java.awt.Color;
import java.awt.event.KeyEvent;

private static final long serialVersionUID = -1372953005378761478L;

private FramesCounter frameCounter;

private Circle centerCircle;
private Circle movableCircle;

private TheSquare centerSquare;
private TheSquare movableSquare;

// Wanted to use enum. BOOO... 1.5.1 Processing disappointment.
// CircleCircle(0), CircleSquare(1), SquareCircle(2), SquareSquare(3)
//
private int currentMode;

private boolean isDebugOverlay;

/**
 	 * The '@Override' on top of void setup() is an annotation. I put that
 	 * there so you would know that it overrides PApplet.setup().
 	 */
@Override
public void setup()
{
  size(640, 480);

  // Unlags the text
  //
  text("", 0, 0);

  frameCounter = new FramesCounter(this);

  // Places the 'centerCircle' circle in the center. 
  // (Good use of meaningful names)
  //
  centerCircle = new Circle(this, new PVector(320, 240), Color.WHITE);
  centerSquare = new TheSquare(this, new PVector(320 - 25, 240 - 25), Color.WHITE);
}

@Override
public void draw()
{
  background(0);

  switch(currentMode)
  {
    // Circle moves, circle center
    //
  case 0:
    {
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

      text("Circle moves, circle center", 10, 20);
      break;
    }

    // Circle moves, square center
    //
  case 1:
    {
      // Sets the 'movableCircle' center position to that of the mouse.
      //
      movableCircle = new Circle(this, new PVector(mouseX, mouseY), Color.RED);

      if (centerSquare.DetectCollide(movableCircle))
      {
        centerSquare.SetColor(Color.BLUE);
      }
      else
      {
        centerSquare.SetColor(Color.WHITE);
      }

      // Displays the two circles.
      //
      centerSquare.Show();
      movableCircle.Show();

      text("Circle moves, square center", 10, 20);
      break;
    }

    // Square moves, circle center
    //
  case 2:
    {
      // Sets the 'movableSquare' center position to that of the mouse.
      //
      movableSquare = new TheSquare(this, new PVector(mouseX - 25, mouseY - 25), Color.RED);

      if (centerCircle.DetectCollide(movableSquare))
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
      movableSquare.Show();

      text("Square moves, circle center", 10, 20);
      break;
    }

    // Square moves, square center
    //
  case 3:
    {
      // Sets the 'movableSquare' center position to that of the mouse.
      //
      movableSquare = new TheSquare(this, new PVector(mouseX - 25, mouseY - 25), Color.RED);

      if (centerSquare.DetectCollide(movableSquare))
      {
        centerSquare.SetColor(Color.BLUE);
      }
      else
      {
        centerSquare.SetColor(Color.WHITE);
      }

      // Displays the two circles.
      //
      centerSquare.Show();
      movableSquare.Show();

      text("Square moves, square center", 10, 20);
      break;
    }
  }
  DrawDebugCenterLines();
  frameCounter.Show();
}

@Override
public void keyReleased()
{
  switch(keyCode)
  {
  case KeyEvent.VK_1:
    {
      currentMode = 0;
      break;
    }
  case KeyEvent.VK_2:
    {
      currentMode = 1;
      break;
    }
  case KeyEvent.VK_3:
    {
      currentMode = 2;
      break;
    }
  case KeyEvent.VK_4:
    {
      currentMode = 3;
      break;
    }
  }

  if (key == '`')
  {
    frameCounter.Act();
    isDebugOverlay = !isDebugOverlay;
  }
}

public void DrawDebugCenterLines()
{
  if (isDebugOverlay)
  {
    stroke(255);
    strokeWeight(1);
    line(0, height/2, width, height/2);
    line(width / 2, 0, width / 2, height);
  }
}