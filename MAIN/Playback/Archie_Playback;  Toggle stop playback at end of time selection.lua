--[[
   * Category:    Playback
   * Description: Toggle stop playback at the end of time selection
   * Author:      Archie
   * Version:     1.01
   * AboutScript: stop playback at the end of time selection
   * О скрипте:   остановить воспроизведения в конце выбора времени
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Supa75(RMM)
   * Gave idea:   Supa75(RMM)
   * Changelog:   +  initialе / v.1.0 [22.01.2019]
   
   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.1.8 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
   --========================================================================================]]




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --======================================= FUNCTION MODULE FUNCTION =============================================================
    local Path,Mod,T,Way = reaper.GetResourcePath()--================== FUNCTION MODULE FUNCTION ===================================
    T = {Path..'\\Scripts\\Archie-ReaScripts\\Functions',(select(2,reaper.get_action_context()):match("(.+)[\\]")),Path};--=========
    for i=1,#T do;for j=0,math.huge do;Mod=reaper.EnumerateFiles(T[i],j);--=========================================================
        if Mod=="Arc_Function_lua.lua"then Way=T[i]break end;if not Mod then break end;end;if Way then break end;--=================
    end;if not Way then reaper.MB ('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in \n'..T[1]
    ..'\n\nОтсутствует файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..T[1],"Error.",0)else;--
    package.path = package.path..";"..Way.."/?.lua";Arc=require"Arc_Function_lua";Arc.VersionArc_Function_lua("2.1.8",Way,"")end;---
    --=========================================================================================================▲▲▲▲▲================




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