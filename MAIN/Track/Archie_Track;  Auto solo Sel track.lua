--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track;  Auto solo Sel track.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.12.0+ http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [130520]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --=========================================
    local ProjState2;
    local function ChangesInProject();
        local ret;
        local ProjState = reaper.GetProjectStateChangeCount(0);
        if not ProjState2 or ProjState2 ~= ProjState then ret = true end;
        ProjState2 = ProjState;
        return ret == true;
    end;
    --=========================================
    
    
    
    --=========================================   
    local function loop();
        local ProjStt = ChangesInProject();
        if ProjStt then;
            local countTrack = reaper.CountTracks(0);
            for i = 1, countTrack do;
                local track = reaper.GetTrack(0,i-1);
                local Solo = reaper.GetMediaTrackInfo_Value(track,"I_SOLO");
                local sel = reaper.IsTrackSelected(track);
                if sel == true then;
                    if Solo == 0 then;
                        reaper.SetMediaTrackInfo_Value(track,"I_SOLO",1);
                    end;
                else;
                    if Solo > 0 then;
                        reaper.SetMediaTrackInfo_Value(track,"I_SOLO",0);
                    end;
                end;
            end;
        end;
        reaper.defer(loop);
    end;
    --=========================================  
    
    
    --=========================================  
    local function SetToggleButtonOnOff(numb);
        local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context();
        reaper.SetToggleCommandState(sec,cmd,numb or 0);
        reaper.RefreshToolbar2(sec,cmd);
    end;
    --=========================================  
    
    
    reaper.defer(loop);
    SetToggleButtonOnOff(1);
    reaper.atexit(SetToggleButtonOnOff);
    
    
    
    