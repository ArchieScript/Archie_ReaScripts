--[[
   * Category:    Edit cursor
   * Description: Move edit cursor to nearest visible grid
   * Author:      Archie
   * Version:     1.02
   * Описание:    Переместить курсор редактирования к ближайшей видимой сетке
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
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


    local function GetPrevNextGridArrange(time,nextPrev);
        local ToggleSnap = reaper.GetToggleCommandStateEx(0,1157);
        local ToggleEnab = reaper.GetToggleCommandStateEx(0,40145);
        if ToggleSnap == 0 or ToggleEnab == 0 then;
            return time;
        end;
        local val;
        for i = 1,math.huge do;
            val = reaper.SnapToGrid(0,time);
            if nextPrev < 0 then;
                if val<=--[[<]]time then;goto ret;end;time=time-0.0001;
            else;
                if val>--[[>=]]time then;goto ret;end;time=time+0.0001;
            end;
        end;
        ::ret::;
        return val;
    end;



    local function GetPrevNextGridArrange2(time,nextPrev);
        local ToggleSnap = reaper.GetToggleCommandStateEx(0,1157);
        if ToggleSnap == 0 then;reaper.Main_OnCommand(1157,0);end;
        local ToggleEnab = reaper.GetToggleCommandStateEx(0,40145);
        if ToggleEnab == 0 then;reaper.Main_OnCommand(40145,0);end;
        local val;
        for i = 1,math.huge do;
            val = reaper.SnapToGrid(0,time);
            if nextPrev < 0 then;
                if val<=--[[<]]time then;goto ret;end;time=time-0.0001;
            else;
                if val>--[[>=]]time then;goto ret;end;time=time+0.0001;
            end;
        end;::ret::;
        if ToggleSnap == 0 then;reaper.Main_OnCommand(1157 ,0);end;
        if ToggleEnab == 0 then;reaper.Main_OnCommand(40145,0);end;
        return val;
    end;


    local GetGridLine;
    if SNAP == true then;
        GetGridLine = GetPrevNextGridArrange;
    else;
        GetGridLine = GetPrevNextGridArrange2;
    end;


    local CursorPosition = reaper.GetCursorPosition();


    local PrevLine = GetGridLine(CursorPosition,-1);
    if PrevLine == CursorPosition then no_undo() return end;

    local NextLine = GetGridLine(CursorPosition, 1);
    if NextLine == CursorPosition then no_undo() return end;

    local L = math.abs(CursorPosition-PrevLine);
    local R = math.abs(NextLine-CursorPosition);

    if L <= R then;--<<<
         reaper.SetEditCurPos(PrevLine,true,false);
    else;
        reaper.SetEditCurPos(NextLine,true,false);
    end;

    no_undo();