--[[
   * Category:    Track
   * Description: Paste selected track name
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Paste selected track name  
   * О скрипте:   вставить название выбранной дорожки
   * GIF:         http://clck.ru/Eey4e
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Supa75[RMM Forum] 
   * Gave idea:   Supa75[RMM Forum] 
   * Changelog:   + GIF      / v.1.01
                  + initialе / v.1.0 
--=============================================================
SYSTEM  REQUIREMENTS:  Reaper v.5.96 |  SWS v.2.9.7  (and above)
СИСТЕМНЫЕ ТРЕБОВАНИЯ:  Reaper v.5.96 |  SWS v.2.9.7     (и выше)
--============================================================]]




    --================================================================
    --/////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\
    --================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo()return end;
    
    
    local ExName = reaper.GetExtState("Archie_Copy selected track name","NAME");
    if ExName == "" or not ExName then no_undo()return end;
    if ExName == " " then ExName = "" end;
   
   
    for i = CountSelTrack-1,0,-1 do;
        local SelTrack = reaper.GetSelectedTrack(0,i);
        reaper.GetSetMediaTrackInfo_String(SelTrack,"P_NAME",ExName,1);
    end
    --reaper.DeleteExtState("Archie_Copy selected track name","NAME",false);
    no_undo();
   