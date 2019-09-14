--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    View
   * Features:    Startup
   * Description: Zoom width full project - recovery back
   * Author:      Archie
   * Version:     1.0
   * Описание:    Масштабировать ширину под полный проект-Восстановление назад
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Krikets(RMM)
   * Gave idea:   Krikets(RMM)
   * Extension:   Reaper 5.983+ http://www.reaper.fm/
   *              Arc_Function_lua v.2.6.1+   (Repository: Archie-ReaScripts)  http://clck.ru/EjERc
   * Changelog:   
   *              v.1.01 [14.09.19]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    local SCROLL_RESET_SAVE = 1
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
    
    
    local OFF_TIME_SELECTION = 1
                    -- = 0 | МАСШТАБИРОВАТЬ ПО ВЫБОРУ ВРЕМЕНИ, ЕСЛИ УСТАНОВЛЕНО
                    -- = 1 | ИГНОРИРОВАТЬ  ВЫБОР ВРЕМЕНИ
                            ----------------------------
                    -- = 0 | ZOOM BY TIME SELECTION IF INSTALLED
                    -- = 1 | IGNORE TIME SELECTION
    ----------------------------------------------
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.6.1",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    
    Arc.HelpWindowWhenReRunning(2,"Arc_Function_lua",false);
    
    
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context();
    local extname = filename:match(".+[/\\](.+)");
    
    
    
    --------------------------------------------------------------
    local NullProject,ProjUserdata2;
    local function loop();
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
    
    
    --------------------------------------------------------------
    --reaper.DeleteExtState(extname,"FirstRun",false);
    local FirstRun = reaper.GetExtState(extname,"FirstRun")=="";
    reaper.SetExtState(extname,"FirstRun",1,false);
    --------------------------------------------------------------
    
    loop();
    
    --------------------------------------------------------------
    
    
    if not FirstRun then;
        --------------------------------------------------------------
        local ret,SaveArrange_View = reaper.GetProjExtState(0,extname,"SaveArrange_View");
        -----
        local Toggle = reaper.GetToggleCommandStateEx(sectionID,cmdID);
        if Toggle == 0 then ret = 0 SaveArrange_View = "" end;
        -----
        if ret == 0 and SaveArrange_View == "" then;
        
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
            local restStart, restEnd  = SaveArrange_View:match("(.+)&&&(.+)");
            Set_ArrangeView(0, restStart, restEnd);
            reaper.SetProjExtState(0,extname,"SaveArrange_View","");
            reaper.SetProjExtState(0,extname,"SaveFullArrange_Button","");
        end;
        --------------------------------------------------------------
    end;
    
    
    --------------------------------------------------------------
    local scriptPath,scriptName = filename:match("(.+)[/\\](.+)");
    local id = Arc.GetIDByScriptName(scriptName,scriptPath);
    if id == -1 or type(id) ~= "string" then Arc.no_undo()return end;
    Arc.StartupScript(scriptName,id);
    --------------------------------------------------------------