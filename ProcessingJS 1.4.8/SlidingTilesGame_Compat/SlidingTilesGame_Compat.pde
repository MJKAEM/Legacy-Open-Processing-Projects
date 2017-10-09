/**
 * A sliding tile game tweaked from http://www.openprocessing.org/sketch/78225
 *
 * The goal of my tweak is to port it into JavaScript mode, so that people won't have to mess around with Java security settings.
 *
 * Also, the code is formatted differently, has code adjustments and bug fixes, and comments are added.
 */

/**
 * Original Description:
 * Nicole Strang
 * ITGM 315 -- Processing
 * 11/06/2012
 * Final Project -- Alpha 1.5
 *
 * The goal of this part of the project is to streamline the core playable code and add
 * classes. The Timer class stores the timer element.
 *
 * Tweaker's Description:
 * The goal of my tweak is to port it into Javascript mode, so that people didn't have
 * to mess arround with java security settings.
 *
 * Also, the code is formatted differently, has code adjustments and bug fixes, and comments are
 * added.
 */

private PuzzleGrid puzzleGrid;
private UserInterface userInterface;

private boolean isGameOver;
private boolean isPlaying;

private int score;
private int bestScore;

public void setup()
{
    size(350, 600);
    frameRate(60);
    noStroke();

    puzzleGrid = new PuzzleGrid(3);
    userInterface = new UserInterface();
}

public void draw()
{
    background(255);
    textSize(24);
    rectMode(CENTER);

    if (isPlaying)
    {
        if (!isGameOver)
        {
            puzzleGrid.show();
            puzzleGrid.update();

            //If the puzzle is solved, update the score and reset the game and timer.
            if (puzzleGrid.checkSolved()) 
            {
                score++;

                if (score > bestScore)
                {
                    bestScore = score;
                }

                fill(0);
                text("Score: " + score + "/5", 175, 450);
                puzzleGrid.scramble();
                userInterface.getTimer().reset();
            }
            else
            {
                userInterface.getTimer().update();

                //If the timer runs out, reset the game and timer.
                if (userInterface.getTimer().getRemainingSeconds() < Timer.LOWEST_SECONDS_VALUE) 
                {
                    puzzleGrid.scramble();
                    userInterface.getTimer().reset();

                    if (bestScore < score)
                    {
                        score = bestScore;
                    }

                    score = 0;
                }
            }
        }
    }

    userInterface.show();
}

public void mouseReleased()
{
    if (isPlaying)
    {
        if (isGameOver) 
        {
            isGameOver = false;
            score = 0;
            userInterface.getTimer().reset();
            puzzleGrid.scramble();
        }
        else
        {
            //If you click on the Next Puzzle button, reset the game and timer.
            if ((mouseX >= 75 && mouseX <= 275) && 
                (mouseY >= 445 && mouseY <= 495))
            {
                puzzleGrid.scramble();
                userInterface.getTimer().reset();
            }

            // If you click on the End Puzzle button, end the game. 
            if ((mouseX >= 75 && mouseX <= 275) && 
                (mouseY >= 515 && mouseY <= 565))
            {
                isGameOver = true;
            }

            //If the puzzle is not solved, allow the timer to run and the pieces to move.
            puzzleGrid.selectPieceToMove();
        }
    } 
    else
    {
        isPlaying = true;
        score = 0;
        userInterface.getTimer().reset();
    }
}

public class PuzzleGrid
{
    private PuzzlePiece[][] puzzlePieces;
    private int baseLength;

    private PuzzleGrid() 
    {
    }

    public PuzzleGrid(int baseLength)
    {
        this.baseLength = baseLength;
        this.puzzlePieces = new PuzzlePiece[baseLength][baseLength];

        boolean[][] reseted = new boolean[baseLength][baseLength];

        for (int row = 0; row < baseLength; row++)
        {
            for (int column = 0; column < baseLength; column++)
            {
                int selectedRow = (int)random(baseLength);
                int selectedColumn = (int)random(baseLength);

                while (reseted[selectedRow][selectedColumn])
                {
                    selectedRow = (int)random(baseLength);
                    selectedColumn = (int)random(baseLength);
                }

                reseted[selectedRow][selectedColumn] = true;
                this.puzzlePieces[row][column] = 
                new PuzzlePiece((selectedRow * baseLength) + selectedColumn, 
                    new PVector(row, column));
            }
        }

        for (int row = 0; row < baseLength; row++)
        {
            for (int column = 0; column < baseLength; column++)
            { 
                if (puzzlePieces[row][column].getNumberValue() == pow(baseLength, 2) - 1)
                {
                    puzzlePieces[row][column] = null;
                }
            }
        }
    }

