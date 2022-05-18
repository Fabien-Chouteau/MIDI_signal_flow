package MIDI_Signal_Flow.Nodes.Output.Print_Data is

   procedure Set_Put_Line (CB : Put_Line_Callback);

   subtype Parent is MIDI_Signal_Flow.Graph.Node;

   type Node
   is new Parent with
   private;

   overriding
   function Category (This : Node) return Category_Kind
   is (MIDI_Signal_Flow.Output);

   overriding
   function Name (This : Node) return String
   is ("print_data");

   overriding
   function In_Port_Info (This : Node; Port : Port_Id) return Port_Info
   is (case Port is
          when 0 =>  (2, Data_Port, "In"),
          when others => Invalid_Port);

   overriding
   function Get_Property_Info (This : Node; Prop : Property_Id)
                               return Property_Info
   is (case Prop is
          when 0 => (4, Str_Prop, "Name",
                     Str_Widget => Text),
          when others => Invalid_Property);

   overriding
   procedure Set_Property (This : in out Node;
                           Id   :        Property_Id;
                           Val  :        Property_Value);

   overriding
   procedure Receive (This : in out Node;
                      Port :        Port_Id;
                      Data :        Link_Data);

private

   type Node
   is new Parent with record
      Name : String (1 .. 20);
      Len : Natural := 0;
   end record;

end MIDI_Signal_Flow.Nodes.Output.Print_Data;
