import java.awt.Color;

public class Target
{
  private PApplet Parent;

  private Color color1, color2;

  private int positionX, positionY;

  public Target(PApplet p, int posX, int posY)
  {
    this(p, posX, posY, Color.RED);
  }

  public Target(PApplet p, int posX, int posY, Color color1)
  {
    this(p, posX, posY, color1, Color.WHITE);
  }

  public Target(PApplet p, int posX, int posY, Color color1, Color color2)
  {
    this.Parent = p;

    this.positionX = posX;
    this.positionY = posY;
    this.color1 = color1;
    this.color2 = color2;
  }

  public void Show()
  {
    Parent.stroke(0);
    Parent.strokeWeight(1);

    for (int i = 4; i >= 0; --i)
    {
      if (i % 2 == 0)
      {
        Parent.fill(color1.getRed(), color1.getGreen(), color1.getBlue());
      }
      else
      {
        Parent.fill(color2.getRed(), color2.getGreen(), color2.getBlue());
      }
      int tempDiameter = 5 + (10 * i);

      Parent.ellipse(positionX, positionY, tempDiameter, tempDiameter);
    }
  }

  public boolean ShootDetect()
  {
    float tempDist = dist(GetPositionX(), GetPositionY(),
                        Parent.mouseX, Parent.mouseY);

    if (tempDist < 24)
    {
      return true;
    }

    return false;
  }

  public boolean SpawnCollideDetect(Target target)
  {
    if (target.equals(this))
    {
      return false;
    }
    
    float tempDist = dist(GetPositionX(), GetPositionY(), 
                        target.GetPositionX(), target.GetPositionY());

    if (tempDist < 45)
    {
      return true;
    }
    return false;
  }
  
  public void SetPosition(int x, int y)
  {
    this.positionX = x;
    this.positionY = y;
  }
  
  public void SetPosition(int x)
  {
    this.positionX = x;
  }
  
  public void SetPositionY(int y)
  {
    this.positionY = y;
  }
  
  public int GetPositionX()
  {
    return this.positionX;
  }
  
  public int GetPositionY()
  {
    return this.positionY;
  }
}