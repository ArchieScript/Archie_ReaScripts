--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Grid
   * Description: Move select items to previous grid
   * Author:      Archie
   * Version:     1.0
   * Описание:    Переместить выбранные элементы к предыдущей сетке
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   v.1.0 [04.02.20]
   *                  + initialе
--]]

    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    -------------------------------------------------------
    local function GetPrevGrid(pos);
        reaper.Main_OnCommand(40755,0); -- Snapping: Save snap state
        reaper.Main_OnCommand(40754,0); -- Snapping: Enable snap
        start_time, end_time = reaper.GetSet_ArrangeView2(0,0,0,0);
        reaper.GetSet_ArrangeView2(0,1,0,0,start_time,start_time+.1);
        if pos > 0 then;
            local grid = pos;
            local i = 0;
            local posX = pos;
            while (grid >= pos) do;
                pos = pos - 0.0001;
                if pos >= 0.0001 then;
                    grid = reaper.SnapToGrid(0,pos);
                else;
                    grid = 0;
                end;
                i=i+1;
                if i>(2e+5)then;
                   reaper.Main_OnCommand(40756,0); -- Snapping: Restore snap state
                   reaper.GetSet_ArrangeView2(0,1,0,0,start_time, end_time);
                   return posX;
                end;
            end;
            reaper.GetSet_ArrangeView2(0,1,0,0,start_time, end_time);
            reaper.Main_OnCommand(40756, 0) -- Snapping: Restore snap state
            return grid;
        end;
        return 0
    end;
    -------------------------------------------------------


    local CntSelIt = reaper.CountSelectedMediaItems(0);
    if CntSelIt == 0 then no_undo() return end;


    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);

    for i = 1,CntSelIt do;
        local selIt = reaper.GetSelectedMediaItem(0,i-1);
        local pos = reaper.GetMediaItemInfo_Value(selIt,'D_POSITION');
        local PrevGrid = GetPrevGrid(pos);
        reaper.SetMediaItemInfo_Value(selIt,'D_POSITION',PrevGrid);
    end;

    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock('Move select items to previous grid',-1);
    reaper.UpdateArrange();