    public void show()
    {
        for (int row = 0; row < getBaseLength (); row++)
        {
            for (int column = 0; column < getBaseLength (); column++)
            {
                PuzzlePiece puzzlePiece = puzzlePieces[row][column];

                if (puzzlePiece != null)
                {
                    puzzlePiece.show();
                }
            }
        }
    }

    public void update()
    {
        for (int row = 0; row < getBaseLength (); row++)
        {
            for (int column = 0; column < getBaseLength (); column++)
            {
                PuzzlePiece puzzlePiece = puzzlePieces[row][column];

                if (puzzlePiece != null)
                {
                    puzzlePiece.update();
                }
            }
        }
    }

    /**
    * Checks the puzzle to see if it is solved.
    */
    public boolean checkSolved()
    {
        for (int row = 0; row < getBaseLength(); row++)
        {
            for (int column = 0; column < getBaseLength(); column++)
            {
                PuzzlePiece puzzlePiece = puzzlePieces[row][column];

                if (puzzlePiece == null)
                {
                    if (row != getBaseLength() - 1 || column != getBaseLength() - 1)
                    {
                        return false;
                    }
                } 
                else
                {
                    if (puzzlePiece.getNumberValue() != (row * getBaseLength()) + column)
                    {
                        return false;
                    }
                }
            }
        }

        return true;
    }

    /**
    * Randomizes the entire puzzle grid. Does not initialize a new set of puzzle pieces.
    */
    public void scramble()
    {
        PuzzlePiece[][] tempPuzzlePieces = new PuzzlePiece[getBaseLength()][getBaseLength()];
        boolean[][] reseted = new boolean[getBaseLength()][getBaseLength()];

        for (int row = 0; row < getBaseLength (); row++)
        {
            for (int column = 0; column < getBaseLength (); column++)
            {
                int selectedRow = (int)random(getBaseLength());
                int selectedColumn = (int)random(getBaseLength());

                while (reseted[selectedRow][selectedColumn])
                {
                    selectedRow = (int)random(getBaseLength());
                    selectedColumn = (int)random(getBaseLength());
                }

                reseted[selectedRow][selectedColumn] = true;
                tempPuzzlePieces[row][column] = puzzlePieces[selectedRow][selectedColumn];

                if (tempPuzzlePieces[row][column] != null)
                {
                    tempPuzzlePieces[row][column].setCurrentPosition(new PVector(row, column));
                    tempPuzzlePieces[row][column].setDestinationPosition(new PVector(row, column));
                }
            }
        }

        puzzlePieces = tempPuzzlePieces;
    }

    public void selectPieceToMove()
    {
        for (int row = 0; row < getBaseLength (); row++)
        {
            for (int column = 0; column < getBaseLength (); column++)
            {
                PuzzlePiece puzzlePiece = puzzlePieces[row][column];

                if (puzzlePiece != null)
                {
                    if (puzzlePiece.isMouseOver())
                    {
                        if ((row - 1 >= 0 && row - 1 < getBaseLength()) &&
                            puzzlePieces[row - 1][column] == null)
                        {
                            puzzlePieces[row - 1][column] = puzzlePiece;
                            puzzlePiece.setDestinationPosition(new PVector(row - 1, column));
                            puzzlePieces[row][column] = null;
                        } 
                        else if ((column - 1 >= 0 && column - 1 < getBaseLength()) &&
                            puzzlePieces[row][column - 1] == null)
                        {
                            puzzlePieces[row][column - 1] = puzzlePiece;
                            puzzlePiece.setDestinationPosition(new PVector(row, column - 1));
                            puzzlePieces[row][column] = null;
                        } 
                        else if ((column + 1 >= 0 && column + 1 < getBaseLength()) &&
                            puzzlePieces[row][column + 1] == null)
                        {
                            puzzlePieces[row][column + 1] = puzzlePiece;
                            puzzlePiece.setDestinationPosition(new PVector(row, column + 1));
                            puzzlePieces[row][column] = null;
                        }
                        else if ((row + 1 >= 0 && row + 1 < getBaseLength()) &&
                            puzzlePieces[row + 1][column] == null)
                        {
                            puzzlePieces[row + 1][column] = puzzlePiece;
                            puzzlePiece.setDestinationPosition(new PVector(row + 1, column));
                            puzzlePieces[row][column] = null;
                        }
                    }
                }
            }
        }
    }

