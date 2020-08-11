--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Paste stretch markers (by playback rate)
   * >>>          >>>                  Archie_Item; Copy stretch markers.lua
   * Author:      Archie
   * Version:     1.02
   * Описание:    Вставить маркеры растяжки (по скорости воспроизведения)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    borisuperful(RMM)$
   * Gave idea:   borisuperful(RMM)$
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [14.02.20]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================


    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------



    local HasExt = reaper.HasExtState('ARCHIESTRETCHMARKCOPYPASTE',1);
    if not HasExt then;
        no_undo()return;
    end;

    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo()return end;

    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);

    for it = 1,CountSelItem do;
        local itemSel = reaper.GetSelectedMediaItem(0,it-1);
        local take = reaper.GetActiveTake(itemSel);
        local numStretchMark = reaper.GetTakeNumStretchMarkers(take);

        reaper.DeleteTakeStretchMarkers(take,0,numStretchMark);

        local slp={};
        local i=0;
        while true do;
            i=i+1;
            local ExtState = reaper.GetExtState('ARCHIESTRETCHMARKCOPYPASTE',i);
            local pos,srcpos,slope = ExtState:match('{(%S-)%s-(%S-)%s-(%S-)}');
            local t = tonumber;
            if t(pos) and t(srcpos) and t(slope)then;
                reaper.SetTakeStretchMarker(take,-1,pos,srcpos);
                slp[i]= t(slope);
            else;
                break;
            end;
        end;

        for sp = 1,#slp do;
            reaper.SetTakeStretchMarkerSlope(take,sp-1,slp[sp]);
        end;
    end;

    local x,y = reaper.GetMousePosition();
    reaper.TrackCtl_SetToolTip("Paste stretch markers (by playback rate)",x+10,y-35,0);

    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock('Paste stretch markers (by playback rate)',-1);
    reaper.UpdateArrange();

