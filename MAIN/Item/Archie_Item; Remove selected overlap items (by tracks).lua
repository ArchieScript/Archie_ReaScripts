--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item; Remove selected overlap items (by tracks)
   * Author:      Archie
   * Version:     1.0
   * Описание:    Удалить выбранные перекрывающиеся элементы (по дорожкам)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
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
                local lenIt = reaper.GetMediaItemInfo_Value(itemTr,'D_LENGTH');

                for i2 = 1, #t do;

                    if posIt+lenIt > t[i2].pos and posIt < t[i2].pos+t[i2].len then;
                        rem[tostring(itemTr)]={};
                        rem[tostring(itemTr)].item=itemTr;
                        rem[tostring(itemTr)].track=reaper.GetMediaItem_Track(itemTr);
                        if not UNDO then;
                            reaper.Undo_BeginBlock();
                            reaper.PreventUIRefresh(1);
                            UNDO = true;
                        end;
                        break;
                    end;
                end;

                if not rem[tostring(itemTr)] then;
                    t[#t+1] = {};
                    t[#t].pos = posIt;
                    t[#t].len = lenIt;
                end;
            end;
        end;

        for key,var in pairs(rem)do;
            reaper.DeleteTrackMediaItem(var.track,var.item);
        end;
    end;


    if UNDO then;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock("Remove selected overlap items (by tracks)",-1);
    else;
        no_undo();
    end;

    reaper.UpdateArrange();





