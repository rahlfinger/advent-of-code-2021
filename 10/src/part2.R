library("stringr")

processFile = function (filepath) {
  con = file(filepath, "r")
  scores <- vector()

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
      newLine = ""
    } else if (str_detect(newLine, "\\[\\)|\\<\\)|\\{\\)")) {
      newLine = ""
    } else if (str_detect(newLine, "\\(\\]|\\<\\]|\\{\\]")) {
      newLine = ""
    } else if (str_detect(newLine, "\\[\\}|\\<\\}|\\(\\}")) {
      newLine = ""
    }

    # Reverse line
    char_to_int <- utf8ToInt(newLine)
    char_to_int

    rev_char_to_int <- rev(char_to_int)
    rev_char_to_int

    int_to_char <- intToUtf8(rev_char_to_int)
    flippedLine = int_to_char

    numberstring_split <- strsplit(flippedLine, "")[[1]]

    score = 0
    for (character in numberstring_split) {
      score = score * 5

      if (character == "(") {
        score = score + 1
      } else if (character == "[") {
        score = score + 2
      } else if (character == "{") {
        score = score + 3
      } else if (character == "<") {
        score = score + 4
      }
    }

    if (score > 0) {
      scores <-c(scores, score)
    }
  }

  sortedScores = sort(scores)
  lengthOfScores = length(sortedScores)

  answer = sortedScores[ceiling(lengthOfScores / 2)]

  print(paste("Part 2 answer: ", answer))
  close(con)
}

processFile("input.txt")
