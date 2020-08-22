--[[
   * Category:    Track
   * Description: Add in end of name of selected track _ARCHIVE
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Add in end of name of selected track _ARCHIVE
   *              NOTE THE SETTINGS BELOW
   * О скрипте:   Добавить в конец имени выбранного трека _ARCHIVE
   *              ОБРАТИТЕ ВНИМАНИЕ НА НАСТРОЙКИ НИЖЕ
   * GIF:         http://clck.ru/Eexrt
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
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



    local AddToNameOfTrack = "_ARCHIVE"
               -- ВВЕДИТЕ ЗНАЧЕНИЕ КОТОРОЕ НУЖНО ДОПИСАТЬ К ИМЕНИ ВЫДЕЛЕННОГО ТРЕКА
                                                         ---------------------------
               -- ENTER THE VALUE YOU WANT TO APPEND TO THE NAME OF THE SELECTED TRACK
               -----------------------------------------------------------------------

    local DoNotAddToTrackNameIfEnd = "_ARCHIVE"
               -- ВВЕДИТЕ ТО ЗНАЧЕНИЕ,ПРИ СОДЕРЖАНИИ КОТОРОГО В КОНЦЕ ИМЕНИ ТРЕКА,
               --                              НЕ БУДЕТ ДОБАВЛЯТЬСЯ К ИМЕНИ ТРЕКА
                                               --------------------------------------
               -- ENTER THE VALUE IN THE CONTENT OF WHICH IS AT THE END OF THE TRACK NAME,
               --                                   WILL BE ADDED TO THE NAME OF THE TRACK
               ---------------------------------------------------------------------------



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo()return end;

    if not AddToNameOfTrack then AddToNameOfTrack = "_ARCHIVE" end;
    if not DoNotAddToTrackNameIfEnd then DoNotAddToTrackNameIfEnd = "AddToNameOfTrack" end;

    for i = CountSelTrack-1,0,-1 do;
        local SelTrack = reaper.GetSelectedTrack(0,i);
        local _,name = reaper.GetSetMediaTrackInfo_String(SelTrack,"P_NAME","",0);
        if not name:match(DoNotAddToTrackNameIfEnd.."$")then;
            reaper.GetSetMediaTrackInfo_String(SelTrack,"P_NAME",name..AddToNameOfTrack,1);
        end;
    end;
    no_undo();