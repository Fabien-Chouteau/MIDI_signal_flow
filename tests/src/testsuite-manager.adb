with Testsuite.Cases;

package body Testsuite.Manager is
begin
   Print_Clock.Singleton.Set_Put_Line (Testsuite.Cases.Print_Line'Access);
   Print_Data.Singleton.Set_Put_Line (Testsuite.Cases.Print_Line'Access);
   Print_Channel.Singleton.Set_Put_Line (Testsuite.Cases.Print_Line'Access);
   Print_Cable.Singleton.Set_Put_Line (Testsuite.Cases.Print_Line'Access);
end Testsuite.Manager;
