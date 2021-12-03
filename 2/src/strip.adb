function Strip (InputString : String; Substring : String) return String is
    Keep   : array (Character) of Boolean := (others => True);
    Result : String (InputString'Range);
    Last   : Natural                      := Result'First - 1;
begin
    for Character in Substring'Range loop
        Keep (Substring (Character)) := False;
    end loop;
    for Character in InputString'Range loop
        if Keep (InputString (Character)) then
            Last          := Last + 1;
            Result (Last) := InputString (Character);
        end if;
    end loop;

    return Result (Result'First .. Last);
end Strip;
