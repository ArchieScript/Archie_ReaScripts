--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item; Remove items except first in one position (by tracks)
   * Author:      Archie
   * Version:     1.02
   * Описание:    Удалить элементы, кроме первого в одной позиции (по дорожкам)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Maxim Kokarev(VK)$
   * Gave idea:   Maxim Kokarev(VK)$
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [050320]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;


    local t = {};
    local tblTrack = {};
    local UNDO;


    for i = 1, CountSelItem do;
        local item = reaper.GetSelectedMediaItem(0,i-1);
        local track = reaper.GetMediaItem_Track(item);
        if not t[tostring(track)]then;
            t[tostring(track)] = track;
            tblTrack[#tblTrack+1] = track;
        end;
    end;


    for iTr = 1, #tblTrack do;

        local t = {};
        local rem = {};

        local CountTrItem = reaper.CountTrackMediaItems(tblTrack[iTr]);
        for iIt = 1, CountTrItem do;
            local itemTr = reaper.GetTrackMediaItem(tblTrack[iTr],iIt-1);
            local sel = reaper.IsMediaItemSelected(itemTr);
            if sel then;

                local posIt = reaper.GetMediaItemInfo_Value(itemTr,'D_POSITION');
                posIt = math.floor(posIt*1000)/1000;

                if not t[posIt] then;
                    t[posIt] = posIt;
                else;
                    rem[#rem+1] = {};
                    rem[#rem].track = tblTrack[iTr];
                    rem[#rem].item = itemTr;
                end;
            end;
        end;

        for iDel = 1, #rem do;
            local Del = reaper.DeleteTrackMediaItem(rem[iDel].track,rem[iDel].item);
            if not UNDO and Del then;
                reaper.Undo_BeginBlock();
                reaper.PreventUIRefresh(1);
                UNDO = true;
            end;
        end;
    end;


    if UNDO then;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock("Remove items except first in one position (by tracks)",-1);
    else;
        no_undo();
    end;

    reaper.UpdateArrange();




