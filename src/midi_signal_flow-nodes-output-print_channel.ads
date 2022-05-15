with MIDI_Signal_Flow.Graph;

package MIDI_Signal_Flow.Nodes.Output.Print_Channel is

   subtype Parent is MIDI_Signal_Flow.Graph.Node;

   type Node
   is new Parent with
   private;

   procedure Set_Put_Line (This : in out Node;
                           CB   :        Put_Line_Callback);

   overriding
   function Category (This : Node) return Category_Kind
   is (MIDI_Signal_Flow.Output);

   overriding
   function Name (This : Node) return String
   is ("print_channel");

   overriding
   function In_Port_Info (This : Node; Port : Port_Id) return Port_Info
   is (case Port is
          when 0 =>  (2, Channel_Port, "In"),
          when others => Invalid_Port);

   overriding
   procedure Receive (This : in out Node;
                      Port :        Port_Id;
                      Data :        Link_Data);

private

   type Node
   is new Parent with record
      CB : Put_Line_Callback := null;
   end record;

end MIDI_Signal_Flow.Nodes.Output.Print_Channel;
