function part1()

  %// get the number of lines to read
  fid = fopen ("input.txt");
    numOfLines = fskipl(fid, Inf) + 1;
  fclose (fid);

  paper = zeros(1, 1);
  foldDirections = [""];
  foldPoints = [0];
  foldIndex = 1;

  %// read the file
  fid = fopen ("input.txt");
    for i=1:numOfLines,
      line = fgetl(fid);

      if (length(line) > 0) 
        if (regexp(line, "fold along y") > 0)
          [text, foldPointStr] = strsplit (line, "="){1,:};
          foldDirections(foldIndex) = "H";
          foldPoints(foldIndex) = str2num(foldPointStr);
          foldIndex++;
        elseif (regexp(line, "fold along x") > 0)
          [text, foldPointStr] = strsplit (line, "="){1,:};
          foldDirections(foldIndex) = "V";
          foldPoints(foldIndex) = str2num(foldPointStr);
          foldIndex++;
        else %// get coordinates
          [col, row] = strsplit (line, ","){1,:};
          paper(str2num(row)+1, str2num(col)+1) = 1;
        endif
      endif
    endfor

  fclose (fid);

  for i=1:1,
    %// Initialize the folded results
    paperRows = rows(paper);
    paperColumns = columns(paper);

    if (foldDirections(i) == "H")
      flippedPaper = flipud(paper);
      foldPoint = foldPoints(i);
      folded = zeros(foldPoint, paperColumns);

      for row=1:foldPoint,
        for col=1:paperColumns,
          folded(row, col) = paper(row, col) || flippedPaper(row, col);
        endfor
      endfor
    else
      flippedPaper = fliplr(paper);
      foldPoint = foldPoints(i);
      folded = zeros(paperRows, foldPoint);
      
      for row=1:paperRows,
        for col=1:foldPoint,
          folded(row, col) = paper(row, col) || flippedPaper(row, col);
        endfor
      endfor
    endif

    paper = folded;
  endfor

  disp ("Part 1 answer: ")
  sum(sum(paper))

endfunction
