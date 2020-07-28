--[[
   * Category:    Track
   * Description: Copy selected track name
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Copy selected track name
   * О скрипте:   копировать название выбранной дорожки
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



    local SelTrack = reaper.GetSelectedTrack(0,0);
    if SelTrack == nil then no_undo()return end;

    reaper.DeleteExtState("Archie_Copy selected track name","NAME",false);

    local _,name = reaper.GetSetMediaTrackInfo_String(SelTrack,"P_NAME","",0);
    if name == "" then name = " " end;
    reaper.SetExtState("Archie_Copy selected track name","NAME",name,false);

    no_undo();