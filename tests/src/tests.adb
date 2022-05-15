with Testsuite.Cases;

with Ada.Command_Line;

procedure Tests is
begin
   if Ada.Command_Line.Argument_Count = 1
     and then
       Ada.Command_Line.Argument (1) = "print"
   then
      Testsuite.Cases.Print_LG_Definitions;
   else
      Testsuite.Cases.Run_Cases (Testsuite.Cases.Find_Cases);
   end if;
end Tests;
