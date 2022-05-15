package body MIDI_Signal_Flow.Nodes.Output.Print_Clock is

   ------------------
   -- Set_Put_Line --
   ------------------

   procedure Set_Put_Line (This : in out Node; CB : Put_Line_Callback) is
   begin
      This.CB := CB;
   end Set_Put_Line;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node; Port : Port_Id; Data : Link_Data)
   is
   begin
      if This.CB /= null then
         case Data.Clock_Evt is
            when Tick =>
               This.CB ("Clock Tick");
            when Start =>
               This.CB ("Clock Start");
            when Stop =>
               This.CB ("Clock Stop");
            when Continue =>
               This.CB ("Clock Continue");
         end case;
      end if;
   end Receive;

end MIDI_Signal_Flow.Nodes.Output.Print_Clock;
