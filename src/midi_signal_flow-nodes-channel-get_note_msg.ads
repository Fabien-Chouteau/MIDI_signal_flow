with MIDI_Signal_Flow.Graph;

package MIDI_Signal_Flow.Nodes.Channel.Get_Note_Msg is

   subtype Parent is MIDI_Signal_Flow.Graph.Node;
   type Node
   is new Parent with
   private;

   overriding
   function Category (This : Node) return Category_Kind
   is (MIDI_Signal_Flow.Channel);

   overriding
   function Name (This : Node) return String
   is ("get_note_msg");

   overriding
   function In_Port_Info (This : Node;
                          Port : Port_Id)
                          return Port_Info
   is (case Port is
          when 0 => (7,  Channel_Port, "Channel"),
          when others => Invalid_Port);

   overriding
   function Out_Port_Info (This : Node;
                           Port : Port_Id)
                           return Port_Info
   is (case Port is
          when 0 => (3, Data_Port, "Key"),
          when 1 => (8, Data_Port, "Velocity"),
          when 2 => (7, Channel_Port, "Channel"),
          when others => Invalid_Port);

   overriding
   function Get_Property_Info (This : Node; Prop : Property_Id)
                               return Property_Info
   is (case Prop is
          when 0 => (7, Bool_Prop, "Note On",
                     Bool_Widget => Toggle,
                     Bool_Default => True),
          when 1 => (8, Bool_Prop, "Note Off",
                     Bool_Widget => Toggle,
                     Bool_Default => False),
          when 2 => (10, Bool_Prop, "Aftertouch",
                     Bool_Widget => Toggle,
                     Bool_Default => False),
          when 3 => (11, Bool_Prop, "Passthrough",
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
      Note_On     : Boolean := True;
      Note_Off    : Boolean := False;
      Aftertouch  : Boolean := False;
      Passthrough : Boolean := False;
   end record;

end MIDI_Signal_Flow.Nodes.Channel.Get_Note_Msg;
