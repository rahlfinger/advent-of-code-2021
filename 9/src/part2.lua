local function readFile(file)
    local lines = {}
    for line in io.lines(file) do
      lines[#lines + 1] = line
    end
    return lines
end

local function fileContentsToMatrix(lines)
    local heightmap = {}

    for rowIndex, row in pairs(lines) do
        heightmap[rowIndex] = {}

        local column = 1

        for i in string.gmatch(row, "%S") do
            heightmap[rowIndex][column] = tonumber(i)
            column = column + 1
        end
    end

    return heightmap
end

local function padMatrix(heightmapBase)
    local rowCount = #heightmapBase
    local columnCount = #heightmapBase[1]
    local heightmap = {}

    -- Create padded out base
    for i=1,rowCount+2 do
        heightmap[i] = {}

        for j=1,columnCount+2 do
           heightmap[i][j] = 9
        end
    end

    -- Drop the heightmap onto of the padded base matrix
    for i=2,rowCount+1 do
        for j=2,columnCount+1 do
            heightmap[i][j] = heightmapBase[i-1][j-1]
        end
    end

    return heightmap
end

local function isNewBasinPoint(heightmap, row, col, basinPositions)
    if heightmap[row][col] < 9 then
        -- It is the right value, see if it is already in the list
        for i=1,#basinPositions do
            if basinPositions[i][1] == row and basinPositions[i][2] == col then
                return false
            end
        end

        -- Not in list so we are good to add it
        return true
    end

    return false
end

local function discoverBasin(heightmap, lowRow, lowColumn)
    local basinSum = 0
    local newBasinsFound = 1

    local basinPositions = {}
    basinPositions[1] = {lowRow, lowColumn, heightmap[lowRow][lowColumn]}

    local timeout = 0 -- So it can't run forever

    -- For each current basin location, see if the basin extends beyond that point
    while newBasinsFound > 0 and timeout < 1000 do
        local initialBasinLocationCount = #basinPositions

        for i=1,initialBasinLocationCount do
            local row = basinPositions[i][1]
            local col = basinPositions[i][2]
            local val = basinPositions[i][3]

            -- Blindly add these in and then we will remove duplicates as another step
            if isNewBasinPoint(heightmap, row-1, col, basinPositions) then  basinPositions[#basinPositions+1] = {row-1, col, heightmap[row-1][col]} end
            if isNewBasinPoint(heightmap, row+1, col, basinPositions) then  basinPositions[#basinPositions+1] = {row+1, col, heightmap[row+1][col]} end
            if isNewBasinPoint(heightmap, row, col-1, basinPositions) then  basinPositions[#basinPositions+1] = {row, col-1, heightmap[row][col-1]} end
            if isNewBasinPoint(heightmap, row, col+1, basinPositions) then  basinPositions[#basinPositions+1] = {row, col+1, heightmap[row][col+1]} end
        end

        if initialBasinLocationCount == #basinPositions then newBasinsFound = 0 end
    end

    -- Count all basin values
    for i=1,#basinPositions do
        basinSum = basinSum + basinPositions[i][3]
    end

    return #basinPositions
end

local file = 'input.txt'
local lines = readFile(file)

local heightmapBase = fileContentsToMatrix(lines)

-- This will keep us from dealing with Nils
local heightmapPadded = padMatrix(heightmapBase)

local rowCount = #heightmapPadded
local columnCount = #heightmapPadded[1]

local basinValues = {}

for i=2,rowCount-1 do
    for j=2,columnCount-1 do
        -- Try to make this more human readable
        local topCenter = heightmapPadded[i-1][j]
        local left = heightmapPadded[i][j-1]
        local currentValue = heightmapPadded[i][j]
        local right = heightmapPadded[i][j+1]
        local bottomCenter = heightmapPadded[i+1][j]

        -- Breaking the if statement into rows so it doesn't get too crowded
        if topCenter > currentValue then
            if left > currentValue and right > currentValue then
                if bottomCenter > currentValue then
                    -- We have a low point, let's discover the basin size.
                    basinValues[#basinValues+1] = discoverBasin(heightmapPadded, i, j)
                end
            end
        end
    end
end

table.sort(basinValues, function(a, b) return a > b end)

print("Answer to Part 2: ", basinValues[1] * basinValues[2] * basinValues[3])
