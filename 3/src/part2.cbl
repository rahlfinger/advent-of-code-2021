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
         01 WS-TopLevelIterator PIC 9(2) VALUE 0.
         01 WS-IteratorMAX PIC 9(2) VALUE 13.
         01 WS-Bits PIC 9(2) VALUE 12.
      
         01  WS-Totals. 
           02  WS-BitSum PIC S9999 OCCURS 12 TIMES VALUE ZEROS. 
           02  WS-BitDecisionSum PIC S9999 OCCURS 12 TIMES VALUE ZEROS. 
           02  WS-Answer PIC 9(10) VALUE ZERO.
           02  WS-Oxygen PIC 9(10) VALUE ZERO.
           02  WS-CO2 PIC 9(10) VALUE ZERO.
           02  WS-Counter PIC 9(10) VALUE ZERO.
           02  WS-ExponentResult PIC 9(10) VALUE ZERO.
           02  WS-BitLocked PIC 9(1) OCCURS 12 TIMES VALUE ZEROS. 
           02  WS-BitValues PIC 9(1) OCCURS 12 TIMES VALUE ZEROS. 
           02  WS-Latest PIC 9(1) OCCURS 12 TIMES VALUE ZEROS. 
           02  WS-IsAMatch PIC S99 VALUE 1. 
           02  WS-LineMatches PIC 9(13) VALUE 0. 
      
      PROCEDURE DIVISION.

         PERFORM MainOxygenProcedure VARYING WS-TopLevelIterator FROM 1 BY 1 UNTIL WS-TopLevelIterator=WS-IteratorMAX.

         PERFORM CalculateOxygenDecimal VARYING WS-TopLevelIterator FROM 1 BY 1 UNTIL WS-TopLevelIterator=WS-IteratorMAX.
         DISPLAY 'Oxygen: ' WS-Oxygen.

         PERFORM Clean VARYING WS-TopLevelIterator FROM 1 BY 1 UNTIL WS-TopLevelIterator=WS-IteratorMAX.
         PERFORM MainCO2Procedure VARYING WS-TopLevelIterator FROM 1 BY 1 UNTIL WS-TopLevelIterator=WS-IteratorMAX.

         PERFORM CalculateCO2Decimal VARYING WS-TopLevelIterator FROM 1 BY 1 UNTIL WS-TopLevelIterator=WS-IteratorMAX.
         DISPLAY 'CO2: ' WS-CO2.

         COMPUTE WS-Answer = WS-Oxygen * WS-CO2.
         DISPLAY 'Part 2 Answer: ' WS-Answer.
      STOP RUN.

      Clean.
         SET WS-Latest (WS-TopLevelIterator) TO 0
         SET WS-BitLocked (WS-TopLevelIterator) TO 0
         SET WS-BitValues (WS-TopLevelIterator) TO 0
         SET WS-IsAMatch TO 1
      .

      IsAMatch.
         IF WS-IsAMatch IS POSITIVE THEN
           IF WS-BitLocked (WS-Iterator) IS POSITIVE THEN
             IF WS-BitValues (WS-Iterator) IS NOT = WS-Binary (WS-Iterator) THEN
               SET WS-IsAMatch TO -1
             END-IF
           END-IF
         END-IF
      .

      ProcessInputFile.
         OPEN INPUT Diagnostics.
            PERFORM UNTIL WS-Eof='Y'
               READ Diagnostics INTO WS-Diagnostics
                  AT END
                    MOVE 'Y' TO WS-Eof
                  NOT AT END
                    SET WS-IsAMatch TO 1
                    PERFORM IsAMatch VARYING WS-Iterator FROM 1 BY 1 UNTIL WS-Iterator=WS-IteratorMAX

                    IF WS-IsAMatch IS POSITIVE THEN
                      ADD 1 TO WS-LineMatches
                      PERFORM SaveLatest VARYING WS-Iterator FROM 1 BY 1 UNTIL WS-Iterator=WS-IteratorMAX
                      PERFORM BitAggregate VARYING WS-Iterator FROM 1 BY 1 UNTIL WS-Iterator=WS-IteratorMAX
                    END-IF
               END-READ
            END-PERFORM.
         CLOSE Diagnostics
      . 

      BitOxygenDecisions.
        IF WS-BitSum (WS-Iterator) IS POSITIVE THEN
          SET WS-BitDecisionSum (WS-Iterator) TO 1
        ELSE IF WS-BitSum (WS-Iterator) IS NEGATIVE THEN
          SET WS-BitDecisionSum (WS-Iterator) TO 0
        ELSE IF WS-BitSum (WS-Iterator) IS ZERO THEN
          SET WS-BitDecisionSum (WS-Iterator) TO 1
        END-IF
      .

      BitCO2Decisions.
        IF WS-BitSum (WS-Iterator) IS POSITIVE THEN
          SET WS-BitDecisionSum (WS-Iterator) TO 0
        ELSE IF WS-BitSum (WS-Iterator) IS NEGATIVE THEN
          SET WS-BitDecisionSum (WS-Iterator) TO 1
        ELSE IF WS-BitSum (WS-Iterator) IS ZERO THEN
          SET WS-BitDecisionSum (WS-Iterator) TO 0
        END-IF
      .
      
      BitAggregate.
        IF WS-Binary (WS-Iterator) IS POSITIVE THEN
          ADD 1 TO WS-BitSum (WS-Iterator)
        ELSE IF WS-Binary (WS-Iterator) IS ZERO THEN
          SUBTRACT 1 FROM WS-BitSum (WS-Iterator)
        END-IF
      .
      
      CalculateOxygenDecimal.
        COMPUTE WS-ExponentResult = WS-BitValues(WS-TopLevelIterator) * (2 ** (WS-Bits - WS-TopLevelIterator)).
        ADD WS-ExponentResult TO WS-Oxygen
      .
      
      CalculateCO2Decimal.
        COMPUTE WS-ExponentResult = WS-BitValues(WS-TopLevelIterator) * (2 ** (WS-Bits - WS-TopLevelIterator)).
        ADD WS-ExponentResult TO WS-CO2
      .

      MainOxygenProcedure.
         MOVE 'N' TO WS-Eof
         PERFORM CleanFileData VARYING WS-Iterator FROM 1 BY 1 UNTIL WS-Iterator=WS-IteratorMAX.
         PERFORM ProcessInputFile.
         
         PERFORM BitOxygenDecisions VARYING WS-Iterator FROM 1 BY 1 UNTIL WS-Iterator=WS-IteratorMAX.

         IF WS-LineMatches = 1 THEN
           *>    Found the last item so let's lock it all down
           PERFORM LockDown VARYING WS-Iterator FROM 1 BY 1 UNTIL WS-Iterator=WS-IteratorMAX
         ELSE
           SET WS-BitValues (WS-TopLevelIterator) TO WS-BitDecisionSum (WS-TopLevelIterator)
           SET WS-BitLocked (WS-TopLevelIterator) TO 1
         END-IF
      .

      MainCO2Procedure.
         MOVE 'N' TO WS-Eof
         PERFORM CleanFileData VARYING WS-Iterator FROM 1 BY 1 UNTIL WS-Iterator=WS-IteratorMAX.
         PERFORM ProcessInputFile.

         PERFORM BitCO2Decisions VARYING WS-Iterator FROM 1 BY 1 UNTIL WS-Iterator=WS-IteratorMAX.

         IF WS-LineMatches = 1 THEN
           *>    Found the last item so let's lock it all down
           PERFORM LockDown VARYING WS-Iterator FROM 1 BY 1 UNTIL WS-Iterator=WS-IteratorMAX
         ELSE
           SET WS-BitValues (WS-TopLevelIterator) TO WS-BitDecisionSum (WS-TopLevelIterator)
           SET WS-BitLocked (WS-TopLevelIterator) TO 1
         END-IF
      .
      
      LockDown.
         SET WS-BitValues (WS-Iterator) TO WS-Latest (WS-Iterator)
         SET WS-BitLocked (WS-Iterator) TO 1
      .

      CleanFileData.
         SET WS-LineMatches TO 0
         SET WS-BitSum (WS-Iterator) TO 0
      .

      SaveLatest.
         SET WS-Latest(WS-Iterator) TO WS-Binary (WS-Iterator)
      .
