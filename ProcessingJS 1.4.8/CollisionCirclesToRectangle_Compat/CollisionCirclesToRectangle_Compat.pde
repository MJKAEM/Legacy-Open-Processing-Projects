/**
 * An expansion to the 'Collision Circles' program.
 *
 * An addition to the original program is a square. There are also four modes to switch to that will check for collision between the shapes.
 *
 * Keyboard buttons:
 * 1 - Switch to 'Circle moves, circle center' mode
 * 2 - Switch to 'Circle moves, square center' mode
 * 3 - Switch to 'Square moves, circle center' mode
 * 4 - Switch to 'Square moves, square center' mode
 * ~ (Tilde) - Enable/disable the debug overlay
 *
 * This has been ported to OpenProcessing.
 */

 private FramesCounter frameCounter;

private Circle centerCircle;
private Circle movableCircle;

private Rectangle centerSquare;
private Rectangle movableSquare;

// Wanted to use enum. BOOO... 1.5.1 Processing disappointment.
// CircleCircle(0), CircleSquare(1), SquareCircle(2), SquareSquare(3)
//
private int currentMode;
private boolean isDebugOverlay;

public void setup()
{
    size(480, 360);
    smooth();
    textSize(12);

    frameCounter = new FramesCounter();

    // Places the 'centerCircle' circle in the center.
    //
    centerCircle = new Circle(new PVector(width / 2, height / 2), 25, Shape.COLOR_WHITE, Shape.COLOR_RED);
    centerSquare = new Rectangle(new PVector(width / 2, height / 2), 50, 50, Shape.COLOR_WHITE, Shape.COLOR_RED);
}

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
            movableCircle = new Circle(new PVector(mouseX, mouseY), 25, Shape.COLOR_BLUE);

            // If the two circles collide, change the 'centerCircle' color ring to blue.
            // Otherwise, keep it blue.
            //
            centerCircle.shiftCurrentColor(centerCircle.detectCollide(movableCircle));

            // Displays the two circles.
            //
            centerCircle.show();
            movableCircle.show();

            text("Circle moves, circle center", 10, 20);
            break;
        }

        // Circle moves, square center
        //
        case 1:
        {
            // Sets the 'movableCircle' center position to that of the mouse.
            //
            movableCircle = new Circle(new PVector(mouseX, mouseY), 25, Shape.COLOR_BLUE);

            centerSquare.shiftCurrentColor(centerSquare.detectCollide(movableCircle));

            // Displays the two circles.
            //
            centerSquare.show();
            movableCircle.show();

            text("Circle moves, square center", 10, 20);
            break;
        }

        // Square moves, circle center
        //
        case 2:
        {
            // Sets the 'movableSquare' center position to that of the mouse.
            //
            movableSquare = new Rectangle(new PVector(mouseX, mouseY), 50, 50, Shape.COLOR_BLUE);

            centerCircle.shiftCurrentColor(centerCircle.detectCollide(movableSquare));

            // Displays the two circles.
            //
            centerCircle.show();
            movableSquare.show();

            text("Square moves, circle center", 10, 20);
            break;
        }

        // Square moves, square center
        //
        case 3:
        {
            // Sets the 'movableSquare' center position to that of the mouse.
            //
            movableSquare = new Rectangle(new PVector(mouseX, mouseY), 50, 50, Shape.COLOR_BLUE);

            centerSquare.shiftCurrentColor(centerSquare.detectCollide(movableSquare));

            // Displays the two circles.
            //
            centerSquare.show();
            movableSquare.show();

            text("Square moves, square center", 10, 20);
            break;
        }
    }

    drawDebugCenterLines();
    frameCounter.show();
}

public void keyReleased()
{
    switch(key)
    {
        case '1':
        {
            currentMode = 0;
            break;
        }
        case '2':
        {
            currentMode = 1;
            break;
        }
        case '3':
        {
            currentMode = 2;
            break;
        }
        case '4':
        {
            currentMode = 3;
            break;
        }

        case '`':
        {
            isDebugOverlay = !isDebugOverlay;
            break;
        }
    }

    frameCounter.update();
}

