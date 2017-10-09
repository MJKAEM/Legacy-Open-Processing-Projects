//EC Alpha Code version 1.6
//EC will only go beta when I can spend full time on this
//Code made by Martino Kuan on Processing
String version = "1.6";
Laser[] laser1, laser2, laser3, laser4, laser5;
Bullet[] bullet1;
Player player;
Enemy[] enemy1;
Blocks[] blocks;
int mode = 1;
int selected = 0;
int pausedselected = 0;
int optionselected = 0;
int optionselected2;
int period = 0;
PImage turtle, enemyI, bossI, huda, laserpic, blocka, blockb, blockc;
PFont font0, font1;
int fixer = 0;
float delayer = 0;
boolean fps = false;
boolean fireattack = false;
boolean bosshurt = false;
boolean keys[] = new boolean [5];
boolean paused = false;
boolean confirma = false;
boolean options = false;
int confirmb = 0;
int bosshealthx = 380;
int bosshealthr = 0;
int bosshealthg = 390;
int lives = 5;
int livesi = 5;
int livesr = 255;
int bombs = 5;
int bombsi = 5;
int bombsg = 255;
int colora = 0;
int colorb = 2;
int score = 0;
int score2= 1000;
int rewarded = 0;
float fpstimer2 = 1000;
int fpsnumber = 0;
int j = 0;
int j2 = 5;
int e = 0;
int b = 0;
int b2 = 0;
int enemyspawn = 0;
int level = 1;
int power = 0;
int prevent1 = 3000;
int prevent2 = 3000;
void setup()
{
  size(640, 480);
  frameRate(60);
  //noCursor();
  enemyI = loadImage("enemy.png");
  bossI = loadImage("boss.bmp");
  turtle = loadImage("turtle.png");
  laserpic = loadImage("laser.bmp");
  blocka = loadImage("blocka.png");
  blockb = loadImage("blockb.png");
  blockc = loadImage("blockc.png");
  huda = loadImage("Stone.jpg");
  font0 = loadFont("ArialMT-12.vlw");
  font1 = loadFont("CenturyGothic-Bold-25.vlw");
  laser1 = new Laser[500000];
  laser2 = new Laser[500000];
  laser3 = new Laser[500000];
  laser4 = new Laser[500000];
  laser5 = new Laser[500000];
  bullet1 = new Bullet[500000];
  enemy1 = new Enemy[500000];
  blocks = new Blocks[500000];
  player = new Player();
  enemy1[0] = new Enemy(50+100*e, 2, 2, 20, 1.7, 4.25, true);
  enemy1[1] = new Enemy(50+100*1, 2, 2, 20, 0.75, 4.25, true);
}
void draw()
{
  println(period);
  println(player.alive);
  if (period > 0)
  {
    period--;
  }
  background(0);
  fill(255);
  smooth();
  strokeWeight(1);
  control();
  if (mode == 0)
  {
    menu();
    optionmenu();
  }
  if (mode == 1)
  {
    fill(255);
    if (player.alive == true)
    {
      if (paused == false)
      {
        movement();
      }
      player.player();
    }
    if (player.alive == false)
    {
      fireattack = false;
      player.revive();
    }
    if (paused == false && player.alive == true)
    {
      attack();
    }
    for (int i = 0; i < e; i++)
    {
      enemy1[i].show();
      enemy1[i].goDown(200);
      enemy1[i].life();
      enemy1[i].attack();
    }
    level();
    for (int i = 0; i < b; i++)
    {
      bullet1[i].show();
      bullet1[i].direction();
      if (player.alive == true)
      {
        bullet1[i].death();
      }
    }
    for (int i = 0; i < j; i++)
    {
      laser1[i].show();
      laser1[i].goUp();
      laser1[i].hit();
      laser2[i].show();
      laser2[i].goUp();
      laser2[i].hit();
      laser3[i].show();
      laser3[i].goUp();
      laser3[i].hit();
      laser4[i].show();
      laser4[i].goUp();
      laser4[i].hit();
      laser5[i].show();
      laser5[i].goUp();
      laser5[i].hit();
    }
    for (int i = 0; i < b2; i++)
    {
      blocks[i].show();
      blocks[i].hit();
    }
    player.hitbox();
    bosshealth();
    hud();
    reward();
    bosshealthnumber();
    pausedmenu();
    confirm();
  }
  fps2();
}
void menu()
{
  if (selected < 0)
  {
    selected = 6;
  }
  else if (selected > 6)
  {
    selected = 0;
  }
  textFont(font1);
  text("Start Game", 395, 150);
  text("Extra Start", 395, 180);
  text("Practice Start", 395, 210);
  text("Option", 395, 240);
  text("Exit", 395, 270);
  switch (selected)
  {
  case 0:
    fill(255, 0, 0, 75);
    noStroke();
    rect(390, 127, 150, 28);
    break;
  case 1:
    fill(255, 0, 0, 75);
    noStroke();
    rect(390, 157, 135, 28);
    break;
  case 2:
    fill(255, 0, 0, 75);
    noStroke();
    rect(390, 187, 175, 28);
    break;
  case 3:
    fill(255, 0, 0, 75);
    noStroke();
    rect(390, 217, 95, 28);
    break;
  case 4:
    fill(255, 0, 0, 75);
    noStroke();
    rect(390, 247, 55, 28);
    break;
  case 5:
    fill(255, 0, 0, 75);
    noStroke();
    rect(390, 277, 150, 28);
    break;
  case 6:
    fill(255, 0, 0, 75);
    noStroke();
    rect(390, 307, 150, 28);
    break;
  }
}
void pausedmenu()
{
  if (paused == true)
  {
    if (pausedselected < 0)
    {
      pausedselected = 2;
    }
    else if (pausedselected > 2)
    {
      pausedselected = 0;
    }
    fill(0, 0, 0, 200);
    rect(0, 0, width, height);
    fill(255);
    textFont(font1);
    text("Resume Game", 125, 200);
    text("Restart Game", 133, 230);
    text("Stop Game", 145, 260);
    switch (pausedselected)
    {
    case 0:
      fill(255, 0, 0, 75);
      noStroke();
      rect(120, 177, 190, 28);
      break;
    case 1:
      fill(255, 0, 0, 75);
      noStroke();
      rect(128, 207, 180, 28);
      break;
    case 2:
      fill(255, 0, 0, 75);
      noStroke();
      rect(140, 237, 150, 28);
      break;
    }
  }
}
void optionmenu()
{
  if (options == true)
  {
    if (optionselected < 0)
    {
      optionselected = 3;
    }
    else if (optionselected > 3)
    {
      optionselected = 0;
    }
    if (livesi < 1)
    {
      livesi = 5;
    }
    else if (livesi > 5)
    {
      livesi = 1;
    }
    if (bombsi < 1)
    {
      bombsi = 5;
    }
    else if (bombsi > 5)
    {
      bombsi = 1;
    }
    fill(0, 0, 0, 200);
    rect(0, 0, width, height);
    fill(255);
    textFont(font1);
    text("Lives      1  2  3  4  5", 125, 200);
    text("Bombs      1  2  3  4  5", 125, 230);
    text("Close Menu", 125, 260);
    switch (optionselected)
    {
    case 0:
      fill(255, 0, 0, 75);
      noStroke();
      rect(120, 177, 70, 28);
      break;
    case 1:
      fill(255, 0, 0, 75);
      noStroke();
      rect(120, 207, 95, 28);
      break;
    case 2:
      fill(255, 0, 0, 75);
      noStroke();
      rect(120, 237, 160, 28);
      break;
    }
    switch (livesi)
    {
    case 1:
      fill(255, 0, 0, 75);
      noStroke();
      rect(222, 177, 22, 28);
      break;
    case 2:
      fill(255, 0, 0, 75);
      noStroke();
      rect(250, 177, 22, 28);
      break;
    case 3:
      fill(255, 0, 0, 75);
      noStroke();
      rect(250+28, 177, 22, 28);
      break;
    case 4:
      fill(255, 0, 0, 75);
      noStroke();
      rect(250+(2*28), 177, 22, 28);
      break;
    case 5:
      fill(255, 0, 0, 75);
      noStroke();
      rect(250+(3*28), 177, 22, 28);
      break;
    }
    switch (bombsi)
    {
    case 1:
      fill(255, 0, 0, 75);
      noStroke();
      rect(246, 207, 22, 28);
      break;
    case 2:
      fill(255, 0, 0, 75);
      noStroke();
      rect(246+(1*28), 207, 22, 28);
      break;
    case 3:
      fill(255, 0, 0, 75);
      noStroke();
      rect(246+(2*28), 207, 22, 28);
      break;
    case 4:
      fill(255, 0, 0, 75);
      noStroke();
      rect(246+(3*28), 207, 22, 28);
      break;
    case 5:
      fill(255, 0, 0, 75);
      noStroke();
      rect(246+(4*28), 207, 22, 28);
      break;
    }
  }
}
void confirm()
{
  if (confirmb < 0)
  {
    confirmb = 1;
  }
  else if (confirmb > 1)
  {
    confirmb = 0;
  }
  if (confirma == true)
  {
    fill(0, 0, 0, 200);
    rect(0, 0, width, height);
    fill(255);
    textFont(font1);
    text("Are you Sure?", 125, 200);
    text("Yes", 175, 230);
    text("No", 175, 260);
    if (confirmb == 0)
    {
      fill(255, 0, 0, 75);
      noStroke();
      rect(170, 207, 55, 28);
    }
    else if (confirmb == 1)
    {
      fill(255, 0, 0, 75);
      noStroke();
      rect(170, 237, 50, 28);
    }
  }
}
void movement() //player movement
{
  if ((keys[0] == true)&&(player.y+20 > 0))
  {
    player.goUp();
  }
  if ((keys[1] == true)&&(player.y+20+13 < 478))
  {
    player.goDown();
  }

  if ((keys[2] == true)&&(player.x+18 > 0))
  {
    player.goLeft();
  }

  if ((keys[3] == true)&&(player.x+18+13 < 438))
  {
    player.goRight();
  }
}
void control() //control settings
{
  if (keyPressed == true)
  {
    if (key == CODED)
    {
      if (keyCode == UP)
      {
        if (mode == 1)
        {
          keys[0] = true;
        }
      }
      if (keyCode == DOWN)
      {
        if (mode == 1)
        {
          keys[1] = true;
        }
      }
      if (keyCode == LEFT)
      {
        keys[2] = true;
      }
      if (keyCode == RIGHT)
      {
        keys[3] = true;
      }
      if (keyCode == SHIFT)
      {
        keys[4] = true;
      }
    }
    if (key == 'z'|| key == 'Z')
    {
      if (mode == 1)
      {
        fireattack = true;
      }
    }
  }
}
void keyReleased()//controls to end movement
{
  if (key == CODED)
  {
    if (keyCode == UP)
    {
      if (mode == 0)
      {
        if (options == false)
        {
          selected--;
        }
        else if (options == true)
        {
          optionselected--;
        }
      }
      if ((confirma == false)&&(paused == true))
      {
        pausedselected--;
      }
      else if ((confirma == true)&&(paused == true))
      {
        confirmb--;
      }
      keys[0] = false;
    }
    if (keyCode == DOWN)
    {
      if (mode == 0)
      {
        if (options == false)
        {
          selected++;
        }
        else if (options == true)
        {
          optionselected++;
        }
      }
      if ((confirma == false)&&(paused == true))
      {
        pausedselected++;
      }
      else if ((confirma == true)&&(paused == true))
      {
        confirmb++;
      }
      keys[1] = false;
    }
    if (keyCode == LEFT)
    {
      if (mode == 0)
      {
        if (options == true)
        {
          switch (optionselected)
          {
          case 0:
            livesi--;
            break;
          case 1:
            bombsi--;
            break;
          }
        }
      }
      keys[2] = false;
    }
    if (keyCode == RIGHT)
    {
      if (mode == 0)
      {
        if (options == true)
        {
          switch (optionselected)
          {
          case 0:
            livesi++;
            break;
          case 1:
            bombsi++;
            break;
          }
        }
      }
      keys[3] = false;
    }
    if (keyCode == SHIFT)
    {
      keys[4] = false;
    }
  }
  if (key == '`')
  {
    if (fps == false)
    {
      fps = true;
    }
    else if (fps == true)
    {
      fps = false;
    }
  }
  if (key == 'y')
  {
    enemyspawn = 1;
  }
  if (key == 'z'|| key == 'Z')
  {
    if (mode == 0)
    {
      if (options == false)
      {
        switch (selected)
        {
        case 0:
          delay(3000);
          mode = 1;
          level = 1;
          lives = livesi;
          bombs = bombsi;
          break;
        case 3:
          options = true;
          period = 5;
          break;
        case 4:
          exit();
          break;
        }
      }
      if ((options == true)&&(period <= 0))
      {
        switch (optionselected)
        {
        case 2:
          options = false;
          period = 5;
          break;
        }
      }
    }
    if (mode == 1)
    {
      fireattack = false;
      if (paused == true)
      {
        if ((pausedselected == 0)&&(confirma == false))
        {
          paused = false;
        }
        if ((pausedselected == 2)&&(confirma == false))
        {
          confirma = true;
          period+=5;
        }
        if ((confirma == true)&&(period <= 0))
        {
          if (confirmb == 0)
          {
            mode = 0;
            confirma = false;
            paused = false;
            delayer = 0;
            player.x = 200;
            player.y = 430;
            score = 0;
            score2 = 1000;
            lives = 5;
            bombs = 5;
            level = 0;
            j = 0;
            b = 0;
            b2 = 0;
            e = 0;
          }
          if (confirmb == 1)
          {
            confirma = false;
          }
        }
      }
    }
  }
  if (key == ESC)
  {
    if (mode == 1)
    {
      if ((paused == false)&&(confirma == false))
      {
        paused = true;
      }
      else if ((paused == true)&&(confirma == false))
      {
        paused = false;
      }
      if (confirma == true)
      {
        confirma = false;
      }
    }
  }
}
void bosshealth()//boss's health and health bar
{
  if ((bosshealthx > 0)&&(bosshurt == true))
  {
    bosshealthx = bosshealthx - 1;
    bosshealthr = bosshealthr + 2;
    bosshealthg = bosshealthg - 1;
  }
  rect(10, 2, 380, 5);
  fill(bosshealthr, bosshealthg, 0);
  rect(10, 2, bosshealthx, 5);
}
void boss()//the boss
{
}
void bosshealthnumber()//boss's health in number
{
  textFont(font0);
  text(bosshealthx, 380, 20);
}
void fps2()//fps visual
{
  int fpstimer = millis();
  if (fps == true)
  {
    fill(255);
    //text(fpstimer,100,100); //debug
    textFont(font1);
    int fpsest = int(frameRate);
    text("version "+version, 475, 445);
    if (fpstimer >= fpstimer2)
    {
      text(fpsest, 600, 475);
    }
  }
}
/*void hitbox()//hitbox
 {
 rect(playerx+20, playery+22, 10, 10);
 }*/
