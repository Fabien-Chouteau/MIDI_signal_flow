with MIDI;
with MIDI_Signal_Flow.Nodes.Data.Generic_Op;

package MIDI_Signal_Flow.Nodes.Data.Add
is new MIDI_Signal_Flow.Nodes.Data.Generic_Op (Node_Name => "add_data",
                                               Op        =>  MIDI."+");
