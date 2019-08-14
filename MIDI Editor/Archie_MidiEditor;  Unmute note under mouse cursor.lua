--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    MIDI Editor
   * Description: Unmute note under mouse cursor
   * Author:      Archie
   * Version:     1.0
   * AboutScript: ---
   * О скрипте:   Включить звук ноты под курсором мыши 
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Antibio(Rmm)
   * Gave idea:   Antibio(Rmm)
   * Changelog:   v.1.0 [14.08.19]
   *                  + initialе

    -- Тест только на windows  /  Test only on windows.
    --=======================================================================================
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
    (+) - required for installation      | (+) - обязательно для установки
    (-) - not necessary for installation | (-) - не обязательно для установки
    -----------------------------------------------------------------------------------------
    (+) Reaper v.5.981 +            --| http://www.reaper.fm/download.php
    (+) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php
    (-) ReaPack v.1.2.2 +           --| http://reapack.com/repos
    (-) Arc_Function_lua v.2.4.4 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]] 
    
    
    
    
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
    
    
    for i = 1, notecnt do;
        local retval,selected,muted,startNote,endNote,chan,pitch,vel = reaper.MIDI_GetNote(take,i-1);
        if startNote < ppqPosition and endNote > ppqPosition and noteRow == pitch then;
            if muted == true then;
                reaper.MIDI_SetNote(take,i-1,selected,false,startNote,endNote,chan,pitch,vel,false);
            end;
            break;
        end;
    end;
    
    no_undo();
    reaper.UpdateArrange();