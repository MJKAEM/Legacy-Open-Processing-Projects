/**
 * A display of multiple sort algorithms that sort out an unsorted list.
 *
 * Controls:
 * Q - Toggle between line / bar mode.
 * 1 - Sets the algorithm to Bubble Sort.
 * 2 - Sets the algorithm to Selection Sort.
 * 3 - Sets the algorithm to Merge Sort.
 * ~ (Tilde) - Toggles the FPS counter.
 */

/**
* Sort_Everything_Compat.pde
*
* Displays various Sort methods using either bars or lines.
*/
public static final int SCREEN_WIDTH = 480;
public static final int SCREEN_HEIGHT = 360;
public static final int MAX_NUMBER = SCREEN_HEIGHT - 60;
public static final int LIST_SIZE_BAR = (SCREEN_WIDTH - 30) / SortBar.BLOCK_WIDTH;
public static final int LIST_SIZE_LINE = SCREEN_WIDTH - 30;

private FramesCounter framesCounter;

private SortMethod<SortBar> sortTypeBar;
private SortMethod<SortLine> sortTypeLine;

private ArrayList<SortBar> unsortedBarList;
private ArrayList<SortLine> unsortedLineList;

public static boolean lineMode = false;

public void setup()
{
    size(480, 360);
    frameRate(60);

    textSize(12);

    framesCounter = new FramesCounter();

    unsortedBarList = new ArrayList<SortBar>(LIST_SIZE_BAR);
    unsortedLineList = new ArrayList<SortLine>(LIST_SIZE_LINE);

    // Initiate all lists.
    for (int i = 0; i < LIST_SIZE_LINE; ++i)
    {
        unsortedLineList.add(new SortLine((int)(random(MAX_NUMBER) + 1)));
    }

    for (int i = 0; i < LIST_SIZE_BAR; ++i)
    {
        unsortedBarList.add(new SortBar((int)(random(MAX_NUMBER) + 1)));
    }

    sortTypeBar = new BubbleSort<SortBar>(unsortedBarList);
    sortTypeLine = new BubbleSort<SortLine>(unsortedLineList);
}

public void draw()
{
    background(0, 0, 64);

    framesCounter.show();

    fill(255);

    if (lineMode)
    {
        text("Size of list: " + LIST_SIZE_LINE, 5, height - 5);
        sortTypeLine.oneSort();
        sortTypeLine.show();
    }
    else
    {
        text("Size of list: " + LIST_SIZE_BAR, 5, height - 5);
        sortTypeBar.oneSort();
        sortTypeBar.show();
    }
}

public void keyReleased()
{
    switch (key)
    {
    case 'q':
        lineMode = !lineMode;

        if (lineMode)
        {
            sortTypeLine.reset();
        }
        else
        {
            sortTypeBar.reset();
        }

        reinitiateList();
        break;

    case '1':
        reinitiateList();
        sortTypeBar = new BubbleSort<SortBar>(unsortedBarList);
        sortTypeLine = new BubbleSort<SortLine>(unsortedLineList);
        break;

    case '2':
        reinitiateList();
        sortTypeBar = new SelectionSort<SortBar>(unsortedBarList);
        sortTypeLine = new SelectionSort<SortLine>(unsortedLineList);
        break;

    case '3':
        reinitiateList();
        sortTypeBar = new MergeSort<SortBar>(unsortedBarList);
        sortTypeLine = new MergeSort<SortLine>(unsortedLineList);
        break;

    default:
        break;
    }

    framesCounter.update();
}

public void initiateSort()
{
    if (lineMode)
    {
        sortTypeLine.reset();
    }
    else
    {
        sortTypeBar.reset();
    }
}

