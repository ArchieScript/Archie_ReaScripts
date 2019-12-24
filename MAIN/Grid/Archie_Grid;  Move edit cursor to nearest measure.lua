--[[
   * Category:    Grid
   * Description: Move edit cursor to nearest measure
   * Author:      Archie
   * Version:     1.0
   * Описание:    Переместить курсор редактирования к ближайшей мере
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
--]]
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    local SNAP = false
            -- = true  | реагировать на привязку к сетке
            -- = false | не реагировать на привязку к сетке
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    if SNAP == true then;  
        local ToggleSnap = reaper.GetToggleCommandStateEx(0,1157);
        local ToggleEnab = reaper.GetToggleCommandStateEx(0,40145);
        if ToggleSnap == 0 or ToggleEnab == 0 then;  
            return no_undo();
        end;
    end;
    
    local CursorPosition = reaper.GetCursorPosition();
    
    local buf = tonumber(reaper.format_timestr_pos(CursorPosition,'',2):match('^%d+'));
    
    local meaL = reaper.parse_timestr_pos(buf,2);
    local meaR = reaper.parse_timestr_pos(buf+1,2);
    
    
    local L = math.abs(CursorPosition-meaL);
    local R = math.abs(meaR-CursorPosition);
    
    
    if L <= R then;--<<<
         reaper.SetEditCurPos(meaL,true,false);
    else;
        reaper.SetEditCurPos(meaR,true,false);
    end;
    
    no_undo();