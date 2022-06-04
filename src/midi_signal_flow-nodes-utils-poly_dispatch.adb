package body MIDI_Signal_Flow.Nodes.Utils.Poly_Dispatch is

   ------------------
   -- Set_Property --
   ------------------

   overriding
   procedure Set_Property (This : in out Node;
                           Id : Property_Id;
                           Val : Property_Value)
   is
   begin
      This.Voices_Count := Val.Int_Val;
   end Set_Property;

   -------------------
   -- Out_Port_Info --
   -------------------

   overriding
   function Out_Port_Info (This : Node;
                           Port : Port_Id)
                           return Port_Info
   is (if Natural (Port) < This.Voices_Count
       then (7, Channel_Port, "Channel")
       else Invalid_Port);

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node; Port : Port_Id; Data : Link_Data)
   is
      use HAL;

      ------------------
      -- Select_Voice --
      ------------------

      function Select_Voice return Natural is
         Oldest_Id : Natural := This.Voices'First;
         Oldest_On : HAL.UInt32 := HAL.UInt32'Last;
      begin
         for Id in
           This.Voices'First .. This.Voices'First +  This.Voices_Count - 1
         loop
            if This.Voices (Id).Last_Key = 0 then
               return Id;
            else
               if This.Voices (Id).Last_Time_On < Oldest_On then
                  Oldest_On := This.Voices (Id).Last_Time_On;
                  Oldest_Id := Id;
               end if;
            end if;
         end loop;

         return Oldest_Id;
      end Select_Voice;

   begin
      case Data.Msg.Kind is
         when Note_On =>

            if Data.Msg.Key = 0 then
               return;
            end if;

            declare
               Id : constant Natural := Select_Voice;
               V : Voice renames This.Voices (Id);
            begin

               --  Terminate the current note of this voice, if any
               if V.Last_Key /= 0 then
                  This.Send (Port_Id (Id), (Kind => Channel_Port,
                                            Msg => (Kind     => Note_Off,
                                                    Chan     => 0,
                                                    Key      => V.Last_Key,
                                                    Velocity => 0)));
               end if;

               --  Keep track of the note played by this voice
               V.Last_Key := Data.Msg.Key;

               This.Evt_Count := This.Evt_Count + 1;
               V.Last_Time_On := This.Evt_Count;

               --  Send the message to the voice
               This.Send (Port_Id (Id), Data);
            end;

         when Note_Off =>
            for Id in This.Voices'Range loop
               if This.Voices (Id).Last_Key = Data.Msg.Key then
                  This.Send (Port_Id (Id), Data);
                  This.Voices (Id).Last_Key := 0;
                  exit;
               end if;
            end loop;

         when Aftertouch =>
            for Id in This.Voices'Range loop
               if This.Voices (Id).Last_Key = Data.Msg.Key then
                  This.Send (Port_Id (Id), Data);
                  exit;
               end if;
            end loop;

         when others =>
            null; --  Other kinds of messages are ignored
      end case;
   end Receive;

end MIDI_Signal_Flow.Nodes.Utils.Poly_Dispatch;
