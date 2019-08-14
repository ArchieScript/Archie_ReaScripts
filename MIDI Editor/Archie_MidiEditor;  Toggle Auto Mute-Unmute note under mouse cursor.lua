--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    MIDI Editor
   * Description: Toggle Auto Mute-Unmute note under mouse cursor
   * Author:      Archie
   * Version:     1.0
   * AboutScript: ---
   * О скрипте:   Автоматического Включения - Отключения звука ноты под курсором мыши 
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
    (+) Arc_Function_lua v.2.4.8 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
    (+) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]] 
    
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.4.8",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    
    local function main();
        
        local JS_Mouse = reaper.JS_Mouse_GetState(1);
        if JS_Mouse ~= 1 then;
            
            local MIDIEditor = reaper.MIDIEditor_GetActive();
            if MIDIEditor then;
                local take = reaper.MIDIEditor_GetTake(MIDIEditor);
                
                local window, segment, details = reaper.BR_GetMouseCursorContext();
                if window == "midi_editor" and segment == "notes" then;
                    local noteRow = ({reaper.BR_GetMouseCursorContext_MIDI()})[3];
                    if noteRow >= 0 then;
                        local mouseTime = reaper.BR_GetMouseCursorContext_Position();
                        local ppqPosition = reaper.MIDI_GetPPQPosFromProjTime(take,mouseTime);
                        local retval,notecnt,ccevtcnt,textsyxevtcnt = reaper.MIDI_CountEvts(take);
                        if notecnt >= 0 then;
                            ------------
                            local Check;
                            for i = 1, notecnt do;
                                local  _,sel,muted,start_note,end_note,chan,pitch,vel = reaper.MIDI_GetNote(take,i-1);
                                if start_note < ppqPosition and end_note > ppqPosition and noteRow == pitch then;
                                    Check = 1;
                                    break;
                                end;
                            end;
                            if not Check then active = nil end;
                            ------------
                            if Check == 1 and not active then;
                                active = true;
                                for i = 1, notecnt do;
                                    local _,sel,muted,start_note,end_note,chan,pitch,vel = reaper.MIDI_GetNote(take,i-1);
                                    if start_note < ppqPosition and end_note > ppqPosition and noteRow == pitch then;
                                        if muted == false then;
                                            reaper.MIDI_SetNote(take,i-1,sel,true,start_note,end_note,chan,pitch,vel,false);
                                        else;
                                            reaper.MIDI_SetNote(take,i-1,sel,false,start_note,end_note,chan,pitch,vel,false);
                                        end;
                                    end;
                                end;
                            end;
                            ------------
                        end;
                    end;
                else;
                    active = nil;
                end;
            else;
                active = nil;
            end;
        end;
        --reaper.ShowConsoleMsg(1);
        reaper.defer(main);
    end;
    
    
    local function Exit();
        local _,_,sec,cmd,_,_,_ = reaper.get_action_context();
        reaper.SetToggleCommandState(sec,cmd,0);
        reaper.RefreshToolbar2(sec,cmd);
    end;
    
    
    Arc.js_ReaScriptAPI(true,0.99);
    Arc.HelpWindowWhenReRunning(1,"Arc_Function_lua",false); 
    
    local _,ScrP,sec,cmd,_,_,_ = reaper.get_action_context();
    reaper.SetToggleCommandState(sec,cmd,1);
    main();
    reaper.atexit(Exit);