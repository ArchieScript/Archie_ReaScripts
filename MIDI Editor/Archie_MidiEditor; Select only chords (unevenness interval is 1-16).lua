--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    MidiEditor
   * Description: MidiEditor; Select only chords (unevenness interval is 1/16).lua
   * Author:      Archie
   * Version:     1.0
   * О скрипте:   Выберите только аккорды (интервал неравномерности 1/16)
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
        
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    local UNDO_TITLE = "Select only chords (unevenness interval is "..(INTERVAL or '')..")";
    
    INTERVAL = tonumber((load('return '..(INTERVAL or ''))())or '') or error('INTERVAL nil');
    if INTERVAL <= 0 then INTERVAL = 0.000000001 end;
    
    
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
    
    local UNSEL,ppqInSec2;
    
    local take = reaper.MIDIEditor_GetTake(editor);
    
    local
    retval,count_notes,count_ccs,count_sysex = reaper.MIDI_CountEvts(take);
    
    
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    
    
    local tbl={};
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
            ppqInSec1 = ppqInSec2;--*** считать с первой иначе последовательно ***
            ----
            tbl[i-1].sel = true;
            tbl[i].sel = true;
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
    
    
    
    
    