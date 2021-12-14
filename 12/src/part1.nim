import strutils, sequtils, sugar, std/strformat

proc findPaths(caveMap: seq[string], pathMap: seq[string]): seq[string] =

    var paths: seq[string]
    let startingPoint = pathMap[^1]

    if startingPoint == "end":
        return @[join(pathMap, ",")]

    # Find all options that have our starting point
    var nextStepOptions = filter(caveMap, str => contains(str, startingPoint&'-'))
    nextStepOptions = concat(nextStepOptions, filter(caveMap, str => contains(str, '-'&startingPoint)))

    # remove any options that have a start in them
    var nextStepOptionsNoStarts: seq[string] 
    for option in nextStepOptions:
        if "start" notin option:
            var optionSeq = @[option]
            nextStepOptionsNoStarts = concat(nextStepOptionsNoStarts, optionSeq) 

    # remove any (lower case) options that have already been visited.
    var cleanedOptions: seq[string] 
    for option in nextStepOptionsNoStarts:
        let points = option.split("-") 
        let nextStep = if points[0] == startingPoint: points[1] else: points[0]

        if isUpperAscii(nextStep[0]) == true:
            cleanedOptions.add(option)
        else:
            let isAlreadyTraveled = filter(pathMap, str => str == nextStep)
            if isAlreadyTraveled.len == 0: # we have not visited this point before so add it
                cleanedOptions.add(option)

    for option in cleanedOptions:
        let points = option.split("-") 
        let nextStep = if points[0] == startingPoint: points[1] else: points[0]
        let nextSteps = concat(pathMap, @[nextStep])
        paths = concat(paths, findPaths(caveMap, nextSteps))

    return paths

# read in the file
let input = readFile("input.txt") 
let caveMap = input.splitLines()

# start processing the data
let startingPoints = filter(caveMap, x => contains(x, "start"))

var totalPoints: seq[string]

for connection in startingPoints:
    var pathMap: seq[string]
    let points = connection.split("-")

    pathMap.add("start")
    if points[0] != "start": 
        pathMap.add(points[0])
    else:
        pathMap.add(points[1])

    totalPoints = concat(totalPoints, findPaths(caveMap, pathMap))

echo (fmt"Part 1 answer: {totalPoints.len}")
