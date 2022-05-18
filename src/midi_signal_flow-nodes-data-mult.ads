with MIDI;
with MIDI_Signal_Flow.Nodes.Data.Generic_Op;

package MIDI_Signal_Flow.Nodes.Data.Mult
is new MIDI_Signal_Flow.Nodes.Data.Generic_Op (Node_Name => "mult_data",
                                               Op        =>  MIDI."*");
