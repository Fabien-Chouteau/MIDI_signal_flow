with HAL; use HAL;

package body MIDI_Signal_Flow.Nodes.Channel.Get_CC is

   ------------------
   -- Set_Property --
   ------------------

   overriding
   procedure Set_Property (This : in out Node;
                           Id   :        Property_Id;
                           Val  :        Property_Value)
   is
   begin
      case Id is
         when 0 =>
            This.Controller := MIDI_Data (Val.Int_Val);
         when 1 =>
            This.Passthrough := Val.Bool_Val;
         when others =>
            null;
      end case;
   end Set_Property;

   -------------
   -- Receive --
   -------------

   overriding
   procedure Receive
     (This : in out Node; Port : Port_Id; Data : Link_Data)
   is
   begin
      case Port is
         when 0 =>
            This.Controller := Data.Data;

         when 1 =>
            if Data.Msg.Kind = Continous_Controller
              and then
                Data.Msg.Controller = This.Controller
            then
               This.Send (0, (Data_Port, Data.Msg.Controller_Value));

               if This.Passthrough then
                  This.Send (1, Data);
               end if;

            else
               This.Send (1, Data);
            end if;

         when others =>
            null;
      end case;
   end Receive;

end MIDI_Signal_Flow.Nodes.Channel.Get_CC;
