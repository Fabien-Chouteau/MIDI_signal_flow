package body MIDI_Signal_Flow.Nodes.Input.Generic_Cable_Input is

   ----------
   -- Push --
   ----------

   procedure Push (This : in out Node; Msg : MIDI.Message) is
   begin
      This.Send (0, (Cable_Port, Msg));
   end Push;

end MIDI_Signal_Flow.Nodes.Input.Generic_Cable_Input;
