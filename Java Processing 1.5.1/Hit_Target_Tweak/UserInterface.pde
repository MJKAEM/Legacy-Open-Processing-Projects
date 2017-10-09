public class UserInterface
{
  private PApplet Parent;

  private PImage bulletImage;

  public UserInterface(PApplet p)
  {
    this.Parent = p;

    this.bulletImage = p.loadImage("bullet.png");
  }

  public void Show()
  {
    Parent.textSize(20);

    if (!Hit_Target_Tweak.gameStarted)
    {
      Parent.fill(0);
      Parent.text("Shoot the three targets to begin!", 90, 100);
    }
    else
    {
      if (!Hit_Target_Tweak.gameEnabled)
      {
        Parent.fill(0);
        Parent.text("Game Over", 190, 100);
        Parent.text("Shoot the three targets to restart.", 90, 120);
      }
    }
    Parent.stroke(0);
    Parent.strokeWeight(2);
    Parent.line(0, 40, Parent.width, 40);

    // Display lives 
    Parent.fill(255, 0, 0);
    if (Hit_Target_Tweak.numLives >= 0)
    {
      Parent.text("Lives: " + Hit_Target_Tweak.numLives, 20, 30);
    }
    else
    {
      Parent.text("Lives: 0", 20, 30);
    }

    // Display number of bullets
    Parent.image(bulletImage, 400, 20);
    Parent.fill(153, 153, 0);
    Parent.text("x " + Hit_Target_Tweak.numBullets, 440, 30);

    // Display score
    //
    Parent.fill(0, 0, 255);
    Parent.text("Score: " + Hit_Target_Tweak.score, 150, 30);

    // Display time
    //
    Parent.fill(0);
    Parent.text("Time: " + (int)(Hit_Target_Tweak.timeBeforeNextSpawn / 60), 275, 30);
  }
}