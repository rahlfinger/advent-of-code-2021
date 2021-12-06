#include <stdio.h>
#include <stdlib.h>

const int MAX = 1000;

struct VentLines
{
    int startX;
    int startY;
    int endX;
    int endY;
};

void initializePlayArea(int (*playArea)[MAX])
{
    for (int i = 0; i < MAX; i++)
    {
        for (int j = 0; j < MAX; j++)
        {
            playArea[i][j] = 0;
        }
    }
}

void addLineToPlayArea(int (*playArea)[MAX], struct VentLines line)
{
    if (line.startX == line.endX)
    { // Horizontal line case.

        // Always want to go in increasing order so swap as needed;
        if (line.endY < line.startY)
        {
            int tempY = line.startY;
            line.startY = line.endY;
            line.endY = tempY;
        }

        for (int y = line.startY; y <= line.endY; y++)
        {
            playArea[line.startX][y]++;
        }
    }
    else if (line.startY == line.endY)
    { // Vertical line case.

        // Always want to go in increasing order so swap as needed;
        if (line.endX < line.startX)
        {
            int tempX = line.startX;
            line.startX = line.endX;
            line.endX = tempX;
        }

        for (int x = line.startX; x <= line.endX; x++)
        {
            playArea[x][line.startY]++;
        }
    }
    else
    { // Diagonal case
        int rise = line.endY - line.startY;
        int run = line.endX - line.startX;
        int slope = rise / run;

        int y = line.startY;
        for (int x = line.startX; x <= line.endX; x++)
        {
            playArea[x][y]++;
            y += slope;
        }
    }
}

int countPlayAreaIntersections(int (*playArea)[MAX])
{
    int count = 0;

    for (int i = 0; i < MAX; i++)
    {
        for (int j = 0; j < MAX; j++)
        {
            if (playArea[i][j] > 1)
            {
                count++;
            }
        }
    }

    return count;
}

int main()
{
    FILE *fp;
    int playArea[MAX][MAX];

    struct VentLines line;

    initializePlayArea(playArea);

    fp = fopen("input.txt", "r");

    while (fscanf(fp, "%i,%i -> %i,%i\n", &line.startX, &line.startY, &line.endX, &line.endY) != EOF)
    {
        // Ensure we are going from origin out.
        if (line.startX > line.endX)
        {
            int tempX = line.endX;
            int tempY = line.endY;

            line.endX = line.startX;
            line.endY = line.startY;

            line.startX = tempX;
            line.startY = tempY;
        }

        addLineToPlayArea(playArea, line);
    }

    int answer = countPlayAreaIntersections(playArea);
    printf("Part 2 answer: %i\n", answer);

    fclose(fp);
}