public void drawDebugCenterLines()
{
    if (isDebugOverlay)
    {
        stroke(255);
        strokeWeight(1);
        line(0, height/2, width, height/2);
        line(width / 2, 0, width / 2, height);
    }
}


/**
* Circle.pde
*/
public class Circle extends Shape implements Collidable<Shape>
{
    private float _radius;

    public Circle(PVector centerPosition, float _radius)
    {
        this(centerPosition, _radius, COLOR_BLUE, COLOR_RED);
    }


    public Circle(PVector centerPosition, float _radius, color _color1)
    {
        this(centerPosition, _radius, _color1, COLOR_RED);
    }

    public Circle(PVector centerPosition, float _radius, color _color1, color _color2)
    {
        super(centerPosition, _color1, _color2);

        this._radius = _radius;
    }

    public void show()
    {
        noFill();
        strokeWeight(DEFAULT_STROKE_WEIGHT);
        stroke(getCurrentColor());

        ellipse(getCenterPosition().x, getCenterPosition().y, getRadius() * 2, getRadius() * 2);
    }

    public boolean detectCollide(Shape shape)
    {
        if (this == shape)
        {
            return false;
        }

        if (shape instanceof Circle)
        {
            Circle circle = (Circle)shape;

            double sideX = pow(circle.getCenterPosition().x - this.getCenterPosition().x, 2);
            double sideY = pow(circle.getCenterPosition().y - this.getCenterPosition().y, 2);

            // The hypotenuse calculated using the two sides.
            //
            double hypo = sqrt((float)(sideX + sideY));

            if (hypo < (this.getRadius() + DEFAULT_STROKE_WEIGHT) + circle.getRadius())
            {
                return true;
            }
        }
        else if (shape instanceof Rectangle)
        {
            Rectangle rectangle = (Rectangle)shape;

            if (this.getCenterPosition().x < rectangle.getCenterPosition().x && 
                this.getCenterPosition().y >= rectangle.getCenterPosition().y)
            {
                for (int i = 89; i >= 0; --i)
                {
                    double positionX = this.getCenterPosition().x + ((this.getRadius() + DEFAULT_STROKE_WEIGHT) * cos(radians(i)));
                    double positionY = this.getCenterPosition().y - ((this.getRadius() + DEFAULT_STROKE_WEIGHT) * sin(radians(i)));

                    if (rectangle.calculateTopLeftPosition().x <= positionX && 
                        rectangle.calculateTopLeftPosition().y + rectangle.getHeight() >= positionY)
                    {
                        return true;
                    }
                }
            }
            else if (this.getCenterPosition().x >= rectangle.getCenterPosition().x && 
                this.getCenterPosition().y > rectangle.getCenterPosition().y)
            {
                for (int i = 89; i >= 0; --i)
                {
                    double positionX = this.getCenterPosition().x - ((this.getRadius() + DEFAULT_STROKE_WEIGHT) * cos(radians(i)));
                    double positionY = this.getCenterPosition().y - ((this.getRadius() + DEFAULT_STROKE_WEIGHT) * sin(radians(i)));

                    if (rectangle.calculateTopLeftPosition().x + rectangle.getWidth() >= positionX && 
                        rectangle.calculateTopLeftPosition().y + rectangle.getHeight() >= positionY)
                    {
                        return true;
                    }
                }
            }
            else if (this.getCenterPosition().x > rectangle.getCenterPosition().x && 
                this.getCenterPosition().y <= rectangle.getCenterPosition().y)
            {
                for (int i = 89; i >= 0; --i)
                {
                    double positionX = this.getCenterPosition().x - ((this.getRadius() + DEFAULT_STROKE_WEIGHT) * cos(radians(i)));
                    double positionY = this.getCenterPosition().y + ((this.getRadius() + DEFAULT_STROKE_WEIGHT) * sin(radians(i)));

                    if (rectangle.calculateTopLeftPosition().x + rectangle.getWidth() >= positionX && 
                        rectangle.calculateTopLeftPosition().y <= positionY)
                    {
                        return true;
                    }
                }
            }
            else if (this.getCenterPosition().x <= rectangle.getCenterPosition().x && 
                this.getCenterPosition().y <= rectangle.getCenterPosition().y)
            {
                for (int i = 89; i >= 0; --i)
                {
                    double positionX = this.getCenterPosition().x + ((this.getRadius() + DEFAULT_STROKE_WEIGHT) * cos(radians(i)));
                    double positionY = this.getCenterPosition().y + ((this.getRadius() + DEFAULT_STROKE_WEIGHT) * sin(radians(i)));

                    if (rectangle.calculateTopLeftPosition().x <= positionX && 
                        rectangle.calculateTopLeftPosition().y <= positionY)
                    {
                        return true;
                    }
                }
            }

            return false;
        }

        return false;
    }