    //
    // Getters / Setters
    //

    public int getBaseLength()
    {
        return this.baseLength;
    }

    public void setBaseLength(int baseLength)
    {
        this.baseLength = baseLength;
    }

    public PuzzlePiece getPuzzleElement(int index)
    {
        int row = index / getBaseLength();
        int column = index % getBaseLength();

        return this.puzzlePieces[row][column];
    }
}

/**
 * Puzzle.pde -> PuzzlePiece.pde
 *
 * Tweaker's note:
 * Another unfortunate crisis is when the naming of variables are extremely vague. For
 * sanity purposes, please name your variables something meaningful! The name of this
 * file was also changed to match its actual use.
 *
 * Some variables are redundant here. Easiy, the display of puzzle pieces could be 
 */
public class PuzzlePiece
{
    public static final int DEFAULT_WIDTH = 72;
    public static final int DEFAULT_HEIGHT = 72;
    public static final int MAX_TRANSITION_VALUE = 100;

    private PVector currentPosition, destinationPosition;
    private int transitionValue;
    private int numberValue;

    public PuzzlePiece(int numberValue, PVector currentPosition)
    {
        this.numberValue = numberValue;
        this.currentPosition = currentPosition;
        this.destinationPosition = currentPosition;
    }

    public void show()
    {
        switch(getNumberValue())
        {
            case 0:
            fill(255, 0, 55);
            break;

            case 1:
            fill(223, 0, 83);
            break;

            case 2:
            fill(195, 0, 111);
            break;

            case 3:
            fill(167, 0, 139);
            break;

            case 4:
            fill(139, 0, 167);
            break;

            case 5:
            fill(111, 0, 195);
            break;

            case 6:
            fill(83, 0, 223);
            break;

            case 7:
            fill(55, 0, 255);
            break;

            case 8:
            fill(255, 255, 255);
            break;

            default:
            fill((getNumberValue() * 37) % 255, 
                (getNumberValue() * 53) % 255, 
                (getNumberValue() * 71) % 255);
            break;
        }

        // Perform calculations to render the tile transition seamlessly, if it needs to move.
        double transitionPercent = (double)((double)getTransitionValue() / MAX_TRANSITION_VALUE);

        int differenceX = (int)((getDestinationPosition().x - getCurrentPosition().x) *
            (DEFAULT_WIDTH + 3) * transitionPercent);
        int differenceY = (int)((getDestinationPosition().y - getCurrentPosition().y) *
            (DEFAULT_HEIGHT + 3) * transitionPercent);

        rect((getCurrentPosition().x * (DEFAULT_WIDTH + 3)) + differenceX + 100, 
            (getCurrentPosition().y * (DEFAULT_HEIGHT + 3)) + differenceY + 150, 
            DEFAULT_WIDTH, DEFAULT_HEIGHT);

        fill(255);
        text(getNumberValue() + 1, 
            (getCurrentPosition().x * (DEFAULT_WIDTH + 3)) + differenceX + 100, 
            (getCurrentPosition().y * (DEFAULT_HEIGHT + 3)) + differenceY + 150);
    }


    public void update()
    {
        // Update the transition value if the destination isn't the same as the current position.
        if (getCurrentPosition().x != getDestinationPosition().x ||
            getCurrentPosition().y != getDestinationPosition().y)
        {
            if (getTransitionValue() < MAX_TRANSITION_VALUE)
            {
                setTransitionValue(getTransitionValue() + 5);
            } 
            else
            {
                setTransitionValue(0);
                setCurrentPosition(getDestinationPosition());
            }
        }
    }

    public boolean isMouseOver()
    {
        if ((mouseX >= (getDestinationPosition().x * (DEFAULT_WIDTH + 3) + 100 - (DEFAULT_WIDTH / 2)))
            && (mouseX <= (getDestinationPosition().x * (DEFAULT_WIDTH + 3) + 100 + (DEFAULT_WIDTH / 2))) &&
            (mouseY >= (getDestinationPosition().y * (DEFAULT_HEIGHT + 3) + 150 - (DEFAULT_HEIGHT / 2)))
            && (mouseY <= (getDestinationPosition().y * (DEFAULT_HEIGHT + 3) + 150 + (DEFAULT_HEIGHT / 2))))
        {
            return true;
        } 
        else
        {
            return false;
        }
    }

