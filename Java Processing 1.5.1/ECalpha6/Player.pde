class Player
{
  int x, y;
  boolean alive;
  Player()
  {
    x = 200;
    y = 430;
    alive = true;
  }
  void goUp()
  {
    if (keys[4] == true)
    {
      y-=2;
    }
    else if (keys[4] == false)
    {
      y-=3;
    }
  }
  void goDown()
  {
    if (keys[4] == true)
    {
      y+=2;
    }
    else if (keys[4] == false)
    {
      y+=3;
    }
  }
  void goLeft()
  {
    if (keys[4] == true)
    {
      x-=2;
    }
    else if (keys[4] == false)
    {
      x-=3;
    }
  }
  void goRight()
  {
    if (keys[4] == true)
    {
      x+=2;
    }
    else if (keys[4] == false)
    {
      x+=3;
    }
  }
  void player()
  {
    image(turtle, x, y, 50, 50);
  }
  void hitbox()
  {
    if (keys[4] == true && alive == true)
    {
      stroke(0);
      fill(255);
      strokeWeight(1);
      ellipse(player.x+25, player.y+25, 10, 10);
    }
  }
  void revive()
  {
    if (period <= 0)
    {
      alive = true;
    }
  }
}