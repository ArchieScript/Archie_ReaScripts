--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    MidiEditor
   * Description: MidiEditor;  Move chords to grid while keeping lively(unevenness interval is 1/16).lua
   * Author:      Archie
   * Version:     1.0
   * О скрипте:   Переместите аккорды в сетку, сохраняя их живыми (интервал неравномерности 1/16)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Юрий Ключня(VK)$
   * Gave idea:   Юрий Ключня(VK)$
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [060620]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local INTERVAL = "1/16";
    
    
    local INVERT = false;
              -- = true;  инвертировать выделение
              -- = false; не инвертировать выделение
        
    
    local LEVEL_ON_NOTE = 0;
                     -- = 0 Ровнять аккорд по второй ноте
                     -- = 1 Ровнять аккорд по первой ноте
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    local UNDO_TITLE = "Move chords to grid while keeping lively(unevenness interval is "..(INTERVAL or '')..")";
    
    INTERVAL = tonumber((load('return '..(INTERVAL or ''))())or '') or error('INTERVAL nil');
    if INTERVAL <= 0 then INTERVAL = 0.000000001 end;
    
    -----
    local function SnapToGridMIDI(take,timeProj);
        local grid_ME,swing = reaper.MIDI_GetGrid(take);
        local item = reaper.GetMediaItemTakeInfo_Value(take,'P_ITEM');
        local itpos = reaper.GetMediaItemInfo_Value(item,'D_POSITION');
        local beats,_,_,tpos_beats = reaper.TimeMap2_timeToBeats(0,timeProj);
        local out_beatpos;
        if swing == 0 then;
           if(beats%grid_ME)<(grid_ME/2)then;
               out_beatpos=tpos_beats-(beats%grid_ME);
           else;
               out_beatpos=tpos_beats-(beats%grid_ME)+grid_ME;
           end;
           local out_pos = reaper.TimeMap2_beatsToTime(0,out_beatpos);
           local out_ppq = reaper.MIDI_GetPPQPosFromProjTime(take,out_pos);
           return out_pos,out_ppq;
        else;         
           local midival=0.5+0.25*swing;
           local checkval=0.5*(beats%(grid_ME*2))/grid_ME;
           if checkval<midival then;
               if checkval<0.5*midival then;
                   out_beatpos=tpos_beats-(beats%grid_ME);
               else;
                   if swing<0 then;
                       out_beatpos=tpos_beats-(beats%grid_ME)+grid_ME*midival*2;
                   else;
                       out_beatpos=tpos_beats-(beats%grid_ME)+grid_ME*swing/2;
                       if checkval%midival<0.5 then out_beatpos=out_beatpos+grid_ME end;
                   end;
               end;
           else;
               if checkval<midival+0.5*(1-midival)then;
                   out_beatpos=tpos_beats-(beats%grid_ME)+grid_ME*0.5*swing;
               else;
                   out_beatpos = tpos_beats-(beats%grid_ME)+grid_ME;
               end;
           end;
           local out_pos = reaper.TimeMap2_beatsToTime(0,out_beatpos);
           local out_ppq = reaper.MIDI_GetPPQPosFromProjTime(take,out_pos);
           return out_pos,out_ppq;
        end;
    end;
    -----
    
    
    -----
    local function print(value);
        reaper.ShowConsoleMsg(tostring(value).."\n");
    end;
    -----
    
    
    -----
    local function no_undo();
        reaper.defer(function()end);
    end;
    -----
    
    
    -----
    local editor = reaper.MIDIEditor_GetActive();
    if not editor then no_undo()return end;
    
    local UNSEL,shiftPrevNote,gridPos,shift,ppqInSec2;
    
    local take = reaper.MIDIEditor_GetTake(editor);
    
    local
    retval,count_notes,count_ccs,count_sysex = reaper.MIDI_CountEvts(take);
    
    
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    
    
    local tbl = {};
    for i = 1, count_notes do;
        local retval,sel,muted,startppq,endppq,chan,pitch,vel = reaper.MIDI_GetNote(take,0);
        tbl[#tbl+1] = {};
        tbl[#tbl].retval = retval;
        tbl[#tbl].sel = sel;
        tbl[#tbl].muted = muted;
        tbl[#tbl].startppq = startppq;
        tbl[#tbl].endppq = endppq;
        tbl[#tbl].chan = chan;
        tbl[#tbl].pitch= pitch;
        tbl[#tbl].vel = vel;
        reaper.MIDI_DeleteNote(take,0);
    end;
    
    
    
    for i = 1, #tbl do;
        local ppqInSec1 = reaper.MIDI_GetProjTimeFromPPQPos(take,tbl[i].startppq);
        if (ppqInSec1 and ppqInSec2) --[[and (ppqInSec1 ~= ppqInSec2)]] then;
            local INTSec = math.abs(ppqInSec1-ppqInSec2);
            INT_QN = reaper.TimeMap2_timeToQN(0,INTSec);
        end;
        
        if INT_QN and INT_QN < (4*INTERVAL) then;
            if not UNSEL then;
                for i2 = 1,#tbl do;tbl[i2].sel=false;end;
                UNSEL = true;
            end;
            if LEVEL_ON_NOTE == 1 then;
                ppqInSec1 = ppqInSec2;-- **1 *** считать с первой иначе последовательно ***
            end;
            ----
            
            if not gridPos then;
                local timeGrid,ppqGrid = SnapToGridMIDI(take,ppqInSec1);
                if LEVEL_ON_NOTE == 1 then;
                    shift = tbl[i-1].startppq-ppqGrid -- **1 по первой
                else;
                    shift = tbl[i].startppq-ppqGrid -- **2 по второй
                end;
                gridPos = true;
            end;
            
            shift = shift or 0;
            tbl[i].startppq = tbl[i].startppq-shift;
            tbl[i].endppq = tbl[i].endppq-shift;
            
            if not shiftPrevNote then;
                tbl[i-1].startppq = tbl[i-1].startppq-shift;
                tbl[i-1].endppq = tbl[i-1].endppq-shift;
                shiftPrevNote = true;
            end;
            ----
            tbl[i-1].sel = true;
            tbl[i].sel = true;
            if LEVEL_ON_NOTE ~= 1 then;
                ppqInSec1 = ppqInSec2;--**2 *** считать с первой иначе последовательно ***
            end;
        else;
            gridPos = nil;
            shift = 0;
            shiftPrevNote = nil;
        end;
        INTSec = nil;
        INT_QN = nil;
        ppqInSec2 = ppqInSec1;
    end;
    
    
    for i = 1, #tbl do;
        reaper.MIDI_InsertNote(take,
                               tbl[i].sel,
                            tbl[i].muted,
                         tbl[i].startppq,
                      tbl[i].endppq,
                   tbl[i].chan,
                tbl[i].pitch,
             tbl[i].vel,
        true);
    end;
    
    reaper.MIDI_Sort(take);
    
    if UNSEL == true and INVERT == true then;
        reaper.MIDIEditor_OnCommand(editor,40501);--INVERT
    end;
    
    
    reaper.Undo_EndBlock(UNDO_TITLE,-1);
    reaper.PreventUIRefresh(-1);