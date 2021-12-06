#include <stdio.h>

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
    for (int i = line.startX; i <= line.endX; i++)
    {
        for (int j = line.startY; j <= line.endY; j++)
        {
            playArea[i][j]++;
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
        if (line.startX > line.endX || line.startY > line.endY)
        {
            int tempX = line.endX;
            int tempY = line.endY;

            line.endX = line.startX;
            line.endY = line.startY;

            line.startX = tempX;
            line.startY = tempY;
        }

        if (line.startX == line.endX || line.startY == line.endY)
        {
            addLineToPlayArea(playArea, line);
        }
    }

    int answer = countPlayAreaIntersections(playArea);
    printf("Part 1 answer: %i\n", answer);

    fclose(fp);
}
