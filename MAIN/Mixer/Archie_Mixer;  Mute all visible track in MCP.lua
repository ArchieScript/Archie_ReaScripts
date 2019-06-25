--[[
   * Category:    Mixer
   * Description: Mute all visible track in MCP
   * Author:      Archie
   * Version:     1.0
   * AboutScript: ---
   * О скрипте:   Отключить звук на всех видимых дорожках в MCP
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Krikets(Rmm)
   * Gave idea:   Krikets(Rmm)
   * Changelog:   
   *              v.1.0 [26.06.2019]
   *                  + initialе
    
    
    -- Тест только на windows  /  Test only on windows.
    --=======================================================================================
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
    (+) - required for installation      | (+) - обязательно для установки
    (-) - not necessary for installation | (-) - не обязательно для установки
    -----------------------------------------------------------------------------------------
    (+) Reaper v.5.978 +            --| http://www.reaper.fm/download.php
    (-) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php
    (-) ReaPack v.1.2.2 +           --| http://reapack.com/repos
    (-) Arc_Function_lua v.2.4.6 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]] 
    
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
  
    
    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then no_undo() return end;
    
    
    reaper.Undo_BeginBlock();
    
    for i = 1,CountTrack do;
        local Track = reaper.GetTrack(0,i-1);
        local Visible = reaper.IsTrackVisible(Track,true);
        if Visible then;
            local mute = reaper.GetMediaTrackInfo_Value(Track,"B_MUTE");
            if mute == 0 then;
                reaper.SetMediaTrackInfo_Value(Track,"B_MUTE",1);
            end;
        end;
    end;
    
    reaper.Undo_EndBlock("Mute all visible track in MCP",-1);