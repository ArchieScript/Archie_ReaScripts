--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Stutter 1.3 items
   * Author:      Archie
   * Version:     1.0
   * AboutScript: ---
   * О скрипте:   ---
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    borisuperful(Rmm)
   * Gave idea:   borisuperful(Rmm)
   * Changelog:   v.1.0 [16.08.19]
   *                  + initialе

    -- Тест только на windows  /  Test only on windows.
    --=======================================================================================
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
    (+) - required for installation      | (+) - обязательно для установки
    (-) - not necessary for installation | (-) - не обязательно для установки
    -----------------------------------------------------------------------------------------
    (+) Reaper v.5.981 +            --| http://www.reaper.fm/download.php
    (-) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php
    (-) ReaPack v.1.2.2 +           --| http://reapack.com/repos
    (-) Arc_Function_lua v.2.4.4 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]] 
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    local MIN_LENGTH = 0.025;
    --------------------------------------------------------
    local function no_undo() reaper.defer(function()end)end;
    --------------------------------------------------------
    
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;
    
    reaper.PreventUIRefresh(1);
    
    local Undo;
    for i = CountSelItem-1,0,-1 do;
        local SelItem = reaper.GetSelectedMediaItem(0,i);
        local trackIt = reaper.GetMediaItem_Track(SelItem);
        local pos = reaper.GetMediaItemInfo_Value(SelItem,"D_POSITION");
        local len = reaper.GetMediaItemInfo_Value(SelItem,"D_LENGTH");
        if len < MIN_LENGTH then goto END_LOOP end;
        if not Undo then reaper.Undo_BeginBlock()Undo = true end;
        local item_Del = reaper.SplitMediaItem(SelItem,pos+(len/3));
        reaper.DeleteTrackMediaItem(trackIt,item_Del);
        local len = reaper.GetMediaItemInfo_Value(SelItem,"D_LENGTH");
        local retval,str = reaper.GetItemStateChunk(SelItem,"",false);
        for ii = 1,2 do;
            local itemNew = reaper.AddMediaItemToTrack(trackIt);
            reaper.SetItemStateChunk(itemNew,str,false);
            reaper.SetMediaItemInfo_Value(itemNew,"D_POSITION",pos+(len*ii));
        end;
        ::END_LOOP::;
    end;
    
    reaper.PreventUIRefresh(-1);
    reaper.UpdateArrange();
    
    if Undo then;
        reaper.Undo_EndBlock("Stutter 1/3 items",-1);
    else;
        no_undo();
    end;