void hud()//hud
{
  fill(255);
  image(huda, 440, 0, 200, 600);//placeholder
  textFont(font1);
  stroke(0);
  strokeWeight(1);
  //score
  fill(0, 0, 255);
  if (score < 9999999)
  {
    text("Score "+score, 455, 50);
  }
  else
  {
    score = 9999999;
    text("Score 9999999", 455, 50);
  }
  //lives
  fill(255, 0, 0);
  text("Lives", 505, 150);
  fill(255);
  ellipse (455, 180, 16, 16);
  ellipse (480, 180, 16, 16);
  ellipse (505, 180, 16, 16);
  ellipse (530, 180, 16, 16);
  ellipse (555, 180, 16, 16);
  ellipse (580, 180, 16, 16);
  ellipse (605, 180, 16, 16);
  ellipse (630, 180, 16, 16);
  fill(livesr, colora, colora);
  if (lives >= 1)
  {
    ellipse (455, 180, 16, 16);
  }
  if (lives >= 2)
  {
    ellipse (480, 180, 16, 16);
  }
  if (lives >= 3)
  {
    ellipse (505, 180, 16, 16);
  }
  if (lives >= 4)
  {
    ellipse (530, 180, 16, 16);
  }
  if (lives >= 5)
  {
    ellipse (555, 180, 16, 16);
  }
  if (lives >= 6)
  {
    ellipse (580, 180, 16, 16);
  }
  if (lives >= 7)
  {
    ellipse (605, 180, 16, 16);
  }
  if (lives >= 8)
  {
    ellipse (630, 180, 16, 16);
  }
  //bombs
  fill(0, 255, 0);
  text("Bombs", 495, 225);
  fill(255);
  ellipse (455, 255, 16, 16);
  ellipse (480, 255, 16, 16);
  ellipse (505, 255, 16, 16);
  ellipse (530, 255, 16, 16);
  ellipse (555, 255, 16, 16);
  ellipse (580, 255, 16, 16);
  ellipse (605, 255, 16, 16);
  ellipse (630, 255, 16, 16);
  fill(colora, bombsg, colora);
  if (bombs >= 1)
  {
    ellipse (455, 255, 16, 16);
  }
  if (bombs >= 2)
  {
    ellipse (480, 255, 16, 16);
  }
  if (bombs >= 3)
  {
    ellipse (505, 255, 16, 16);
  }
  if (bombs >= 4)
  {
    ellipse (530, 255, 16, 16);
  }
  if (bombs >= 5)
  {
    ellipse (555, 255, 16, 16);
  }
  if (bombs >= 6)
  {
    ellipse (580, 255, 16, 16);
  }
  if (bombs >= 7)
  {
    ellipse (605, 255, 16, 16);
  }
  if (bombs >= 8)
  {
    ellipse (630, 255, 16, 16);
  }
}
void reward()
{
  if ((score >= 1000000) && (rewarded <= 0))
  {
    rewarded++;
    lives++;
  }
  if ((score >= 2000000) && (rewarded <= 1))
  {
    rewarded++;
    lives++;
  }
  if ((score >= 4000000) && (rewarded <= 2))
  {
    rewarded++;
    lives++;
  }
  if ((score >= 6000000) && (rewarded <= 3))
  {
    rewarded++;
    lives++;
  }
  if ((score >= 8000000) && (rewarded <= 4))
  {
    rewarded++;
    lives++;
  }
}

