--[[
   * Category:    Track
   * Description: Remove from end of name of selected track _ARCHIVE
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Remove from end of name of selected track "_ARCHIVE"
   *              NOTE THE SETTINGS BELOW
   * О скрипте:   Удалить из конца имени выбранного трека _ARCHIVE
   *              ОБРАТИТЕ ВНИМАНИЕ НА НАСТРОЙКИ НИЖЕ
   * GIF:         http://clck.ru/Eexrt
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Supa75 (Rmm/forum)
   * Gave idea:   Supa75 (Rmm/forum)
   * Changelog:
   *              v. 1.0 [18.06.19]
   *                  + initialе / v.1.0

    -------------------------------------------
    SYSTEM REQUIREMENTS: / СИСТЕМНЫЕ ТРЕБОВАНИЯ:
    + Reaper v.5.962 + (and above |и выше)  http://www.reaper.fm/download.php
    -----------------------------------------------------------------------]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local RemoveFomNameOfTrack = "_ARCHIVE"
               -- ВВЕДИТЕ ЗНАЧЕНИЕ, КОТОРОЕ ВЫ ХОТИТЕ УДАЛИТЬ ИЗ КОНЦА ИМЕНИ ВЫБРАННОЙ ДОРОЖКИ
                                                         -------------------------------------
               -- ENTER THE VALUE YOU WANT TO DELETE FROM THE END OF THE NAME OF THE SELECTED TRACK
                  ---------------------------------------------------------------------------------



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo()return end;

    if not RemoveFomNameOfTrack then RemoveFomNameOfTrack = "_ARCHIVE" end;

    for i = CountSelTrack-1,0,-1 do;
        local SelTrack = reaper.GetSelectedTrack(0,i);
        local _,name = reaper.GetSetMediaTrackInfo_String(SelTrack,"P_NAME","",0);
        local nameX = name:gsub(RemoveFomNameOfTrack.."$","");
        reaper.GetSetMediaTrackInfo_String(SelTrack,"P_NAME",nameX,1);
    end;
    no_undo();