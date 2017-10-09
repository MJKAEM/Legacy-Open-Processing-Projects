class Bullet
{
  int r, g, b, c, d;
  boolean directionx, directiony;
  float x, y, sx, sy;
  Bullet(float bulletx, float bullety, float speedx, float speedy, int r, int g, int b)
  {
    x = bulletx;
    y = bullety;
    sx = speedx;
    sy = speedy;
    this.r = r;
    this.g = g;
    this.b = b;
    c = player.x;
    d = player.y;
    directionx = false;
  }
  void show()
  {
    stroke(r, g, b);
    strokeWeight(2);
    fill(255);
    ellipse(x, y, 20, 20);
    fill(255, 0, 0, 50);
    ellipse(x, y, 20, 20);
    strokeWeight(1);
    stroke(0);
    //rect(x-7,y-7,14,14);
    x+=sx;
    y+=sy;
  }
  void direction()
  {
    if (c < x)
    {
      if (directionx == false)
      {
        c = c;
        sx*=-1;
        directionx = true;
      }
    }
    else
    {
      directionx = true;
    }
    if (d < y)
    {
      if (directiony == false)
      {
        d = d;
        sy*=-1;
        directiony = true;
      }
    }
    else
    {
      directiony = true;
    }
  }
  void death()
  {
    if (x-7 <= player.x+23 && x+7 >= player.x+27 && (y-7 <= player.y+23 && y+7 >= player.y+27))
    {
      period = 50;
      lives-=1;
      player.alive = false;
    }
    if (player.alive == false)
    {
      b = 0;
      x = width+25;
      y = height+25;
    }
  }
}