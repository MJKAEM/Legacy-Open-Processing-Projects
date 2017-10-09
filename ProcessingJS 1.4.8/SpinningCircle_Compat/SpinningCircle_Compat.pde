/**
 * A spinning line that circles around the circumference of the circle, to give the illusion of the circle spinning.
 */

/**
* A circle with a line in the center, which moves along the circumference of the circle.
*/

private Circle c;
private FramesCounter fc;

void setup()
{
    text("z", 0, 0);

    size(250, 250);
    frameRate(60);
        
    c = new Circle(100);
    fc = new FramesCounter();
}

void draw()
{
    background(255);
    smooth();
    strokeWeight(20);
    
    c.show();
    c.update();
    
    fc.show();
}

void keyReleased()
{
    fc.update();
}

public class Circle
{
    private int radius;
    private int angle;
    
    private Circle() {}
    
    public Circle(int radius)
    {
        this.radius = radius;
    }
    
    public void show()
    {
        noFill();
        stroke(0);
        
        float centerX = width / 2;
        float centerY = height / 2;
        
        ellipse(centerX , centerY , getRadius() * 2, getRadius() * 2);
        
        line(centerX, 
            centerY, 
            centerX + (radius * cos(getAngle() * PI / 180)), 
            centerY + (radius * sin(getAngle() * PI / 180)));
    }
    
    public void update()
    {
        if (getAngle() < 360)
        {
            setAngle(getAngle() - 2);
        }
        else
        {
            setAngle(1);
        }
    }
    
    //
    // Getters / Setters
    //
    
    public int getAngle()
    {
        return this.angle;
    }
    
    public void setAngle(int angle)
    {
        this.angle = angle;
    }
    
    public int getRadius()
    {
        return this.radius;
    }
    
    public void setRadius(int radius)
    {
        this.radius = radius;
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

            fill(0);
 
            // text(fpsTimer, 100, 100); //debug
            text(getCurrentFrames(), 20, 20);
 
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