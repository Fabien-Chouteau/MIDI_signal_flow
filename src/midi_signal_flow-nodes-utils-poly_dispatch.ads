with MIDI_Signal_Flow.Graph;
with HAL;

package MIDI_Signal_Flow.Nodes.Utils.Poly_Dispatch is

   Default_Poly_Voices : constant := 2;
   Max_Poly_Voices : constant := 10;

   subtype Parent is MIDI_Signal_Flow.Graph.Node;
   type Node
   is new Parent with
   private;

   overriding
   function Category (This : Node) return Category_Kind
   is (MIDI_Signal_Flow.Utils);

   overriding
   function Name (This : Node) return String
   is ("poly_dispatch");

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
                           return Port_Info;

   overriding
   function Get_Property_Info (This : Node; Prop : Property_Id)
                               return Property_Info
   is (case Prop is
          when 0 => (6, Int_Prop, "voices",
                     Int_Widget => Output_Clones,
                     Int_Min => 1, Int_Max => Max_Poly_Voices,
                     Int_Default => Default_Poly_Voices),
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

   type Voice is record
      Last_Key : MIDI.MIDI_Key := 0;
      Last_Time_On  : HAL.UInt32 := 0;
   end record;

   type Voice_Array is array (0 .. Max_Poly_Voices - 1) of Voice;

   type Node
   is new Parent
   with record
      Voices : Voice_Array;
      Voices_Count : Positive := Default_Poly_Voices;
      Evt_Count : HAL.UInt32 := 0;
   end record;

end MIDI_Signal_Flow.Nodes.Utils.Poly_Dispatch;
