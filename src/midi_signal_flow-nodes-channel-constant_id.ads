with MIDI_Signal_Flow.Graph;
with MIDI_Signal_Flow.Nodes.Generic_MIDI_Data_Constant;

package MIDI_Signal_Flow.Nodes.Channel.Constant_Id
is new Generic_MIDI_Data_Constant (Node_Cat     => MIDI_Signal_Flow.Channel,
                                   Node_Name    => "const_chan_id",
                                   Prop_Info    => (10, Graph.Int_Prop,
                                                    "channel id",
                                                    Graph.Combo,
                                                    Int_Min => 1,
                                                    Int_Max => 16,
                                                    Int_Default => 1));
