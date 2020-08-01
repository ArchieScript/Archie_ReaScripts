--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    MIDI Editor
   * Description: MIDI Editor; Velocity note under mouse cursor (mouse wheel).lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Supa75 - (Rmm)
   * Gave idea:   Supa75 - (Rmm)
   * Extension:   Reaper 6.07+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   v.1.0 [040420]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    ---------------------------------------------------------
    local function no_undo(); reaper.defer(function()end)end;
    ---------------------------------------------------------
    
    
    local MIDIEditor = reaper.MIDIEditor_GetActive();
    if not MIDIEditor then no_undo() return end;
    local take = reaper.MIDIEditor_GetTake(MIDIEditor);
    
    
    local window, segment, details = reaper.BR_GetMouseCursorContext();
    if window ~= "midi_editor" and segment ~= "notes" then no_undo() return end;
    
    
    local noteRow = ({reaper.BR_GetMouseCursorContext_MIDI()})[3];
    if noteRow < 0 then no_undo() return end;
    
    
    local mouseTime = reaper.BR_GetMouseCursorContext_Position();
    local ppqPosition = reaper.MIDI_GetPPQPosFromProjTime(take,mouseTime);
    
    
    local retval,notecnt,ccevtcnt,textsyxevtcnt = reaper.MIDI_CountEvts(take);
    if notecnt == 0 then no_undo() return end;
    
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context();
    
    for i = 1, notecnt do;
        local retval,selected,muted,startNote,endNote,chan,pitch,vel = reaper.MIDI_GetNote(take,i-1);
        if startNote < ppqPosition and endNote > ppqPosition and noteRow == pitch then;
            
            if val > 0 then;
                vel = vel+1;
                if vel > 127 then vel = 127 end;
            else;
                vel = vel-1;
                if vel < 0 then vel = 0 end;
            end;
            reaper.MIDI_SetNote(take,i-1,selected,muted,startNote,endNote,chan,pitch,vel,false);
            
            break;
        end;
    end;
    
    no_undo();
    reaper.UpdateArrange();
    
    
    
    