    //
    // Getters / Setters
    //

    public float getRadius()
    {
        return this._radius;
    }

    protected void setRadius(float _radius)
    {
        this._radius = _radius;
    }
}


/**
* Collidable.pde
*
* An interface for all collidable objects.
*/
public interface Collidable<E>
{
    boolean detectCollide(E object);
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


/**
* Rectangle.pde
*/
public class Rectangle extends Shape implements Collidable<Shape>
{
    // Thanks, ProcessingJS, for forcing me to use underscores.
    //
    private float _width, _height;

    public Rectangle(PVector centerPosition, float _width, float _height)
    {
        this(centerPosition, _width, _height, COLOR_BLUE);
    }

    public Rectangle(PVector centerPosition, float _width, float _height, color _color1)
    {
        this(centerPosition, _width, _height, _color1, COLOR_RED);
    }

    public Rectangle(PVector centerPosition, float _width, float _height, color _color1,
        color _color2)
    {
        super(centerPosition, _color1, _color2);

        this._width = _width;
        this._height = _height;
    }

    public void show()
    {
        stroke(getCurrentColor());
        noFill();
        strokeWeight(DEFAULT_STROKE_WEIGHT);
        rect(getCenterPosition().x - (getWidth() / 2), getCenterPosition().y - (getHeight() / 2),
            getWidth(), getHeight());
    }

    public PVector calculateTopLeftPosition()
    {
        return PVector.sub(getCenterPosition(), new PVector(getWidth() / 2, getHeight() / 2));
    }

