--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item;  Glue selected items each individually.lua
   * Author:      Archie
   * Version:     1.0
   * Описание:    Склейте выбранные предметы каждый по отдельности
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Changelog:   
   *              v.1.0 [060420]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo()return end;
    
    local sel_item = {};
    local sel_it2  = {};
    
    for i = 1,CountSelItem do;
        sel_item[i] = reaper.GetSelectedMediaItem(0,i-1);
    end;
    
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    
    reaper.SelectAllMediaItems(0,0);
    
    for i=1,#sel_item do;
        reaper.SetMediaItemSelected(sel_item[i],1);
        reaper.Main_OnCommand(40257,0);--Glue items
        local item = reaper.GetSelectedMediaItem(0,0);
        reaper.SetMediaItemSelected(item,0);
        sel_it2[#sel_it2+1]=item;
    end;
    
    for i=1,#sel_it2 do;
        reaper.SetMediaItemSelected(sel_it2[i],1);
    end;
    
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("Glue selected items each individually",-1);
    reaper.UpdateArrange();
    
    
    