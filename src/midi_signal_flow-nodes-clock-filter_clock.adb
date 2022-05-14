package body MIDI_Signal_Flow.Nodes.Clock.Filter_Clock is

   ------------------
   -- Set_Property --
   ------------------

   overriding
   procedure Set_Property (This : in out Node;
                           Id   :        Property_Id;
                           Val  :        Property_Value)
   is
   begin
      This.Passthrough := Val.Bool_Val;
   end Set_Property;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node; Port : Port_Id; Data : Link_Data)
   is
   begin
      if Data.Msg.Kind in MIDI.Sys then
         case Data.Msg.Cmd is
            when Timming_Tick =>
               This.Send (0, (Clock_Port, Tick));
               if This.Passthrough then
                  This.Send (1, Data);
               end if;

            when Start_Song =>
               This.Send (0, (Clock_Port, Start));
               if This.Passthrough then
                  This.Send (1, Data);
               end if;

            when Stop_Song =>
               This.Send (0, (Clock_Port, Stop));
               if This.Passthrough then
                  This.Send (1, Data);
               end if;

            when Continue_Song =>
               This.Send (0, (Clock_Port, Continue));
               if This.Passthrough then
                  This.Send (1, Data);
               end if;

            when others =>
               This.Send (1, Data);
         end case;
      else
         This.Send (1, Data);
      end if;
   end Receive;

end MIDI_Signal_Flow.Nodes.Clock.Filter_Clock;
