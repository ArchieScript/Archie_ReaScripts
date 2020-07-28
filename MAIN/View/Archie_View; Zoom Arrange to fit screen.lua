--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    View
   * Description: Zoom Arrange to fit screen
   * Author:      Archie
   * Version:     1.02
   * Описание:    Масштабировать Arrange по размеру экрана
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    YuriOl(RMM)
   * Gave idea:   YuriOl(RMM)
   * Extension:   Reaper 5.983+ http://www.reaper.fm/
   *              Arc_Function_lua v.2.6.1+  (Repository Archie-ReaScripts)  http://clck.ru/EjERc
   * Changelog:
   *              v.1.0 [14.09.2019]
   *                + initialе
--]]


    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    -------- / ARRANGE / ---------------
    local INDENT_END = 30
                    -- | ОТРЕГУЛИРУЙТЕ ОТСТУП В КОНЦЕ КАК ВАМ УДОБНО
                         -------------------------------------------
                    -- | REGULATE REMEDY AT THE END AS CONVENIENT FOR YOU
                    -----------------------------------------------------



    local INDENT_START =  10
                    -- | ОТРЕГУЛИРУЙТЕ ОТСТУП В НАЧАЛЕ КАК ВАМ УДОБНО
                         --------------------------------------------
                    -- | REGULATE RETIREMENT AT THE BEGINNING HOW YOU COMFORTABLE
                    -------------------------------------------------------------


    local OFF_TIME_SELECTION = 0
                    -- = 0 | МАСШТАБИРОВАТЬ ПО ВЫБОРУ ВРЕМЕНИ, ЕСЛИ УСТАНОВЛЕНО
                    -- = 1 | ИГНОРИРОВАТЬ  ВЫБОР ВРЕМЕНИ
                            ----------------------------
                    -- = 0 | ZOOM BY TIME SELECTION IF INSTALLED
                    -- = 1 | IGNORE TIME SELECTION
    ----------------------------------------------


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
	




    --------------------------------------------------------------
    local function Set_ArrangeView(proj,start_View,end_View);
        reaper.PreventUIRefresh(498712);
        reaper.GetSet_ArrangeView2(proj,1,0,0,0,1000);
        reaper.GetSet_ArrangeView2(proj,1,0,0,1000,2000);
        reaper.GetSet_ArrangeView2(proj,1,0,0,start_View,end_View);
        reaper.PreventUIRefresh(-498712);
    end;
    --------------------------------------------------------------


    ----------------------------------------------------
    local function Arrange();
        local startTime,endTime;
        local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,1,0,0,0);
        local startTimeSel, endTimeSel = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
        if startLoop == endLoop then;
            startTime = startTimeSel;
            endTime = endTimeSel;
        else;
            startTime = startLoop;
            endTime = endLoop;
        end;

        local ProjectLength = reaper.GetProjectLength(0);

        if OFF_TIME_SELECTION == 1 then startTime = endTime end;

        if startTime == endTime then startTime = 0 endTime = ProjectLength end;
        -----
        Set_ArrangeView(0,startTime,endTime);
        local Pix = reaper.GetHZoomLevel()*(endTime-startTime) -- длина проекта или выб.врем. в пикселях

        local ProjectLength2 = (Pix+(INDENT_END))/reaper.GetHZoomLevel(); --длина проекта или в.в. в сек +INDENT_END пикселей
        local X = ProjectLength2-(endTime-startTime);
        local END = endTime + X;

        local ProjectLength2 = (Pix+(INDENT_START))/reaper.GetHZoomLevel(); --длина проекта или в.в. в сек+INDENT_START пикселей
        local X = ProjectLength2-(endTime-startTime);
        START = startTime - X;
        if START < 0 then START = 0 end;
        -----
        Set_ArrangeView(0,START,END);

        reaper.UpdateTimeline();
    end;
    ----------------------------------------------------


    Arrange();
    reaper.UpdateArrange();
    Arc.no_undo();