public void reinitiateList()
{
    if (lineMode)
    {
        for (int i = 0; i < LIST_SIZE_LINE; ++i)
        {
            unsortedLineList.set(i, new SortLine((int)(random(MAX_NUMBER) + 1)));
        }

        if (sortTypeLine instanceof BubbleSort)
        {
            sortTypeLine = new BubbleSort<SortLine>(unsortedLineList);
        }
        else if (sortTypeLine instanceof SelectionSort)
        {
            sortTypeLine = new SelectionSort<SortLine>(unsortedLineList);
        }
        else if (sortTypeLine instanceof MergeSort)
        {
            sortTypeLine = new MergeSort<SortLine>(unsortedLineList);
        }
    }
    else
    {
        for (int i = 0; i < LIST_SIZE_BAR; ++i)
        {
            unsortedBarList.set(i, new SortBar((int)(random(MAX_NUMBER) + 1)));
        }

        if (sortTypeBar instanceof BubbleSort)
        {
            sortTypeBar = new BubbleSort<SortBar>(unsortedBarList);
        }
        else if (sortTypeBar instanceof SelectionSort)
        {
            sortTypeBar = new SelectionSort<SortBar>(unsortedBarList);
        }
        else if (sortTypeBar instanceof MergeSort)
        {
            sortTypeBar = new MergeSort<SortBar>(unsortedBarList);
        }
    }
}


/**
* BubbleSort.pde
*
* Performs a visual representation of how Bubble Sort works.
*/
public class BubbleSort<E extends Sortable<E>> extends SortMethod<E>
{
    private int scan, progress;
    private E sortable;

    public BubbleSort(ArrayList<E> unsortedList)
    {
        super(unsortedList);
    }

    public void show()
    {
        super.show();

        if (progress > -1)
        {
            if (lineMode)
            {
                showAllLines();
            }
            else
            {
                showAllBars();
            }
        }
        else
        {
            showCheckSort();
        }
    }

    public void oneSort()
    {
        if (progress > -1)
        {
            if (scan < progress)
            {
                if (sortable.compareTo(getCurrentList().get(scan)) < 0)
                {
                    sortable = getCurrentList().get(scan);
                }
                else
                {
                    E temp = getCurrentList().get(scan);
                    getCurrentList().set(scan, sortable);
                    getCurrentList().set(scan - 1, temp);
                }

                ++scan;
            }
            else
            {
                scan = 1;
                sortable = getCurrentList().get(0);
                --progress;
            }
        }
        else
        {
            if (!isCompleted())
            {
                setCompleted(true);
                takeTime();
            }
            checkSort();
        }
    }

    public void reset()
    {
        super.reset();

        progress = getCurrentList().size();

        if (progress > 0)
        {
            sortable = getCurrentList().get(0);
            scan = 1;
        }
    }

    private void showAllLines()
    {
        noFill();

        // Show regular lines
        //
        stroke(255);

        for (int i = progress - 1; i >= 0; --i)
        {
            getCurrentList().get(i).show(15 + i);
        }

        // Show lines on the sorted side
        //
        stroke(0, 255, 0);

        for (int i = getCurrentList().size() - 1; i >= progress; --i)
        {
            getCurrentList().get(i).show(15 + i);
        }

        // Show flag
        //
        stroke(255, 0, 0);
        getCurrentList().get(scan - 1).show(15 + (scan - 1));

        // Show current Search
        //
        if (scan < getCurrentList().size())
        {
            stroke(255, 255, 0);
            getCurrentList().get(scan).show(15 + scan);
        }
    }

    private void showAllBars()
    {
        stroke(0);

        // Show regular bars
        //
        fill(255);

        for (int i = 0; i < progress; i++)
        {
            getCurrentList().get(i).show(15 + (i * SortBar.BLOCK_WIDTH));
        }

        // Show bars on the sorted side
        //
        fill(0, 255, 0);

        for (int i = getCurrentList().size() - 1; i >= progress; --i)
        {
            getCurrentList().get(i).show(15 + (i * SortBar.BLOCK_WIDTH));
        }

        // Show flag
        //
        fill(255, 0, 0);
        getCurrentList().get(scan - 1).show(
                15 + ((scan - 1) * SortBar.BLOCK_WIDTH));

        // Show current search
        //
        if (scan < getCurrentList().size())
        {
            fill(255, 0, 0);
            getCurrentList().get(scan).show(
                    15 + (scan * SortBar.BLOCK_WIDTH));
        }
    }

    public String getSortName()
    {
        return "Bubble Sort";
    }

    //
    // Getters / Setters
    //

    public int getScan()
    {
        return this.scan;
    }
}


/**
* FramesCounter.pde
*
* Displays the current frames and updates every second.
*/
public class FramesCounter
{
    public static final int F3_VALUE = 114;
    public static final int TILDE_VALUE = 192;

    private int currentFrames, fpsTimer;
    private boolean enabled;

    public FramesCounter()
    {
    }