    //
    // Getters / Setters
    //

    public PVector getCurrentPosition()
    {
        return this.currentPosition;
    }

    public void setCurrentPosition(PVector currentPosition)
    {
        this.currentPosition = currentPosition;
    }

    public PVector getDestinationPosition()
    {
        return this.destinationPosition;
    }

    public void setDestinationPosition(PVector destinationPosition)
    {
        this.destinationPosition = destinationPosition;
    }

    public int getNumberValue()
    {
        return this.numberValue;
    }

    public void setNumberValue(int numberValue)
    {
        this.numberValue = numberValue;
    }

    public int getTransitionValue()
    {
        return this.transitionValue;
    }

    public void setTransitionValue(int transitionValue)
    {
        this.transitionValue = transitionValue;
    }
}

/**
 * Timer.pde
 * 
 * Tweaker's note:
 * Unfortunately, the original author included the variables secMin and seconds, which are
 * rendered redundant by tricks by the tweaker. Thus, two variables are removed from the
 * original.
 */
public class Timer
{
    public static final int LOWEST_SECONDS_VALUE = 0;

    private int maximumSeconds;
    private int currentTime, startingTime;

    public Timer(int maximumSeconds)
    {
        this.maximumSeconds = maximumSeconds;
    }

  /**
   * Resets the timer
   */
  public void reset()
  {
    setStartingTime(millis());
  }

  /**
   * Renders the timer text to the screen.
   */
  public void show()
  {
    fill(0);
    textAlign(CENTER);
    text("Time Left: " + ceil(getRemainingSeconds()), 175, 50);
  }

  /**
   * Updates the timer.
   */
  public void update()
  {
    setCurrentTime(millis());
  }

  /**
  * Returns the number of seconds left for the current game.
  */
  public int getRemainingSeconds()
  {
    return getMaximumSeconds() - ((getCurrentTime() - getStartingTime()) / 1000);
  }

  //
  // Getters / Setters
  //

  public int getCurrentTime()
  {
    return this.currentTime;
  }

  public void setCurrentTime(int currentTime)
  {
    this.currentTime = currentTime;
  }

  public int getMaximumSeconds()
  {
    return this.maximumSeconds;
  }

  public void setMaximumSeconds(int maximumSeconds)
  {
    this.maximumSeconds = maximumSeconds;
  }

  public int getStartingTime()
  {
    return this.startingTime;
  }

  public void setStartingTime(int startingTime)
  {
    this.startingTime = startingTime;
  }
}

/**
* Screen.pde -> UserInterface.pde
*
* Tweaker's note:
* By putting your update code all over the place, you risk making everything completely hard to
* maintain for not only everyone who reads your code, but also for yourself. To fix this,
* UserInterface would only contain the timer and certain rendering.
*
* Also, had I simply chose to do a direct port of the code to ProcessingJS, then the program would
* crash upon entering the Game Over state, due to textAlign not being adjusted for zero length
* string. This is caused by the use of newlines (\n) in the text display.
*
*/
public class UserInterface
{
    private Timer timer;

    public UserInterface()
    {
        timer = new Timer(90);
    }

    public void show()
    {
        fill(0);
        textAlign(CENTER);

        if (isPlaying)
        {
            if (isGameOver)
            {
                fill(0);
                text("Thanks for playing!\n \nScore: " + score + 
                    "\nBest Score: " + bestScore + 
                    "\n \nClick to \nplay again", 
                    width / 2, 
                    150);
            } 
            else
            {
                timer.show();

                //draw score
                fill(0);
                text("Score: " + score, 175, 400);

                //draw new puzzle button
                fill(100);
                rect(175, 470, 200, 50);
                fill(255);
                text("New Puzzle", 175, 480);

                //draw end game button
                fill(100);
                rect(175, 540, 200, 50);
                fill(255);
                text("End Game", 175, 550);
            }
        } 
        else
        {
            fill(0);
            text("Left click to start", width / 2, height / 2);
        }
    }

    public void update()
    {
        timer.update();
    }

    //
    // Getters / Setters
    //

    public Timer getTimer()
    {
        return this.timer;
    }

    public void setTimer(Timer timer)
    {
        this.timer = timer;
    }
}