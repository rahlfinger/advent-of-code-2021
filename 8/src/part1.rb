input = File.new("input.txt", "r")

counts = Array.new(10, 0)

input.each {
  |line|
  lineSegments = line.split(" | ")
  keySegment = lineSegments[1]
  signals = keySegment.split(" ")

  signals.each {
    |n|
    counts[n.length] = (counts[n.length] + 1)
  }
}

print "Part 1 answer: #{counts[2] + counts[3] + counts[4] + counts[7]}\n"
