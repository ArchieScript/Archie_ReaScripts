--[[
   * Category:    Track
   * Description: Activate-Deactivate rec-armed rec-monitoring all input-Fx in selected tracks
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Activate-Deactivate rec-armed rec-monitoring all input-Fx in selected tracks
   * О скрипте:   ---
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Maestro Sound[RMM]
   * Gave idea:   Maestro Sound[RMM]
   * Changelog:   
   *              +  initialе / v.1.0 [02032019]


   --========================================================================================
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\
   \/--------------------------------------------------------------------------------------||
   + Reaper v.5.967 +           --| http://www.reaper.fm/download.php                      ||
   - SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                 ||
   - ReaPack v.1.2.2 +          --| http://reapack.com/repos                               ||
   - Arc_Function_lua v.2.3.0 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc   ||
   - reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr   ||
                                                                    http://clck.ru/Eo5Lw   ||
   - Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                  ||
   ----------------------------------------------------------------------------------------||
   --\\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: /////
   ========================================================================================]]



    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local DeactivateFx =  2
                     -- = 0 | НЕ ДЕАКТИВИРОВАТЬ FX
                     -- = 1 | ДЕАКТИВИРОВАТЬ В ОБХОД 
                     -- = 2 | ДЕАКТИВИРОВАТЬ В АВТОНОМНЫЙ РЕЖИМ
                             ----------------------------------
                     -- = 0 | NOT DEACTIVATE FX
                     -- = 1 | DEACTIVATE IN BYPASS
                     -- = 2 | DEACTIVATE IN OFFLINE
                     ------------------------------
                     
                     

   --======================================================================================
   --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
   --====================================================================================== 
   
   
   
   
    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------
    
    

    local CountSelTrack = reaper.CountSelectedTracks();
    if CountSelTrack == 0 then no_undo()return end;
    
    
    local i, record, Undo;
    repeat;
        i = (i or 0) + 1;
        local selTrack = reaper.GetSelectedTrack(0,i-1);
        if selTrack then;
            local recArm = reaper.GetMediaTrackInfo_Value(selTrack,"I_RECARM");
            if recArm == 0 then;
                record = 0;
            end;
        end;
    until not selTrack;
    
  
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
  
    local InFx,i = 0x1000000;
    repeat;
        i = (i or 0) + 1;
        local selTrack = reaper.GetSelectedTrack(0,i-1);
        if selTrack then;
            local CountInpFX = reaper.TrackFX_GetRecCount(selTrack);
            if record == 0 then;
                reaper.SetMediaTrackInfo_Value(selTrack,"I_RECARM",1);
                reaper.SetMediaTrackInfo_Value(selTrack,"I_RECMON",1);
                for i2 = 1,CountInpFX do; 
                    if reaper.TrackFX_GetOffline(selTrack,InFx+i2-1)then;
                        reaper.TrackFX_SetOffline(selTrack,InFx+i2-1,0);
                    end;
                    if not reaper.TrackFX_GetEnabled(selTrack,InFx+i2-1)then;
                        reaper.TrackFX_SetEnabled(selTrack, InFx+i2-1,1);
                    end;
                end;
            else;  
                reaper.SetMediaTrackInfo_Value(selTrack,"I_RECARM",0);
                reaper.SetMediaTrackInfo_Value(selTrack,"I_RECMON",0);
                if DeactivateFx > 0 then;
                    for i2 = 1,CountInpFX do; 
                        if DeactivateFx == 1 then;
                            if reaper.TrackFX_GetEnabled(selTrack,InFx+i2-1)then;
                                reaper.TrackFX_SetEnabled(selTrack, InFx+i2-1,0);
                            end; 
                        elseif DeactivateFx > 1 then;
                            if not reaper.TrackFX_GetOffline(selTrack,InFx+i2-1)then;
                                reaper.TrackFX_SetOffline(selTrack,InFx+i2-1,1);
                            end;
                        end;
                    end;
                end;   
            end;    
        end;
    until not selTrack;

    if record == 0 then;
        Undo = "Activate";
    else;
        Undo = "Deactivate";
    end;    
      
    reaper.PreventUIRefresh(-1); 
    reaper.Undo_EndBlock(Undo.." rec-armed,rec-monitoring,all input-Fx in selected tracks",-1);