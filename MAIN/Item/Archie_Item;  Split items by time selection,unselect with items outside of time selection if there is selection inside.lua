--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item;  Split items by time selection,unselect with items outside of time selection if there is selection inside.lua
   * Author:      Archie
   * Version:     1.0
   * Описание:    Разделить элементы по выбору времени,снять выделения вне выбора времени если внутри есть выделения
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Archie(---)
   * Gave idea:   Kokarev Maxim(Rmm)
   * Changelog:   
   *              v.1.0 [060420]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --------------------------------------------------------
    local function no_undo() reaper.defer(function()end)end;
    --------------------------------------------------------
    
    
    local startTSel,endTSel = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    if startTSel == endTSel then no_undo() return end;
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;
    
    local TMSL,UNDO;
    for t = CountSelItem-1,0,-1 do;
        local item = reaper.GetSelectedMediaItem(0,t);
        local posIt = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
        local lenIt = reaper.GetMediaItemInfo_Value(item, "D_LENGTH");
        if posIt < endTSel and posIt+lenIt > startTSel then;
            TMSL = true;
            if not UNDO then;
                reaper.Undo_BeginBlock();
                reaper.PreventUIRefresh(1);
                UNDO = true;
            end;
        end;
        if posIt < endTSel and posIt+lenIt > endTSel then;
            reaper.SplitMediaItem(item,endTSel);
        end;
        if posIt < startTSel and posIt+lenIt > startTSel then;
            reaper.SplitMediaItem(item,startTSel);
        end;
    end;
    
    if TMSL then;
        for t = reaper.CountSelectedMediaItems(0)-1,0,-1 do;
            local item = reaper.GetSelectedMediaItem(0,t);
            local posIt = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
            local lenIt = reaper.GetMediaItemInfo_Value(item, "D_LENGTH");
            if posIt >= endTSel or posIt+lenIt <= startTSel then;
                reaper.SetMediaItemInfo_Value(item,'B_UISEL',0);
            end;
        end;
    end;
    
    if UNDO then;
         reaper.PreventUIRefresh(-1);
         reaper.Undo_EndBlock("Split items by time selection,unselect with items outside of time selection if there is selection inside",-1);
    else;
        no_undo();
    end;
    
    reaper.UpdateArrange();
    
    
    
    