--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: UnMute all track
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(Rmm)
   * Gave idea:   Archie(Rmm)
   * Extension:   Reaper 6.01+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.0 [25.01.20]
   *                  + initialе
--]]
    
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
    
    
    -------------------------------------------------------
    local function AnyTrackMute(proj);
        for i = 1,reaper.CountTracks(proj)do;
            local Track = reaper.GetTrack(proj,i-1);
            local mute = reaper.GetMediaTrackInfo_Value(Track,"B_MUTE");
            if mute > 0 then return true end;
        end;
        return false;
    end;
    -------------------------------------------------------
    
    
    
    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then no_undo() return end;
    
    
    local AnyTrMute = AnyTrackMute(0);
    if AnyTrMute then;
        reaper.Undo_BeginBlock();
        reaper.MuteAllTracks(0);
        reaper.Undo_EndBlock("UnMute all track",-1);
    end;
    
    
    
    if button_illum == 1 then;
    
        local _,_,sec,cmd,_,_,_ = reaper.get_action_context();
        local ProjtState2;
        
        local function loop();
            
            local ProjtState = reaper.GetProjectStateChangeCount(0);
            if ProjtState ~= ProjtState2 then;
                ProjtState2 = ProjtState;
            
                local Repeat_Off,Repeat_On,On; 
                local On = nil;
                local AnyTrMute = AnyTrackMute(0);
                if AnyTrMute then;
                    On = 1;
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