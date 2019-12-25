--[[
   * Category:    Grid
   * Description: Move edit cursor to nearest 1/1.3 grid line
   * Author:      Archie
   * Version:     1.0
   * Описание:    Переместить курсор редактирования на ближайшую 1/1.3 линию сетки
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Arthur McArthur(forum Reaper)
   * Gave idea:   Arthur McArthur(forum Reaper)
--]]
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    local SNAP = false
            -- = true  | реагировать на привязку к сетке
            -- = false | не реагировать на привязку к сетке
            -- = true  | respond to snap to grid
            -- = false | do not respond to grid snap
    
    
    local ToRound = -1
              -- > 0 Округлять вперед из середины
              -- < 0 Округлять назад из середины
              -- > 0 To round forward from the middle
              -- < 0 To round back
    
    
    local SHIFT = 1/1.333333333333333  -- 0...0.999 (0.25 or 1/4)
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    if not tonumber(SHIFT)or SHIFT<0 or SHIFT>1 then no_undo()return end;
    if SHIFT == 1 then SHIFT = 0 end;
    
    
    if SNAP == true then;  
        local ToggleSnap = reaper.GetToggleCommandStateEx(0,1157);
        local ToggleEnab = reaper.GetToggleCommandStateEx(0,40145);
        if ToggleSnap == 0 or ToggleEnab == 0 then;  
            return no_undo();
        end;
    end;
    
    local CursorPosition = reaper.GetCursorPosition();
    
    local buf = tonumber(reaper.format_timestr_pos(CursorPosition,'',2):match('^%d+'));
    
    local meaL = reaper.parse_timestr_pos(buf-1,2);
    local meaC = reaper.parse_timestr_pos(buf,2);
    local meaR = reaper.parse_timestr_pos(buf+1,2);
    
    SHIFT = (meaR-meaC)*SHIFT;
    
    meaL = meaL + SHIFT;
    meaC = meaC + SHIFT;
    meaR = meaR + SHIFT;
    
    local L = math.abs(CursorPosition-meaL);
    local C = math.abs(CursorPosition-meaC);
    local R = math.abs(meaR-CursorPosition);
      
    local min = math.min(L,C,R);
    
    local destination;
    
    if tonumber(ToRound) and ToRound < 0 then;
        if min == R then; destination = meaR; end;
        if min == C then; destination = meaC; end;
        if min == L then; destination = meaL; end;
    else;   
        if min == L then; destination = meaL; end;
        if min == C then; destination = meaC; end;
        if min == R then; destination = meaR; end;
    end;
    
    
    reaper.SetEditCurPos(destination,true,false);
         
    no_undo();