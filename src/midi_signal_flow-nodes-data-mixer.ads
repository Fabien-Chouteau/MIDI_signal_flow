with MIDI_Signal_Flow.Nodes.Generic_Mixer;

package MIDI_Signal_Flow.Nodes.Data.Mixer
is new Generic_Mixer (Node_Cat       => MIDI_Signal_Flow.Data,
                      Node_Name      => "data_mixer",
                      Mix_Port_Kind  => Data_Port,
                      Default_Inputs => 2,
                      Max_Inputs     => 16);
