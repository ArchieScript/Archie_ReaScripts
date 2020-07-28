--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Select Next item in track excluding midi
   * Author:      Archie
   * Version:     1.0
   * Описание:    Выберите следующий пункт в треке исключая midi
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(Rmm)
   * Gave idea:   borisuperful(Rmm)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [07.02.20]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    ------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local CountSelitem = reaper.CountSelectedMediaItems(0);
    if CountSelitem == 0 then no_undo() return end;


    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then no_undo() return end;

    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);

    for i = 1,CountTrack do;
        local track = reaper.GetTrack(0,i-1);

        ---
        local CountTrItem = reaper.CountTrackMediaItems(track);
        local sel2,item2;
        for i = CountTrItem-1,0,-1 do;

            local item = reaper.GetTrackMediaItem(track,i);
            local take = reaper.GetActiveTake(item);
            local IsMIDI = reaper.TakeIsMIDI(take);
            if not IsMIDI then;

                local sel = reaper.GetMediaItemInfo_Value(item,'B_UISEL');

                if sel == 1 and sel2 == 0 then;
                    reaper.SetMediaItemInfo_Value(item2,'B_UISEL',1);
                    reaper.SetMediaItemInfo_Value(item,'B_UISEL',0);
                    sel = 0;
                end;
                sel2 = sel;
                item2 = item;
            end;
        end;
        ---
    end;

    reaper.PreventUIRefresh(1);
    reaper.Undo_EndBlock('Select Next item in track excluding midi',-1);

    reaper.UpdateArrange();



