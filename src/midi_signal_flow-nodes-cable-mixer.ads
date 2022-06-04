with MIDI_Signal_Flow.Nodes.Generic_Mixer;

package MIDI_Signal_Flow.Nodes.Cable.Mixer
is new Generic_Mixer (Node_Cat       => MIDI_Signal_Flow.Cable,
                      Node_Name      => "cable_mixer",
                      Mix_Port_Kind  => Cable_Port,
                      Default_Inputs => 2,
                      Max_Inputs     => 16);
