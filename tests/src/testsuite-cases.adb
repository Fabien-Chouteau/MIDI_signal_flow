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

   --------------------
   -- Parse_MIDI_Msg --
   --------------------

   procedure Parse_MIDI_Msg (Str     :     String;
                             Msg     : out MIDI.Message;
                             Success : out Boolean)
   is
      use MIDI;

      V1, V2 : MIDI_Data;
      Chan : MIDI_Channel;
   begin
      if Str'Length < 2
        or else
          Str (Str'First) /= '('
        or else
          Str (Str'Last) /= ')'
      then
         Print_Line ("MIDI Message missing parens");
         Success := False;
         return;
      end if;

      declare
         Elements : constant AAA.Strings.Vector :=
           AAA.Strings.Split (Str (Str'First + 1 .. Str'Last - 1), ',');
      begin
         case Elements.Count is
         when 1 =>
            if Elements.First_Element = "System Exclusive" then
               Msg := (Kind => Sys, Cmd => Exclusive, others => <>);
            elsif Elements.First_Element = "End System Exclusive" then
               Msg := (Kind => Sys, Cmd => End_Exclusive, others => <>);
            elsif Elements.First_Element = "Tune Request" then
               Msg := (Kind => Sys, Cmd => Tune_Request, others => <>);
            elsif Elements.First_Element = "Timming Tick" then
               Msg := (Kind => Sys, Cmd => Timming_Tick, others => <>);
            elsif Elements.First_Element = "Start Song" then
               Msg := (Kind => Sys, Cmd => Start_Song, others => <>);
            elsif Elements.First_Element = "Continue Song" then
               Msg := (Kind => Sys, Cmd => Continue_Song, others => <>);
            elsif Elements.First_Element = "Stop Song" then
               Msg := (Kind => Sys, Cmd => Stop_Song, others => <>);
            elsif Elements.First_Element = "Active Sensing" then
               Msg := (Kind => Sys, Cmd => Active_Sensing, others => <>);
            elsif Elements.First_Element = "Reset" then
               Msg := (Kind => Sys, Cmd => Reset, others => <>);
            else
               Print_Line ("invalid MIDI msg: unknown kind '" &
                             Elements.First_Element & "'");
               Success := False;
               return;
            end if;

            Success := True;

         when 2 =>
            V1 := MIDI_Data'Value (Elements.Element (2));

            if Elements.First_Element = "Song Select" then
               Msg := (Kind => Sys, Cmd => Song_Select, S1 => V1, S2 => 0);

            elsif Elements.First_Element = "Bus Select" then
               Msg := (Kind => Sys, Cmd => Bus_Select, S1 => V1, S2 => 0);

            else
               Print_Line ("invalid MIDI msg: unknown kind '" &
                             Elements.First_Element & "'");
               Success := False;
               return;
            end if;

            Success := True;

         when 3 =>
            Chan := MIDI_Channel'Value (Elements.Element (2));
            V1 := MIDI_Data'Value (Elements.Element (3));

            if Elements.First_Element = "Patch Change" then
               Msg := (Kind => Patch_Change, Chan => Chan, Instrument => V1);

            elsif Elements.First_Element = "Channel Pressure" then
               Msg := (Kind => Channel_Pressure, Chan => Chan, Pressure => V1);

            elsif Elements.First_Element = "Pitch Bend" then
               Msg := (Kind => Pitch_Bend, Chan => Chan, Bend => V1);

            else
               Print_Line ("invalid MIDI msg: unknown kind '" &
                             Elements.First_Element & "'");
               Success := False;
               return;
            end if;

            Success := True;

         when 4 =>
            Chan := MIDI_Channel'Value (Elements.Element (2));
            V1 := MIDI_Data'Value (Elements.Element (3));
            V2 := MIDI_Data'Value (Elements.Element (4));

            if Elements.First_Element = "Note Off" then
               Msg := (Kind => Note_Off, Chan => Chan, Key => V1,
                       Velocity => V2);

            elsif Elements.First_Element = "Note On" then
               Msg := (Kind => Note_On, Chan => Chan, Key => V1,
                       Velocity => V2);

            elsif Elements.First_Element = "Aftertouch" then
               Msg := (Kind => Aftertouch, Chan => Chan, Key => V1,
                       Velocity => V2);

            elsif Elements.First_Element = "Continous Controller" then
               Msg := (Kind => Continous_Controller,
                       Chan => Chan,
                       Controller => V1,
                       Controller_Value => V2);
            else
               Print_Line ("invalid MIDI msg: unknown kind '" &
                             Elements.First_Element & "'");
               Success := False;
               return;
            end if;

            Success := True;

         when others =>
            Print_Line ("invalid MIDI msg: too many elements");
            Success := False;
         end case;
      end;

   end Parse_MIDI_Msg;

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
      Reset_Prints;
      Manager.Manager.Reset;

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
               declare
                  Msg : MIDI.Message;
                  Success : Boolean;
               begin
                  Parse_MIDI_Msg (Trim (Tail (Line, ':')), Msg, Success);
                  if Success then
                     Manager.Test_Channel_Input.Singleton.Push (Msg);
                  end if;
               end;

            elsif Has_Prefix (Line, "cable:") then
               declare
                  Msg : MIDI.Message;
                  Success : Boolean;
               begin
                  Parse_MIDI_Msg (Trim (Tail (Line, ':')), Msg, Success);
                  if Success then
                     Manager.Test_Cable_Input.Singleton.Push (Msg);
                  end if;
               end;
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
   MIDI_Signal_Flow.Set_Put_Line (Print_Line'Access);
end Testsuite.Cases;
