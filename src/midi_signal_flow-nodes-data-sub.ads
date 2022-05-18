with MIDI;
with MIDI_Signal_Flow.Nodes.Data.Generic_Op;

package MIDI_Signal_Flow.Nodes.Data.Sub
is new MIDI_Signal_Flow.Nodes.Data.Generic_Op (Node_Name => "sub_data",
                                               Op        =>  MIDI."-");
