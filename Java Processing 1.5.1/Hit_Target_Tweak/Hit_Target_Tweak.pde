/**
 * This is a tweak of 'Day 1' by Jane McDonough. It represents the targets using
 * a class based system. Also, they will respawn and provide points if shot.
 * 
 * @author Jane McDonough (Original)
 * @author Martino Kuan (Tweaked version)
 *
 */

// Must multiply by 60 due to '60 frames per second'.
//
public static final int MAX_TIME_DELAY = 60 * 4;
public static final int MAX_BULLETS = 5;
public static final int MAX_LIVES = 3;

private ArrayList<Target> targetList;

private FramesCounter frameCounter;
private UserInterface userInterface;

public static int numLives = 3, numBullets = MAX_BULLETS, score = 0;
public static int timeBeforeNextSpawn;
public static boolean gameStarted = false, gameEnabled = false;

@Override
public final void setup() 
{
  size(500, 500);

  smooth();
  cursor(CROSS);

  targetList = new ArrayList<Target>(3);
  frameCounter = new FramesCounter(this);
  userInterface = new UserInterface(this);

  targetList.add(new Target(this, 160, 250));
  targetList.add(new Target(this, 250, 250));
  targetList.add(new Target(this, 340, 250));

  timeBeforeNextSpawn = MAX_TIME_DELAY;

  // This is done to load the text font.
  //
  text('C', -50, 0);
}

@Override
public final void draw()
{
  // White background. No need to add unnecessary white cicles to the
  // background.
  //
  background(255);

  // Displays all targets and enables hitboxes.
  for (Target temp : targetList)
  {
    temp.Show();
  }

  // If currently in game mode
  //
  if (gameEnabled)
  {
    if (targetList.size() == 0)
    { 
      RespawnTargets();
    }
    else if (timeBeforeNextSpawn <= 0)
    {
      targetList = new ArrayList<Target>(0);

      --numLives;

      if (numLives >= 0)
      {
        RespawnTargets();
      }
      else // if (numLives <= 0)
      {
        gameEnabled = false;

        CompleteResetTargets();
      }
    }
    else
    {
      --timeBeforeNextSpawn;
    }
  }
  // If not in game mode
  //
  else
  {
    if (targetList.size() == 0)
    { 
      score = 0;
      numLives = MAX_LIVES;
      RespawnTargets();
      gameEnabled = true;
      gameStarted = true;
    }
  }

  frameCounter.Show();
  userInterface.Show();
}

public final void RespawnTargets()
{
  // Spawn three targets
  //
  for (int do3x = 0; do3x < 3; ++do3x)
  {
    // Create a new target with random positions. They will not go off the
    // screen due to adjustments.
    //
    int tempRandomX = (int)(45 + (Math.random() * 410));
    int tempRandomY = (int)(85 + (Math.random() * 360));

    Target tempTarget = new Target(this, tempRandomX, tempRandomY);

    // Determine if the spawns conflict, by going through the list of
    // targets.
    //
    for (int i = 0, max = targetList.size(); i < max; ++i)
    {
      // If a conflict is detected, randomize location again.
      //
      while (tempTarget.SpawnCollideDetect (targetList.get (i)))
      {
        tempRandomX = (int)(45 + (Math.random() * 410));
        tempRandomY = (int)(85 + (Math.random() * 360));

        tempTarget.SetPosition(tempRandomX, tempRandomY);

        i = 0;
      }
    }
    targetList.add(tempTarget);
  }

  numBullets = MAX_BULLETS;
  timeBeforeNextSpawn = MAX_TIME_DELAY;
}

public final void CompleteResetTargets()
{
  targetList = new ArrayList<Target>(3);

  targetList.add(new Target(this, 160, 250));
  targetList.add(new Target(this, 250, 250));
  targetList.add(new Target(this, 340, 250));
}

@Override
public final void mouseReleased()
{
  if (gameEnabled)
  {
    if (numBullets > 0)
    {
      --numBullets;

      for (int i = targetList.size() - 1; i >= 0; --i)
      {
        Target tempTarget = targetList.get(i);

        if (tempTarget.ShootDetect())
        {
          targetList.remove(tempTarget);
          ++score;
          return;
        }
      }
    }
  }
  else
  {
    for (int i = targetList.size() - 1; i >= 0; --i)
    {
      Target tempTarget = targetList.get(i);

      if (tempTarget.ShootDetect())
      {
        targetList.remove(tempTarget);
        return;
      }
    }
  }
}

@Override
public final void keyReleased()
{
  if (key == '`')
  {
    frameCounter.Act();
  }
}