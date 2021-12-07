using DelimitedFiles
using Statistics
using Formatting

function createLookup(n)

    growth = zeros(n);

    previous = 0
    for i in 1:n
        growth[i] = previous + i
        previous = growth[i]
    end

    return transpose(growth)
end

function mapDistanceLookup(distances, lookups)
    results = zeros(length(distances) + 1);

    for i in 1:length(distances)
        index = trunc(Int, distances[i])
        results[i] = index == 0 ? 0 : lookups[index]
    end

    return results
end

input = readdlm("input.txt", ',', Int, '\n');

# Create the growth lookup sequence.
distanceLookup = createLookup(maximum(input))

meanVal = floor(mean(input))
distances = input .- meanVal

absDistances = broadcast(abs, distances)

adjustedDistances = mapDistanceLookup(absDistances, distanceLookup)

floorValue = sum(adjustedDistances)

# Recomupte for upper bound of mean
distances = input .- (meanVal + 1)

absDistances = broadcast(abs, distances)

adjustedDistances = mapDistanceLookup(absDistances, distanceLookup)
ceilValue = sum(adjustedDistances)

printfmt("Part 2 answer: {:d}\n", floorValue < ceilValue ? floorValue : ceilValue)
