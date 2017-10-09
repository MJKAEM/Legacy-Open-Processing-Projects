import java.awt.Color;

public class UncommentedCircle
{
  private final PApplet Parent;

  private PVector position;
  private Color col;

  private int _radius;
  private int strokeSize;

  public UncommentedCircle(PApplet p, PVector position, Color col)
  {
    this(p, position, col, 25, 5);
  }

  public UncommentedCircle(PApplet p, PVector position, Color col, int _radius, int strokeSize)
  {
    this.Parent = p;
    this.position = position;
    this.col = col;
    this._radius = _radius;
    this.strokeSize = strokeSize;
  }
  
  public void Show()
  {
    Parent.smooth();
    Parent.noFill();
    Parent.strokeWeight(strokeSize);
    Parent.stroke(col.getRed(), col.getGreen(), col.getBlue());

    Parent.ellipse(position.x, position.y, _radius * 2, _radius * 2);
  }
  
  public boolean DetectCollide(UncommentedCircle circle)
  {
    if (circle.equals(this))
    {
      return false;
    }
    else
    {
      double sideX = Math.pow(circle.GetPosition().x - position.x, 2);
      double sideY = Math.pow(circle.GetPosition().y - position.y, 2);

      double hypo = Math.sqrt(sideX + sideY);

      if (hypo < (_radius + strokeSize) + circle.GetRadius())
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

  public int GetRadius()
  {
    return this._radius;
  }
};