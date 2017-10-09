class Enemy
{
  int h, a, hasfired;
  float x, y, sx, sy, z, f;
  boolean fo;
  Enemy(float enemyx, float enemym, int health, int attack, float speedx, float speedy, boolean follow)
  {
    x = enemyx;
    y = -50;
    z = enemym;
    h = health;
    a = attack;
    sx = speedx;
    sy = speedy;
  }
  void goDown(float n)
  {
    if (y < n)
    {
      y+=z;
    }
  }
  void show()
  {
    image(enemyI, x, y, 25, 42);
  }
  void life()
  {
    if (h <= 0)
    {
      blocks[b2] = new Blocks();
      blocks[b2].x = x;
      blocks[b2].y = y;
      blocks[b2].x = blocks[b2].x;
      blocks[b2].y = blocks[b2].y;
      blocks[b2].ym = -5;
      b2++;
      x = 3000;
      y = 3000;
    }
  }
  void attack()
  {
    if (y >= a)
    {
      bullet1[b] = new Bullet(x, y, sx, sy, 255, 0, 0);
      if (hasfired < 1)
      {
        b++;
        hasfired++;
      }
    }
  }
  void hit()
  {
    if (h > 0)
    {
      h--;
      score+=15;
    }
  }
  /*void formula()
  {
    if (fo == true)
    {
      f = player.x - x
    }
  }*/
}