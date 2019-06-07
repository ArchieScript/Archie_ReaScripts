--[[
   * Category:    Track
   * Description: Copy track icon
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Copy track icon  /  Archie_Track;  Paste icon selected tracks.lua
   * О скрипте:   Копировать иконку дорожки
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    YuriOl[RMM]
   * Gave idea:   YuriOl[RMM]
   * Changelog:   
   *              +  initialе / v.1.0 [07062019]
   
   
   -- Тест только на windows  /  Test only on windows.
   --=======================================================================================
	    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.975 +           --| http://www.reaper.fm/download.php                     
   (-) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                              
   (-) Arc_Function_lua v.2.4.4 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
   (-) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                
   =======================================================================================]] 
    
    
    
    
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
    end;
    
    no_undo();