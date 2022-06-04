package body MIDI_Signal_Flow.Nodes.Channel.Transpose_Octave is

   ------------------
   -- Set_Property --
   ------------------

   overriding
   procedure Set_Property (This : in out Node;
                           Id   :        Property_Id;
                           Val  :        Property_Value)
   is
   begin
      This.Shift := Val.Int_Val * 12;
   end Set_Property;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node;
                      Port :        Port_Id;
                      Data :        Link_Data)
   is
      New_Data : Link_Data := Data;
      Key      : Integer;
   begin
      if New_Data.Msg.Kind in Note_Off | Note_On | Aftertouch then
         Key := Integer (New_Data.Msg.Key);

         Key := Key + This.Shift;

         if Key <= Integer (MIDI_Key'First) then
            New_Data.Msg.Key := MIDI_Key'First;
         elsif Key >= Integer (MIDI_Key'Last) then
            New_Data.Msg.Key := MIDI_Key'Last;
         else
            New_Data.Msg.Key := MIDI_Key (Key);
         end if;
      end if;

      This.Send (0, New_Data);

   end Receive;

end MIDI_Signal_Flow.Nodes.Channel.Transpose_Octave;
