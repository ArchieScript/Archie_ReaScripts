--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Copy stretch markers
   * >>>                              Archie_Item;  Paste stretch markers.lua
   * Author:      Archie
   * Version:     1.0
   * Описание:    Копирование маркеров растяжки
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Борис Янушевич(VK)
   * Gave idea:   Борис Янушевич(VK)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [14.02.20]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local x=0;
    for i = 1,math.huge do;
        local ExtState = reaper.GetExtState('ARCHIESTRETCHMARKCOPYPASTE',i);
        if ExtState == '' then;
            x=x+1;
        else; 
            x=x-1;
            reaper.DeleteExtState('ARCHIESTRETCHMARKCOPYPASTE',i,false);
        end;
        if x >= 20 then break end;
    end;
    
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo()return end;
    if CountSelItem > 1 then;
        reaper.MB('More than one item is selected,only one is allowed\n\n'..
                  'Выбрано более одного элемента, допустимо один\n',
                  'Error',0)no_undo();
        return;
    end;
    
    
    local itemFirst = reaper.GetSelectedMediaItem(0,0);
    local take = reaper.GetActiveTake(itemFirst);
    local numStretchMark = reaper.GetTakeNumStretchMarkers(take);
    if numStretchMark == 0 then;
        reaper.MB('Nothing to copy, no markers\n\n'..
                  'Нечего копировать , маркеров нет\n',
                  'Error',0)no_undo();
        return;
    end;
    
    
    for i = 1,numStretchMark do; 
        local retval, pos, srcpos = reaper.GetTakeStretchMarker(take,i-1);
        local slope = reaper.GetTakeStretchMarkerSlope(take,i-1);
        local str = tostring('{'..pos..' '..srcpos..' '..slope..'}');
        reaper.SetExtState('ARCHIESTRETCHMARKCOPYPASTE',i,str,false);
    end;
    
    local x,y = reaper.GetMousePosition();
    reaper.TrackCtl_SetToolTip("Copy stretch markers",x+10,y-35,0);
    no_undo();
    