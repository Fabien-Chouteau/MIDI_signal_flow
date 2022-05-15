package body MIDI_Signal_Flow.Nodes.Input.Generic_Clock_Input is

   ----------
   -- Push --
   ----------

   procedure Push (This : in out Node; Evt : Clock_Event) is
   begin
      This.Send (0, (Clock_Port, Evt));
   end Push;

end MIDI_Signal_Flow.Nodes.Input.Generic_Clock_Input;
