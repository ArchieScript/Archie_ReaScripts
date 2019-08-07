--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Duplicate item to mouse position
   * Author:      Archie
   * Version:     1.0
   * AboutScript: ---
   * О скрипте:   Дублировать элемент в положение мыши
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Antibio(Rmm)
   * Gave idea:   Antibio(Rmm)
   * Changelog:   v.1.0 [07.08.19]
   *                  + initialе

    -- Тест только на windows  /  Test only on windows.
    --=======================================================================================
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
    (+) - required for installation      | (+) - обязательно для установки
    (-) - not necessary for installation | (-) - не обязательно для установки
    -----------------------------------------------------------------------------------------
    (+) Reaper v.5.981 +            --| http://www.reaper.fm/download.php
    (+) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php
    (+) ReaPack v.1.2.2 +           --| http://reapack.com/repos
    (-) Arc_Function_lua v.2.4.4 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]] 
    
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
        
    
    
    ---------------------------------------------------------
    local function no_undo();reaper.defer(function()end);end;
    ---------------------------------------------------------
    
    
    
    local pos_MouseCursor = reaper.BR_PositionAtMouseCursor(true);
    if pos_MouseCursor < 0 then no_undo() return end;
    
    
    local CountSelaItem = reaper.CountSelectedMediaItems(0);
    if CountSelaItem == 0 then no_undo(); return end;
    
    
    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();
    
    
    local posItemStart = reaper.GetProjectLength(0);
    local posItemEnd   = 0;
    
    for i = 1,CountSelaItem do;
        local SelItem = reaper.GetSelectedMediaItem(0,i-1);
        local pos = reaper.GetMediaItemInfo_Value(SelItem, "D_POSITION");
        local len = reaper.GetMediaItemInfo_Value(SelItem, "D_LENGTH");
        if pos     < posItemStart then posItemStart = pos     end;
        if pos+len > posItemEnd   then posItemEnd   = pos+len end;
    end;
    
    local Apply_value = (pos_MouseCursor - posItemStart);
    
    reaper.ApplyNudge(0,--project,
                      0,--nudgeflag,
                      5,--nudgewhat,
                      1,--nudgeunits,
                      Apply_value,--value,
                      false,--reverse,
                      0);--copies)
    
    
    reaper.Undo_EndBlock("Duplicate item to mouse position",-1);
    reaper.PreventUIRefresh(-1);
    reaper.UpdateArrange();