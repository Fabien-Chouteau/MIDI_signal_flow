with Litegraph_To_Ada.Bounded_Manager;
with MIDI_Signal_Flow.Graph;

with MIDI_Signal_Flow.Nodes; use MIDI_Signal_Flow.Nodes;

with MIDI_Signal_Flow.Nodes.Channel.Constant_Id;
with MIDI_Signal_Flow.Nodes.Channel.Filter_Channel;
with MIDI_Signal_Flow.Nodes.Channel.Get_CC;
with MIDI_Signal_Flow.Nodes.Channel.Get_Note_Msg;
with MIDI_Signal_Flow.Nodes.Channel.Send_CC;
with MIDI_Signal_Flow.Nodes.Channel.Mixer;
with MIDI_Signal_Flow.Nodes.Channel.Keyboard_Split;
with MIDI_Signal_Flow.Nodes.Channel.Map_Channel;
with MIDI_Signal_Flow.Nodes.Channel.Merge_Channel;

with MIDI_Signal_Flow.Nodes.Cable.Mixer;

with MIDI_Signal_Flow.Nodes.Clock.Filter_Clock;
with MIDI_Signal_Flow.Nodes.Clock.Mixer;

with MIDI_Signal_Flow.Nodes.Data.Constant_Data;
with MIDI_Signal_Flow.Nodes.Data.Mixer;
with MIDI_Signal_Flow.Nodes.Data.Add;
with MIDI_Signal_Flow.Nodes.Data.Sub;
with MIDI_Signal_Flow.Nodes.Data.Mult;
with MIDI_Signal_Flow.Nodes.Data.Div;
with MIDI_Signal_Flow.Nodes.Data.Modulo;

with MIDI_Signal_Flow.Nodes.Output.Print_Cable;
with MIDI_Signal_Flow.Nodes.Output.Print_Channel;
with MIDI_Signal_Flow.Nodes.Output.Print_Clock;
with MIDI_Signal_Flow.Nodes.Output.Print_Data;

with MIDI_Signal_Flow.Nodes.Utils.Volca_Sample;

with Testsuite.Nodes.Test_Cable_Input;
with Testsuite.Nodes.Test_Channel_Input;
with Testsuite.Nodes.Test_Clock_Input;
with Testsuite.Nodes.Test_Data_Input;

package Testsuite.Manager
with Elaborate_Body
is

   package Manager
   is new MIDI_Signal_Flow.Graph.Bounded_Manager (Number_Of_Links  => 1000,
                                                  Number_Of_Nodes  => 1000,
                                                  Node_Memory_Size => 1024);

   package Channel_Constant_Id
   is new Manager.Node_Type_Register (Channel.Constant_Id.Node);
   package Channel_Filter_Channel
   is new Manager.Node_Type_Register (Channel.Filter_Channel.Node);
   package Channel_Get_CC
   is new Manager.Node_Type_Register (Channel.Get_CC.Node);
   package Channel_Send_CC
   is new Manager.Node_Type_Register (Channel.Send_CC.Node);
   package Channel_Get_Note_Msg
   is new Manager.Node_Type_Register (Channel.Get_Note_Msg.Node);
   package Channel_Mixer
   is new Manager.Node_Type_Register (Channel.Mixer.Node);
   package Channel_Keyboard_Split
   is new Manager.Node_Type_Register (Channel.Keyboard_Split.Node);
   package Channel_Map
   is new Manager.Node_Type_Register (Channel.Map_Channel.Node);
   package Channel_Merge
   is new Manager.Node_Type_Register (Channel.Merge_Channel.Node);

   package Clock_Filter
   is new Manager.Node_Type_Register (Clock.Filter_Clock.Node);
   package Clock_Mixer
   is new Manager.Node_Type_Register (Clock.Mixer.Node);

   package Data_Constant
   is new Manager.Node_Type_Register (Data.Constant_Data.Node);
   package Data_Mixer
   is new Manager.Node_Type_Register (Data.Mixer.Node);
   package Data_Add
   is new Manager.Node_Type_Register (Data.Add.Node);
   package Data_Sub
   is new Manager.Node_Type_Register (Data.Sub.Node);
   package Data_Mult
   is new Manager.Node_Type_Register (Data.Mult.Node);
   package Data_Div
   is new Manager.Node_Type_Register (Data.Div.Node);
   package Data_Modulo
   is new Manager.Node_Type_Register (Data.Modulo.Node);

   package Cable_Mixer
   is new Manager.Node_Type_Register (Cable.Mixer.Node);

   package Print_Data
   is new Manager.Node_Type_Register (Output.Print_Data.Node);
   package Print_Channel
   is new Manager.Node_Type_Register (Output.Print_Channel.Node);
   package Print_Cable
   is new Manager.Node_Type_Register (Output.Print_Cable.Node);
   package Print_Clock
   is new Manager.Node_Type_Register (Output.Print_Clock.Node);

   package Volca_Sample
   is new Manager.Node_Type_Register (Utils.Volca_Sample.Node);

   package Test_Cable_Input
   is new Manager.Singleton_Node_Register
     (Testsuite.Nodes.Test_Cable_Input.Node);
   package Test_Channel_Input
   is new Manager.Singleton_Node_Register
     (Testsuite.Nodes.Test_Channel_Input.Node);
   package Test_Data_Input
   is new Manager.Singleton_Node_Register
     (Testsuite.Nodes.Test_Data_Input.Node);
   package Test_Clock_Input
   is new Manager.Singleton_Node_Register
     (Testsuite.Nodes.Test_Clock_Input.Node);

end Testsuite.Manager;
