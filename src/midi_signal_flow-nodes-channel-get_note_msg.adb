package body MIDI_Signal_Flow.Nodes.Channel.Get_Note_Msg is

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
         when 0 => This.Note_On := Val.Bool_Val;
         when 1 => This.Note_Off := Val.Bool_Val;
         when 2 => This.Aftertouch := Val.Bool_Val;
         when 3 => This.Passthrough := Val.Bool_Val;
         when others => null;
      end case;
   end Set_Property;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node; Port : Port_Id; Data : Link_Data)
   is
   begin
      if (This.Note_On and then Data.Msg.Kind = Note_On)
        or else
         (This.Note_Off and then Data.Msg.Kind = Note_Off)
        or else
         (This.Aftertouch and then Data.Msg.Kind = Aftertouch)
      then
         This.Send (0, (Data_Port, Data.Msg.Key));
         This.Send (1, (Data_Port, Data.Msg.Velocity));

         if This.Passthrough then
            This.Send (2, Data);
         end if;
      else
         This.Send (2, Data);
      end if;
   end Receive;

end MIDI_Signal_Flow.Nodes.Channel.Get_Note_Msg;
