--[[
   * Category:    Track
   * Description: Toggle Mute Unmute all visible track in TCP
   * Author:      Archie
   * Version:     1.0
   * AboutScript: ---
   * О скрипте:   Переключатель Отключить Включить звук на всех видимых дорожках в TCP
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Krikets(Rmm)
   * Gave idea:   Krikets(Rmm)
   * Changelog:   
   *              v.1.01 [26.06.2019]
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
    (+) Arc_Function_lua v.2.4.6 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]] 
    
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
    
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.4.6",Fun,"")then Arc.no_undo() end;      --=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ============== 
    
    
    
    Arc.HelpWindowWhenReRunning(2,"Arc_Function_lua",false); 
    
    
    
    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then no_undo() return end;
    
    local mute;
    for i = 1,CountTrack do;
        local Track = reaper.GetTrack(0,i-1);
        local Visible = reaper.IsTrackVisible(Track,false);
        if Visible then;
            mute = reaper.GetMediaTrackInfo_Value(Track,"B_MUTE");
            break;
        end;
    end;
    
    
    for i = 1,CountTrack do;
        local Track = reaper.GetTrack(0,i-1);
        local Visible = reaper.IsTrackVisible(Track,false);
        if Visible then;
            reaper.SetMediaTrackInfo_Value(Track,"B_MUTE",math.abs(mute-1));
        end;
    end;
    
    
    
    local _,_,sec,cmd,_,_,_ = reaper.get_action_context();
    local ProjtState2;
    
    local function loop();
        
        local ProjtState = reaper.GetProjectStateChangeCount(0);
        if ProjtState ~= ProjtState2 then;
            ProjtState2 = ProjtState;
        
        
            local Repeat_Off,Repeat_On;
            local Off = nil;
            for i = 1,CountTrack do;
                local Track = reaper.GetTrack(0,i-1);
                local Visible = reaper.IsTrackVisible(Track,false);
                if Visible then;
                    mute = reaper.GetMediaTrackInfo_Value(Track,"B_MUTE");
                    if mute == 0 then Off = 1 break end;
                end;
            end;
            
            if Off == 1 and not Repeat_Off then;
                reaper.SetToggleCommandState(sec,cmd,0);
                reaper.RefreshToolbar2(sec,cmd);
                Repeat_Off = true;
                Off = nil;
                Repeat_On = nil;
            elseif not Off and not Repeat_On then;
                reaper.SetToggleCommandState(sec,cmd,1);
                reaper.RefreshToolbar2(sec,cmd);
                Repeat_On = true;
                Repeat_Off = nil;
            end;
            --t=(t or 0)+1
        end;
        reaper.defer(loop);
    end;
    
    
    loop();