with MIDI_Signal_Flow.Graph;

package MIDI_Signal_Flow.Nodes.Utils.Volca_Sample is

   subtype Parent is MIDI_Signal_Flow.Graph.Node;
   type Node
   is new Parent with
   private;

   overriding
   function Category (This : Node) return Category_Kind
   is (MIDI_Signal_Flow.Utils);

   overriding
   function Name (This : Node) return String
   is ("volca_sample");

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
          when 0 => (5, Cable_Port, "Cable"),
          when others => Invalid_Port);

   overriding
   procedure Receive (This : in out Node;
                      Port :        Port_Id;
                      Data :        Link_Data);

private

   type Node
   is new Parent
   with record
      Last_Chan : MIDI_Channel := 0;
   end record;

end MIDI_Signal_Flow.Nodes.Utils.Volca_Sample;
