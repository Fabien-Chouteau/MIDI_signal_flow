package body MIDI_Signal_Flow.Nodes.Data.Generic_Op is

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node; Port : Port_Id; Data : Link_Data)
   is
   begin
      case Port is
         when 0 =>
            This.A := Data.Data;
            This.Got_A := True;

         when 1 =>
            This.B := Data.Data;
            This.Got_B := True;

         when others =>
            return;
      end case;

      if This.Got_A and then This.Got_B then
         This.Send (0, (Data_Port, Op (This.A, This.B)));
         This.Got_A := False;
         This.Got_B := False;
      end if;
   end Receive;

end MIDI_Signal_Flow.Nodes.Data.Generic_Op;
