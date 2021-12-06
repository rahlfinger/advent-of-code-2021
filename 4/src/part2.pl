#!/usr/bin/perl
use strict;
use warnings;

use Path::Tiny;
use autodie; # die if problem reading or writing a file

my $dir = path("/usr/src/myapp");

my $file = $dir->child("input.txt");

# Read in the entire contents of a file
my $content = $file->slurp_utf8();

# openr_utf8() returns an IO::File object to read from
# with a UTF-8 decoding layer
my $file_handle = $file->openr_utf8();

my $hasDrawnValues = 0;
my @drawnValues = ();
my $currentBoardRowsRead = 0;
my @currentBingoBoard;
my @newRow = ();
my $winnerScore = 0;
my $winnerTurn = 0;

# Read in line at a time
while( my $lineBase= $file_handle->getline() ) {
        my $line = trim($lineBase);
        my $lineLength = length($line);

        if ($lineLength < 2) {  # Skip blank lines
        } elsif ($hasDrawnValues == 0) { # Get the drawn values
                @drawnValues = split(',', $line);
                my $numberOfDrawnValues = scalar(@drawnValues);
                print "Number of draws: $numberOfDrawnValues\n";
                $hasDrawnValues = 1;
        } else {
                # Add the input into the Bingo board
                @newRow = split (/\s+/, $line);
                my $index = 0;
                foreach $a (@newRow) {
                    $currentBingoBoard[$currentBoardRowsRead][$index] = $a;
                    $index++;
                }

                # Need to get 5 lines to make up the bingo board
                if ($currentBoardRowsRead == 4 ) {
                        # We have a bingo board, process it.
                        my @scores;
                        @scores = processBoard(\@currentBingoBoard, \@drawnValues);
                        my ($turn, $score, $lastDraw) = (@scores);

                        if ( $turn >= $winnerTurn) {
                                $winnerScore = $score * $lastDraw;
                                $winnerTurn = $turn;
                                print "New Leader! turn: $turn Base score: $score last draw: $lastDraw\n";
                                printBoard(@currentBingoBoard);

                        }

                        # Reset it
                        $currentBoardRowsRead = 0;
                } else {
                        $currentBoardRowsRead++;
                }
        }
}

print "Winner score: $winnerScore on turn $winnerTurn\n";

sub processBoard {
        my ($matrixRef, $drawsRef) = (@_);
        my @matrix = @{$matrixRef};
        my @matrixOrig = map { [@$_] } @matrix;
        my @draws = @{$drawsRef};
        my $rows = scalar(@matrix);
        my $columns = scalar(@{ $matrix[0] });
        my $draw;
        my $drawCount = 1;

        foreach $draw (@draws) {
                # Zero out if there is a match.
                for(my $i = 0; $i < $rows; $i++){
                        for(my $j = 0; $j < $columns; $j++){
                                if ($matrix[$i][$j] == $draw) {
                                        $matrix[$i][$j] = 0;
                                        
                                        my $isWin = isWinner(@matrix);

                                        if ($isWin == 1) {
                                                my $score = getScore(@matrix);

                                                return ($drawCount, $score, $draw)
                                        }
                                        
                                }
                        }
                }

                $drawCount++;
        }

        return ($drawCount, 0);
}

sub getScore {
        my @matrix =@_;
        my $rows = scalar(@matrix);
        my $columns = scalar(@{ $matrix[0] });
        my $sum = 0;

        for(my $i = 0; $i < $rows; $i++){
                for(my $j = 0; $j < $columns; $j++){
                        $sum = $sum + $matrix[$i][$j];
                }
        }

        return $sum;
}

sub isWinner {
        my @matrix = @_;
        my $rows = scalar(@matrix);
        my $columns = scalar(@{ $matrix[0] });
        my $sum = 0;

        # Check row win.
        for(my $i = 0; $i < $rows; $i++){
                for(my $j = 0; $j < $columns; $j++){
                        $sum = $sum + $matrix[$i][$j];
                }

                if ($sum == 0) {
                        return 1;
                }

                $sum = 0;
        }

        # Check column win.
        for(my $i = 0; $i < $rows; $i++){
                for(my $j = 0; $j < $columns; $j++){
                        $sum = $sum + $matrix[$j][$i];
                }

                if ($sum == 0) {
                        return 1;
                }

                $sum = 0;
        }

        return 0;

}

sub printBoard {
        my @matrix =@_;
        my $rows = scalar(@matrix);
        my $columns = scalar(@{ $matrix[0] });

        for(my $i = 0; $i < $rows; $i++){
                for(my $j = 0; $j < $columns; $j++){
                        if ($matrix[$i][$j] < 10) {
                            print " $matrix[$i][$j] ";

                        } else {
                            print "$matrix[$i][$j] ";
                        }
                }
                print "\n";
        }
        print "\n";

}

sub  trim {
        my $s = shift;
        $s =~ s/^\s+|\s+$//g;
        
        return $s
};
