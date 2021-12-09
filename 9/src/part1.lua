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

local file = 'input.txt'
local lines = readFile(file)

local heightmapBase = fileContentsToMatrix(lines)

-- This will keep us from dealing with Nils
local heightmapPadded = padMatrix(heightmapBase)

local rowCount = #heightmapPadded
local columnCount = #heightmapPadded[1]

local sum = 0

for i=2,rowCount-1 do
    for j=2,columnCount-1 do
        -- Try to make this more human readable
        local topCenter = heightmapPadded[i-1][j]
        local left = heightmapPadded[i][j-1]
        local currentValue = heightmapPadded[i][j]
        local right = heightmapPadded[i][j+1]
        local bottomCenter = heightmapPadded[i+1][j]

        if topCenter > currentValue then
            if left > currentValue and right > currentValue then
                if bottomCenter > currentValue then
                    sum = sum + currentValue + 1
                end
            end
        end
    end
end

print("Answer to Part 1: ", sum)
