class Boss
{
  int x, y;
  Boss()
  {
    x = 200;
    y = -50;
  }
  void show()
  {
    image(bossI, x, y, 100, 100);
  }
}