/**
 * A short program to coordinate the angle of facing based on the mouse position.
 *
 * ~ (Tilde) - Toggles the FPS counter.
 */

private FramesCounter framesCounter;

public void setup()
{
	size(320, 240);
	smooth();

	framesCounter = new FramesCounter();
}

public void draw()
{
	background(0, 0, 64);

	fill(255);
	framesCounter.show();

	// Draw the circle
	noFill();
	stroke(255);
	ellipse(width / 2, height / 2, 100, 100);

	// Calculate ball's position.
	float lengthX = mouseX - (width / 2);
	float lengthY = mouseY - (height / 2);

	float hypotenuse = sqrt(pow(lengthX, 2) + pow(lengthY, 2));

	// float angleInRadians = asin(lengthY / hypotenuse);
	float angleInRadians = acos(lengthX / hypotenuse);

	if (mouseY < height / 2)
	{
		angleInRadians = TWO_PI - angleInRadians;
	}

	PVector ballPosition = new PVector((width / 2) + (cos(angleInRadians) * 50), 
		(height / 2) + (sin(angleInRadians) * 50));

	fill(0, 255, 0);
	ellipse(ballPosition.x, ballPosition.y, 10, 10);

	// Angles display
	fill(255);
	text("Angle: " + (int)degrees(angleInRadians), 5, 15);
}

public void keyReleased() 
{
	framesCounter.update();
}
/**
* FramesCounter.pde
*
* Displays the current frames and updates every second.
*/
public class FramesCounter
{
	public static final int F3_VALUE = 114;
	public static final int TILDE_VALUE = 192;

	private int currentFrames, fpsTimer;
	private boolean enabled;

	public FramesCounter()
	{
	}

	public FramesCounter(boolean enabled)
	{
		this.enabled = enabled;
	}

	public void update()
	{
		if (keyCode == TILDE_VALUE)
		{
			setEnabled(!isEnabled());
			setFpsTimer(0);
		}
	}

	public void show()
	{
		if (isEnabled())
		{
			if (getFpsTimer() >= 5)
			{
				setCurrentFrames((int)frameRate);
				setFpsTimer(0);
			}

			fill(255);

			// text(fpsTimer, 100, 100); //debug
			text(getCurrentFrames(), width - 20, height - 5);

			setFpsTimer(getFpsTimer() + 1);
		}
	}

	//
	// Getters / Setters
	//

	public int getCurrentFrames()
	{
		return this.currentFrames;
	}

	protected void setCurrentFrames(int currentFrames)
	{
		this.currentFrames = currentFrames;
	}

	public boolean isEnabled()
	{
		return this.enabled;
	}

	protected void setEnabled(boolean isEnabled)
	{
		this.enabled = isEnabled;
	}

	public int getFpsTimer()
	{
		return this.fpsTimer;
	}

	protected void setFpsTimer(int fpsTimer)
	{
		this.fpsTimer = fpsTimer;
	}
}