    public FramesCounter(boolean enabled)
    {
        this.enabled = enabled;
    }

    public void update()
    {
        if (keyCode == TILDE_VALUE)
        {
            setEnabled(!isEnabled());
            setFpsTimer(0);
        }
    }

    public void show()
    {
        if (isEnabled())
        {
            if (getFpsTimer() >= 5)
            {
                setCurrentFrames((int)frameRate);
                setFpsTimer(0);
            }

            fill(255);
            textSize(12);

            // text(fpsTimer, 100, 100); //debug
            text(getCurrentFrames(), width - 20, height - 5);

            setFpsTimer(getFpsTimer() + 1);
        }
    }

    //
    // Getters / Setters
    //

    public int getCurrentFrames()
    {
        return this.currentFrames;
    }

    protected void setCurrentFrames(int currentFrames)
    {
        this.currentFrames = currentFrames;
    }

    public boolean isEnabled()
    {
        return this.enabled;
    }

    protected void setEnabled(boolean isEnabled)
    {
        this.enabled = isEnabled;
    }

    public int getFpsTimer()
    {
        return this.fpsTimer;
    }

    protected void setFpsTimer(int fpsTimer)
    {
        this.fpsTimer = fpsTimer;
    }
}


/**
* MergeSort.pde
*
* Performs a visual representation of how Merge Sort works.
*/
public class MergeSort<E extends Sortable<E>> extends SortMethod<E>
{
    protected MergeSortPiece<E> partA, partB;

    private ArrayList<E> sortedList;
    protected int scanA, scanB;

    public MergeSort(ArrayList<E> unsortedList)
    {
        super(unsortedList);

        final int SIZE = unsortedList.size();
        sortedList = new ArrayList<E>(SIZE);

        if (unsortedList.size() > 2)
        {
            final int HALF_SIZE = unsortedList.size() >> 1;

            final ArrayList<E> listA = new ArrayList<E>(HALF_SIZE);
            final ArrayList<E> listB = new ArrayList<E>(HALF_SIZE);

            for (int i = 0; i < HALF_SIZE; ++i)
            {
                listA.add(unsortedList.get(i));
            }

            for (int i = HALF_SIZE; i < SIZE; ++i)
            {
                listB.add(unsortedList.get(i));
            }

            partA = new MergeSortPiece<E>(listA);
            partB = new MergeSortPiece<E>(listB);
        }
    }

    public void show()
    {
        if (!(this instanceof MergeSortPiece))
        {
            super.show();
        }

        if (!isCompleted())
        {
            partA.show();

            translatePart();
            if (!partA.isCompleted())
            {
                if (lineMode)
                {
                    stroke(255);
                    noFill();

                    for (int i = 0; i < partB.getCurrentList().size(); ++i)
                    {
                        partB.getCurrentList().get(i).show(15 + i);
                    }
                }
                else
                {
                    stroke(0);
                    fill(255);

                    for (int i = 0; i < partB.getCurrentList().size(); ++i)
                    {
                        partB.getCurrentList().get(i)
                        .show(15 + (i * SortBar.BLOCK_WIDTH));
                    }
                }
            }
            else
            {

                partB.show();

            }
            untranslatePart();

            // This section displays the searching colors after combining the
            // sorted parts, hence why it requires both parts be completed
            //
            if (partA.isCompleted() && partB.isCompleted())
            {
                if (lineMode)
                {
                    noFill();

                    if (scanA < partA.getCurrentList().size())
                    {
                        stroke(255, 255, 0);
                        partA.getCurrentList().get(scanA).show(15 + scanA);
                    }

                    translatePart();
                    if (scanB < partB.getCurrentList().size())
                    {
                        stroke(255, 255, 0);
                        partB.getCurrentList().get(scanB).show(15 + scanB);
                    }
                    untranslatePart();
                }
                else
                {
                    stroke(0);

                    if (scanA < partA.getCurrentList().size())
                    {
                        fill(255, 255, 0);

                        partA.getCurrentList().get(scanA).show(
                            15 + (scanA * SortBar.BLOCK_WIDTH));
                    }

                    translatePart();
                    if (scanB < partB.getCurrentList().size())
                    {
                        fill(255, 255, 0);

                        partB.getCurrentList().get(scanB).show(
                            15 + (scanB * SortBar.BLOCK_WIDTH));
                    }
                    untranslatePart();
                }
            }
        }
        // If the work is completed, show the checking process
        //
        else
        {
            showCheckSort();
        }
    }

