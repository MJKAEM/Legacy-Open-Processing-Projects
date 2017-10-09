/**
 * Port of Minesweeper to use ProcessingJS.
 *
 * Original Description:
 * Classic minesweeper.
 *
 * Version 2.1 -
 * - Added a timer
 * - Added a 'Flags Left' display
 * - Slightly modified aesthetics of cells
 * 
 * Version 2.0 -
 * - Re-made the code for more efficiency and speed
 * - Improved aesthetics
 * - Bug fixes
 * - More of the classic minesweeper controls available
 */

/* @pjs font="gishabd.ttf" */
/*/----------
 Minesweeper
 Simon Hajjar
 20.03.12
 ----------/*/

final int SCREEN_SIZE = 700; //Dimensions of the screen
final int MENU_HEIGHT = SCREEN_SIZE/15; //Height of the menu
boolean gameOverState = false;
float gameTimer = 0; //The game time so far (exact)
int clockMax = 999; //The maximum time on the clock

//Variables pertaining to the cells
PFont cellFont; //Creates a variable to hold the cell font
Cell[][] cellAssignments; //Array holding the co-ordinates of the cells
final int CELL_SIZE = SCREEN_SIZE/35; //Size of the cell
final int TOTAL_MINES = 140; //Total number of mines on the grid
int flagsLeft = TOTAL_MINES; //The total number of flags

void setup() {
  size(700, 700, JAVA2D); //Creates a screen
  smooth();
  cellFont = createFont("GishaBd", 48); //Loads the cell font from the data file

  //Rendering the game
  spawnNewLevel(); //Spawns a new level
}

void draw() {  //Allows the game to continually run
  background(255);
  for (int i = 0; i < cellAssignments.length; i++) //Gets the x co-ordinate of each cell
    for (int j = 0; j < cellAssignments[0].length; j++) { //Gets the y co-ordinate of each cell
      if (!cellAssignments[i][j].perimeterCleared && cellAssignments[i][j].openCell && !cellAssignments[i][j].mineCell && cellAssignments[i][j].adjacentMines == 0) {
        clearSurroundingCells(i, j); //Clears unflagged surrounding cells
        cellAssignments[i][j].perimeterCleared = true; //The perimeter has been cleared
      }
      if (cellAssignments[i][j].mineCell && cellAssignments[i][j].openCell) gameOverState = true; //If a mine is ever open, the game is done
      cellAssignments[i][j].updateCell(); //Renders the cell
    }

  if (gameOverState) { //If the user has lost
    fill(255, 255, 255, 150);
    rect(0, SCREEN_SIZE*2/5, SCREEN_SIZE, SCREEN_SIZE/4);
    textSize(SCREEN_SIZE/16);
    fill(0);
    textAlign(CENTER);
    text("GAME OVER" + "\n Press 'N' to Start a New Game", SCREEN_SIZE/2, SCREEN_SIZE/2);
  }

  fill(255); //Fills with a lighter color
  rect(0, 0, SCREEN_SIZE, MENU_HEIGHT); //Draws the HUD bar
  fill(0); //Fills black
  textAlign(CENTER); //Aligns text to the center
  textSize(SCREEN_SIZE/25); //Sets the text size
  text("Minesweeper", SCREEN_SIZE/2, MENU_HEIGHT*3/4); //Writes the title
  textSize(SCREEN_SIZE*4/175);
  if(!gameOverState && gameTimer < clockMax) gameTimer++;
  text("Time: " + (int)(gameTimer/50), SCREEN_SIZE/12, MENU_HEIGHT*9/13);
  text("Flags Left: " + flagsLeft, SCREEN_SIZE*44/50, MENU_HEIGHT*9/13);
}

