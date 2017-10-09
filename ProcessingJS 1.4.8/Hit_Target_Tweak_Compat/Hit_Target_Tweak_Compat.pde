/**
 * This is a tweak of 'Day 1' by Jane McDonough. It represents the targets using a class based system. Also, they will respawn and provide points if shot.
 *
 * Click to shoot. Try your best to shoot the targets. If you miss, you will waste a bullet. If you shoot all three targets of the current wave, three more will pop out. If you take too long, you will lose a life.
 *
 * Also,
 * ~ (Tilde) - Displays FPS counter
 *
 * This has been ported to be compatible with OpenProcessing.
 */

/**
 * This is a tweak of 'Day 1' by Jane McDonough. It represents the targets using
 * a class based system. Also, they will respawn and provide points if shot.
 *
 * Ported to OpenProcessing, due to Java security issues.
 *
 * Author: Jane McDonough (Original), Martino Kuan (Tweaked version)
 *
 */

// Must multiply by 60 due to '60 frames per second'.
//
public static final int MAX_TIME_DELAY = 60 * 4;
public static final int MAX_BULLETS = 5;
public static final int MAX_LIVES = 3;

public static int numLives = 3;
public static int numBullets = MAX_BULLETS;
public static int score = 0;
public static int timeBeforeNextSpawn = 0;
public static boolean gameStarted = false;
public static boolean gameEnabled = false;

private ArrayList<Target> targetList;
private FramesCounter frameCounter;
private UserInterface userInterface;

public void setup()
{
    // Set up graphics.
    //
    size(500, 500);
    frameRate(60);
    smooth();
    
    // Initialize variables.
    //
    targetList = new ArrayList<Target>();
    frameCounter = new FramesCounter();
    userInterface = new UserInterface();
    timeBeforeNextSpawn = MAX_TIME_DELAY;
    
    // Set up starting targets.
    //
    targetList.add(new Target(new PVector(160, 250)));
    targetList.add(new Target(new PVector(250, 250)));
    targetList.add(new Target(new PVector(340, 250)));
}

public void draw()
{
    background(255);
    cursor(CROSS);
    
    for (Target target : targetList)
    {
        target.show();
    }
    
    if (gameEnabled)
    {
        if (targetList.isEmpty())
        {
            respawnTargets();
        }
        else if (timeBeforeNextSpawn <= 0)
        {
            targetList = new ArrayList<Target>(0);
            
            numLives--;
            
            if (numLives >= 0)
            {
                respawnTargets();
            }
            else
            {
                gameEnabled = false;
                completeResetTargets();
            }
        }
        else
        {
            timeBeforeNextSpawn--;
        }
    }
    else
    {
        if (targetList.isEmpty())
        {
            score = 0;
            numLives = MAX_LIVES;
            respawnTargets();
            gameEnabled = true;
            gameStarted = true;
        }
    }
    
    frameCounter.show();
    userInterface.show();
}

public void mouseReleased()
{
    if (gameEnabled)
    {
        if (numBullets > 0)
        {
            numBullets--;
            
            for (int i = 0; i < targetList.size(); i++)
            {
                if (targetList.get(i).detectShot())
                {
                    targetList.remove(i);
                    score++;
                    return;
                }
            }
        }
    }
    else
    {
        for (int i = 0; i < targetList.size(); i++)
        {
            if (targetList.get(i).detectShot())
            {
                targetList.remove(i);
                return;
            }
        }
    }
}

public void keyReleased()
{
    frameCounter.update();
}

public void respawnTargets()
{
    // Spawn three targets
    //
    for (int do3x = 0; do3x < 3; do3x++)
    {
        // Create a new target with random positions. They will not go off the
        // screen due to adjustments.
        //
        int randomX = (int)(random(410) + 45);
        int randomY = (int)(random(360) + 85);
        
        Target target = new Target(new PVector(randomX, randomY));
        
        // Determine if the spawns conflict, by going through the list of
        // targets.
        //
        for (int i = 0; i < targetList.size(); i++)
        {
            // If a conflict is detected, randomize location again.
            //
            while (target.detectSpawnCollide(targetList.get(i)))
            {
                randomX = (int)(random(410) + 45);
                randomY = (int)(random(360) + 85);
                
                target.setPosition(new PVector(randomX, randomY));
                
                i = 0;
            }
        }
        
        targetList.add(target);
    }
    
    numBullets = MAX_BULLETS;
    timeBeforeNextSpawn = MAX_TIME_DELAY;
}

public void completeResetTargets()
{
    targetList = new ArrayList<Target>(3);
    
    targetList.add(new Target(new PVector(160, 250)));
    targetList.add(new Target(new PVector(250, 250)));
    targetList.add(new Target(new PVector(340, 250)));
}


/**
* Bullet.pde
*/
public class Bullet
{
    private PVector position;
    
    public Bullet(PVector position)
    {
        this.position = position;
    }
    