    /**
     * Sorts the list using Merge sort, modified for visualization purposes.
     */
    public void oneSort()
    {
        if (!isCompleted())
        {
            // Ensure the smaller parts are finished first before merging
            //
            if (!partA.isCompleted())
            {
                partA.oneSort();
            }
            else if (!partB.isCompleted())
            {
                partB.oneSort();
            }
            else
            {
                // Booleans for readability and optimization
                //
                boolean incompleteA = scanA < partA.getSortedList().size();
                boolean incompleteB = scanB < partB.getSortedList().size();

                E itemA = null;
                E itemB = null;

                // If both scanA and scanB are not done, then merge the
                // elements into a sorted list
                //
                if (incompleteA && incompleteB)
                {
                    itemA = partA.getCurrentList().get(scanA);
                    itemB = partB.getCurrentList().get(scanB);

                    if (itemA.compareTo(itemB) < 0)
                    {
                        sortedList.add(itemA);
                        ++scanA;
                    }
                    else
                    {
                        sortedList.add(itemB);
                        ++scanB;
                    }
                }
                // If part A is complete, fill in the rest with B
                //
                else if (!incompleteA && incompleteB)
                {
                    itemB = partB.getCurrentList().get(scanB);
                    sortedList.add(itemB);
                    ++scanB;
                }
                // If part B is complete, fill in the rest with A
                //
                else if (incompleteA && !incompleteB)
                {
                    itemA = partA.getCurrentList().get(scanA);
                    sortedList.add(itemA);
                    ++scanA;
                }
                // If both parts are complete, then do checks and change its
                // status to complete
                //
                else if (!incompleteA && !incompleteB)
                {
                    setCurrentList(getSortedList());
                    takeTime();
                    setCompleted(true);
                }
            }
        }
        else
        {
            checkSort();
        }
    }

    public void reset()
    {
        super.reset();

        scanA = scanB = 0;
    }

    public String getSortName()
    {
        return "Merge Sort";
    }

    protected void translatePart()
    {
        if (lineMode)
        {
            translate(partA.getCurrentList().size(), 0);
        }
        else
        {
            translate(
                partA.getCurrentList().size() * SortBar.BLOCK_WIDTH,
                0);
        }
    }

    protected void untranslatePart()
    {
        if (lineMode)
        {
            translate(-partA.getCurrentList().size(), 0);
        }
        else
        {
            translate(
                -(partA.getCurrentList().size() * SortBar.BLOCK_WIDTH),
                0);
        }
    }

    //
    // Getters and Setters
    //
    public ArrayList<E> getSortedList()
    {
        return this.sortedList;
    }
}


/**
* MergeSortPiece.pde
*
* A part of the MergeSort class. Performs a visual representation of how Merge Sort works.
*/
public class MergeSortPiece<E extends Sortable<E>> extends MergeSort<E>
{
    public MergeSortPiece(final ArrayList<E> unsortedList)
    {
        super(unsortedList);
    }

    public void show()
    {
        // If the size of the list is smaller than 2, then show the list.
        //
        if (getCurrentList().size() <= 2)
        {
            // If work is not completed
            //
            if (!isCompleted())
            {
                if (lineMode)
                {
                    noFill();
                    stroke(255);

                    for (int i = getCurrentList().size() - 1; i >= 0; --i)
                    {
                        getCurrentList().get(i).show(15 + i);
                    }

                    if (scanA < getCurrentList().size())
                    {
                        stroke(255, 255, 0);

                        getCurrentList().get(scanA).show(15 + scanA);
                    }
                }
                else
                {
                    fill(255);
                    stroke(0);

                    for (int i = getCurrentList().size() - 1; i >= 0; --i)
                    {
                        getCurrentList().get(i).show(
                                15 + (i * SortBar.BLOCK_WIDTH));
                    }

                    if (scanA < getCurrentList().size())
                    {
                        fill(255, 255, 0);

                        getCurrentList().get(scanA).show(
                                15 + (scanA * SortBar.BLOCK_WIDTH));
                    }
                }
            }
            // If the work is completed
            //
            else
            {
                if (lineMode)
                {
                    noFill();
                    stroke(255);

                    for (int i = getCurrentList().size() - 1; i >= 0; --i)
                    {
                        getCurrentList().get(i).show(15 + i);
                    }
                }
                else
                {
                    stroke(0);
                    fill(255);

                    for (int i = getCurrentList().size() - 1; i >= 0; --i)
                    {
                        getCurrentList().get(i).show(
                                15 + (i * SortBar.BLOCK_WIDTH));
                    }
                }
            }
        }
        // If the size is the list is more than two, then show all other parts
        //
        else
        {
            super.show();
        }
    }