void mousePressed() { //Called when the mouse is pressed
  if (!gameOverState) {
    for (int i = 0; i < cellAssignments.length; i++) //Gets the x co-ordinate of each cell
      for (int j = 0; j < cellAssignments[0].length; j++) { //Gets the y co-ordinate of each cell
        if (mouseX > i*CELL_SIZE && mouseX < (i + 1)*CELL_SIZE
          && mouseY > j*CELL_SIZE + MENU_HEIGHT && mouseY < (j + 1)*CELL_SIZE + MENU_HEIGHT) { //If the mouse is in a cell
          if (mouseButton == LEFT && cellAssignments[i][j].flagCell == false) { 
            if (cellAssignments[i][j].openCell) {//If the cell is already open
              if (cellAssignments[i][j].adjacentFlags == cellAssignments[i][j].adjacentMines) //If the adjacent flags is equal to the number of mines
                  clearSurroundingCells(i, j); //Clears the surrounding squares (besides the flags)
            }            
            else {
              cellAssignments[i][j].openCell = true; //Opens the cell
            }
          }
          else if (mouseButton == RIGHT) { 
            if (!cellAssignments[i][j].openCell) { //If the cell is closed
              flagsLeft += (cellAssignments[i][j].flagCell) ? 1 : -1; //Modify number of flags left
              cellAssignments[i][j].flagCell = !cellAssignments[i][j].flagCell; //If right clicked, flag the cell
              //Adds one to all adjacent flag counts
              if (i > 0) cellAssignments[i - 1][j].adjacentFlags += (cellAssignments[i][j].flagCell) ? 1 : -1;
              if (i < cellAssignments.length - 1) cellAssignments[i + 1][j].adjacentFlags += (cellAssignments[i][j].flagCell) ? 1 : -1;
              if (j > 0) cellAssignments[i][j - 1].adjacentFlags += (cellAssignments[i][j].flagCell) ? 1 : -1;
              if (j < cellAssignments[0].length - 1) cellAssignments[i][j + 1].adjacentFlags += (cellAssignments[i][j].flagCell) ? 1 : -1; 
              if (i > 0 && j > 0) cellAssignments[i - 1][j - 1].adjacentFlags += (cellAssignments[i][j].flagCell) ? 1 : -1;
              if (i < cellAssignments.length - 1 && j > 0) cellAssignments[i + 1][j - 1].adjacentFlags += (cellAssignments[i][j].flagCell) ? 1 : -1; 
              if (i > 0 && j < cellAssignments[0].length - 1) cellAssignments[i - 1][j + 1].adjacentFlags += (cellAssignments[i][j].flagCell) ? 1 : -1; 
              if (i < cellAssignments.length - 1 && j < cellAssignments[0].length - 1) cellAssignments[i + 1][j + 1].adjacentFlags += (cellAssignments[i][j].flagCell) ? 1 : -1;
            }
          }
        }
      }
  }
}

void keyPressed() {
  if ((key == 'N' || key == 'n') && gameOverState) { //If the user presses 'N' after a game over
    gameOverState = false; //Turn off the game over mode
    gameTimer = 0; //Resets game timer
    flagsLeft = TOTAL_MINES; //Resets number of flags left
    spawnNewLevel(); //Spawn a new level
  }
}

void spawnNewLevel() { //Spawns a new level
  //Creates the cells
  cellAssignments = new Cell[SCREEN_SIZE/CELL_SIZE][(SCREEN_SIZE - MENU_HEIGHT)/CELL_SIZE]; //Creates a new array of coordinates
  for (int i = 0; i < cellAssignments.length; i++) //Gets the x co-ordinate of each cell
    for (int j = 0; j < cellAssignments[0].length; j++) { //Gets the y co-ordinate of each cell
      cellAssignments[i][j] = new Cell(i*CELL_SIZE, j*CELL_SIZE + MENU_HEIGHT); //Creates a new cell in the grid
    }

  //Creates the mines
  for (int i = 0; i < TOTAL_MINES; i++) {
    PVector randomCellAssignment = new PVector(random(cellAssignments.length), random(cellAssignments[0].length)); //Chooses a random cell
    if (cellAssignments[int(randomCellAssignment.x)][int(randomCellAssignment.y)].mineCell == false) //If the cell is not a mine
        cellAssignments[int(randomCellAssignment.x)][int(randomCellAssignment.y)].mineCell = true; //Make the cell a mine cell
    else i--; //Else re-do the loop an extra time
  }

  //Updates adjacent mine cells of each cell
  for (int i = 0; i < cellAssignments.length; i++) //Gets the x co-ordinate of each cell
    for (int j = 0; j < cellAssignments[0].length; j++) {//Gets the y co-ordinate of each cell
      if (cellAssignments[i][j].mineCell == false) { //If the cell is not a mine cell
        if (i > 0 && cellAssignments[i - 1][j].mineCell == true) cellAssignments[i][j].adjacentMines++; //If there is a cell on the left, add one to adjacent mine cells
        if (i < cellAssignments.length - 1 && cellAssignments[i + 1][j].mineCell == true) cellAssignments[i][j].adjacentMines++; //If there is a cell on the right, add one to adjacent mine cells
        if (j > 0 && cellAssignments[i][j - 1].mineCell == true) cellAssignments[i][j].adjacentMines++; //If there is a cell on top, add one to adjacent mine cells
        if (j < cellAssignments[0].length - 1 && cellAssignments[i][j + 1].mineCell == true) cellAssignments[i][j].adjacentMines++; //If there is a cell underneath, add one to adjacent mine cells       
        if (i > 0 && j > 0 && cellAssignments[i - 1][j - 1].mineCell == true) cellAssignments[i][j].adjacentMines++; //If there is a cell on the top left, add one to adjacent mine cells
        if (i < cellAssignments.length - 1 && j > 0 && cellAssignments[i + 1][j - 1].mineCell == true) cellAssignments[i][j].adjacentMines++; //If there is a cell on the top right, add one to adjacent mine cells
        if (i > 0 && j < cellAssignments[0].length - 1 && cellAssignments[i - 1][j + 1].mineCell == true) cellAssignments[i][j].adjacentMines++; //If there is a cell on the bottom left, add one to adjacent mine cells
        if (i < cellAssignments.length - 1 && j < cellAssignments[0].length - 1 && cellAssignments[i + 1][j + 1].mineCell == true) cellAssignments[i][j].adjacentMines++; //If there is a cell on the bottom right, add one to adjacent mine cells
      }
    }
}

