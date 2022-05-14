with MIDI_Signal_Flow.Nodes.Generic_Mixer;

package MIDI_Signal_Flow.Nodes.Channel.Mixer
is new Generic_Mixer (Node_Cat       => MIDI_Signal_Flow.Channel,
                      Node_Name      => "channel_mixer",
                      Mix_Port_Kind  => Channel_Port,
                      Default_Inputs => 2);