    /**
     * Sorts the list using Merge sort, modified for visualization purposes.
     */
    public void oneSort()
    {
        if (!isCompleted())
        {
            switch (getCurrentList().size())
            {
                case 1:
                    //
                    // If list has one item, then make it the list and make
                    // everything complete
                    //

                    getSortedList().add(getCurrentList().get(0));
                    setCurrentList(getSortedList());
                    setCompleted(true);
                    break;

                case 2:
                    //
                    // If list has two items, then sort the two
                    //

                    if (scanA < getCurrentList().size() - 1)
                    {
                        // Check for the lower number and add the lower before
                        // the higher value item
                        //
                        E itemA = getCurrentList().get(scanA);
                        E itemB = getCurrentList().get(scanA + 1);

                        if (itemA.compareTo(itemB) < 0)
                        {
                            getSortedList().add(itemA);
                            getSortedList().add(itemB);
                        }
                        else
                        {
                            getSortedList().add(itemB);
                            getSortedList().add(itemA);
                        }

                        ++scanA;
                    }
                    else
                    {
                        setCurrentList(getSortedList());
                        setCompleted(true);
                    }
                    break;

                default:
                    super.oneSort();
                    break;
            }
        }
    }

    /**
     * Modified method to make it show only necessary items and save memory.
     */
    public void showCheckSort()
    {
        if (lineMode)
        {
            noFill();
            stroke(255);

            for (int i = getCurrentList().size() - 1; i >= 0; --i)
            {
                getCurrentList().get(i).show(15 + i);
            }
        }
        else
        {
            fill(255);
            stroke(0);

            for (int i = getCurrentList().size() - 1; i >= 0; --i)
            {
                getCurrentList().get(i).show(15 + (i * SortBar.BLOCK_WIDTH));
            }
        }
    }

    /**
     * Does nothing, to save memory
     */
    public void checkSort()
    {
        // Does nothing, to save memory
    }

    public String getSortName()
    {
        return "Merge Sort Piece";
    }
}


/**
* SelectionSort.pde
*
* Performs a visual representation of how Selection Sort works.
*/
public class SelectionSort<E extends Sortable<E>> extends SortMethod<E>
{
    private int progress, flag, scan;

    public SelectionSort(ArrayList<E> unsortedList)
    {
        super(unsortedList);
    }

    /**
     * Sorts the list using Selection sort, modified for visualization purposes.
     */
    public void oneSort()
    {
        // Only works if there is anything left to sort.
        //
        if (progress < getCurrentList().size())
        {
            if (scan >= getCurrentList().size())
            {
                // Reached end of current search, so swap places
                //
                E temp = getCurrentList().get(progress);
                getCurrentList().set(progress, getCurrentList().get(flag));
                getCurrentList().set(flag, temp);

                // Reset positions
                //
                scan = ++progress;
                flag = scan;
            }
            else
            {
                // Set the flag, if needed
                //
                if (getCurrentList().get(flag).compareTo(getCurrentList().get(scan)) > 0)
                {
                    flag = scan;
                }

                ++scan;
            }
        }
        else
        {
            if (!isCompleted())
            {
                takeTime();
                setCompleted(true);
            }
            checkSort();
        }
    }

    public void show()
    {
        super.show();

        if (progress < getCurrentList().size())
        {
            if (lineMode)
            {
                showAllLines();
            }
            else
            {
                showAllBars();
            }
        }
        else
        {
            showCheckSort();
        }
    }

    public void reset()
    {
        super.reset();

        progress = flag = scan = 0;
    }

