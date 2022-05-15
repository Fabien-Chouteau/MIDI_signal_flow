package body MIDI_Signal_Flow.Nodes.Input.Generic_Data_Input is

   ----------
   -- Push --
   ----------

   procedure Push (This : in out Node; Data : MIDI.MIDI_Data) is
   begin
      This.Send (0, (Data_Port, Data));
   end Push;

end MIDI_Signal_Flow.Nodes.Input.Generic_Data_Input;
