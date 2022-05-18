package body MIDI_Signal_Flow.Nodes.Channel.Merge_Channel is

   ------------------
   -- Set_Property --
   ------------------

   overriding
   procedure Set_Property (This : in out Node;
                           Id   :        Property_Id;
                           Val  :        Property_Value)
   is
   begin
      case Id is
         when 0 =>
            This.Chan := MIDI_Channel (Val.Int_Val - 1);
         when others =>
            null;
      end case;
   end Set_Property;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node;
                      Port :        Port_Id;
                      Data :        Link_Data)
   is
      New_Data : Link_Data := Data;
   begin
      case Port is
         when 0 =>
            if Data.Data in 1 .. 16 then
               This.Chan := MIDI.MIDI_Channel (Data.Data - 1);
            end if;

         when 1 =>
            if Data.Msg.Kind /= Sys then
               New_Data.Msg.Chan := This.Chan;
            end if;

            This.Send (0, New_Data);

         when 2 =>
            This.Send (0, Data);

         when others =>
            null;
      end case;
   end Receive;

end MIDI_Signal_Flow.Nodes.Channel.Merge_Channel;
