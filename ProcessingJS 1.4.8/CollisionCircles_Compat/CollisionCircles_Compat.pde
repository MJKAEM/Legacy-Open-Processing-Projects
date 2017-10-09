/**
 * The program tests if two circles collide with each other. The center circle with be colored blue if it collides with the movable circle.
 *
 * Ported to non-Java OpenProcessing.
 */

private Circle c1;
private Circle c2;

private FramesCounter fc;

public void setup()
{
    size(320, 240);
    smooth();
    
    frameRate(60);

    c1 = new Circle(width / 2, height / 2, 25, 5);
    c2 = new Circle(25, 25, 25, 5, Circle.COLOR_BLUE);
    
    fc = new FramesCounter();
}

public void draw()
{
    background(0);
    
    if (c2.detectCollision(c1))
    {
        c2.setColor(Circle.COLOR_RED);
    }
    else
    {
        c2.setColor(Circle.COLOR_BLUE);
    }
    
    c1.show();
    c2.show();
    
    c2.setPositionX(mouseX);
    c2.setPositionY(mouseY);
    
    fc.show();
}

public void keyReleased()
{
    fc.update();
}

public class Circle
{
    public final static color COLOR_BLUE =  color(0, 0, 255);
    public final static color COLOR_RED = color(255, 0, 0);
    public final static color COLOR_WHITE = color(255);

    private color _color;

    private int positionX, positionY;
    private int radius, strokeSize;
    
    private Circle() { }
    
    public Circle(int positionX, int positionY, int radius, int strokeSize)
    {
        this(positionX, positionY, radius, strokeSize, COLOR_WHITE);
    }
    
    public Circle(int positionX, int positionY, int radius, int strokeSize, color _color)
    {
        this.positionX = positionX;
        this.positionY = positionY;
        this.radius = radius;
        this.strokeSize = strokeSize;
        this._color = _color;
    }
    
    public boolean detectCollision(Circle circle)
    {
        if (circle == this)
        {
            return false;
        }
        
        double sideX = pow(circle.getPositionX() - this.getPositionX(), 2);
        double sideY = pow(circle.getPositionY() - this.getPositionY(), 2);
        
        double hypo = sqrt(sideX + sideY);
        
        if (hypo < (getRadius() + getStrokeSize()) + circle.getRadius())
        {
            return true;
        }
        
        return false;
    }
    
    public void show()
    {
        noFill();
        stroke(getColor());
        strokeWeight(getStrokeSize());
        ellipse(getPositionX(), getPositionY(), getRadius() * 2, getRadius() * 2);
    }
    
    //
    // Getters / Setters
    //
    
    public color getColor()
    {
        return this._color;
    }
    
    public void setColor(color _color)
    {
        this._color = _color;
    }
    
    public int getPositionX()
    {
        return this.positionX;
    }
    
    public void setPositionX(int positionX)
    {
        this.positionX = positionX;
    }
    
    public int getPositionY()
    {
        return this.positionY;
    }
    
    public void setPositionY(int positionY)
    {
        this.positionY = positionY;
    }
    
    public int getRadius()
    {
        return this.radius;
    }
    
    public void setRadius(int radius)
    {
        this.radius = radius;
    }
    
    public int getStrokeSize()
    {
        return this.strokeSize;
    }
    
    public void setStrokeSize(int strokeSize)
    {
        this.strokeSize = strokeSize;
    }
}

public class FramesCounter
{
    public int F3_VALUE = 114;
 
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
        if (keyCode == F3_VALUE)
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
            text(getCurrentFrames(), 5, 20);
  
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
     
    public void setCurrentFrames(int currentFrames)
    {
        this.currentFrames = currentFrames;
    }
     
    public boolean isEnabled()
    {
        return this.enabled;
    }
  
    public void setEnabled(boolean isEnabled)
    {
        this.enabled = isEnabled;
    }
     
    public int getFpsTimer()
    {
        return this.fpsTimer;
    }
     
    public void setFpsTimer(int fpsTimer)
    {
        this.fpsTimer = fpsTimer;
    }
}