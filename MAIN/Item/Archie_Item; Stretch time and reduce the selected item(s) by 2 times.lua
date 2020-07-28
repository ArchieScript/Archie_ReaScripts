--[[
   * Category:    Item
   * Description: Stretch time and reduce the selected item(s) by 2 times
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Stretch time and reduce the selected item(s) by 2 times
   * О скрипте:   Растянуть время и уменьшить выбранные элемент(ы) в 2 раза
   * GIF:         http://clck.ru/EeHc3
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Snjuk(RMM Forum)
   * Gave idea:   Snjuk(RMM Forum)
   * Changelog:   + initialе / v.1.0 
--================================]]




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    ------------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end;
    ------------------------------------------------------------------------------



    local Count =  reaper.CountSelectedMediaItems(0);
    if Count == 0 then  no_undo() return end;


    reaper.Undo_BeginBlock();

    for i = Count-1,0,-1 do;
        local SelItem = reaper.GetSelectedMediaItem(0,i);
        local Length = reaper.GetMediaItemInfo_Value(SelItem,"D_LENGTH");
        local Counttake = reaper.CountTakes(SelItem);
        for ii = 1, Counttake do;
            local Take = reaper.GetMediaItemTake(SelItem, ii-1 );
            local PlayRate = reaper.GetMediaItemTakeInfo_Value(Take,"D_PLAYRATE");
            reaper.SetMediaItemTakeInfo_Value(Take, "D_PLAYRATE", PlayRate*2);
        end;
        reaper.SetMediaItemInfo_Value(SelItem,"D_LENGTH",Length/2);
    end;    

    reaper.Undo_EndBlock("Stretch time and reduce the selected item(s) by 2 times",-1);
    reaper.UpdateArrange(); 