    public void show()
    {
        // Since I cannot upload my image to OpenProcessing without messing up format,
        // I will need to replicate it using draw.
        // 
        strokeWeight(1);
        
        // Bullet Tip
        //
        stroke(#EBE061);
        fill(#EBE061);
        rect(getPosition().x, getPosition().y + 3, 2, 2);
        rect(getPosition().x + 2, getPosition().y + 2, 2, 3);
        rect(getPosition().x + 4, getPosition().y + 1, 3, 5);
        rect(getPosition().x + 7, getPosition().y, 3, 7);
        
        // Bullet Tip Shadow
        //
        stroke(#C4BA50);
        fill(#C4BA50);
        rect(getPosition().x + 2, getPosition().y + 5, 2, 0);
        rect(getPosition().x + 4, getPosition().y + 6, 3, 0);
        rect(getPosition().x + 7, getPosition().y + 7, 3, 0);
        
        // Bullet Body
        //
        stroke(#BCAE12);
        fill(#BCAE12);
        rect(getPosition().x + 10, getPosition().y, 16, 7);
        rect(getPosition().x + 27, getPosition().y + 1, 3, 5);
        rect(getPosition().x + 30, getPosition().y, 2, 7);
        
        // Bullet Body Shadow
        //
        stroke(#80760C);
        fill(#BCAE12);
        rect(getPosition().x + 10, getPosition().y + 7, 16, 0);
        rect(getPosition().x + 27, getPosition().y + 6, 3, 0);
        rect(getPosition().x + 30, getPosition().y + 7, 2, 0);
        
        // Shine
        //
        stroke(255);
        fill(255);
        rect(getPosition().x + 13, getPosition().y + 2, 11, 0);
    }
    
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
/**
* FramesCounter.pde
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
  
            fill(0);
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
/**
* Target.pde
*/
public class Target
{
    public static final int DEFAULT_RINGS = 5;
    
    private PVector position;
    private color color1, color2;
    private int rings;
    
    private Target() { }
    
    public Target(PVector position)
    {
        this(position, DEFAULT_RINGS);
    }

    public Target(PVector position, int rings)
    {
        this(position, rings, color(255, 0, 0));
    }
    
    public Target(PVector position, int rings, color color1)
    {
        this(position, rings, color1, color(255));
    }
    
    public Target(PVector position, int rings, color color1, color color2)
    {
        this.position = position;
        this.rings = rings;
        this.color1 = color1;
        this.color2 = color2;
    }
    
    public boolean detectShot()
    {
        float distance = dist(getPosition().x, getPosition().y, mouseX, mouseY);
        
        return (distance < ((getRings() - 1) * 5) + 5);
    }
    
    public boolean detectSpawnCollide(Target target)
    {
        if (this == target)
        {
            return false;
        }
        
        float distance = dist(this.getPosition().x, this.getPosition().y,
                                target.getPosition().x, target.getPosition().y);
                                
        return (distance < ((getRings() - 1) * 10) + 5);
    }
    
    public void show()
    {
        stroke(0);
        strokeWeight(1);
        
        for (int i = getRings() - 1; i >= 0; i--)
        {
            if (i % 2 == 0)
            {
                /* Blue color hitbox test.
                if (detectShot())
                    fill(0, 0, 255);
                else
                */
                fill(getColor1());
            }
            else
            {
                fill(getColor2());
            }
            
            int diameter = 5 + (i * 10);
            ellipse(getPosition().x, getPosition().y, diameter, diameter);
        }
    }
    
    //
    // Getters / Setters
    //
    
    public color getColor1()
    {
        return this.color1;
    }
    
    public void setColor1(color color1)
    {
        this.color1 = color1;
    }
    
    public color getColor2()
    {
        return this.color2;
    }
    
    public void setColor2(color color2)
    {
        this.color2 = color2;
    }
    
    public PVector getPosition()
    {
        return this.position;
    }
    
    public void setPosition(PVector position)
    {
        this.position = position;
    }
    
    public int getRings()
    {
        return this.rings;
    }
    
    public void setRings(int rings)
    {
        this.rings = rings;
    }
}
/**
* UserInterface.pde
*/
public class UserInterface
{
    private Bullet bullet;
    
    public UserInterface()
    {
        bullet = new Bullet(new PVector(400, 20));
    }
    
    public void show()
    {
        textSize(20);
        
        if (gameStarted)
        {
            if (!gameEnabled)
            {
                fill(0);
                text("Game Over", 190, 100);
                text("Shoot the three targets to restart.", 90, 120);
            }
        }
        else
        {
            fill(0);
            text("Shoot the three targets to begin!", 90, 100);
        }
        
        stroke(0);
        strokeWeight(2);
        line(0, 40, width, 40);
        
        // Display lives.
        fill(255, 0, 0);
        
        if (numLives >= 0)
        {
            text("Lives: " + numLives, 20, 30);
        }
        else
        {
            text("Lives: 0", 20, 30);
        }
        
        // Display number of bullets
        bullet.show();
        fill(153, 153, 0);
        text("x " + numBullets, 440, 30);
        
        // Display score
        //
        fill(0, 0, 255);
        text("Score: " + score, 150, 30);
        
        // Display time
        //
        fill(0);
        text("Time: " + (int)(timeBeforeNextSpawn / 60), 275, 30);
    }
}