void attack()
{
  if (fireattack == true)
  {
    if (delayer == 0)
    {
      j2++;
      laser1[j] = new Laser(player.x+25, player.y, 0);
      laser2[j] = new Laser(player.x+20+prevent1, player.y, -0.25);
      laser3[j] = new Laser(player.x+30+prevent1, player.y, 0.25);
      laser4[j] = new Laser(player.x+15+prevent2, player.y, -0.5);
      laser5[j] = new Laser(player.x+35+prevent2, player.y, 0.5);
      if (power >= 16)
      {
        prevent1 = 0;
      }
      else
      {
        prevent1 = 3000;
      }
      if (power >= 64)
      {
        prevent2 = 0;
      }
      else
      {
        prevent2 = 3000;
      }
      delayer = 0.35;
      if (j < j2-2)
      {
        j++;
      }
    }
  }
  if (delayer != 0)
  {
    delayer-=0.1;
  }
  if (delayer < 0)
  {
    delayer = 0;
  }
}
void level()
{
  switch (level)
  {
  case 1:
    switch (enemyspawn)
    {
    case 0:
    //enemy1[e] = new Enemy(50+100*e, 2, 2, 20, 0.75, 4.25);
      
      if (e <= 1)
      {
        e++;
      }
      break;
      /*if (e >= 9)
       {
       enemyspawn = 2;
       }*/
    }
    break;
  }
}
void keyPressed()
{
  if (key == ESC)
  {
    key = 0;
  }
}