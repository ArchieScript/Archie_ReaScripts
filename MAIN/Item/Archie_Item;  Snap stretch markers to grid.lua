--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item;  Snap stretch markers to grid
   * Author:      Archie
   * Version:     1.0
   * Описание:    Привязка маркеров растяжки к сетке
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Maxim Kokarev(VK)$
   * Gave idea:   Maxim Kokarev(VK)$
   * Extension:   Reaper 6.05+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [130320]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local forceSnap = 100; -- binding strength / сила привязки
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;
    
    if not tonumber(forceSnap) then forceSnap = 100 end;
    
    local UNDO;
    for i = 1,CountSelItem do;
        local SelItem = reaper.GetSelectedMediaItem(0,i-1);
        local posIt = reaper.GetMediaItemInfo_Value(SelItem,"D_POSITION");
        local take = reaper.GetActiveTake(SelItem); 
        local rateIt = reaper.GetMediaItemTakeInfo_Value(take,'D_PLAYRATE');
        ---
        local countStrMar = reaper.GetTakeNumStretchMarkers(take);
        for i = 1,countStrMar do;
            local pos = ({reaper.GetTakeStretchMarker(take,i-1)})[2]/rateIt+posIt;
            local posGrid = reaper.SnapToGrid(0,pos);
            if forceSnap < 0 then forceSnap = 0 elseif forceSnap > 100 then forceSnap = 100 end;
            local new_pos = (((posGrid-pos)/100*forceSnap)+pos)-posIt; 
            ----
            if math.abs((new_pos+posIt)-pos)> 1e-7 and not UNDO then;
                reaper.Undo_BeginBlock();
                UNDO = true;
            end;
            ----
            reaper.SetTakeStretchMarker(take,i-1,new_pos*rateIt);
        end;
        reaper.UpdateItemInProject(SelItem);   
    end;
    
    if UNDO then;
        reaper.Undo_EndBlock("Snap stretch markers to grid",-1);
    else;
        no_undo();
    end;
    
    
    