    private void showAllLines()
    {
        noFill();

        // Show lines on the sorted side
        //
        stroke(0, 255, 0);

        for (int i = progress - 1; i >= 0; --i)
        {
            getCurrentList().get(i).show(15 + i);
        }

        // Show regular lines
        //
        stroke(255);

        for (int i = getCurrentList().size() - 1; i >= progress; --i)
        {
            getCurrentList().get(i).show(15 + i);
        }

        // Show flag
        //
        stroke(255, 0, 0);
        getCurrentList().get(flag).show(15 + flag);

        // Show current scan
        //
        if (scan < getCurrentList().size())
        {
            stroke(255, 255, 0);
            getCurrentList().get(scan).show(15 + scan);
        }
    }

    private void showAllBars()
    {
        stroke(0);

        // Show bars on the sorted side
        //
        fill(0, 255, 0);

        for (int i = progress - 1; i >= 0; --i)
        {
            getCurrentList().get(i).show(15 + (i * SortBar.BLOCK_WIDTH));
        }

        // Show regular bars
        //
        fill(255);

        for (int i = getCurrentList().size() - 1; i >= progress; --i)
        {
            getCurrentList().get(i).show(15 + (i * SortBar.BLOCK_WIDTH));
        }

        // Show flag
        //
        fill(255, 0, 0);
        getCurrentList().get(flag).show(15 + (flag * SortBar.BLOCK_WIDTH));

        // Show current scan
        //
        if (scan < getCurrentList().size())
        {
            fill(255, 255, 0);
            getCurrentList().get(scan).show(
                15 + (scan * SortBar.BLOCK_WIDTH));
        }
    }

    public String getSortName()
    {
        return "Selection Sort";
    }
}


/**
* SortBar.pde
*
* A renderable bar (rectangle in disguise) that can be sorted.
*/
public class SortBar extends Sortable<SortBar>
{
    public static final int BLOCK_WIDTH = 10;

    private SortBar() { }

    public SortBar(int numberValue)
    {
        super(numberValue);
    }

    public void show(float positionX)
    {
        rect(positionX - (BLOCK_WIDTH / 2), Sortable.BOTTOM_HEIGHT, BLOCK_WIDTH, -getNumberValue());
        /*text("PositionX: " + (positionX - (BLOCK_WIDTH / 2)), 20, 20);
        text("Block width / 2: " + BLOCK_WIDTH / 2, 20, 40);
        text("NumValue: " + -getNumberValue(), 20, 60);
        text("BOTTOM_HEIGHT: " + Sortable.BOTTOM_HEIGHT, 20, 80);*/
    }
}


/**
* SortLine.pde
*
* A renderable line that can be sorted.
*/
public class SortLine extends Sortable<SortLine>
{
    private SortLine() { }

    public SortLine(int numberValue)
    {
        super(numberValue);
    }

    public void show(float positionX)
    {
        line(positionX, Sortable.BOTTOM_HEIGHT, positionX, Sortable.BOTTOM_HEIGHT - getNumberValue());
    }
}


/**
* SortMethod.pde
*
* A blueprint for classes that render a visual representation of sort methods.
*/
public abstract class SortMethod<E extends Sortable<E>>
{
    private ArrayList<E> currentList;
    private int checkProgress;
    private boolean completed, failedSort;
    private int endTime, startTime;

    protected SortMethod(ArrayList<E> unsortedList)
    {
        this.currentList = unsortedList;
        reset();
    }

