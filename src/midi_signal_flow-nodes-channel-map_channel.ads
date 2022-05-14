with MIDI;
with MIDI_Signal_Flow.Graph; use MIDI_Signal_Flow.Graph;

package MIDI_Signal_Flow.Nodes.Channel.Map_Channel is

   subtype Parent is MIDI_Signal_Flow.Graph.Node;
   type Node
   is new Parent with
   private;

   overriding
   function Category (This : Node) return Category_Kind
   is (MIDI_Signal_Flow.Channel);

   overriding
   function Name (This : Node) return String
   is ("map_channel");

   overriding
   function In_Port_Info (This : Node;
                          Port : Port_Id)
                          return Port_Info
   is (case Port is
          when 0 => (13, Data_Port, "In_Channel_Id"),
          when 1 => (14, Data_Port, "Out_Channel_Id"),
          when 2 => (5, Cable_Port, "Cable"),
          when others => Invalid_Port);

   overriding
   function Out_Port_Info (This : Node;
                           Port : Port_Id)
                           return Port_Info
   is (case Port is
          when 0 => (5, Cable_Port, "Cable"),
          when others => Invalid_Port);

   overriding
   function Get_Property_Info (This : Node; Prop : Property_Id)
                               return Property_Info
   is (case Prop is
          when 0 => (13, Int_Prop, "In_Channel_Id",
                     Int_Widget => Combo,
                     Int_Min => 1, Int_Max => 16,
                     Int_Default => 1),
          when 1 => (14, Int_Prop, "Out_Channel_Id",
                     Int_Widget => Combo,
                     Int_Min => 1, Int_Max => 16,
                     Int_Default => 2),
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
   is new Parent
   with record
      In_Chan : MIDI_Channel := 0;
      Out_Chan : MIDI_Channel := 1;
   end record;

end MIDI_Signal_Flow.Nodes.Channel.Map_Channel;
