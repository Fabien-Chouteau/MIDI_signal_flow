with MIDI_Signal_Flow.Nodes.Generic_Mixer;

package MIDI_Signal_Flow.Nodes.Clock.Mixer
is new Generic_Mixer (Node_Cat       => MIDI_Signal_Flow.Clock,
                      Node_Name      => "clock_mixer",
                      Mix_Port_Kind  => Clock_Port,
                      Default_Inputs => 2);
