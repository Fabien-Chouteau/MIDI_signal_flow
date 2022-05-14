with MIDI_Signal_Flow.Graph;
with MIDI_Signal_Flow.Nodes.Generic_MIDI_Data_Constant;

package MIDI_Signal_Flow.Nodes.Data.Constant_Data
is new Generic_MIDI_Data_Constant (Node_Cat     => MIDI_Signal_Flow.Data,
                                   Node_Name    => "const_data",
                                   Prop_Info    => (5, Graph.Int_Prop,
                                                    "value",
                                                    Graph.Slider,
                                                    Int_Min => 0,
                                                    Int_Max => 127,
                                                    Int_Default => 0));
