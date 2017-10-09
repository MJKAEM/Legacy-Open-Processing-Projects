/**
 * Variable Frame Rate
 *
 * Tests the usage of an uncapped frame rate, while unbounding movement to
 * frames.
 * 
 * This is perhaps not the best way to implement uncapped frame rate in
 * Processing due to the problems of the update method not being capped. This
 * can affect the behavior and reactions speeds of programmed artificial
 * intelligence, making them smarter due to having more frames to react. As a
 * result, capping their reaction ability may be the solution.
 */

// Global Variables
public static final float STANDARD_FRAME = 60;

// Main variables

private FramesCounter framesCounter;
private MovingCircle movingCircle;

public void setup()
{
	size(640, 480, P2D);
	frameRate(pow(2, 32));
	framesCounter = new FramesCounter();
	movingCircle = new MovingCircle(new PVector(width / 2, height / 2), 20);
}

public void draw()
{
	background(0, 0, 64);
	update();
	framesCounter.show();
	movingCircle.show();
}

public void update()
{
	movingCircle.update();
}

public void keyReleased()
{
	framesCounter.toggle();
}

// Global Methods

public float getUpdateUnit()
{
	return STANDARD_FRAME / frameRate;
}
/**
* FramesCounter.pde
*
* Displays the current frames and updates every second.
*/
public class FramesCounter {
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
 
	public void toggle()
	{
		if (keyCode == TILDE_VALUE) {
			setEnabled(!isEnabled());
			setFpsTimer(0);
		}
	}
 
	public void show()
	{
		if (isEnabled()) {
			if (getFpsTimer() >= 5) {
				setCurrentFrames((int)frameRate);
				setFpsTimer(0);
			}
 
			fill(255);
			textSize(12);
 
			// text(fpsTimer, 100, 100); //debug
			text(getCurrentFrames(), width - (log(getCurrentFrames()) * 5), height - 5);
 
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
public class MovingCircle {
	private float degreePosition;
	private PVector position;
	private float radius;

	public MovingCircle(PVector position, float radius)
	{
		this.position = position;
		this.radius = radius;
	}

	public void show()
	{
		ellipse(position.x + (cos(radians(degreePosition)) * (radius * 10)),
			position.y + (sin(radians(degreePosition)) * (radius * 10)),
			radius * 2,
			radius * 2);
	}

	public void update()
	{
		degreePosition += getUpdateUnit();
	}
}