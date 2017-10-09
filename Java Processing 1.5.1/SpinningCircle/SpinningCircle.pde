private OrbittingCircle[] circleArray;

@Override
public void setup()
{
  size(300, 300);

  circleArray = new OrbittingCircle[5];

  circleArray[0] = new OrbittingCircle(this);
  circleArray[1] = new OrbittingCircle(this, 10, 60);
  circleArray[2] = new OrbittingCircle(this, 20, 180);
  circleArray[3] = new OrbittingCircle(this, 30, 90);
  circleArray[4] = new OrbittingCircle(this, 40, 270);
}

@Override
public void draw()
{
  background(0);

  for (int i = circleArray.length - 1; i >= 0; --i)
  {
    if (circleArray[i] != null)
      circleArray[i].Show();
  }
}