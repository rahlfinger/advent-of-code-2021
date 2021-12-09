input = File.new("input.txt", "r")

displayValues = input.map {
  |line|
  simpleMapLookup = Hash.new(0)
  mapLookup = Hash.new(0)

  # Get an array of just the encoded character strings
  adjustedLine = line.dup
  adjustedLine["| "] = ""
  signals = adjustedLine.split(" ")

  # Map to the known patterns
  signals.each {
    |n|
    if (n.length == 2)
      simpleMapLookup["cf"] = n  # 1
      mapLookup[n] = 1
    elsif (n.length == 3)
      simpleMapLookup["acf"] = n # 7
      mapLookup[n] = 7
    elsif (n.length == 4)
      simpleMapLookup["bcdf"] = n # 4
      mapLookup[n] = 4
    elsif (n.length == 7)
      simpleMapLookup["abcdefg"] = n # 8
      mapLookup[n] = 8
    end
  }

  # Infer the unknowns
  signals.each {
    |n|
    if (n.length == 6)
      if !(n.include?(simpleMapLookup["cf"][0]) && n.include?(simpleMapLookup["cf"][1]))
        mapLookup[n] = 6
      elsif (n.include?(simpleMapLookup["bcdf"][0]) && n.include?(simpleMapLookup["bcdf"][1]) && n.include?(simpleMapLookup["bcdf"][2]) && n.include?(simpleMapLookup["bcdf"][3]))
        mapLookup[n] = 9
      else
        mapLookup[n] = 0
      end
    elsif (n.length == 5)
      if (n.include?(simpleMapLookup["acf"][0]) && n.include?(simpleMapLookup["acf"][1]) && n.include?(simpleMapLookup["acf"][2]))
        mapLookup[n] = 3
      elsif (((n.include?(simpleMapLookup["bcdf"][0]) && 1 || 0) + (n.include?(simpleMapLookup["bcdf"][1]) && 1 || 0) + (n.include?(simpleMapLookup["bcdf"][2]) && 1 || 0) + (n.include?(simpleMapLookup["bcdf"][3]) && 1 || 0)) == 3)
        mapLookup[n] = 5
      else
        mapLookup[n] = 2
      end
    end
  }

  # Do the mapping from the original encoded values to the displayed digits.
  lineSegments = line.split(" | ")
  displayDigits = lineSegments[1].split(" ")

  signalNumbers = displayDigits.map {
    |sig|
    mapLookup[sig]
  }

  signalNumbers.join.to_i
}

print "Part 2 answer: #{displayValues.sum()}\n"
