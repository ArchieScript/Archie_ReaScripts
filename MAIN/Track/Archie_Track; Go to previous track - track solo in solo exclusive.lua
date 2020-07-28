--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Go to previous track - track solo in solo exclusive
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---(---)
   * Gave idea:   ---(---)
   * Extension:   Reaper 5.984+ http://www.reaper.fm/
   * Changelog:   v.1.0 [04.12.19]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    reaper.PreventUIRefresh(1);


    local LastTouchedTrack = reaper.GetLastTouchedTrack();
    if LastTouchedTrack then;

        reaper.Main_OnCommand(40286,0);
        local NewTrack = reaper.GetLastTouchedTrack();
        local Solo = reaper.GetMediaTrackInfo_Value(LastTouchedTrack,"I_SOLO");
        if Solo ~= 0 then;
            reaper.SetMediaTrackInfo_Value(NewTrack,"I_SOLO",1);
            for i = 1, reaper.CountTracks(0) do;
                local Track = reaper.GetTrack(0,i-1);
                if Track ~= NewTrack then;
                    local Solo = reaper.GetMediaTrackInfo_Value(Track,"I_SOLO");
                    if Solo ~= 0 then;
                        reaper.SetMediaTrackInfo_Value(Track,"I_SOLO",0);
                    end;
                end;
            end;
        end;
    end;

    reaper.PreventUIRefresh(-1);