package body MIDI_Signal_Flow.Nodes.Generic_Mixer is

   ------------------
   -- In_Port_Info --
   ------------------

   overriding
   function In_Port_Info (This : Node; Port : Port_Id) return Port_Info is
   begin
      if Port < Port_Id (This.Input_Count) then
         return (2, Mix_Port_Kind, "In");
      else
         return Invalid_Port;
      end if;
   end In_Port_Info;

   ------------------
   -- Set_Property --
   ------------------

   overriding
   procedure Set_Property (This : in out Node;
                           Id   :        Property_Id;
                           Val  :        Property_Value)
   is
   begin
      This.Input_Count := Val.Int_Val;
   end Set_Property;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node; Port : Port_Id; Data : Link_Data) is
   begin
      --  Send everything from all inputs got our single output
      This.Send (0, Data);
   end Receive;

end MIDI_Signal_Flow.Nodes.Generic_Mixer;
