with MIDI_Signal_Flow.Graph;

package MIDI_Signal_Flow.Nodes.Channel.Transpose_Octave is

   subtype Parent is MIDI_Signal_Flow.Graph.Node;
   type Node
   is new Parent with
   private;

   overriding
   function Category (This : Node) return Category_Kind
   is (MIDI_Signal_Flow.Channel);

   overriding
   function Name (This : Node) return String
   is ("transpose_octave");

   overriding
   function In_Port_Info (This : Node;
                          Port : Port_Id)
                          return Port_Info
   is (case Port is
          when 0 => (7, Channel_Port, "Channel"),
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
          when 0 => (6, Int_Prop, "octave",
                     Int_Widget => Combo,
                     Int_Min => -5, Int_Max => 5,
                     Int_Default => 1),
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
      Shift : Integer := 0;
   end record;

end MIDI_Signal_Flow.Nodes.Channel.Transpose_Octave;
