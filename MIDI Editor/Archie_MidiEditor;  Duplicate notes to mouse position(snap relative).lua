--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    MidiEditor
   * Description: Duplicate notes to mouse position(snap relative)
   * Author:      Archie
   * Version:     1.0
   * AboutScript: ---
   * О скрипте:   Дублирование нот в положение мыши(привязка относительно)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Antibio(Rmm)
   * Gave idea:   Antibio(Rmm)
   *              https://rmmedia.ru/threads/134701/post-2391494
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   v.1.0 [01.09.19]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    
    local MidiEditor = reaper.MIDIEditor_GetActive();
    if not MidiEditor then no_undo() return end;
    
    local take = reaper.MIDIEditor_GetTake(MidiEditor);
    
    local window, segment, details = reaper.BR_GetMouseCursorContext();
    if window ~= "midi_editor" or segment ~= "notes" then no_undo() return end;
    
    local mouseTime = reaper.BR_GetMouseCursorContext_Position();
    
    local _,notecnt,_,_ = reaper.MIDI_CountEvts(take);
    for i = 1, notecnt do;
	   local _,selected,_,startppqpos,_,_,_,_ = reaper.MIDI_GetNote(take,i-1);
	   if selected == true then posFirstNotePpq = startppqpos break end;
    end;
    
    if not posFirstNotePpq then no_undo() return end;
    
    local posFirstNoteTime = reaper.MIDI_GetProjTimeFromPPQPos(take,posFirstNotePpq);
    
    
    reaper.PreventUIRefresh(1);
    
    local GridM = select(1,reaper.MIDI_GetGrid(take))/4;
    local retval,Agrid,AswingOnOff,AswingShift = reaper.GetSetProjectGrid(0,0);
    reaper.GetSetProjectGrid(0,1,GridM,0,0);
    
    local posNoteStartGrid   = reaper.BR_GetPrevGridDivision(posFirstNoteTime+1e-11);
    local posMouseCursorGrid = reaper.BR_GetPrevGridDivision(mouseTime+1e-11);
    local Shift_value = (math.abs(posMouseCursorGrid-posNoteStartGrid));
    local Shift_valuePpq = reaper.MIDI_GetPPQPosFromProjTime(take,Shift_value);
    
    reaper.GetSetProjectGrid(0,1,Agrid,AswingOnOff,AswingShift);
    
    local noSortIn;
    if posMouseCursorGrid < posNoteStartGrid then;
	   
	   local _,notecnt,_,_ = reaper.MIDI_CountEvts(take);
	   for i = 1, notecnt do;
		  local retval,sel,mute,startppqpos,endppqpos,chan,pitch,vel = reaper.MIDI_GetNote(take,i-1);
		  if sel == true then;
			 if not noSortIn then;reaper.Undo_BeginBlock2(0);end;
			 noSortIn = true;
			 reaper.MIDI_SetNote(take,i-1,sel,mute,startppqpos-Shift_valuePpq,endppqpos-Shift_valuePpq,chan,pitch,vel,false);
		  end;
	   end;
	   
    elseif posMouseCursorGrid > posNoteStartGrid then;
	   
	   for i = notecnt-1,0,-1 do;
		  local retval,sel,mute,startppqpos,endppqpos,chan,pitch,vel = reaper.MIDI_GetNote(take,i);
		  if sel == true then;
			 if not noSortIn then;reaper.Undo_BeginBlock2(0);end;
			 noSortIn = true;
			 reaper.MIDI_SetNote(take,i,sel,mute,startppqpos+Shift_valuePpq,endppqpos+Shift_valuePpq,chan,pitch,vel,false);
		  end;
	   end;
    end;
    
    
    if noSortIn then;
	   reaper.MIDI_Sort(take);
	   reaper.Undo_EndBlock2(0,'Duplicate notes to mouse position(snap relative)',-1);
    else;
	   no_undo();
    end;
    
    reaper.PreventUIRefresh(-1);