with MIDI;
with MIDI_Signal_Flow.Graph;

package body MIDI_Signal_Flow.Nodes.Generic_MIDI_Data_Constant is

   --------------
   -- On_Start --
   --------------

   overriding
   procedure On_Start (This : in out Node)
   is
   begin
      This.Send (0, (Data_Port, MIDI.MIDI_Data (This.Val)));
   end On_Start;

   ------------------
   -- Set_Property --
   ------------------

   overriding
   procedure Set_Property (This : in out Node;
                           Id   :        Property_Id;
                           Val  :        Property_Value)
   is
   begin
      This.Val := Val.Int_Val;
   end Set_Property;

end MIDI_Signal_Flow.Nodes.Generic_MIDI_Data_Constant;
