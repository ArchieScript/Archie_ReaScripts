--[[
   * Category:    Track
   * Description: Unsolo all visible track in TCP and MCP
   * Author:      Archie
   * Version:     1.0
   * AboutScript: ---
   * О скрипте:   ---
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
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local button_illum = 0
                    -- = 0 Отключить подсветку кнопки
                    -- = 1 включить подсветку кнопки **
                         ---------------------------
                    -- = 0 To disable the backlight buttons
                    -- = 1 to turn on the backlight button **
                    --------------------------------------
                    
                    -- ** При отключении скрипта появится окно "Reascript task control:"
                    --    Для коректной работы скрипта ставим галку(Remember my answer for this script)
                    --    Нажимаем: 'NEW INSTANCE
                          -----------------------
                    -- ** When you disable script window will appear (Reascript task controll,
                    --    For correct work of the script put the check
                    --    (Remember my answer for this script)
                    --    Click: NEW INSTANCE
                    -------------------------
                    
    
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
            local Visible = reaper.IsTrackVisible(Track,false);
            if Visible then;
                local solo = reaper.GetMediaTrackInfo_Value(Track,"I_SOLO");
                if solo > 0 then;
                    reaper.SetMediaTrackInfo_Value(Track,"I_SOLO",0);
                end;
            end;
        end;
    end;
    
    reaper.Undo_EndBlock("Unsolo all visible track in TCP and MCP",-1);
    
    ------------------------
    
    
    
    if button_illum == 1 then;
    
        local _,_,sec,cmd,_,_,_ = reaper.get_action_context();
        local ProjtState2;
        
        local function loop();
            
            local ProjtState = reaper.GetProjectStateChangeCount(0);
            if ProjtState ~= ProjtState2 then;
                ProjtState2 = ProjtState;
            
            
                local Repeat_Off,Repeat_On;
                local On = nil;
                for i = 1,reaper.CountTracks(0) do;
                    local Track = reaper.GetTrack(0,i-1);
                    local Visible = reaper.IsTrackVisible(Track,true);
                    if Visible then;
                        local Visible = reaper.IsTrackVisible(Track,false);
                        if Visible then;
                            local solo = reaper.GetMediaTrackInfo_Value(Track,"I_SOLO");
                            if solo > 0 then On = 1 break end;
                        end;
                    end;
                end;
                
                if On == 1 and not Repeat_On then;
                    reaper.SetToggleCommandState(sec,cmd,1);
                    reaper.RefreshToolbar2(sec,cmd);
                    Repeat_On = true;
                    Repeat_Off = nil;
                elseif not On and not Repeat_Off then;
                    reaper.SetToggleCommandState(sec,cmd,0);
                    reaper.RefreshToolbar2(sec,cmd);
                    Repeat_Off = true;
                    Repeat_On = nil;
                end;
                --t=(t or 0)+1
            end;
            reaper.defer(loop);
        end;
        loop();
    end;