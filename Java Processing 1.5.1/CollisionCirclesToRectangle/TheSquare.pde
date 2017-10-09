import java.awt.Color;

public class TheSquare
{
  private final PApplet Parent;

  private PVector position;
  private Color col;

  private int sideLength;
  private int strokeSize;

  public TheSquare(PApplet p, PVector position, Color col)
  {
    this(p, position, col, 50, 5);
  }

  public TheSquare(PApplet p, PVector position, Color col, int sideLength, int strokeSize)
  {
    this.Parent = p;
    this.position = position;
    this.col = col;
    this.sideLength = sideLength;
    this.strokeSize = strokeSize;
  }

  public void Show()
  {
    Parent.smooth();
    Parent.noFill();
    Parent.strokeWeight(strokeSize);
    Parent.stroke(col.getRed(), col.getGreen(), col.getBlue());

    Parent.rect(position.x, position.y, sideLength, sideLength);
  }

  public boolean DetectCollide(Circle circle)
  {
    if (circle.GetPosition().x < GetPosition().x + (GetSideLength() / 2) && circle.GetPosition().y >= GetPosition().y + (GetSideLength() / 2))
    {
      for (int i = 89; i >= 0; --i)
      {
        double PosX = circle.GetPosition().x + ((circle.GetRadius() + circle.GetStrokeSize()) * Math.cos(Math.toRadians(i)));
        double PosY = circle.GetPosition().y - ((circle.GetRadius() + circle.GetStrokeSize()) * Math.sin(Math.toRadians(i)));

        if (GetPosition().x <= PosX && GetPosition().y + GetSideLength() >= PosY)
        {
          return true;
        }
      }
    }
    else if (circle.GetPosition().x >= GetPosition().x + (GetSideLength() / 2) && circle.GetPosition().y > GetPosition().y + (GetSideLength() / 2))
    {
      for (int i = 89; i >= 0; --i)
      {
        double PosX = circle.GetPosition().x - ((circle.GetRadius() + circle.GetStrokeSize()) * Math.cos(Math.toRadians(i)));
        double PosY = circle.GetPosition().y - ((circle.GetRadius() + circle.GetStrokeSize()) * Math.sin(Math.toRadians(i)));

        if (GetPosition().x + GetSideLength() >= PosX && GetPosition().y + GetSideLength() >= PosY)
        {
          return true;
        }
      }
    }
    else if (circle.GetPosition().x > GetPosition().x + (GetSideLength() / 2) && circle.GetPosition().y <= GetPosition().y + (GetSideLength() / 2))
    {
      for (int i = 89; i >= 0; --i)
      {
        double PosX = circle.GetPosition().x - ((circle.GetRadius() + circle.GetStrokeSize()) * Math.cos(Math.toRadians(i)));
        double PosY = circle.GetPosition().y + ((circle.GetRadius() + circle.GetStrokeSize()) * Math.sin(Math.toRadians(i)));

        if (GetPosition().x + GetSideLength() >= PosX && GetPosition().y <= PosY)
        {
          return true;
        }
      }
    }
    else if (circle.GetPosition().x <= GetPosition().x + (GetSideLength() / 2) && circle.GetPosition().y < GetPosition().y + (GetSideLength() / 2))
    {
      for (int i = 89; i >= 0; --i)
      {
        double PosX = circle.GetPosition().x + ((circle.GetRadius() + circle.GetStrokeSize()) * Math.cos(Math.toRadians(i)));
        double PosY = circle.GetPosition().y + ((circle.GetRadius() + circle.GetStrokeSize()) * Math.sin(Math.toRadians(i)));

        if (GetPosition().x <= PosX && GetPosition().y <= PosY)
        {
          return true;
        }
      }
    }
    return false;
  }

  public boolean DetectCollide(TheSquare aSquare)
  {
    if (aSquare.equals(this))
    {
      return false;
    }

    if (GetPosition().x - strokeSize  < (aSquare.GetPosition().x + aSquare.GetSideLength())  
      && (GetPosition().x + sideLength) + strokeSize > aSquare.GetPosition().x)
    {
      if (GetPosition().y - strokeSize < (aSquare.GetPosition().y + aSquare.GetSideLength()) 
        && (GetPosition().y + sideLength) + strokeSize > aSquare.GetPosition().y)
      {
        return true;
      }
    }
    return false;
  }

  public Color GetColor()
  {
    return this.col;
  }

  public void SetColor(Color col)
  {
    if (col == null)
    {
      throw new IllegalArgumentException("The color cannot be null.");
    }
    this.col = col;
  }

  public PVector GetPosition()
  {
    return this.position;
  }

  public int GetSideLength()
  {
    return this.sideLength;
  }

  public int GetStrokeSize()
  {
    return this.strokeSize;
  }

  public void SetStrokeSize(int strokeSize)
  {
    this.strokeSize = strokeSize;
  }
};