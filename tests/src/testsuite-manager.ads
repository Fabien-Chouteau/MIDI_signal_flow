with Litegraph_To_Ada.Bounded_Manager;
with MIDI_Signal_Flow.Graph;

with MIDI_Signal_Flow.Nodes; use MIDI_Signal_Flow.Nodes;

with MIDI_Signal_Flow.Nodes.Channel.Constant_Id;
with MIDI_Signal_Flow.Nodes.Channel.Filter_Channel;
with MIDI_Signal_Flow.Nodes.Channel.Get_CC;
with MIDI_Signal_Flow.Nodes.Channel.Send_CC;
with MIDI_Signal_Flow.Nodes.Channel.Mixer;
with MIDI_Signal_Flow.Nodes.Channel.Keyboard_Split;
with MIDI_Signal_Flow.Nodes.Channel.Map_Channel;

with MIDI_Signal_Flow.Nodes.Cable.Mixer;

with MIDI_Signal_Flow.Nodes.Clock.Filter_Clock;

with MIDI_Signal_Flow.Nodes.Data.Constant_Data;
with MIDI_Signal_Flow.Nodes.Data.Mixer;

package Testsuite.Manager is

   package Manager
   is new MIDI_Signal_Flow.Graph.Bounded_Manager (Number_Of_Links => 1000,
                                                  Number_Of_Types => 100,
                                                  Number_Of_Nodes => 1000);

   package Channel_Constant_Id
   is new Manager.Node_Type_Register (Channel.Constant_Id.Node, 100);

   package Channel_Filter_Channel
   is new Manager.Node_Type_Register (Channel.Filter_Channel.Node, 100);

   package Channel_Get_CC
   is new Manager.Node_Type_Register (Channel.Get_CC.Node, 100);

   package Channel_Send_CC
   is new Manager.Node_Type_Register (Channel.Send_CC.Node, 100);

   package Channel_Mixer
   is new Manager.Node_Type_Register (Channel.Mixer.Node, 100);

   package Channel_Keyboard_Split
   is new Manager.Node_Type_Register (Channel.Keyboard_Split.Node, 100);

   package Channel_Map
   is new Manager.Node_Type_Register (Channel.Map_Channel.Node, 100);

   package Clock_Filter
   is new Manager.Node_Type_Register (Clock.Filter_Clock.Node, 100);

   package Data_Constant
   is new Manager.Node_Type_Register (Data.Constant_Data.Node, 100);

   package Data_Mixer
   is new Manager.Node_Type_Register (Data.Mixer.Node, 100);

   package Cable_Mixer
   is new Manager.Node_Type_Register (Cable.Mixer.Node, 100);

end Testsuite.Manager;