    public boolean detectCollide(Shape shape)
    {
        if (this == shape)
        {
            return false;
        }

        if (shape instanceof Rectangle)
        {
            Rectangle rectangle = (Rectangle)shape;

            if (this.calculateTopLeftPosition().x - DEFAULT_STROKE_WEIGHT  < (rectangle.calculateTopLeftPosition().x + rectangle.getWidth()) 
                && (this.calculateTopLeftPosition().x + this.getWidth()) + DEFAULT_STROKE_WEIGHT > rectangle.calculateTopLeftPosition().x)
            {
                if (this.calculateTopLeftPosition().y - DEFAULT_STROKE_WEIGHT < (rectangle.calculateTopLeftPosition().y + rectangle.getHeight())
                    && (this.calculateTopLeftPosition().y + this.getHeight()) + DEFAULT_STROKE_WEIGHT > rectangle.calculateTopLeftPosition().y)
                {
                    return true;
                }
            }
        }
        else if (shape instanceof Circle)
        {
            Circle circle = (Circle)shape;

            if (circle.getCenterPosition().x < this.getCenterPosition().x && 
                circle.getCenterPosition().y >= this.getCenterPosition().y)
            {
                for (int i = 89; i >= 0; --i)
                {
                    double positionX = circle.getCenterPosition().x + ((circle.getRadius() + DEFAULT_STROKE_WEIGHT) * cos(radians(i)));
                    double positionY = circle.getCenterPosition().y - ((circle.getRadius() + DEFAULT_STROKE_WEIGHT) * sin(radians(i)));

                    if (this.calculateTopLeftPosition().x <= positionX &&
                        this.calculateTopLeftPosition().y + this.getHeight() >= positionY)
                    {
                        return true;
                    }
                }
            }
            else if (circle.getCenterPosition().x >= this.getCenterPosition().x && 
                circle.getCenterPosition().y > this.getCenterPosition().y)
            {
                for (int i = 89; i >= 0; --i)
                {
                    double positionX = circle.getCenterPosition().x - ((circle.getRadius() + DEFAULT_STROKE_WEIGHT) * cos(radians(i)));
                    double positionY = circle.getCenterPosition().y - ((circle.getRadius() + DEFAULT_STROKE_WEIGHT) * sin(radians(i)));

                    if (this.calculateTopLeftPosition().x + getWidth() >= positionX &&
                        this.calculateTopLeftPosition().y + getHeight() >= positionY)
                    {
                        return true;
                    }
                }
            }
            else if (circle.getCenterPosition().x > this.getCenterPosition().x && 
                circle.getCenterPosition().y <= this.getCenterPosition().y)
            {
                for (int i = 89; i >= 0; --i)
                {
                    double positionX = circle.getCenterPosition().x - ((circle.getRadius() + DEFAULT_STROKE_WEIGHT) * cos(radians(i)));
                    double positionY = circle.getCenterPosition().y + ((circle.getRadius() + DEFAULT_STROKE_WEIGHT) * sin(radians(i)));

                    if (this.calculateTopLeftPosition().x + getWidth() >= positionX && 
                        this.calculateTopLeftPosition().y <= positionY)
                    {
                        return true;
                    }
                }
            }
            else if (circle.getCenterPosition().x <= calculateTopLeftPosition().x + (getWidth() / 2) &&
                circle.getCenterPosition().y <= calculateTopLeftPosition().y + (getHeight() / 2))
            {
                for (int i = 89; i >= 0; --i)
                {
                    double positionX = circle.getCenterPosition().x + ((circle.getRadius() + DEFAULT_STROKE_WEIGHT) * cos(radians(i)));
                    double positionY = circle.getCenterPosition().y + ((circle.getRadius() + DEFAULT_STROKE_WEIGHT) * sin(radians(i)));

                    if (this.calculateTopLeftPosition().x <= positionX && 
                        this.calculateTopLeftPosition().y <= positionY)
                    {
                        return true;
                    }
                }
            }

            return false;
        }

        return false;
    }

    //
    // Getters / Setters
    //

    public float getHeight()
    {
        return this._height;
    }

    protected void setHeight(float _height)
    {
        this._height = _height;
    }

    public float getWidth()
    {
        return this._width;
    }

    protected void setWidth(float _width)
    {
        this._width = _width;
    }
}


/**
* Shape.pde
*
* A abstract blueprint for all other shapes to be derived from.
*/
public abstract class Shape
{
    public static final color COLOR_BLUE = #0000FF;
    public static final color COLOR_RED = #FF0000;
    public static final color COLOR_WHITE = #FFFFFF;

    public static final int DEFAULT_STROKE_WEIGHT = 5;

    private PVector centerPosition;
    private color currentColor, _color1, _color2;

    protected Shape(PVector centerPosition)
    {
        this(centerPosition, COLOR_BLUE, COLOR_RED);
    }

    protected Shape(PVector centerPosition, color _color1)
    {
        this(centerPosition, _color1, COLOR_RED);

    }

    protected Shape(PVector centerPosition, color _color1, color _color2)
    {
        this.centerPosition = centerPosition;
        this.currentColor = _color1;
        this._color1 = _color1;
        this._color2 = _color2;
    }

    public void shiftCurrentColor(boolean condition)
    {
        if (condition)
        {
            setCurrentColor(getColor2());
        }
        else
        {
            setCurrentColor(getColor1());
        }
    }

    public abstract void show();

    //
    // Getters / Setters
    //

    public PVector getCenterPosition()
    {
        return this.centerPosition;
    }

    protected void setCenterPosition(PVector centerPosition)
    {
        this.centerPosition = centerPosition;
    }

    public color getCurrentColor()
    {
        return this.currentColor;
    }

    protected void setCurrentColor(color currentColor)
    {
        this.currentColor = currentColor;
    }

    public color getColor1()
    {
        return this._color1;
    }

    protected void setColor1(color _color1)
    {
        this._color1 = _color1;
    }

    public color getColor2()
    {
        return this._color2;
    }

    protected void setColor2(color _color2)
    {
        this._color2 = _color2;
    }
}