with MIDI;
with MIDI_Signal_Flow.Graph; use MIDI_Signal_Flow.Graph;

package MIDI_Signal_Flow.Nodes.Channel.Send_CC is

   subtype Parent is MIDI_Signal_Flow.Graph.Node;
   type Node
   is new Parent with
   private;

   overriding
   function Category (This : Node) return Category_Kind
   is (MIDI_Signal_Flow.Channel);

   overriding
   function Name (This : Node) return String
   is ("send_cc");

   overriding
   function In_Port_Info (This : Node;
                          Port : Port_Id)
                          return Port_Info
   is (case Port is
          when 0 => (10, Data_Port, "Controller"),
          when 1 => (5,  Data_Port, "Value"),
          when others => Invalid_Port);

   overriding
   function Out_Port_Info (This : Node;
                           Port : Port_Id)
                           return Port_Info
   is (case Port is
          when 0 => (7, Channel_Port, "Channel"),
          when others => Invalid_Port);

   overriding
   function Get_Property_Info (This : Node; Prop : Property_Id)
                               return Property_Info
   is (case Prop is
          when 0 => (10, Int_Prop, "Controller",
                     Int_Widget => Slider,
                     Int_Min => 0, Int_Max => 127,
                     Int_Default => 0),
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
      Controller : MIDI.MIDI_Key := 0;
   end record;

end MIDI_Signal_Flow.Nodes.Channel.Send_CC;
