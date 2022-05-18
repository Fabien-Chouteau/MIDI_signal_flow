with MIDI_Signal_Flow.Graph; use MIDI_Signal_Flow.Graph;

generic
   Node_Name : String;
   with function Op (A, B : MIDI.MIDI_Data) return MIDI.MIDI_Data;
package MIDI_Signal_Flow.Nodes.Data.Generic_Op is

   subtype Parent is MIDI_Signal_Flow.Graph.Node;
   type Node
   is new Parent with
   private;

   overriding
   function Category (This : Node) return Category_Kind
   is (MIDI_Signal_Flow.Data);

   overriding
   function Name (This : Node) return String
   is (Node_Name);

   overriding
   function In_Port_Info (This : Node;
                          Port : Port_Id)
                          return Port_Info
   is (case Port is
       when 0 =>  (1, Data_Port, "A"),
       when 1 =>  (1, Data_Port, "B"),
       when others => Invalid_Port);

   overriding
   function Out_Port_Info (This : Node;
                           Port : Port_Id)
                           return Port_Info
   is (case Port is
       when 0 =>  (6, Data_Port, "Result"),
       when others => Invalid_Port);

   overriding
   procedure Receive (This : in out Node;
                      Port :        Port_Id;
                      Data :        Link_Data);

private

   type Node
   is new Parent with record
      A, B : MIDI.MIDI_Data;

      Got_A, Got_B : Boolean := False;
   end record;

end MIDI_Signal_Flow.Nodes.Data.Generic_Op;
