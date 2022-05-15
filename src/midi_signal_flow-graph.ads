
with Litegraph_To_Ada;

package MIDI_Signal_Flow.Graph
is new Litegraph_To_Ada (Port_Kind      => Port_Kind,
                         Category_Kind  => Category_Kind,
                         Link_Data      => Link_Data,
                         Shape_For_Port => Shape_For_Port,
                         Port_Value     => Port_Value,
                         Cat_Value      => Cat_Value,
                         Put_Line       => MIDI_Signal_Flow.Put_Line);
