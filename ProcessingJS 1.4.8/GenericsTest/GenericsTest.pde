/**
 * A small program to determine whether OpenProcessing supports Java generics.
 *
 * Also testing a new slightly bluish hue for the background, so that the tweaked icon would be visible.
 *
 * ~ (Tilde) - Toggle FPS counter
 */

private FramesCounter framesCounter;

private Container<Circle> circleContainer;
private Container<Rectangle> rectangleContainer;
private Container<Triangle> triangleContainer;

public void setup()
{
	size(480, 360);
	frameRate(60);

	smooth();
	textSize(12);

	framesCounter = new FramesCounter();

	Circle circle = new Circle(new PVector(100, 100), 25);
	circleContainer = new Container(circle);

	Rectangle rectangle = new Rectangle(new PVector(width / 2, 200), 50, 50);
	rectangleContainer = new Container(rectangle);

	Triangle tri = new Triangle(new PVector(width - 100, 50), 50);
	triangleContainer = new Container(tri);
}

public void draw()
{
	background(0, 0, 64);

	circleContainer.update();
	circleContainer.show();

	rectangleContainer.update();
	rectangleContainer.show();

	triangleContainer.update();
	triangleContainer.show();

	framesCounter.show();
}

public void keyReleased()
{
	framesCounter.update();
}
public class Circle extends Shape
{
	private float radius;

	public Circle(PVector position, float radius)
	{
		super(position);

		this.radius = radius;
	}

	public void show()
	{
		ellipse(getPosition().x, getPosition().y, getRadius() * 2, getRadius() * 2);
	}

	//
	// Getters / Setters
	//

	public float getRadius()
	{
		return this.radius;
	}

	public void setRadius(float radius)
	{
		this.radius = radius;
	}
}
public class Container<E extends Shape>
{
	private E shape;

	public Container(E shape)
	{
		this.shape = shape;
	}

	public void show()
	{
		shape.show();
	}

	public void update()
	{
		shape.update();
	}

	//
	// Getters / Setters
	//

	public E getShape()
	{
		return this.shape;
	}
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
			textSize(12);

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
public class Rectangle extends Shape
{
	private float width, height;

	public Rectangle(PVector position, float width, float height)
	{
		super(position);

		this.width = width;
		this.height = height;
	}

	public void show()
	{
		rect(getPosition().x, getPosition().y, getWidth(), getHeight());
	}

	//
	// Getters / Setters/
	//

	public float getHeight()
	{
		return this.height;
	}

	public void setHeight(float height)
	{
		this.height = height;
	}

	public float getWidth()
	{
		return this.width;
	}

	public void setWidth(float width)
	{
		this.width = width;
	}
}
public abstract class Shape
{
	private PVector position;

	/**
	* false if oing down. true if going up.
	*/
	private boolean bouncing;

	protected Shape(PVector position)
	{
		this.position = position;
	}

	public void update()
	{
		if (bouncing)
		{
			if (getPosition().y <= 0)
			{
				bouncing = false;
			}
			else
			{
				setPosition(new PVector(getPosition().x, getPosition().y - 5));
			}
		}
		else
		{
			if (getPosition().y >= height)
			{
				bouncing = true;
			}
			else
			{
				setPosition(new PVector(getPosition().x, getPosition().y + 5));
			}
		}
	}

	public abstract void show();

	//
	// Getters / Setters
	//

	public PVector getPosition()
	{
		return this.position;
	}

	public void setPosition(PVector position)
	{
		this.position = position;
	}
}
public class Triangle extends Shape
{
	private float sideLength;

	public Triangle(PVector position, float sideLength)
	{
		super(position);

		this.sideLength = sideLength;
	}

	public void show()
	{
		float hypotenuse = sqrt(pow(sideLength, 2) + pow((sideLength / 2), 2)); 

		triangle(getPosition().x, getPosition().y,
			getPosition().x - (getSideLength() / 2), getPosition().y + hypotenuse,
			getPosition().x + (getSideLength() / 2), getPosition().y + hypotenuse);
	}

	//
	// Getters / Setters
	//

	public float getSideLength()
	{
		return this.sideLength;
	}

	public void setSideLength(float sideLength)
	{
		this.sideLength = sideLength;
	}
}
