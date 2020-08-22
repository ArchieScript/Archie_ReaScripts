--[[
   * Category:    Track
   * Description: Select tracks that have at end of name _ARCHIVE
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Select tracks that have at end of name _ARCHIVE
   *              NOTE THE SETTINGS BELOW
   * О скрипте:   Выберите треки, которые имеют в конце названия _ARCHIVE
   *              ОБРАТИТЕ ВНИМАНИЕ НА НАСТРОЙКИ НИЖЕ
   * GIF:         http://clck.ru/Eeye5
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Supa75 (Rmm/forum)
   * Gave idea:   Supa75 (Rmm/forum)
   * Changelog:
   *              v.1.0[18.06.19]
   *                  + initialе / v.1.0

    SYSTEM REQUIREMENTS: / СИСТЕМНЫЕ ТРЕБОВАНИЯ:
   + Reaper v.5.962 + and above |и выше  http://www.reaper.fm/download.php
   --===================================================================]]



    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local EndOfTrackContains = "_ARCHIVE"
                   -- ВВЕДИТЕ ЗНАЧЕНИЕ ПРИ СОДЕРЖАНИИ КОТОРОГО В КОНЦЕ ИМЕНИ ВЫДЕЛИТЬСЯ ТРЕК
                   -- ENTER A VALUE FOR THE CONTENT WHICH AT THE END OF THE NAME STAND OUT TRACK
                      --------------------------------------------------------------------------


    local UnselectPreviousTrack = 1
                             -- = 0 | НЕ СНИМАТЬ ВЫДЕЛЕННИЕ С ПРЕДЫДУЩИХ ТРЕКОВ
                             -- = 1 | СНЯТЬ ВЫДЕЛЕННИЕ С ПРЕДЫДУЩИХ ТРЕКОВ
                                    ---------------------------------
                             -- = 0 | NOT UNSELECT PREVIOUS TRACKS
                             -- = 1 | UNSELECT PREVIOUS TRACKS
                             ---------------------------------



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then no_undo()return end;

    if not EndOfTrackContains then EndOfTrackContains = "_ARCHIVE" end;
    if not UnselectPreviousTrack then UnselectPreviousTrack = 1 end;



    for i = 1,CountTrack do;
        local Track = reaper.GetTrack(0,i-1);
        local _,name = reaper.GetSetMediaTrackInfo_String(Track,"P_NAME","",0);
        if name:match(EndOfTrackContains.."$") then;
            Start = true; break;
        end;
    end;
    if not Start then no_undo()return end;


    reaper.PreventUIRefresh(1);

    for i = 1,CountTrack do;
        local Track = reaper.GetTrack(0,i-1);
        local _,name = reaper.GetSetMediaTrackInfo_String(Track,"P_NAME","",0);
        if name:match(EndOfTrackContains.."$") then;
             ----
             if UnselectPreviousTrack == 1 then;
                 for i = reaper.CountSelectedTracks(0)-1,0,-1 do;
                     local SelTrack = reaper.GetSelectedTrack(0,i);
                     reaper.SetMediaTrackInfo_Value(SelTrack,"I_SELECTED",0);
                 end;
                 UnselectPreviousTrack = nil;
             end;
             ----
             reaper.SetMediaTrackInfo_Value(Track,"I_SELECTED",1);
        end;
    end;
    reaper.PreventUIRefresh(-1);
    no_undo();