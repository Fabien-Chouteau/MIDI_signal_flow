with Testsuite.Cases;

package body Testsuite.Manager is
begin
   Output.Print_Clock.Set_Put_Line (Testsuite.Cases.Print_Line'Access);
   Output.Print_Data.Set_Put_Line (Testsuite.Cases.Print_Line'Access);
   Output.Print_Channel.Set_Put_Line (Testsuite.Cases.Print_Line'Access);
   Output.Print_Cable.Set_Put_Line (Testsuite.Cases.Print_Line'Access);
end Testsuite.Manager;
