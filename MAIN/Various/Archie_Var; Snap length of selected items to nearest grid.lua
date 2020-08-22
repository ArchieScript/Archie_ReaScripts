--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Var; Snap length of selected items to nearest grid.lua
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.08+ http://www.reaper.fm/
   * Changelog:
   *              v.1.0 [170420]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------



    -------------------------------------------------------
    local function Arc_GetClosestGridDivision(time_pos);
        if not tonumber(time_pos)then return -1 end;
        reaper.PreventUIRefresh(4573);
        local st_tm, en_tm = reaper.GetSet_ArrangeView2(0,0,0,0);
        reaper.GetSet_ArrangeView2(0,1,0,0,st_tm,st_tm+.1);
        local Grid = reaper.SnapToGrid(0,time_pos);
        reaper.GetSet_ArrangeView2(0,1,0,0,st_tm,en_tm);
        reaper.PreventUIRefresh(-4573);
        return Grid;
    end;
    -------------------------------------------------------



    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo()return end;

	local UNDO;

    for i = 1,CountSelItem do;
        local itemSel = reaper.GetSelectedMediaItem(0,i-1);
        local posIt = reaper.GetMediaItemInfo_Value(itemSel,"D_POSITION");
        local lenIt = reaper.GetMediaItemInfo_Value(itemSel,"D_LENGTH");
        local endIt = posIt + lenIt;
        local Grid = Arc_GetClosestGridDivision(endIt);
        if endIt ~= Grid and Grid >= 0 then;
            if not UNDO then;
                reaper.Undo_BeginBlock();
                reaper.PreventUIRefresh(1);
                UNDO = true;
            end;
            reaper.SetMediaItemInfo_Value(itemSel,"D_LENGTH",Grid-posIt);
        end;
    end;


    if UNDO then;
        reaper.UpdateArrange();
        reaper.Undo_EndBlock("Snap length of selected items to nearest grid",-1);
        reaper.UpdateArrange();
    else;
        no_undo();
    end;




