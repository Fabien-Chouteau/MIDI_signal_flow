
package MIDI_Signal_Flow.Nodes.Clock.Filter_Clock is

   subtype Parent is MIDI_Signal_Flow.Graph.Node;
   type Node
   is new Parent with
   private;

   overriding
   function Category (This : Node) return Category_Kind
   is (MIDI_Signal_Flow.Clock);

   overriding
   function Name (This : Node) return String
   is ("filter_clock");

   overriding
   function In_Port_Info (This : Node;
                          Port : Port_Id)
                          return Port_Info
   is (case Port is
          when 0 => (5, Cable_Port, "Cable"),
          when others => Invalid_Port);

   overriding
   function Out_Port_Info (This : Node;
                           Port : Port_Id)
                           return Port_Info
   is (case Port is
          when 0 => (5, Clock_Port, "Clock"),
          when 1 => (5, Cable_Port, "Cable"),
          when others => Invalid_Port);

   overriding
   function Get_Property_Info (This : Node; Prop : Property_Id)
                               return Property_Info
   is (case Prop is
          when 0 => (11, Bool_Prop, "passthrough",
                     Bool_Widget => Toggle,
                     Bool_Default => False),
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
      Passthrough : Boolean := False;
   end record;

end MIDI_Signal_Flow.Nodes.Clock.Filter_Clock;
