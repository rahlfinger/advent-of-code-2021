with Ada.Strings;           use Ada.Strings;
with Ada.Strings.Unbounded; use Ada.Strings.Unbounded;
with Ada.Strings.Fixed;     use Ada.Strings.Fixed;
with Ada.Text_IO;           use Ada.Text_IO;
with Strip;

procedure part2 is
    Filename    : constant String := "input.txt";
    UP          : constant String := "up ";
    DOWN        : constant String := "down ";
    FORWARD     : constant String := "forward ";
    File_Handle : File_Type;
    Horizontal  : Integer         := 0;
    Depth       : Integer         := 0;
    Aim         : Integer         := 0;
    Line        : Unbounded_String;
begin
    Open (File_Handle, In_File, Filename);
    while not End_Of_File (File_Handle) loop
        Line := To_Unbounded_String (Get_Line (File_Handle));
        if Index (To_String (Line), UP) > 0 then
            Aim := Aim - Integer'Value (Strip (To_String (Line), UP));
        elsif Index (To_String (Line), DOWN) > 0 then
            Aim := Aim + Integer'Value (Strip (To_String (Line), DOWN));
        elsif Index (To_String (Line), FORWARD) > 0 then
            Horizontal :=
               Horizontal + Integer'Value (Strip (To_String (Line), FORWARD));
            Depth :=
               Depth + Aim * Integer'Value (Strip (To_String (Line), FORWARD));
        end if;
    end loop;

    Close (File_Handle);

    Put_Line ("Part 2 Results:");
    Put_Line ("    Depth: " & Integer'Image (Depth));
    Put_Line ("    Horizontal: " & Integer'Image (Horizontal));
    Put_Line ("    Aim: " & Integer'Image (Aim));
    Put_Line ("    Result: " & Integer'Image (Horizontal * Depth));

end part2;
