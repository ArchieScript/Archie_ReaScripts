--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    MidiEditor
   * Description: Duplicate selected events to mouse position(snap relative)
   * Author:      Archie
   * Version:     1.02
   * AboutScript: ---
   * О скрипте:   Дублировать выбранные события(ноты) в положение мыши(привязка относительно)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Antibio(Rmm)
   * Gave idea:   Antibio(Rmm)
   *              https://rmmedia.ru/threads/134701/post-2391494
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.02 [16.09.19]
   *              Performance: Script completely rewritten
   
   *              v.1.01 [02.09.19]
   *              Bug fixed: Incorrect duplication when item not at beginning; / Undo action; 
   *              v.1.0 [01.09.19]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    
    -----------------------------------------------------------------------------------------
    -----------------------------------------------------------------------------------------  
    -- Author of function: MPL http://github.com/MichaelPilyavskiy/ReaScripts/blob/571c10a9c3b6d78dc454fd7f69ec8f40fb81d9c8/MIDI%20editor/mpl_Smart%20duplicate%20events.lua#L27
	 function ParseRAWMIDI(take)
		local data = {}
		local gotAllOK, MIDIstring = reaper.MIDI_GetAllEvts(take, "")
		if not gotAllOK then return end
		local s_unpack = string.unpack
		local s_pack   = string.pack
		local MIDIlen = MIDIstring:len()
		local idx = 0    
		local offset, flags, msg1
		local ppq_pos = 0
		local nextPos, prevPos = 1, 1 
		while nextPos <= MIDIlen do 
		    prevPos = nextPos
		    offset, flags, msg1, nextPos = s_unpack("i4Bs4", MIDIstring, prevPos)  
		    idx = idx + 1
		    ppq_pos = ppq_pos + offset
		    data[idx] = {rawevt = s_pack("i4Bs4", offset, flags , msg1),
						  offset=offset, 
						  flags=flags, 
						  selected =flags&1==1,
						  muted =flags&2==2,
						  msg1=msg1,
						  pitch=msg1:byte(2),--pitch
						  ppq_pos = ppq_pos,
						  isNoteOn =msg1:byte(1)>>4 == 0x9,
						  isNoteOff =msg1:byte(1)>>4 == 0x8,
						  isCC = msg1:byte(1)>>4 == 0xB,
						  chan = 1+(msg1:byte(1)&0xF),
						  vel=vel}
		end
		return data
	 end
    ----------------------------------------------------------------------------------------- 
    -----------------------------------------------------------------------------------------
    
    
    
    ----------------------------------------------------------------------------------------- 
	function AddShiftedSelectedEvents(take, data, ppq_shift,new_Pitch)
	  local str = ''
	  local last_ppq

	  for i = 1, #data-1 do      
	    local flag
	    if data[i].flags&1==1 then flag = data[i].flags-1 else flag = data[i].flags end
	    local str_per_msg = string.pack("i4Bs4", data[i].offset, flag , data[i].msg1)
	    str = str..str_per_msg
	    last_ppq = data[i].ppq_pos
	  end

	  for i = 1, #data-1 do   
		 if data[i].selected then
		 local newPitch = data[i].pitch + new_Pitch
		 local new_ppq = data[i].ppq_pos + ppq_shift
		 local str_per_msg = string.pack("i4Bi4BBB", new_ppq-last_ppq, data[i].flags, 3, data[i].msg1:byte(1), newPitch, data[i].msg1:byte(3))
		 --local str_per_msg = string.pack("i4Bs4", new_ppq-last_ppq, data[i].flags, data[i].msg1)--****
		 str = str..str_per_msg
		 last_ppq = new_ppq
	    end
	  end
	  
	  local noteoffoffs = data[#data].ppq_pos -last_ppq
	  if data[#data].ppq_pos < last_ppq then noteoffoffs = 1 end
	  str = str.. string.pack("i4Bs4", noteoffoffs, data[#data].flags , data[#data].msg1)
	  reaper.MIDI_SetAllEvts(take, str) 
	  
	  if data[#data].ppq_pos < last_ppq then return true, noteoffoffs + last_ppq  end
	end
    ----------------------------------------------------------------------------------------- 
    
    
    
    
    local MidiEditor = reaper.MIDIEditor_GetActive();
    if not MidiEditor then no_undo() return end;
    
    local take = reaper.MIDIEditor_GetTake(MidiEditor);
    
    local window, segment, details = reaper.BR_GetMouseCursorContext();
    if window ~= "midi_editor" or segment ~= "notes" then no_undo() return end;
    
    local mouseTime = reaper.BR_GetMouseCursorContext_Position();
    
    local noteRow = ({reaper.BR_GetMouseCursorContext_MIDI()})[3];
    if noteRow < 0 then no_undo() return end;
    
    local ParseMIDI = ParseRAWMIDI(take);
    
    local pitchFirstNote;
    for i = 1,#ParseMIDI do;
	   if ParseMIDI[i].selected == true then;
		  pitchFirstNote = ParseMIDI[i].pitch 
		  posFirstNotePpq = ParseMIDI[i].ppq_pos break;
	   end;  
    end;
    
    if not posFirstNotePpq then no_undo() return end;
    
    local shiftPitch = noteRow - pitchFirstNote;
    
    
    reaper.Undo_BeginBlock();
    
    local posFirstNoteTime = reaper.MIDI_GetProjTimeFromPPQPos(take,posFirstNotePpq);
    
    local item = reaper.GetMediaItemTake_Item(take);
    local posTake = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
    
    reaper.PreventUIRefresh(1);
    local GridM = select(1,reaper.MIDI_GetGrid(take))/4;
    local retval,Agrid,AswingOnOff,AswingShift = reaper.GetSetProjectGrid(0,0);
    reaper.GetSetProjectGrid(0,1,GridM,0,0);
    
    local posNoteStartGrid   = reaper.BR_GetPrevGridDivision(posFirstNoteTime+1e-11);
    local posMouseCursorGrid = reaper.BR_GetPrevGridDivision(mouseTime+1e-11);
    local Shift_value = ((posMouseCursorGrid-posNoteStartGrid)+posTake);
    local Shift_valuePpq = reaper.MIDI_GetPPQPosFromProjTime(take,Shift_value);
    
    reaper.GetSetProjectGrid(0,1,Agrid,AswingOnOff,AswingShift);
    
    reaper.PreventUIRefresh(1);
    
    
    AddShiftedSelectedEvents(take,ParseMIDI,Shift_valuePpq,shiftPitch);
    
    
    local item = reaper.GetMediaItemTake_Item(take);
    reaper.MarkTrackItemsDirty(reaper.GetMediaItemTake_Track(take),item);
    reaper.Undo_EndBlock('Duplicate selected events to mouse cursor(snap relative)',-1);