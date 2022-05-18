package body MIDI_Signal_Flow.Nodes.Utils.Volca_Sample is

   procedure Key_To_Chan (Key  :     MIDI_Key;
                          Chan : out MIDI_Channel;
                          Oct  : out Octaves)
   is
   begin
      case Key is
         when C1 .. A1 =>
            Oct := 1;
            Chan := MIDI_Channel (Key - C1);

         when C2 .. A2 =>
            Oct := 2;
            Chan := MIDI_Channel (Key - C2);

         when C3 .. A3 =>
            Oct := 3;
            Chan := MIDI_Channel (Key - C3);

         when C4 .. A4 =>
            Oct := 4;
            Chan := MIDI_Channel (Key - C4);

         when C5 .. A5 =>
            Oct := 5;
            Chan := MIDI_Channel (Key - C5);

         when C6 .. A6 =>
            Oct := 6;
            Chan := MIDI_Channel (Key - C6);

         when C7 .. A7 =>
            Oct := 7;
            Chan := MIDI_Channel (Key - C7);

         when C8 .. A8 =>
            Oct := 4;
            Chan := MIDI_Channel (Key - C8);
         when others =>
            Chan := MIDI_Channel'Last;
      end case;

   end Key_To_Chan;

      -------------
   -- Receive --
   -------------

   overriding
   procedure Receive (This : in out Node;
                      Port :        Port_Id;
                      Data :        Link_Data)
   is
      New_Data : Link_Data := Data;
      Oct : Octaves;
   begin
      case Data.Msg.Kind is
         when Note_On | Note_Off | Aftertouch =>

            Key_To_Chan (New_Data.Msg.Key, New_Data.Msg.Chan, Oct);

            if New_Data.Msg.Chan = MIDI_Channel'Last then
               --  Outside of supported notes
               return;
            end if;

            if Data.Msg.Kind = Note_On then
               This.Last_Chan := New_Data.Msg.Chan;

               --  Send velocity as level control
               This.Send (0, (Channel_Port,
                          (Kind => Continous_Controller,
                           Chan => This.Last_Chan,
                           Controller => 7,
                           Controller_Value => New_Data.Msg.Velocity)));

               --  Send pitch as speed control
               This.Send (0, (Channel_Port,
                          (Kind => Continous_Controller,
                           Chan => This.Last_Chan,
                           Controller => 43,
                           Controller_Value => (case Oct is
                                                   when 1 => 64 - 49,
                                                   when 2 => 64 - 49,
                                                   when 3 => 64 - 31,
                                                   when 4 => 64 + 00,
                                                   when 5 => 64 + 31,
                                                   when 6 => 64 + 49,
                                                   when 7 => 64 + 49,
                                                   when 8 => 64 + 49))));
            end if;

         when Continous_Controller | Patch_Change |
              Channel_Pressure | Pitch_Bend =>

            --  Messages that are dedicated to a single channel but not
            --  associated with a given key are sent to the last channel. This
            --  means that playing a key select a channel for CC message for
            --  instance.

            New_Data.Msg.Chan := This.Last_Chan;

         when Sys =>
            null;
      end case;

      This.Send (0, New_Data);
   end Receive;

end MIDI_Signal_Flow.Nodes.Utils.Volca_Sample;
