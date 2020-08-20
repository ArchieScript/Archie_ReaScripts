--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Nudge right edge of selected items to left one grid unit
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Nudge right edge of selected items to left one grid unit
   *              Nudge right edge of selected items to right one grid unit*
   * О скрипте:   Сдвиг правого края выделенных элементов влево на одну единицу сетки
   *              Сдвиньте правый край выделенных элементов вправо на одну единицу сетки*
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Ильмир Азгамов(vk)
   * Gave idea:   Ильмир Азгамов(vk)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   * Changelog:   v.1.0 [02.09.19]
   *                  + initialе
--]]


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local function GetPrevNextGridArrange(time,nextPrev);
        local ToggleSnap = reaper.GetToggleCommandStateEx(0,1157);
        if ToggleSnap == 0 then;reaper.Main_OnCommand(1157,0);end;
        local ToggleEnab = reaper.GetToggleCommandStateEx(0,40145);
        if ToggleEnab == 0 then;reaper.Main_OnCommand(40145,0);end;
        local val;
        for i = 1,math.huge do;
            val = reaper.SnapToGrid(0,time);
            if nextPrev < 0 then;
                if val<--[[<=]]time then;goto ret;end;time=time-0.001;
            else;
                if val>=--[[>]]time then;goto ret;end;time=time+0.001;
            end;
        end;::ret::;
        if ToggleSnap == 0 then;reaper.Main_OnCommand(1157 ,0);end;
        if ToggleEnab == 0 then;reaper.Main_OnCommand(40145,0);end;
        return val;
    end;


    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;

    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);

    for i = 1, CountSelItem do
        local item = reaper.GetSelectedMediaItem(0,i-1);
        local pos = reaper.GetMediaItemInfo_Value(item,'D_POSITION');
        local len = reaper.GetMediaItemInfo_Value(item,'D_LENGTH');
        local Prev = GetPrevNextGridArrange(pos+len,-1);
        local Next = GetPrevNextGridArrange(pos+len,1);
        reaper.SetMediaItemInfo_Value(item,'D_LENGTH',(len-(Next-Prev)));
    end;

    reaper.Undo_EndBlock("Nudge right edge of selected items to left one grid unit",-1);
    reaper.PreventUIRefresh(-1);
    reaper.UpdateArrange();