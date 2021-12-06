<?php
$myfile = fopen("input.txt", "r") or die("Unable to open file!");
$line = fread($myfile, filesize("input.txt"));
fclose($myfile);

$days = 256;
$populationCount = 0;

// Load the population into an array by aggregating timers.
// This will prevent expoential memory usage.
for ($x = 0; $x < 9; $x++) {
    $population[$x] = substr_count($line, $x);
}

for ($day = 1; $day <= $days; $day++) {
    $populationCount = 0;

    // Save the values from the previous day as we are going to 
    // write into population[]
    for ($x = 0; $x < 9; $x++) {
        $prevDayPopulation[$x] = $population[$x];
    }

    // Shift the population to show a decrease by a day.
    for ($x = 0; $x < (9 - 1); $x++) {
        $population[$x] = $prevDayPopulation[$x + 1];
    }
    $population[6] = $population[6] + $prevDayPopulation[0];
    $population[8] = $prevDayPopulation[0];

    // Get total population count.
    for ($x = 0; $x < 9; $x++) {
        $populationCount += $population[$x];
    }
}

echo "Part 2 population count: ", $populationCount, "\n";
