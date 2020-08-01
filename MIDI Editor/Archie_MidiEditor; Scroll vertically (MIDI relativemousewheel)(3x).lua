--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    MidiEditor
   * Description: MidiEditor; Scroll vertically (MIDI relative/mousewheel)(3x).lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Changelog:   
   *              v.1.0 [250620]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local X = 3;
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end; 
    -------------------------------------------------------
    
    
    local MidiEditor = reaper.MIDIEditor_GetActive();
    if not MidiEditor then no_undo() return end;
    
    
    X = math.abs((tonumber(X)or 0));
    local _,_,_,_,_,_,val = reaper.get_action_context();
    if val > 0 then;
	   for i = 1, X do;
		  reaper.MIDIEditor_OnCommand(MidiEditor,40138);--View: Scroll view up
	   end;
    else;
	   for i = 1, X do;
		  reaper.MIDIEditor_OnCommand(MidiEditor,40139);--View: Scroll view down
	   end;
    end;
    
    no_undo();
    
    
    