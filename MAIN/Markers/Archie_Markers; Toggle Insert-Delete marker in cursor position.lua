--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Markers
   * Description: Markers; Toggle Insert-Delete marker in cursor position.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Snjuk(---)
   * Gave idea:   Snjuk(---)
   * Extension:   Reaper 6.12+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [080820]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local NAME = '';
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local function compare(x,y);
        local floatShare = 0.0000001;
        return math.abs(x-y)<floatShare;
    end;
    
    local CurPos = reaper.GetCursorPosition();
    
    local retval,num_markers,num_regions = reaper.CountProjectMarkers(0);
    if num_markers > 0 then;
        
        for i = 1,retval do;
            local retval,isrgn,pos,rgnend,name,markrgnindexnumber,color = reaper.EnumProjectMarkers3(0,i-1);
            if not isrgn and compare(pos,CurPos)then;
                reaper.Undo_BeginBlock();
                reaper.DeleteProjectMarkerByIndex(0,i-1);
                reaper.Undo_EndBlock('Delete marker under cursor',-1);
                return;
            end;
        end;
    end;
    
    reaper.Undo_BeginBlock();
    reaper.AddProjectMarker(0,false,CurPos,CurPos,NAME,-1);
    reaper.Undo_EndBlock('Insert marker under cursor',-1);
    
    
    
    
    