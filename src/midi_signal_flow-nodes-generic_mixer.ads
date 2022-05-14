with MIDI_Signal_Flow.Graph; use MIDI_Signal_Flow.Graph;

generic
   Node_Cat       : Category_Kind;
   Node_Name      : String;
   Mix_Port_Kind  : Port_Kind;
   Default_Inputs : Positive;
package MIDI_Signal_Flow.Nodes.Generic_Mixer is


   subtype Parent is MIDI_Signal_Flow.Graph.Node;
   type Node
   is new Parent with
   private;

   overriding
   function Category (This : Node) return Category_Kind
   is (Node_Cat);

   overriding
   function Name (This : Node) return String
   is (Node_Name);

   overriding
   function In_Port_Info (This : Node; Port : Port_Id) return Port_Info;

   overriding
   function Out_Port_Info (This : Node; Port : Port_Id) return Port_Info
   is (case Port is
          when 0 =>  (3, Mix_Port_Kind, "Out"),
          when others => Invalid_Port);


   overriding
   function Get_Property_Info (This : Node; Prop : Property_Id)
                               return Property_Info
   is (case Prop is
          when 0 => (11, Int_Prop, "input_count",
                     None,
                     Int_Min => 1,
                     Int_Max => 100,
                     Int_Default => Default_Inputs),
          when others => Invalid_Property);

   overriding
   procedure Set_Property (This : in out Node;
                           Id   :        Property_Id;
                           Val  :        Property_Value);

   overriding
   procedure Receive (This : in out Node;
                      Port :        Port_Id;
                      Data :        Link_Data);
   --  This node doesn't receive any data

private

   type Node
   is new Parent with record
      Input_Count : Integer := Default_Inputs;
   end record;

end MIDI_Signal_Flow.Nodes.Generic_Mixer;
