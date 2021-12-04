      IDENTIFICATION DIVISION.
      PROGRAM-ID. PART-ONE.
      
      ENVIRONMENT DIVISION.
         INPUT-OUTPUT SECTION.
            FILE-CONTROL.
            SELECT Diagnostics ASSIGN TO 'input.txt'
            ORGANIZATION IS LINE SEQUENTIAL.
      
      DATA DIVISION.
         FILE SECTION.
         FD Diagnostics.
         01 DiagnosticsFile.
            02 Name PIC A(12).
      
         WORKING-STORAGE SECTION.
         01 WS-Diagnostics.
            02 WS-Binary PIC 9(1) OCCURS 12 TIMES.
         01 WS-Eof PIC A(1).
         01 WS-Iterator PIC 9(2) VALUE 0.
      
         01  WS-Totals. 
           02  WS-BitSum PIC S9999 OCCURS 12 TIMES VALUE ZEROS. 
           02  WS-BitGammaSum PIC S9999 OCCURS 12 TIMES VALUE ZEROS. 
           02  WS-BitEpsilonSum PIC S9999 OCCURS 12 TIMES VALUE ZEROS. 
           02  WS-Answer PIC 9(10) VALUE ZERO.
           02  WS-EpsilonRate PIC 9(10) VALUE ZERO.
           02  WS-GammaRate PIC 9(10) VALUE ZERO.
           02  WS-ExponentResult PIC 9(10) VALUE ZERO.
      
      PROCEDURE DIVISION.
         PERFORM ProcessInputFile.
         
         PERFORM BitDecisions VARYING WS-Iterator FROM 1 BY 1 UNTIL WS-Iterator=13.

         PERFORM CalculateDecimalGamma VARYING WS-Iterator FROM 1 BY 1 UNTIL WS-Iterator=13.
         DISPLAY 'Gamma Rate: ' WS-GammaRate.

         PERFORM CalculateDecimalEpsilon VARYING WS-Iterator FROM 1 BY 1 UNTIL WS-Iterator=13.
         DISPLAY 'Epsilon Rate: ' WS-EpsilonRate.

         COMPUTE WS-Answer = WS-EpsilonRate * WS-GammaRate.
         DISPLAY 'Part 1 Answer: ' WS-Answer.
      STOP RUN.

      ProcessInputFile.
         OPEN INPUT Diagnostics.
            PERFORM UNTIL WS-Eof='Y'
               READ Diagnostics INTO WS-Diagnostics
                  AT END
                    MOVE 'Y' TO WS-Eof
                  NOT AT END 
                    PERFORM BitAggregate VARYING WS-Iterator FROM 1 BY 1 UNTIL WS-Iterator=13
               END-READ
            END-PERFORM.
         CLOSE Diagnostics
      .
      
      BitDecisions.
        IF WS-BitSum (WS-Iterator) IS POSITIVE THEN
          SET WS-BitEpsilonSum (WS-Iterator) TO 0
          SET WS-BitGammaSum (WS-Iterator) TO 1
        ELSE IF WS-BitSum (WS-Iterator) IS NEGATIVE THEN
          SET WS-BitEpsilonSum (WS-Iterator) TO 1
          SET WS-BitGammaSum (WS-Iterator) TO 0
        END-IF
      .
      
      BitAggregate.
        IF WS-Binary (WS-Iterator) IS POSITIVE THEN
          ADD 1 TO WS-BitSum (WS-Iterator)
        ELSE IF WS-Binary (WS-Iterator) IS ZERO THEN
          SUBTRACT 1 FROM WS-BitSum (WS-Iterator)
        END-IF
      .
      
      CalculateDecimalGamma.
        COMPUTE WS-ExponentResult = WS-BitGammaSum(WS-Iterator) * (2 ** (12 - WS-Iterator)).
        ADD WS-ExponentResult TO WS-GammaRate
      .
      
      CalculateDecimalEpsilon.
        COMPUTE WS-ExponentResult = WS-BitEpsilonSum(WS-Iterator) * (2 ** (12 - WS-Iterator)).
        ADD WS-ExponentResult TO WS-EpsilonRate
      .
