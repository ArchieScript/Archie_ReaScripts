--[[
   * Category:    Track
   * Description: Track;  Cut track icon
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Cut track icon  /  Archie_Track;  Paste icon selected tracks.lua
   * О скрипте:   Вырезать иконку дорожки
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(RMM)
   * Gave idea:   Archie(RMM)
   * Changelog:   
   *              v.1.0 [040320]
   *                  initialе 
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    
    ---------------------------------------------------------
    local function no_undo();reaper.defer(function()end);end;
    ---------------------------------------------------------
    
    
    
    local Count = reaper.CountSelectedTracks(0);
    if Count == 0 then no_undo() return end;
    
    
    local section = "Archie_Track_CopyPasteTrackIcon";
    
    
    local icoTrack;
    local LastTouchedTrack = reaper.GetLastTouchedTrack();
    local sel = reaper.GetMediaTrackInfo_Value(LastTouchedTrack,"I_SELECTED");
    if sel == 1 then;
        icoTrack = LastTouchedTrack;
    else;
        icoTrack = reaper.GetSelectedTrack(0,0);
    end;
    
    
    local retval,stringNeedBig = reaper.GetSetMediaTrackInfo_String(icoTrack,"P_ICON",0,0);
    
    reaper.DeleteExtState(section,"path",false);
    
    if stringNeedBig ~= "" then;
        reaper.SetExtState(section,"path",stringNeedBig,false);
        reaper.GetSetMediaTrackInfo_String(icoTrack,"P_ICON","",1); 
    end;
    
    no_undo();
    
    
    
    