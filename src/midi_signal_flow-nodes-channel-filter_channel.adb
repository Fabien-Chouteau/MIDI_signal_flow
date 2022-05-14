package body MIDI_Signal_Flow.Nodes.Channel.Filter_Channel is

   ------------------
   -- Set_Property --
   ------------------

   overriding
   procedure Set_Property (This : in out Node;
                           Id : Property_Id;
                           Val : Property_Value)
   is
   begin
      case Id is
         when 0 =>
            This.Chan := MIDI_Channel (Val.Int_Val - 1);
         when 1 =>
            This.Passthrough := Val.Bool_Val;
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
   begin
      case Port is
         when 0 =>
            if Data.Data in 1 .. 16 then
               This.Chan := MIDI_Channel (Data.Data - 1);
            end if;

         when 1 =>
            if Data.Msg.Kind /= Sys and then Data.Msg.Chan = This.Chan then
               This.Send (0, Data);

               if This.Passthrough then
                  This.Send (1, Data);
               end if;

            else
               This.Send (1, Data);
            end if;

         when others =>
            null;

      end case;
   end Receive;

end MIDI_Signal_Flow.Nodes.Channel.Filter_Channel;
