package body MIDI_Signal_Flow is

   ----------------
   -- Port_Value --
   ----------------

   procedure Port_Value (Str     :     String;
                         K       : out Port_Kind;
                         Success : out Boolean)
   is
   begin
      if Str = "DATA_PORT" then
         K := Data_Port;
         Success := True;
      elsif Str = "CHANNEL_PORT" then
         K := Data_Port;
         Success := True;
      elsif Str = "CABLE_PORT" then
         K := Data_Port;
         Success := True;
      else
         Success := False;
      end if;
   end Port_Value;

   ---------------
   -- Cat_Value --
   ---------------

   procedure Cat_Value (Str     :     String;
                        K       : out Category_Kind;
                        Success : out Boolean)
   is
   begin
      if Str = "INPUT" then
         K := Input;
         Success := True;
      elsif Str = "OUTPUT" then
         K := Output;
         Success := True;
      elsif Str = "CABLE" then
         K := Cable;
         Success := True;
      elsif Str = "CHANNEL" then
         K := Channel;
         Success := True;
      elsif Str = "DATA" then
         K := Data;
         Success := True;
      elsif Str = "UTILS" then
         K := Utils;
         Success := True;
      else
         Success := False;
      end if;
   end Cat_Value;

end MIDI_Signal_Flow;
