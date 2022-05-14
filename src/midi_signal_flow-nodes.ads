with MIDI_Signal_Flow.Graph; use MIDI_Signal_Flow.Graph;

package MIDI_Signal_Flow.Nodes is

   function Check_Data (Val   : Graph.Property_Value;
                        Min   : Integer := 0;
                        Max   : Integer := 127)
                        return Boolean
   is (Val.Kind = Int_Prop and then Val.Int_Val in Min .. Max);

end MIDI_Signal_Flow.Nodes;
