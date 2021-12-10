library("stringr")

processFile = function (filepath) {
  con = file(filepath, "r")
  points = 0

  while (TRUE) {
    line = readLines(con, n = 1)
    if (length(line) == 0) {
      break
    }

    newLine = line
    for (i in 1: 1000) {
      newLine = str_replace_all(newLine, "\\[\\]", "")
      newLine = str_replace_all(newLine, "\\(\\)", "")
      newLine = str_replace_all(newLine, "\\{\\}", "")
      newLine = str_replace_all(newLine, "\\<\\>", "")
    }

    if (str_detect(newLine, "\\[\\>|\\(\\>|\\{\\>")) {
      points = points + 25137
    } else if (str_detect(newLine, "\\[\\)|\\<\\)|\\{\\)")) {
      points = points + 3
    } else if (str_detect(newLine, "\\(\\]|\\<\\]|\\{\\]")) {
      points = points + 57
    } else if (str_detect(newLine, "\\[\\}|\\<\\}|\\(\\}")) {
      points = points + 1197
    }
  }

  print(paste("Part 1 answer: ", points))
  close(con)
}

processFile("input.txt")
