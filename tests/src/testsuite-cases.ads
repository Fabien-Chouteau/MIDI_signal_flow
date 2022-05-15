with Ada.Containers.Indefinite_Doubly_Linked_Lists;

with AAA.Strings;

package Testsuite.Cases is

   package Test_Cases_List
   is new Ada.Containers.Indefinite_Doubly_Linked_Lists
     (Element_Type => String);

   function Find_Cases return Test_Cases_List.List;

   function Run_Case (Dirname : String) return AAA.Strings.Vector;

   procedure Run_Cases (List : Test_Cases_List.List);

   procedure Print_LG_Definitions;

   procedure Print_Line (Str : String);
   function Get_Prints return AAA.Strings.Vector;
   procedure Reset_Prints;

end Testsuite.Cases;
