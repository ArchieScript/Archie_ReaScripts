--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Show hide Media explorer FX browser Track manager Region-marker manager
   * Author:      Archie
   * Version:     1.03
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Snjuk(Rmm) http://rmmedia.ru/threads/134701/post-2403405
   * Gave idea:   Snjuk(Rmm)
   * Changelog:   
   *              v.1.03 [13.10.19]
   *                  -----
   
   *              v.1.01 [10.10.19]
   *                  + The closure of the dock (Performance degradation):(
   *              v.1.0 [10.10.19]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    local
    Window = {
              "Show_FXBrowser"       ,
              "Show_TrackManager"    ,
              "Show_RegionMarker"    ,
              --"Show_PerformanceMeter",
              "Media_Explorer"       , 
              --"Mixer_Visible"        ,  
              --"Show_Project_bay" 
              }
    
    
    
    
    local
    Focus_Reaper = 0
    
    
    local MediaExplorer = reaper.GetToggleCommandStateEx(0,50124);
    local ShowFXBrowser = reaper.GetToggleCommandStateEx(0,40271);
    local ShowTrackMana = reaper.GetToggleCommandStateEx(0,40906);
    local ShowRegioMark = reaper.GetToggleCommandStateEx(0,40326);
    local ShowPerfMeter = reaper.GetToggleCommandStateEx(0,40240);
    local MixerVisible  = reaper.GetToggleCommandStateEx(0,40078);
    local ShowProjectBay= reaper.GetToggleCommandStateEx(0,41157);
    
    if MediaExplorer == 1 or ShowFXBrowser == 1 or ShowTrackMana == 1 or ShowRegioMark == 1 then;
        
        for i = 1, #Window do
            
            --Двойное нажатие из-за не работы в доке
            if Window[i] == "Media_Explorer" then;
                reaper.Main_OnCommand(50124,0);
                local MediaExplorer = reaper.GetToggleCommandStateEx(0,50124);
                if MediaExplorer == 1 then;
                    reaper.Main_OnCommand(50124,0);
                end;
            end;
            
            if Window[i] == "Show_FXBrowser" then;
                reaper.Main_OnCommand(40271,0);
                local ShowFXBrowser = reaper.GetToggleCommandStateEx(0,40271);
                if ShowFXBrowser == 1 then;
                    reaper.Main_OnCommand(40271,0);
                end;
            end;
            
            if Window[i] == "Show_TrackManager" then;
                reaper.Main_OnCommand(40906,0);
                local ShowTrackMana = reaper.GetToggleCommandStateEx(0,40906);
                if ShowTrackMana == 1 then;
                    reaper.Main_OnCommand(40906,0);
                end;
            end;
            
            if Window[i] == "Show_RegionMarker" then;
                reaper.Main_OnCommand(40326,0);
                local ShowRegioMark = reaper.GetToggleCommandStateEx(0,40326);
                if ShowRegioMark == 1 then;
                    reaper.Main_OnCommand(40326,0);
                end;
            end;
            
            if Window[i] == "Show_PerformanceMeter" then;
                reaper.Main_OnCommand(40240,0);
                local ShowPerfMeter = reaper.GetToggleCommandStateEx(0,40240);
                if ShowPerfMeter == 1 then;
                    reaper.Main_OnCommand(40240,0);
                end;
            end;
            
            if Window[i] == "Mixer_Visible" then;
                reaper.Main_OnCommand(40078,0);
                local MixerVisible  = reaper.GetToggleCommandStateEx(0,40078);
                if MixerVisible == 1 then;
                    reaper.Main_OnCommand(40078,0);
                end;
            end;
            
            if Window[i] == "Show_Project_bay" then;
                reaper.Main_OnCommand(41157,0);
                local ShowProjectBay= reaper.GetToggleCommandStateEx(0,41157);
                if ShowProjectBay == 1 then;
                    reaper.Main_OnCommand(41157,0);
                end;
            end;
            
        end;
        
    else;
        
        for i = 1, #Window do
        
            if ShowFXBrowser == 0 and Window[i] == "Show_FXBrowser" then;
                reaper.Main_OnCommand(40271,0);
            end;
            if ShowTrackMana == 0 and Window[i] == "Show_TrackManager" then;
                reaper.Main_OnCommand(40906,0);
            end;
            if ShowRegioMark == 0 and Window[i] == "Show_RegionMarker" then;
                reaper.Main_OnCommand(40326,0);
            end;
            if MediaExplorer == 0 and Window[i] == "Media_Explorer" then;
                reaper.Main_OnCommand(50124,0);
            end;
            if ShowPerfMeter == 0 and Window[i] == "Show_PerformanceMeter" then;
                reaper.Main_OnCommand(40240,0);
            end;
            if MixerVisible == 0 and Window[i] == "Mixer_Visible" then;
                reaper.Main_OnCommand(40078,0);
            end;
            if ShowProjectBay == 0 and Window[i] == "Show_Project_bay" then;
                reaper.Main_OnCommand(41157,0);
            end;
            
        end;
        
        if Focus_Reaper == 1 then;
            local Context2 = reaper.GetCursorContext2(true);
            if Context2 == 2 then envIn = reaper.GetSelectedTrackEnvelope(0) else envIn = nil end;
            reaper.SetCursorContext(Context2,envIn);
        end;
        
    end;
    
    no_undo();