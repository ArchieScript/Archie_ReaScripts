--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item;  Remove selected overlapped items
   * Author:      Archie
   * Version:     1.02
   * Описание:    Удаление выбранных перекрывающихся элементов
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Maxim Kokarev(VK)$
   * Gave idea:   Maxim Kokarev(VK)$
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.02 [040320]
   *                  + Performance improvement
   
   *              v.1.0 [03.03.20]
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
    
    local UNDO;
    local t = {};
    local rem = {};
    
    for i = 1, CountSelItem do;
        local item = reaper.GetSelectedMediaItem(0,i-1);
        local posIt = reaper.GetMediaItemInfo_Value(item,'D_POSITION');
        posIt = math.floor(posIt*1000)/1000;
        
        if not t[posIt] then;
            t[posIt] = posIt;
        else;
            local tr = reaper.GetMediaItem_Track(item);
            rem[#rem+1] = {};
            rem[#rem].track = tr;
            rem[#rem].item = item;
        end;
    end;
    
    
    for i = 1, #rem do;
        local Del = reaper.DeleteTrackMediaItem(rem[i].track,rem[i].item);
        if not UNDO and Del then;
            reaper.Undo_BeginBlock();
            reaper.PreventUIRefresh(1);
            UNDO = true;
        end;
    end;
    
    
    if UNDO then;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock("Remove selected overlapped items",-1);
    else;
        no_undo();
    end;
    
    reaper.UpdateArrange();
    
    
    