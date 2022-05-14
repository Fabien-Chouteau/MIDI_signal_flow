with HAL;

package body MIDI_Signal_Flow.Nodes.Channel.Keyboard_Split is

   ------------------
   -- Set_Property --
   ------------------

   overriding
   procedure Set_Property (This : in out Node;
                           Id   :        Property_Id;
                           Val  :        Property_Value)
   is
      use MIDI;
   begin
      This.Split_Key := MIDI_Data (Val.Int_Val);
   end Set_Property;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node; Port : Port_Id; Data : Link_Data)
   is
      use type HAL.UInt8;
      use MIDI;
   begin
      case Port is
         when 0 =>
            This.Split_Key := Data.Data;

         when 1 =>
            case Data.Msg.Kind is
            when Note_On | Note_Off | Aftertouch =>
               --  Send to either output depending on the key
               if Data.Msg.Key >= This.Split_Key then
                  This.Send (0, Data);
               else
                  This.Send (1, Data);
               end if;

            when others =>
               --  Any other message is broadcasted to both outputs
               This.Send (0, Data);
               This.Send (1, Data);
            end case;

         when others =>
            null;
      end case;
   end Receive;

end MIDI_Signal_Flow.Nodes.Channel.Keyboard_Split;
