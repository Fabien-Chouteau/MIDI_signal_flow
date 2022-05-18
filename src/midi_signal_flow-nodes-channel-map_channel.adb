package body MIDI_Signal_Flow.Nodes.Channel.Map_Channel is

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
            This.In_Chan := MIDI_Channel (Val.Int_Val - 1);
         when 1 =>
            This.Out_Chan := MIDI_Channel (Val.Int_Val - 1);
         when others =>
            null;
      end case;
   end Set_Property;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node; Port : Port_Id; Data : Link_Data)
   is

      New_Data : Link_Data := Data;
   begin
      case Port is
         when 0 =>
            if Data.Data in 1 .. 16 then
               This.In_Chan := MIDI.MIDI_Channel (Data.Data - 1);
            end if;

         when 1 =>
            if Data.Data in 1 .. 16 then
               This.Out_Chan := MIDI.MIDI_Channel (Data.Data - 1);
            end if;

         when 2 =>
            if Data.Msg.Kind /= Sys and then Data.Msg.Chan = This.In_Chan then
               New_Data.Msg.Chan := This.Out_Chan;
            end if;

            This.Send (0, New_Data);

         when others =>
            null;
      end case;
   end Receive;

end MIDI_Signal_Flow.Nodes.Channel.Map_Channel;
