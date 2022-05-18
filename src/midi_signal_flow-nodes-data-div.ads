with MIDI;
with MIDI_Signal_Flow.Nodes.Data.Generic_Op;

package MIDI_Signal_Flow.Nodes.Data.Div
is new MIDI_Signal_Flow.Nodes.Data.Generic_Op (Node_Name => "div_data",
                                               Op        =>  MIDI."/");
