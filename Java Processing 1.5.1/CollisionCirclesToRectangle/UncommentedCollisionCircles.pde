import java.awt.Color;
 
private UncommentedCircle UnusedCenterCircle;
private UncommentedCircle UnusedMovableCircle;

public void UnusedSetup()
{
  size(640, 480);
  
  UnusedCenterCircle = new UncommentedCircle(this, new PVector(320, 240), Color.WHITE);
}

public void UnusedDraw()
{
  background(0);
  
  UnusedMovableCircle = new UncommentedCircle(this, new PVector(mouseX, mouseY), Color.RED);

  if (UnusedCenterCircle.DetectCollide(UnusedMovableCircle))
  {
    UnusedCenterCircle.SetColor(Color.BLUE);
  }
  else
  {
    UnusedCenterCircle.SetColor(Color.WHITE);
  }

  UnusedCenterCircle.Show();
  UnusedMovableCircle.Show();
}