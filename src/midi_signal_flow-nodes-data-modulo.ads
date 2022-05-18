with MIDI;
with MIDI_Signal_Flow.Nodes.Data.Generic_Op;

package MIDI_Signal_Flow.Nodes.Data.Modulo
is new MIDI_Signal_Flow.Nodes.Data.Generic_Op (Node_Name => "modulo_data",
                                               Op        =>  MIDI."mod");
