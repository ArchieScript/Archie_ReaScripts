--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Markers
   * Description: Markers; Go to random marker.lua
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Snjuk(---)
   * Gave idea:   Snjuk(---)
   * Extension:   Reaper 6.12+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [080820]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local retval,num_markers,num_regions = reaper.CountProjectMarkers(0);
    if num_markers == 0 then no_undo()return end;
    
    --math.randomseed(os.time());
    
    local markers;
    local Prev = tonumber(reaper.GetExtState('GotorandommarkerGTRM5578','GTRM597'))or 0;
    for i = 1,1000 do;
        markers = math.random(1,num_markers);
        if markers ~= Prev then;
            break;
        end;
    end;
    
    local x = 0;
    for i = 1,retval do;
        local retval,isrgn,pos,rgnend,name,markrgnindexnumber = reaper.EnumProjectMarkers(i);
        if not isrgn then x=x+1 end;
        if x == markers then;
            reaper.SetEditCurPos(pos,true,true);
            reaper.SetExtState('GotorandommarkerGTRM5578','GTRM597',x,false);
            break;
        end;
    end;
    
    no_undo();
    
    
    