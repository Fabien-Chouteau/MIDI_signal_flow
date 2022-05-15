with MIDI_Signal_Flow.Graph; use MIDI_Signal_Flow.Graph;

generic
   Node_Name      : String;
package MIDI_Signal_Flow.Nodes.Input.Generic_Channel_Input is

   subtype Parent is MIDI_Signal_Flow.Graph.Node;
   type Node
   is new Parent with
   private;

   procedure Push (This : in out Node; Msg : MIDI.Message);

   overriding
   function Category (This : Node) return Category_Kind
   is (MIDI_Signal_Flow.Input);

   overriding
   function Name (This : Node) return String
   is (Node_Name);

   overriding
   function Out_Port_Info (This : Node; Port : Port_Id) return Port_Info
   is (case Port is
          when 0 =>  (7, Channel_Port, "Channel"),
          when others => Invalid_Port);

private

   type Node
   is new Parent with null record;

end MIDI_Signal_Flow.Nodes.Input.Generic_Channel_Input;
