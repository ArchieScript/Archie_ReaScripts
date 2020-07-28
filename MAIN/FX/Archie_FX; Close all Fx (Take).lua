--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Fx
   * Description: Fx; Close all Fx (Take).lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.12+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [010720]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    local UNDO;
    local CountItem = reaper.CountMediaItems(0);
    if CountItem > 0 then;
        ----
        reaper.PreventUIRefresh(1);
        for i = 1,CountItem do;
            local item = reaper.GetMediaItem(0,i-1);
            local CountTake = reaper.GetMediaItemNumTakes(item);
            for i2 = 1,CountTake do;
                local take = reaper.GetTake(item,i2-1);
                local CountFx = reaper.TakeFX_GetCount(take);
                for i3 = 1,CountFx do;
                    local Open = reaper.TakeFX_GetOpen(take,i3-1);
                    if Open then;
                        if not UNDO then;reaper.Undo_BeginBlock();UNDO=true;end;
                        reaper.TakeFX_Show(take,i3-1,2);--float 2..3
                        reaper.TakeFX_Show(take,i3-1,0);--chain 0..1
                    end;
                end;
            end;
        end;
        reaper.PreventUIRefresh(-1);
        ----
    end;
    
    
    if UNDO then;
        reaper.Undo_EndBlock('Close all Fx (Take)',-1);
    else;
        reaper.defer(function()end);
    end;