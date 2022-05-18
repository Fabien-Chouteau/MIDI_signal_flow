package body MIDI_Signal_Flow.Nodes.Output.Print_Channel is

   CB : Put_Line_Callback := null;

   ------------------
   -- Set_Put_Line --
   ------------------

   procedure Set_Put_Line (CB : Put_Line_Callback) is
   begin
      Print_Channel.CB := CB;
   end Set_Put_Line;

   ------------------
   -- Set_Property --
   ------------------

   overriding
   procedure Set_Property (This : in out Node;
                           Id   :        Property_Id;
                           Val  :        Property_Value)
   is
   begin
      if Val.Str_Len <= This.Name'Length then
         This.Name (This.Name'First .. This.Name'First + Val.Str_Len - 1) :=
           Val.Str_Val;
         This.Len := Val.Str_Len;
      end if;
   end Set_Property;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node; Port : Port_Id; Data : Link_Data)
   is
      Name : constant String := This.Name
        (This.Name'First .. This.Name'First + This.Len - 1);
      Info : constant String := (if Name'Length /= 0
                                 then " (" & Name & ")"
                                 else "");

      Mod_Data : Link_Data := Data;
   begin
      if CB /= null then
         if Data.Msg.Kind = Sys then
            CB ("Invalid Channel msg" & Info & ": " &
                       MIDI.Img (Data.Msg));
         else
            Mod_Data.Msg.Chan := 0;
            CB ("Channel msg" & Info & ": " & MIDI.Img (Mod_Data.Msg));
         end if;
      end if;
   end Receive;

end MIDI_Signal_Flow.Nodes.Output.Print_Channel;