    protected void showCheckSort()
    {
        int timeTaken = getEndTime() - getStartTime();

        text("Time taken to sort (ms): " + timeTaken, 20, 20);
        text("Time taken to sort (sec): " + (int)(timeTaken / 1000), 20, 35);

        if (isFailedSort())
        {
            if (lineMode)
            {
                for (int i = getCurrentList().size() - 1; i >= 0; --i)
                {
                    stroke(255, 0, 0);
                    getCurrentList().get(i).show(15 + i);
                }
            }
            else
            {
                for (int i = getCurrentList().size() - 1; i >= 0; --i)
                {
                    fill(255, 0, 0);
                    getCurrentList().get(i).show(15 + (i * SortBar.BLOCK_WIDTH));
                }
            }
        }
        else
        {
            if (lineMode)
            {
                if (checkProgress <= getCurrentList().size())
                {
                    // Current scanning
                    //
                    for (int i = 0; i < checkProgress; ++i)
                    {
                        stroke(0, 255, 0);
                        getCurrentList().get(i).show(15 + i);
                    }
                    for (int i = checkProgress, max = getCurrentList().size(); i < max; ++i)
                    {
                        stroke(255);
                        getCurrentList().get(i).show(15 + i);
                    }
                }
                else
                {
                    // Done scanning
                    //
                    for (int i = getCurrentList().size() - 1; i >= 0; --i)
                    {
                        stroke(255);
                        getCurrentList().get(i).show(15 + i);
                    }
                }
            }
            else
            {
                if (checkProgress <= getCurrentList().size())
                {
                    // Currently scanning
                    //
                    for (int i = 0; i < checkProgress; ++i)
                    {
                        fill(0, 255, 0);
                        getCurrentList().get(i).show(15 + (i * SortBar.BLOCK_WIDTH));
                    }
                    for (int i = checkProgress, max = getCurrentList().size(); i < max; ++i)
                    {
                        fill(255);
                        getCurrentList().get(i).show(15 + (i * SortBar.BLOCK_WIDTH));
                    }
                }
                else
                {
                    // Done scanning
                    //
                    for (int i = getCurrentList().size() - 1; i >= 0; --i)
                    {
                        fill(255);
                        getCurrentList().get(i).show(15 + (i * SortBar.BLOCK_WIDTH));
                    }
                }
            }
        }
    }

    /**
    * Resets the time in the sort method.
    */
    public void resetTime()
    {
        setStartTime(millis());
    }

    /**
     * Checks if the sorting method failed. If it did, then it will make note of
     * that.
     */
    protected void checkSort()
    {
        // Only work if the sort has not failed yet
        //
        if (!isFailedSort())
        {
            // Work if the scanning is done
            //
            if (checkProgress < getCurrentList().size())
            {
                // If the scanner is at its end, then add one more and finish
                // it
                //
                if (checkProgress + 1 == getCurrentList().size())
                {
                    ++checkProgress;
                    return;
                }

                // Compare two items next to each other and report results
                //
                E currentItem = getCurrentList().get(checkProgress);
                E nextItem = getCurrentList().get(checkProgress + 1);

                if (currentItem.compareTo(nextItem) <= 0)
                {
                    ++checkProgress;
                }
                else
                {
                    failedSort = true;
                }
            }
            else if (checkProgress == getCurrentList().size())
            {
                ++checkProgress;
            }
        }
    }

    protected void takeTime()
    {
        setEndTime(millis());
    }

    /**
    * Renders the current sort to the screen.
    */
    public void show()
    {
        text(getSortName(), (width / 2) - ((getSortName().length() * 6) / 2), height - 5);
    }

    public abstract void oneSort();

    /**
    * Resets the entire sort.
    */
    public void reset()
    {
        resetTime();
    }

    public abstract String getSortName();

    //
    // Getters and Setters
    //

    public boolean isCompleted()
    {
        return this.completed;
    }

    protected void setCompleted(boolean completed)
    {
        this.completed = completed;
    }

    public int getEndTime()
    {
        return this.endTime;
    }

    protected void setEndTime(int endTime)
    {
        this.endTime = endTime;
    }

    public boolean isFailedSort()
    {
        return this.failedSort;
    }

    protected void setFailedSort(boolean failedSort)
    {
        this.failedSort = failedSort;
    }

    public ArrayList<E> getCurrentList()
    {
        return this.currentList;
    }

    protected void setCurrentList(ArrayList<E> newlist)
    {
        this.currentList = newlist;
    }

    public int getStartTime()
    {
        return this.startTime;
    }

    public void setStartTime(int startTime)
    {
        this.startTime = startTime;
    }
}


/**
* Sortable.pde
*
* A blueprint for classes which can be sorted.
*/
public abstract class Sortable<E extends Sortable<E>> implements Comparable<E>
{
    public static final int BOTTOM_HEIGHT = /* SCREEN_HEIGHT - 30; */360 - 30;

    private int numberValue;

    private Sortable() { }

    protected Sortable(int numberValue)
    {
        this.numberValue = numberValue;
    }

    public abstract void show(float positionX);

    public int compareTo(E o)
    {
        return this.getNumberValue() - o.getNumberValue();
    }

    //
    // Getters / Setters
    //

    public int getNumberValue()
    {
        return this.numberValue;
    }

    protected void setNumberValue(int numberValue)
    {
        this.numberValue = numberValue;
    }
}