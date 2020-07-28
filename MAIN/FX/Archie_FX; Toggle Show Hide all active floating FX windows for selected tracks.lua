--[[ 
   * Category:    Fx 
   * Description: Toggle Show Hide all active floating FX windows for selected tracks 
   * Author:      Archie 
   * Version:     1.0 
   * AboutScript: Toggle Show Hide all active floating FX windows for selected tracks 
   * О скрипте:   Переключатель Показать Скрыть все активные плавающие окна FX для выбранных дорожек 
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    smrz1[RMM] 
   * Gave idea:   smrz1[RMM] 
   * Changelog:    
   *              +  initialе / v.1.0 [270219] 
   ========================================================================================== 
    
    
   --======================================================================================== 
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\ 
   ----------------------------------------------------------------------------------------|| 
   + Reaper v.5.967 +           --| http://www.reaper.fm/download.php                      || 
   + SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                 || 
   - ReaPack v.1.2.2 +          --| http://reapack.com/repos                               || 
   - Arc_Function_lua v.2.3.0 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc   || 
   - reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr   || 
                                                                    http://clck.ru/Eo5Lw   || 
   ? Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                  || 
   ----------------------------------------------------------------------------------------|| 
   --\\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// 
   ========================================================================================]] 
     
     
 
    --=========================================================================== 
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
    --=========================================================================== 
     
     
      
    ----------------------------------------------------------------------------- 
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end 
    ----------------------------------------------------------------------------- 
    
    
    local CountSeTrack = reaper.CountSelectedTracks(0); 
    local SelMastTrack = reaper.IsTrackSelected(reaper.GetMasterTrack(0)); 
    if CountSeTrack == 0 and not SelMastTrack then no_undo() return end; 
     
 
    reaper.PreventUIRefresh(1); 
    local track,OpenClose; 
    ::start:: 
    for i = 0,CountSeTrack do; 
        if i == 0 then; 
            track = reaper.GetMasterTrack(0); 
            local Sel = reaper.IsTrackSelected(track); 
            if not Sel then track = nil end; 
        else; 
            track = reaper.GetSelectedTrack(0,i-1); 
        end; 
        if track then; 
            local TrFxBypass = reaper.GetMediaTrackInfo_Value(track,"I_FXEN"); 
            if TrFxBypass == 1 then; 
                local FXCount = reaper.TrackFX_GetCount(track); 
                if FXCount > 0 then; 
                    for i2 = 1,FXCount do; 
                        local Offline = reaper.TrackFX_GetOffline(track,i2-1); 
                        if not Offline then; 
                            local bypass = reaper.TrackFX_GetEnabled(track,i2-1); 
                            if bypass then; 
                                ---- 
                                if not OpenClose then;   
                                    local Open = reaper.TrackFX_GetFloatingWindow(track,i2-1); 
                                    if Open then OpenClose = 2 goto start end; 
                                else; 
                                    reaper.TrackFX_Show(track,i2-1,OpenClose); 
                                end;  
                                ---- 
                            end; 
                        end; 
                    end; 
                end; 
                if i == CountSeTrack and not OpenClose then OpenClose = 3 goto start end; 
            end; 
        end; 
    end; 
    reaper.PreventUIRefresh(-1); 
    no_undo(); 