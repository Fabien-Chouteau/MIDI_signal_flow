package body MIDI_Signal_Flow.Nodes.Output.Print_Cable is

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
         This.CB ("Cable msg: " & MIDI.Img (Data.Msg));
      end if;
   end Receive;

end MIDI_Signal_Flow.Nodes.Output.Print_Cable;
