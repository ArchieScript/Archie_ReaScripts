--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; UnMute all selected tracks except selected folders.lua
   * Author:      Archie
   * Version:     1.01
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.08+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [080620]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo()return end;


    for i = 1,CountSelTrack do;
        local TrackSel = reaper.GetSelectedTrack(0,i-1);
        local fold = reaper.GetMediaTrackInfo_Value(TrackSel,"I_FOLDERDEPTH")==1;
        if not fold then;
            local mute = reaper.GetMediaTrackInfo_Value(TrackSel,"B_MUTE")==1;
            if mute then;
                if not UNDO then;
                    reaper.Undo_BeginBlock();
                    reaper.PreventUIRefresh(1);
                    UNDO = true;
                end;
                reaper.SetMediaTrackInfo_Value(TrackSel,"B_MUTE",0);
            end;

        end;
    end;


    if UNDO then;
        reaper.Undo_EndBlock("UnMute all selected tracks except selected folders",-1);
        reaper.PreventUIRefresh(-1);
    else;
        no_undo();
    end;


