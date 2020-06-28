--[[        TERMINATE INSTANCES
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Playback
   * Description: Playback;  stop playback at the end of time selection.lua
   * Author:      Archie
   * Version:     1.05
   * О скрипте:   остановить воспроизведения в конце выбора времени
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Supa75(RMM)
   * Gave idea:   Supa75(RMM)
   * Provides:
   * Extension:   Reaper 6.12+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.8.5+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.0 [220119]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
    
    
     
    local Jump,Active = 9^99;
    local function loop();
        
        local startLoop,endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
        if startLoop ~= endLoop then;
            
            if not Active then;    
                local PlayState = reaper.GetPlayState();
                local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
                local PlayPos = reaper.GetPlayPosition ();
                if PlayState == 1 or PlayState >= 4 then;
                    if PlayPos < endLoop then;
                        Active = "Active";
                    end;
                end;
            end;
            
            if Active then;
                 local PlayState = reaper.GetPlayState();
                 local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
                 local PlayPos = reaper.GetPlayPosition();
                 if PlayPos > Jump+1 then Active = nil end;
                 Jump = PlayPos;
                 if Active then;
                    local Repeat = reaper.GetSetRepeat(-1);
                    if Repeat ~= 0 then minus = 0.05 else minus = 0 end;
                    if PlayState >= 4 then PlayState = 1 end;
                    if PlayPos >= endLoop-minus or PlayState ~= 1 then;
                        reaper.OnStopButton();
                        Active = nil;
                    end;
                end;
            end;
        end;
        reaper.defer(loop);
    end;
    
    
    Arc.SetToggleButtonOnOff(1,1);
    loop();
    reaper.atexit(function()Arc.SetToggleButtonOnOff(0,1)end);
    
    
    ---------------------
    reaper.defer(function();local ScrPath,ScrName = debug.getinfo(1,'S').source:match('^[@](.+)[/\\](.+)');Arc.GetSetTerminateAllInstancesOrStartNewOneKB_ini(1,260,ScrPath,ScrName)end);
    
    
    