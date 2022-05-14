with HAL;  use HAL;
with MIDI; use MIDI;

package MIDI_Signal_Flow is

   type Port_Kind is (Data_Port, Channel_Port, Cable_Port, Clock_Port);
   type Category_Kind is (Input, Output, Cable, Channel, Clock, Data, Utils);

   type Clock_Event is (Tick, Start, Stop, Continue);

   type Link_Data (Kind : Port_Kind) is record
      case Kind is
         when Data_Port =>
            Data : MIDI.MIDI_Data;
         when Channel_Port | Cable_Port =>
            Msg : MIDI.Message;
         when Clock_Port =>
            Clock_Evt : Clock_Event;
      end case;
   end record;

   function Shape_For_Port (Kind : Port_Kind) return String
   is (case Kind is
          when Data_Port    => "ROUND_SHAPE",
          when Channel_Port => "ARROW_SHAPE",
          when Cable_Port   => "BOX_SHAPE",
          when Clock_Port   => "CARD_SHAPE");

   procedure Port_Value (Str     :     String;
                         K       : out Port_Kind;
                         Success : out Boolean);

   procedure Cat_Value (Str     :     String;
                        K       : out Category_Kind;
                        Success : out Boolean);

end MIDI_Signal_Flow;

