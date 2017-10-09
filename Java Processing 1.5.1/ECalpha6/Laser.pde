class Laser
{
  float x, y;
  float m;
  Laser(float laserx, float lasery, float laserm)
  {
    x = laserx;
    y = lasery;
    m = laserm;
  }
  void show()
  {
    image(laserpic, x-2, y-25, 4, 25);
    x+=m;
  }
  void goUp()
  {
    if (y >= -100)
    {
      y-=10;
    }
    if (y <= -100)
    {
      x = -500;
    }
  }
  void hit()
  {
    for (int i = 0; i < e; i++)
    {
      if (enemy1[i].y <= y && enemy1[i].y+42 >= y && (enemy1[i].x <= x && enemy1[i].x+25 >= x))
      {
        enemy1[i].hit();
        x = -500;
      }
    }
  }
}