--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item;  Remove non even items from the selected items in track.lua
   * Author:      Archie
   * Version:     1.0
   * Описание:    Удаление нечетных элементов из выбранных элементов в треке
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.08+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.0 [250420]
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
    local track2,x;
    
    for i = 1, CountSelItem do;
        
        local item = reaper.GetSelectedMediaItem(0,i-1);
        local track = reaper.GetMediaItem_Track(item);
        if track2 ~= track then x = 0 end;
        x = x + 1;
        if x%2 ~= 0 then;
            t[#t+1] = item;
        end;
        track2 = track;  
    end;
    
    if #t == 0 then no_undo()return end;
    
    
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    
    for i = 1, #t do;
        local track = reaper.GetMediaItem_Track(t[i]);
        reaper.DeleteTrackMediaItem(track,t[i]);
    end;
    
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("Remove non even items from the selected items in track",-1);
    
    reaper.UpdateArrange();
    
    
    
    
    