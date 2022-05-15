with MIDI_Signal_Flow.Graph; use MIDI_Signal_Flow.Graph;

generic
   Node_Cat : Category_Kind;
   Node_Name : String;
   Prop_Info : Property_Info;
package MIDI_Signal_Flow.Nodes.Generic_MIDI_Data_Constant is

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
   function Out_Port_Info (This : Node;
                           Port : Port_Id)
                           return Port_Info
   is (case Port is
       when 0 =>  (3, Data_Port, "Out"),
       when others => Invalid_Port);

   overriding
   function Get_Property_Info (This : Node; Prop : Property_Id)
                               return Property_Info
   is (case Prop is
          when 0 => Prop_Info,
          when others => Invalid_Property);

   overriding
   procedure On_Start (This : in out Node);

   overriding
   procedure Set_Property (This : in out Node;
                           Id   :        Property_Id;
                           Val  :        Property_Value);

private

   type Node
   is new Parent with record
      Val : Integer;
   end record;

end MIDI_Signal_Flow.Nodes.Generic_MIDI_Data_Constant;
