--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Add Remove stretch marks under mouse cursor(snap to grid)
   * Author:      Archie
   * Version:     1.0
   * Описание:    Добавить удалить маркеры растяжки под курсором мыши (привязка к сетке)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    AndiVax(Rmm)
   * Gave idea:   AndiVax(Rmm)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   v.1.0 [08.10.19]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    --------------------------------------------------------
    local function no_undo() reaper.defer(function()end)end;
    --------------------------------------------------------
    
    
    
    local function GetPreviousGrid(time);
        for i = 1,math.huge do;
            local val = reaper.SnapToGrid(0,time);
            if val <= time then return val end;
            time = time-0.001;
        end;
    end;
    
    
    local function GetNextGrid(time);
        for i = 1,math.huge do;
            local val = reaper.SnapToGrid(0,time);
            if val >= time then return val end;
            time = time+0.001;
        end;
    end;
    
    
    local x,y = reaper.GetMousePosition();
    local item,take = reaper.GetItemFromPoint(x,y,false);
    if not take or reaper.TakeIsMIDI(take)then no_undo() return end;
    reaper.BR_GetMouseCursorContext();
    local mousePos = reaper.BR_PositionAtMouseCursor(true);
    local PreviousGrid = GetPreviousGrid(mousePos);
    local NextGrid = GetNextGrid(mousePos);
    local newPos;
    if math.abs(mousePos-PreviousGrid ) < math.abs(mousePos-NextGrid)then;
        newPos = PreviousGrid else newPos = NextGrid;
    end;
    local posIt = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
    local ratIt = reaper.GetMediaItemTakeInfo_Value(take,"D_PLAYRATE");
    local sm_mar = reaper.BR_GetMouseCursorContext_StretchMarker();
    if sm_mar < 0 then;
        for i = 1, reaper.GetTakeNumStretchMarkers(take)do;
            local retval, pos, srcpos = reaper.GetTakeStretchMarker(take,i-1);
            if (pos/ratIt)+posIt == newPos then sm_mar = i-1 end;
        end;
    end;
    reaper.Undo_BeginBlock();
    
    if sm_mar >= 0 then; 
        reaper.DeleteTakeStretchMarkers(take,sm_mar);
        reaper.Undo_EndBlock("Remove stretch marks under mouse cursor(snap to grid)",-1);
    else;
        reaper.SetTakeStretchMarker(take,-1,(newPos-posIt)*ratIt);
        reaper.Undo_EndBlock("Add stretch marker under mouse cursor (snap to grid)",-1);
    end;
    reaper.UpdateArrange();