void clearSurroundingCells(int i, int j) { //Clears all surrounding cells that aren't flagged
  if (i > 0 && !cellAssignments[i - 1][j].flagCell) cellAssignments[i - 1][j].openCell = true; //Opens the left cell
  if (i < cellAssignments.length - 1 && !cellAssignments[i + 1][j].flagCell) cellAssignments[i + 1][j].openCell = true; //Opens the right cell
  if (j > 0 && !cellAssignments[i][j - 1].flagCell) cellAssignments[i][j - 1].openCell = true; //Opens the top cell
  if (j < cellAssignments[0].length - 1 && !cellAssignments[i][j + 1].flagCell) cellAssignments[i][j + 1].openCell = true; //Opens the bottom cell    
  if (i > 0 && j > 0 && !cellAssignments[i - 1][j - 1].flagCell) cellAssignments[i - 1][j - 1].openCell = true; //Opens the top left cell
  if (i < cellAssignments.length - 1 && j > 0 && !cellAssignments[i + 1][j - 1].flagCell) cellAssignments[i + 1][j - 1].openCell = true; //Opens the top right cell
  if (i > 0 && j < cellAssignments[0].length - 1 && !cellAssignments[i - 1][j + 1].flagCell) cellAssignments[i - 1][j + 1].openCell = true; //Opens the bottom left cell
  if (i < cellAssignments.length - 1 && j < cellAssignments[0].length - 1 && !cellAssignments[i + 1][j + 1].flagCell) cellAssignments[i + 1][j + 1].openCell = true; //Opens the bottom right cell
}

class Cell { //Class for the cells
  PVector location; //Location of the cell

  boolean mineCell = false; //If the cell is a mine cell or not
  boolean openCell = false; //If the cell is open or not
  boolean flagCell = false; //If the cell is flagged or not
  boolean perimeterCleared = false; //If the cell has cleared around it yet (only applies to those with no adjacent mines)
  int adjacentMines = 0; //The number of adjacent mines to the cell
  int adjacentFlags = 0; //The number of adjacent flags to the cell

  Cell(int locationInputX, int locationInputY) { //Creates a new cell
    this.location = new PVector(locationInputX, locationInputY); //Sets location to inputed co-ordinates
  }

  void updateCell() { //Renders the cell
    strokeWeight(SCREEN_SIZE/400); //Sets the stroke weight
    if (!this.openCell) fill(#5C62F0); //If the cell isn't open, fills light
    else fill(230); //If it is open, fills darker
    rect(this.location.x, this.location.y, CELL_SIZE, CELL_SIZE); //Draws the cell

    if (this.openCell) {
      if (this.mineCell) {
        fill(0); //Fills black
        ellipse(this.location.x + CELL_SIZE/2, this.location.y + CELL_SIZE/2, CELL_SIZE/2, CELL_SIZE/2); //Draws the mine
      } 
      else if (this.adjacentMines > 0) { //Else if there is at least one adjacent mine block
        textSize(CELL_SIZE*5/7); //Sets the font size of the cells
        switch(this.adjacentMines) { //Checks the number of adjacent mines, and colors accordingly
          case 1: fill(#0000FF); break;
          case 2: fill(#009500); break;
          case 3: fill(#FF0000); break;
          case 4: fill(#000090); break;
          case 5: fill(#550000); break;
          case 6: fill(#0089AA); break;
          case 7: fill(#AD00A2); break;
          case 8: fill(#000000); break;
        }
        text(this.adjacentMines, this.location.x + SCREEN_SIZE*3/200, this.location.y + SCREEN_SIZE*11/500); //Writes the number of adjacent blocks
      }
    } else if(this.flagCell) { //If it is a flag cell
        fill(#FF0000); //Fills black
        ellipse(this.location.x + CELL_SIZE/2, this.location.y + CELL_SIZE/2, CELL_SIZE/2, CELL_SIZE/2); //Draws the flag
    }
  }
}