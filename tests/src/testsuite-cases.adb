with Ada.Exceptions;
with Ada.Directories;
with Ada.Text_IO;

with GNAT.OS_Lib;

with MIDI;
with MIDI_Signal_Flow;

with Testsuite.Manager;

with CLIC.TTY;

package body Testsuite.Cases is

   package Manager renames Testsuite.Manager;

   type Required_Files is (Config, Expected, Input);

   function Filename (F : Required_Files) return String
   is (case F is
          when Config   => "config.txt",
          when Expected => "expected.txt",
          when Input    => "input.txt");

   ----------------
   -- Find_Cases --
   ----------------

   function Find_Cases return Test_Cases_List.List is
      use Ada.Directories;

      Result : Test_Cases_List.List;

      procedure Rec_Find (Path : String) is
         Found : array (Required_Files) of Boolean := (others => False);

         procedure Print (Item : Directory_Entry_Type) is
         begin
            for F in Required_Files loop
               if Simple_Name (Item) = Filename (F) then
                  Found (F) := True;
               end if;
            end loop;
         end Print;

         procedure Walk (Item : Directory_Entry_Type) is
         begin
            if Simple_Name (Item) /= "." and then Simple_Name (Item) /= ".."
            then
               Rec_Find (Path & "/" & Simple_Name (Item));
            end if;
         exception
            when Name_Error => null;
         end Walk;
      begin
         Search (Path, "*", (others => True), Print'Access);
         Search (Path, "", (Directory => True, others => False),
                 Walk'Access);

         if (for all F of Found => F) then
            --  We got all required files for a test case
            Result.Append (Path);

         elsif (for some F of Found => F) then
            --  At least one missing file
            for F in Required_Files loop
               if not Found (F) then
                  Ada.Text_IO.Put_Line
                    (CLIC.TTY.Warn ("warning: missing '" & Filename (F) &
                       "' in '" & Path &
                       "' for a complete test case."));
               end if;
            end loop;
         end if;
      end Rec_Find;
   begin
      Rec_Find ("test_cases");
      return Result;
   end Find_Cases;

   ------------------
   -- Load_Content --
   ------------------

   function Load_Content (Dir : String; F : Required_Files)
                          return AAA.Strings.Vector
   is
      use Ada.Text_IO;
      Result : AAA.Strings.Vector;
      File : File_Type;
   begin
      Open (File, In_File, Dir & "/" & Filename (F));
      while not End_Of_File (File) loop
         Result.Append (Get_Line (File));
      end loop;
      Close (File);
      return Result;
   end Load_Content;

   --------------
   -- Run_Case --
   --------------

   function Run_Case (Dirname : String) return AAA.Strings.Vector is
      use AAA.Strings;

      Config   : constant Vector := Load_Content (Dirname, Cases.Config);
      Input    : constant Vector := Load_Content (Dirname, Cases.Input);
      Expected : constant Vector := Load_Content (Dirname, Cases.Expected);

      Result : Manager.Manager.Load_Result;
      use type Manager.Manager.Load_Result;

      Line_Nbr : Positive := 1;
   begin
      MIDI_Signal_Flow.Set_Put_Line (Print_Line'Access);
      Reset_Prints;
      Manager.Manager.Reset;

      --  Manager.Bounded_Manager.Print_LG_Definitions;
      --  Ada.Text_IO.Put_Line (Config.Flatten (ASCII.LF));
      --  Ada.Text_IO.Put_Line (Input.Flatten (ASCII.LF));
      --  Ada.Text_IO.Put_Line (Expected.Flatten (ASCII.LF));

      for Line of Config loop
         Manager.Manager.Load_Config_Line (Line, Result);
         if Result /= Manager.Manager.Ok then
            Print_Line
              (Filename (Cases.Config) & ":" & Trim (Line_Nbr'Img) &
                 ": error " &
                 Manager.Manager.Result_String (Result));
            exit;
         end if;
         Line_Nbr := Line_Nbr + 1;
      end loop;

      if Result = Manager.Manager.Ok then
         --  Only send inputs if the config is correct

         Manager.Manager.Start;

         for Line of Input loop
            if Has_Prefix (Line, "data:") then
               Manager.Test_Data_Input.Singleton.Push
                 (MIDI.MIDI_Data'Value (Tail (Line, ':')));

            elsif Has_Prefix (Line, "clock:") then
               Manager.Test_Clock_Input.Singleton.Push
                 (MIDI_Signal_Flow.Clock_Event'Value (Tail (Line, ':')));

            elsif Has_Prefix (Line, "channel:") then
               Manager.Test_Channel_Input.Singleton.Push
                 ((MIDI.Sys, others => <>));

            elsif Has_Prefix (Line, "cable:") then
               Manager.Test_Cable_Input.Singleton.Push
                 ((MIDI.Sys, others => <>));
            end if;
         end loop;
      end if;

      declare
         Output : constant AAA.Strings.Vector := Get_Prints;
      begin
         if Output = Expected then
            return Empty_Vector;
         else
            return Diff (A           => Expected,
                         B           => Output,
                         A_Name      => "expected",
                         B_Name      => "output");
         end if;
      end;
   exception
      when E : others =>
         return Result : AAA.Strings.Vector do
            Result.Append (Ada.Exceptions.Exception_Information (E));
         end return;
   end Run_Case;

   ---------------
   -- Run_Cases --
   ---------------

   procedure Run_Cases (List : Test_Cases_List.List) is
      use AAA.Strings;
      use CLIC.TTY;

      Count : Natural := 0;
      Fail  : Natural := 0;
      Result : AAA.Strings.Vector;
   begin

      for Dirname of List loop
         Count := Count + 1;
         Ada.Text_IO.Put ("[" & Emph (Trim (Count'Img) & "/" &
                            Trim (List.Length'Img)) & "] " &
                            Dirname & " -> ");
         Result := Run_Case (Dirname);
         if Result = Empty_Vector then
            Ada.Text_IO.Put_Line (OK ("PASS"));
         else
            Fail := Fail + 1;
            Ada.Text_IO.Put_Line (Error ("FAIL"));
            Ada.Text_IO.Put_Line (Result.Flatten (ASCII.LF));
         end if;
      end loop;

      if Fail = 0 then
         Ada.Text_IO.Put_Line
           (Emph ("Result:") & OK (Count'Img & " PASS"));
         GNAT.OS_Lib.OS_Exit (0);
      else
         Ada.Text_IO.Put_Line
           (Emph ("Result:") & Error (Fail'Img & " FAIL"));
         GNAT.OS_Lib.OS_Exit (1);
      end if;
   end Run_Cases;

   --------------------------
   -- Print_LG_Definitions --
   --------------------------

   procedure Print_LG_Definitions is
   begin
      Reset_Prints;
      Manager.Manager.Print_LG_Definitions;
      Ada.Text_IO.Put_Line (Get_Prints.Flatten (ASCII.LF));
   end Print_LG_Definitions;

   Lines : AAA.Strings.Vector;

   ----------------
   -- Print_Line --
   ----------------

   procedure Print_Line (Str : String) is
   begin
      Lines.Append (Str);
   end Print_Line;

   ----------------
   -- Get_Prints --
   ----------------

   function Get_Prints return AAA.Strings.Vector is
   begin
      return Lines;
   end Get_Prints;

   ------------------
   -- Reset_Prints --
   ------------------

   procedure Reset_Prints is
   begin
      Lines.Clear;
   end Reset_Prints;

begin
   CLIC.TTY.Enable_Color;
end Testsuite.Cases;
