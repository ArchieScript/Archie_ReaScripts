--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Toggle Open close MIDI editor and zoom to content by item
   * Author:      Archie
   * Version:     1.0
   * Описание:    Переключатель Открыть закрыть MIDI редактор и масштабировать содержимое по элементу
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.01+ http://www.reaper.fm/
   * Changelog:   v.1.0 [15.12.19]
   *                  + initialе
--]]
     
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local Indent = 0.04;  -- Отступ
    
    local Vertically_Zoom = false -- true/false
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    local ZoomProj = 40726;
    local OpenMIDI = 40153;
    local ZoomCont = 40466
    
    if not tonumber(Indent) then Indent = 0 end;
    
    
    
    local MIDIEditor = reaper.MIDIEditor_GetActive();
    if MIDIEditor then;
        -----------------------------------------------------
        reaper.MIDIEditor_OnCommand(MIDIEditor,2);
        -----------------------------------------------------
    else;
        -----------------------------------------------------
        reaper.Main_OnCommand(OpenMIDI,0);
        
        local MIDIEditor = reaper.MIDIEditor_GetActive();
        if not MIDIEditor then no_undo() return end;
        
        local Take = reaper.MIDIEditor_GetTake(MIDIEditor);
        local Item = reaper.GetMediaItemTake_Item(Take);
        local pos = reaper.GetMediaItemInfo_Value(Item, "D_POSITION");
        local len = reaper.GetMediaItemInfo_Value(Item, "D_LENGTH");
        local endPos = pos + len;
        local StartLoop,EndLoop = reaper.GetSet_LoopTimeRange(0,1,0,0,0);
        
        local source = reaper.GetMediaItemTake_Source(Take);
        local retval,lengthIsQN = reaper.GetMediaSourceLength(source);
        local TimeFromQN = reaper.TimeMap2_QNToTime(0,retval);
        if TimeFromQN ~= len then Indent = 0 end;
        
        reaper.PreventUIRefresh(1);
        
        if Vertically_Zoom == true then;
            reaper.MIDIEditor_OnCommand(MIDIEditor,ZoomCont);
        end;
        
        if Indent > len / 2 then Indent = 0 end;
        reaper.GetSet_LoopTimeRange(1,1,pos+Indent,endPos-Indent,0);
        
        reaper.MIDIEditor_OnCommand(MIDIEditor,ZoomProj);
        reaper.GetSet_LoopTimeRange(1,1,StartLoop,EndLoop,0);
        
        reaper.PreventUIRefresh(-1);
        -----------------------------------------------------
    end;
    
    reaper.UpdateTimeline();
    no_undo();