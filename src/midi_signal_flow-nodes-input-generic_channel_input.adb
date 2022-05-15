package body MIDI_Signal_Flow.Nodes.Input.Generic_Channel_Input is

   ----------
   -- Push --
   ----------

   procedure Push (This : in out Node; Msg : MIDI.Message) is
   begin
      This.Send (0, (Channel_Port, Msg));
   end Push;

end MIDI_Signal_Flow.Nodes.Input.Generic_Channel_Input;
