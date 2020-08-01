--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   * 
   * Category:    MidiEditor
   * Description: MidiEditor; Velocity for note(mousewheel).lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [180520]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local VALUE = 1;
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    VALUE = math.abs(VALUE);
    local cur_editor = reaper.MIDIEditor_GetActive();
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context();
    if val < 0 then VALUE = VALUE-VALUE*2 end;
    if not cur_editor then return end;
    reaper.Undo_BeginBlock();
    local cur_take = reaper.MIDIEditor_GetTake(cur_editor);
    local _,_,_ = reaper.BR_GetMouseCursorContext();
    local _,_,noteRow,_,_,_ = reaper.BR_GetMouseCursorContext_MIDI();
    local mouse_time = reaper.BR_GetMouseCursorContext_Position();
    local mouse_ppq_pos = reaper.MIDI_GetPPQPosFromProjTime(cur_take,mouse_time);
    local notes,_,_ = reaper.MIDI_CountEvts(cur_take);
    for i = 0, notes - 1 do;
	   local retval,sel,mute,startppqpos,endppqpos,chan,pitch,vel = reaper.MIDI_GetNote(cur_take,i);
	   if startppqpos < mouse_ppq_pos and endppqpos > mouse_ppq_pos and noteRow == pitch then 
		  vel2 = vel+VALUE;
		  if vel2 <= 1 then vel2 = 1 end;
		  if vel2 >= 127 then vel2 = 127 end;
		  reaper.MIDI_SetNote(cur_take,i,sel,mute,startppqpos,endppqpos,chan,pitch,vel2,false);
		  break;
	   end;
    end;
    reaper.Undo_EndBlock("Velocity for note(mousewheel)",-1);
    
    