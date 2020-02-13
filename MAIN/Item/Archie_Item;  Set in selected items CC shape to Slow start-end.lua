--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Set in selected items CC shape Slow start/end
   * Author:      Archie
   * Version:     1.02
   * Описание:    Установить в выбранных элементах CC форму Slow start/end
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    BAYANBAYAN(Rmm)
   * Gave idea:   BAYANBAYAN(Rmm)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [13.02.20]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    for it = 1,reaper.CountSelectedMediaItems(0) do;
        local item = reaper.GetSelectedMediaItem(0,it-1);
        local take = reaper.GetActiveTake(item);
        local i = 0;
        while true do;
            i=i+1;
            local retval, shape, beztension = reaper.MIDI_GetCCShape(take,i-1);
            if retval then;
                reaper.MIDI_SetCCShape(take,i-1,2,beztension,true);
            else;
                break;
            end;
        end;
        reaper.MIDI_Sort(take);
    end;
    
    reaper.UpdateArrange();
    no_undo();
   