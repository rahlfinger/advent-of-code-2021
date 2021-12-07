using DelimitedFiles
using Statistics

input = readdlm("input.txt", ',', Int, '\n');

medianVal = median(input)

distances = input .- medianVal
absDistances = broadcast(abs, distances)

println("Part 1 answer: $(trunc(Int, sum(absDistances)))")
