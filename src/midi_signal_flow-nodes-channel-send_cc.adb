package body MIDI_Signal_Flow.Nodes.Channel.Send_CC is

   ------------------
   -- Set_Property --
   ------------------

   overriding
   procedure Set_Property (This : in out Node;
                           Id   :        Property_Id;
                           Val  :        Property_Value)
   is
   begin
      This.Controller := MIDI_Data (Val.Int_Val);
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
            This.Send (0, (Channel_Port,
                       Msg => (Continous_Controller,
                               0,
                               This.Controller,
                               Data.Data) ));
         when others =>
            null;
      end case;
   end Receive;

end MIDI_Signal_Flow.Nodes.Channel.Send_CC;
