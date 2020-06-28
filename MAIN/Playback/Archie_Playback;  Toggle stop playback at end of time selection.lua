--[[
   * Category:    Playback
   * Description: Toggle stop playback at the end of time selection
   * Author:      Archie
   * Version:     1.04
   * AboutScript: stop playback at the end of time selection
   * О скрипте:   остановить воспроизведения в конце выбора времени
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Supa75(RMM)
   * Gave idea:   Supa75(RMM)
   * Changelog:   +  Fixed paths for Mac/ v.1.03 [29.01.19] 
   *              +  Исправлены пути для Mac/ v.1.03 [29.01.19]  

   *              +  initialе / v.1.0 [22.01.2019]
   
   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.965 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.2.2 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




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
	




    local function SetToggleButtonOnOff(numb);
        local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context();
        reaper.SetToggleCommandState(sec,cmd,numb or 0);
        reaper.RefreshToolbar2(sec,cmd);
    end;

    Arc.HelpWindowWhenReRunning(1,14541,false);
    local Jump,Active = 9^99;
    local function loop();
         
        local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
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

    SetToggleButtonOnOff(1);
    loop();
    reaper.atexit(SetToggleButtonOnOff);