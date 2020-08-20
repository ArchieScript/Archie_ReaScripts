--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    View
   * Features:    Startup
   * Description: Zoom width full project - recovery back
   * Author:      Archie
   * Version:     1.09
   * Описание:    Масштабировать ширину под полный проект-Восстановление назад
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Krikets(RMM)
   * Gave idea:   Krikets(RMM)
   * Extension:   Reaper 5.983+ http://www.reaper.fm/
   *              Arc_Function_lua v.2.6.5+   (Repository: Archie-ReaScripts)  http://clck.ru/EjERc
   * Changelog:
   *              v.1.05 [25.09.19]
   *                  ---

   *              v.1.03 [21.09.19]
   *                  ! not show help window at startup reaper
   *              v.1.02 [16.09.19]
   *                  ! Fix bug flickering button
   *              v.1.01 [15.09.19]
   *                  ! Performance: Break previous copy "defer"
   *              v.1.0 [14.09.19]
   *                  + initialе
--]]


    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local SCROLL_RESET_SAVE = 0
                        --  = 0 | НЕ СБРАСЫВАТЬ СОХРАНЕНИЯ ПРИ СКРОЛЛЕ
                        --  = 1 | СБРОСИТЬ СОХРАНЕНИЯ ПРИ СКРОЛЛЕ
                                  -------------------------------
                        --  = 0 | DO NOT THROW SAVINGS WHEN SCROLLING
                        --  = 1 | RESET STORAGE WHEN SCROLLING
                        --------------------------------------


    local INDENT_END = 25
                    -- НАСТРОЙТЕ ОТСТУП В КОНЦЕ АРРАНЖА В ПИКСЕЛЯХ
                    -- ADJUST THE INDENTATION AT THE END THE ARRANGE IN PIXELS
                    ----------------------------------------------------------


    local INDENT_START =  10
                    -- | ОТРЕГУЛИРУЙТЕ ОТСТУП В НАЧАЛЕ АРРАНЖА В ПИКСЕЛЯХ
                         --------------------------------------------
                    -- | ADJUST THE RETREAT AT THE BEGINNING OF ARRANGE IN PIXELS
                    -------------------------------------------------------------


    local OFF_TIME_SELECTION = 0
                    -- = 0 | МАСШТАБИРОВАТЬ ПО ВЫБОРУ ВРЕМЕНИ, ЕСЛИ УСТАНОВЛЕНО
                    -- = 1 | ИГНОРИРОВАТЬ ВЫБОР ВРЕМЕНИ
                            ----------------------------
                    -- = 0 | ZOOM BY TIME SELECTION IF INSTALLED
                    -- = 1 | IGNORE TIME SELECTION
                    ------------------------------


    local
    STARTUP = 1
         -- = 0 Отключить автозапуск скрипта*
         -- = 1 Включить автозапуск скрипта*
         -- * После изменения запустите скрипт, что бы изменения вступили в силу
              ------------------------------------------------------------------
         -- = 0 Disable script autorun*
         -- = 1 Enable script autorun*
         -- * After the change, run the script so that the changes take effect
         ----------------------------------------------------------------------



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
	




    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context();
    local extname = filename:match(".+[/\\](.+)");



    --------------------------------------------------------------
    local NullProject,ProjUserdata2;
    local stopDoubleScr,ActiveDoubleScr;
    local function loop();

        ----- stop Double Script -------
        if not ActiveDoubleScr then;
            stopDoubleScr = (tonumber(reaper.GetExtState(extname,"stopDoubleScr"))or 0)+1;
            reaper.SetExtState(extname,"stopDoubleScr",stopDoubleScr,false);
            ActiveDoubleScr = true;
        end;

        local stopDoubleScr2 = tonumber(reaper.GetExtState(extname,"stopDoubleScr"));
        if stopDoubleScr2 > stopDoubleScr then return end;
        --------------------------------

        local ret,SaveFull_But = reaper.GetProjExtState(0,extname,"SaveFullArrange_Button");
        local RestButStart, RestButEnd = SaveFull_But:match("(.+)&&&(.+)");
        local RestButStart = tonumber(RestButStart)or 0;
        local RestButEnd = tonumber(RestButEnd)or 0;
        ----
        local start_View,end_View = reaper.GetSet_ArrangeView2(0,0,0,0);
        ----
        local Toggle = reaper.GetToggleCommandStateEx(sectionID,cmdID);
        local ToggleButton;
        -----
        if SCROLL_RESET_SAVE == 1 then;
            if RestButStart - (1e-7) < start_View and RestButStart + (1e-7) > start_View and
               RestButEnd - (1e-7) < end_View and RestButEnd + (1e-7) > end_View then;
               ToggleButton = 1;else; ToggleButton = 0;
            end;
        else;
            if (RestButEnd-RestButStart)-(1e-7)<(end_View-start_View)and (RestButEnd-RestButStart)+(1e-7)>(end_View-start_View)then;
                ToggleButton = 1;else; ToggleButton = 0;
            end;
        end;
        -----
        ----- Зажечь кнопку в новом проекте ------------
        local ProjUserdata,_ = reaper.EnumProjects(-1,0);
        if ProjUserdata ~= ProjUserdata2 then ProjUserdata2 = ProjUserdata NullProject = nil end;
        if SaveFull_But ~= "" then NullProject = true end;
        if not NullProject and reaper.GetProjectLength(0) == 0 then ToggleButton = 1 end;
        ---------------------------------------------------------------------------------
        if ToggleButton == 1 then;
            if Toggle ~= 1 then;
                reaper.SetToggleCommandState(sectionID,cmdID,1);--t=(t or 0)+1
                reaper.RefreshToolbar2(sectionID,cmdID);
            end;
        else;
            if Toggle ~= 0 then;
                reaper.SetToggleCommandState(sectionID,cmdID,0);--t2=(t2 or 0)+1
                reaper.RefreshToolbar2(sectionID,cmdID);
            end;
        end;
        reaper.defer(loop);
    end;
    --------------------------------------------------------------


    --------------------------------------------------------------
    local function Set_ArrangeView(proj,start_View,end_View);
        reaper.PreventUIRefresh(498712);
        reaper.GetSet_ArrangeView2(proj,1,0,0,0,1000);
        reaper.GetSet_ArrangeView2(proj,1,0,0,1000,2000);
        reaper.GetSet_ArrangeView2(proj,1,0,0,start_View,end_View);
        reaper.PreventUIRefresh(-498712);
    end;
    --------------------------------------------------------------


    ---___-----------------------------------------------
    local FirstRun;
    if STARTUP == 1 then;
        --reaper.DeleteExtState(extname,"FirstRun",false);
        FirstRun = reaper.GetExtState(extname,"FirstRun")=="";
        if FirstRun then;
            reaper.SetExtState(extname,"FirstRun",1,false);
        end;
    end;
    -----------------------------------------------------

    loop();

    --------------------------------------------------------------


    if not FirstRun then;
        Arc.HelpWindowWhenReRunning(2,"Arc_Function_lua",false,"/ "..extname);

        --------------------------------------------------------------
        local ret,SaveArrange_View = reaper.GetProjExtState(0,extname,"SaveArrange_View");
        -----
        local Toggle = reaper.GetToggleCommandStateEx(sectionID,cmdID);
        if Toggle == 0 then ret = 0 SaveArrange_View = "" end;
        -----
        if ret == 0 and SaveArrange_View == "" then;

            reaper.SetToggleCommandState(sectionID,cmdID,1);
            reaper.RefreshToolbar2(sectionID,cmdID);

            reaper.SetProjExtState(0,extname,"SaveArrange_View","");
            reaper.SetProjExtState(0,extname,"SaveFullArrange_Button","");

            local start_View,end_View = reaper.GetSet_ArrangeView2(0,0,0,0);
            reaper.SetProjExtState(0,extname,"SaveArrange_View",start_View.."&&&"..end_View);

            local startTime,endTime = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
            local ProjectLength = reaper.GetProjectLength(0);

            if OFF_TIME_SELECTION == 1 then startTime = endTime end;

            if startTime == endTime then startTime = 0 endTime = ProjectLength end;

            Set_ArrangeView(0,startTime,endTime);
            local Pix = reaper.GetHZoomLevel()*(endTime-startTime) -- длина проекта или выб.врем. в пикселях

            local ProjectLength2 = (Pix+(INDENT_END))/reaper.GetHZoomLevel(); --длина проекта или в.в. в сек +INDENT_END пикселей
            local X = ProjectLength2-(endTime-startTime);
            local END = endTime + X;

            local ProjectLength2 = (Pix+(INDENT_START))/reaper.GetHZoomLevel(); --длина проекта или в.в. в сек+INDENT_START пикселей
            local X = ProjectLength2-(endTime-startTime);
            local START = startTime - X;
            if START < 0 then START = 0 end;

            Set_ArrangeView(0,START,END);

            reaper.UpdateTimeline();

            ---------------------
            local start_View,end_View = reaper.GetSet_ArrangeView2(0,0,0,0);
            reaper.SetProjExtState(0,extname,"SaveFullArrange_Button",start_View.."&&&"..end_View);
        else;
            reaper.SetToggleCommandState(sectionID,cmdID,0);
            reaper.RefreshToolbar2(sectionID,cmdID);
            local restStart, restEnd  = SaveArrange_View:match("(.+)&&&(.+)");
            Set_ArrangeView(0, restStart, restEnd);
            reaper.SetProjExtState(0,extname,"SaveArrange_View","");
            reaper.SetProjExtState(0,extname,"SaveFullArrange_Button","");
        end;
        --------------------------------------------------------------
    end;



    ---___-----------------------------------------------
    local scriptPath,scriptName = filename:match("(.+)[/\\](.+)");
    local id = Arc.GetIDByScriptName(scriptName,scriptPath);
    if id == -1 or type(id) ~= "string" then Arc.no_undo()return end;
    local check_Id, check_Fun = Arc.GetStartupScript(id);

    if STARTUP == 1 then;
        if not check_Id then;
            Arc.SetStartupScript(scriptName,id);
        end;
    else;
        if check_Id then;
            Arc.SetStartupScript(scriptName,id,nil,"ONE");
        end;
    end;
    -----------------------------------------------------]]