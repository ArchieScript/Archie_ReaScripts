-- NoIndex: true
--[[
   * Category:    Various
   * Description: Zoom TCP or Arrange Depending on focus to fit screen (Ctrl + Click save restore)Smart(`)
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Zoom TCP or Arrange Depending on focus to fit screen (Ctrl + Click save restore)Smart(`)
   * О скрипте:   Увеличить TCP или Arrange В зависимости от фокуса по размеру экрана (Ctrl+клик сохранить, восстановить) Smart (`)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Microtonic (RMM)$
   * Gave idea:   Microtonic (RMM)$
   * Changelog:   
   *              v.1.02 [23.05.2019]
   *                + Added the ability to scroll to the first selected track
   *                + Добавлена возможность прокрутки до первой выбранной дорожки
   
   *              v.1.01 [14.05.2019]
   *                +! Fixed bug when the lock is enabled, the height of the track
   *                +! Исправлена ошибка при включенной блокировке высоты дорожки  
   *              v.1.00 [14.05.2019]
   *                + initialе
   
   
   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.975 +           --| http://www.reaper.fm/download.php                     
   (+) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                
   (-) ReaPack v.1.2.2 -         --| http://reapack.com/repos                              
   (+) Arc_Function_lua v.2.4.1 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
   (+) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                
   =======================================================================================]] 
    
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    -------- / TCP / ---------------
  
  
    local CTRL = 1
            -- = 0 | СКРИПТ БУДЕТ РАБОТАТЬ КАК ТОГГЛЕ, СОХРАНИЛ-ВОССТАНОВИЛ, БЕЗ ВСЯКИХ CTRL
            -- = 0 | THE SCRIPT WILL WORK AS TOGGLE, PRESERVED-RESTORED, WITHOUT CTRL
                     ----------------------------------------------------------------
            -- = 1 | 
    
    -- СКРИПТ МАСШТАБИРУЕТ ТРЕКИ В TCP ПО РАЗМЕРУ ЭКРАНА
    -- ЕСЛИ НАДО СОХРАНИТЬ ТЕКУЩИЙ РАЗМЕР ТРЕКОВ, ТО ЗАПУСТИТЕ СКРИПТ СОЧЕТАНИЕМ КЛАВИШ CTRL + КЛИК,
    -- СКРИПТ СДЕЛАЕТ ВСЕ ТРЕКИ ПОД РАЗМЕР ЭКРАНА И СОХРАНИТ ПРЕДЫДУЩИЕ РАЗМЕРЫ ТРЕКОВ
    -- ЕСЛИ У СКРИПТА СТАТУС ВКЛ(ГОРИТ КНОПКА) ЭТО ЗНАЧИТ, ЧТО В СКРИПТЕ ПРИСУТСТВУЕТ СОХРАНЕНИЕ,
    -- ДЛЯ ВОССТАНОВЛЕНИЯ СОХРАНЕННЫХ РАЗМЕРОВ, ТАК ЖЕ ЗАПУСТИТЕ СКРИПТ СОЧЕТАНИЕМ КЛАВИШ CTRL + КЛИК,
    -- ДЛЯ ПЕРЕСОХРАНЕНИЯ, ЗАПУСТИТЕ СКРИПТ СОЧЕТАНИЕМ КЛАВИШ CTRL + SHIFT + КЛИК.
    ------------------------------------------------------------------------------
    -- Sorry for my english
    -- THE SCRIPT SCALES TRACKS IN TCP TO FIT THE SCREEN
    -- IF YOU WANT TO SAVE THE CURRENT SIZE OF THE TRACKS, RUN THE SCRIPT BY PRESSING CTRL + CLICK,
    -- THE SCRIPT WILL MAKE ALL THE TRACKS UNDER THE SIZE OF THE SCREEN AND SAVE THE PREVIOUS SIZE OF THE TRACKS
    -- IF THE STATUS OF THE SCRIPT ON (LIST BUTTON) IT MEANS THAT THE SCRIPT IS PRESENT TO SAVE, TO RESTORE THE -- SAVED SIZE, JUST RUN THE SCRIPT BY PRESSING CTRL + CLICK,
    -- TO RESAVE, RUN THE SCRIPT BY PRESSING CTRL +SHIFT + CLICK.
    -------------------------------------------------------------
  
  
    
    local shrink = 0
                 -- | Отрегулируйте отступ снизу как вам удобно 
                 -- | shrink = 0 / shrink = 10 / shrink = 20 и т.д.
                          -----------------------------------------
                 -- | Adjust the padding at the bottom as you like
                 -- | shrink = 0 / shrink = 10 / shrink = 20 etc.
                 ------------------------------------------------
    
    
    
    local ScrollTop = 2
                 -- = 0 | Отключить прокрутку вверх
                 -- = 1 | Включить прокрутку вверх
                 -- = 2 | Включить, при восстановлении верхний трек будет первый выделенный
                          -----------------------------------------------------------------
                 -- = 0 | Disable scroll up
                 -- = 1 | Enable scroll up
                 -- = 2 | Enable,when restoring, the first selected track will be considered as the top one
                 ------------------------------------------------------------------------------------------
    
    
    
    local  heigh_lock = 1
                   -- = 0 | ОТКЛ ЗАМОК (ТРЕКИ С ВКЛЮЧЕННЫМ LOCK TRACK HEIGHT БУДУТ МАСШТАБИРОВАТЬСЯ)
                   -- = 1 | ВКЛ ЗАМОК (ТРЕКИ С ВКЛЮЧЕННЫМ LOCK TRACK HEIGHT НЕ БУДУТ МАСШТАБИРОВАТЬСЯ)
                            --------------------------------------------------------------------------
                   -- = 0 | OFF LOCK (TRACKS WITH INCLUDED LOCK TRACK HEIGHT WILL BE SCALE)
                   -- = 1 | ON LOCK (TRACKS WITH INCLUDED LOCK TRACK HEIGHT WILL NOT BE SCALE)
                   ---------------------------------------------------------------------------
    
    
    
    
    -------- / ARRANGE / ---------------
    
    
    local INDENT_END = 0
                    -- | ОТРЕГУЛИРУЙТЕ ОТСТУП В КОНЦЕ КАК ВАМ УДОБНО 
                         -------------------------------------------
                    -- | REGULATE REMEDY AT THE END AS CONVENIENT FOR YOU
                    -----------------------------------------------------
    
    
    
    local INDENT_START = -0.5
                    -- | ОТРЕГУЛИРУЙТЕ ОТСТУП В НАЧАЛЕ КАК ВАМ УДОБНО 
                         --------------------------------------------
                    -- | REGULATE RETIREMENT AT THE BEGINNING HOW YOU COMFORTABLE
                    -------------------------------------------------------------
    
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.4.2",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ============== 
    
    
    
    local Api_js = Arc.js_ReaScriptAPI(true,0.986);
    local Api_sws = Arc.SWS_API(true);
    if not Api_js or not Api_sws then Arc.no_undo() return end;
    
    
    Arc.HelpWindowWhenReRunning(2,"Arc_Function_lua",false);
    
    
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
        
        if startTime == endTime then startTime = 0 endTime = ProjectLength end;
        
        local START = (startTime-(endTime-startTime)/150)-(INDENT_START / 100);
        local END = (endTime + (endTime-startTime)/50)+ (INDENT_END / 100);
        
        reaper.GetSet_ArrangeView2(0,1,0,0, START, END);
        reaper.UpdateTimeline();
    end;
    ----------------------------------------------------
    
    
    
    
    local function TCP();
        shrink = shrink + 7;
        local CountTrack = reaper.CountTracks(0);
        if CountTrack == 0 then Arc.no_undo() return end;
        
        reaper.PreventUIRefresh(1);
        
        local HeightPlus, TrackT, DepthFold, DepthChild = 0,{};
        
        for i = 1, CountTrack do;
            local Track = reaper.GetTrack(0,i-1);
            local showTCP = reaper.GetMediaTrackInfo_Value(Track,"B_SHOWINTCP");
            local HeightLock = reaper.GetMediaTrackInfo_Value(Track,"B_HEIGHTLOCK");
            ----
            
            if heigh_lock ~= 1 then HeightLock = 0 end;
            
            if HeightLock == 1 then;
                if showTCP == 1 then;
                    local Height = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH");
                    HeightPlus = HeightPlus + Height;
                end;
            end;
            
            if DepthFold then;
                DepthChild = reaper.GetTrackDepth(Track); 
                if DepthChild <= DepthFold then;
                    DepthFold = nil;
                else;
                    if showTCP == 1 then;
                        if HeightLock == 0 then;
                            local Height = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH");
                            HeightPlus = HeightPlus + Height;
                        end;
                    end;
                end;
            end;
            
            if not DepthFold and HeightLock == 0 then;
                if showTCP == 1 then;
                    table.insert(TrackT,Track);
                end;
            end;
            
            if not DepthFold then;
                local Fold = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH");
                if Fold == 1 then;
                    local FoldCom = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERCOMPACT");
                    if FoldCom > 0 then;
                        DepthFold = reaper.GetTrackDepth(Track);  
                    end;
                end;
            end;
        end;
        
        local _,_, scr_x, scr_y = reaper.my_getViewport(0,0,0,0,0,0,0,0,true);
        --local heightAll = math.floor(((scr_y-HeightPlus-210)/#TrackT)+0.5);
        local heightAll = math.floor(((scr_y-HeightPlus-210-(shrink or 0))/#TrackT)+0.5);
        
        for i = 1, #TrackT do;
            reaper.SetMediaTrackInfo_Value(TrackT[i],"I_HEIGHTOVERRIDE",heightAll);
        end
        
        reaper.TrackList_AdjustWindows(false);
        
        if ScrollTop == 1 or ScrollTop == 2 then;
            reaper.CSurf_OnScroll(0,-1000);
            reaper.CSurf_OnScroll(0, 1   );
            reaper.CSurf_OnScroll(0, -1  );
        end;
        
        reaper.PreventUIRefresh(-1);
    end;  
    ----------------
    
    
    
    
    local section = ({reaper.get_action_context()})[2]:match('.*[/\\](.+)%..*$');
    
    --- / TCP / ---
    local CursorContext = reaper.GetCursorContext2(true);
    if CursorContext <= 0 then;
    
        local TrackVal;
        local CtrlShift = reaper.JS_Mouse_GetState(12);
        ----
        if CTRL == 0 then CtrlShift = 4 end;
        ----
        if CtrlShift == 12 then;
            reaper.DeleteExtState(section,"SaveHeightTCP",false);
            CtrlShift = 4;
        end;
        
        if CtrlShift == 4 then; -- Ctrl
            if not reaper.HasExtState(section,"SaveHeightTCP")then;
                for i = 1, reaper.CountTracks(0) do;
                    local Track = reaper.GetTrack(0,i-1);
                    local GUID = reaper.GetTrackGUID(Track);
                    ----
                    local HeightS = reaper.GetMediaTrackInfo_Value(Track,"I_HEIGHTOVERRIDE");
                    if tonumber(HeightS) == 0 then;
                        HeightS = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH");
                    end
                    ----
                    TrackVal = (TrackVal or "").."{"..GUID..HeightS .."}";  
                end;
                reaper.SetExtState(section,"SaveHeightTCP",TrackVal,false);
                TCP();
                Arc.SetToggleButtonOnOff(1);
            else;
                reaper.PreventUIRefresh(1);
                local rest = reaper.GetExtState(section,"SaveHeightTCP");
                for GUID, Height  in string.gmatch(rest,"{({.-})(.-)}") do;
                    local Track = reaper.BR_GetMediaTrackByGUID(0,GUID);
                    if Track then;
                        -------
                        if tonumber(Height) < 24 then;
                            Height = reaper.GetMediaTrackInfo_Value(Track,"I_HEIGHTOVERRIDE");
                            if Height == 0 then;
                                Height = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH");
                            end;
                        end;
                        -------
                        reaper.SetMediaTrackInfo_Value(Track,"I_HEIGHTOVERRIDE",Height);
                    end;
                end;
                reaper.DeleteExtState(section,"SaveHeightTCP",false);
                Arc.SetToggleButtonOnOff(0);
                
                if ScrollTop == 2 then;
                    if reaper.CountSelectedTracks(0)==0 then;
                        ScrollTop = 1;
                    end;
                end;
                    
                if ScrollTop == 1 then;
                    reaper.CSurf_OnScroll(0,-1000);
                    reaper.CSurf_OnScroll(0, 1   );
                    reaper.CSurf_OnScroll(0, -1  );
                elseif ScrollTop == 2 then;
                    reaper.defer(function();
                                 reaper.PreventUIRefresh(5);
                                 reaper.CSurf_OnScroll(0,10000);  
                                 Arc.Action(40285,40286);-->-< Go to track 
                                 reaper.PreventUIRefresh(-5);
                                 end);
                end;
                
                reaper.PreventUIRefresh(-1);
            end;
        else;
            TCP();
        end;
        reaper.TrackList_AdjustWindows(false);
         
    else;    
           
        --- / ARRANGE / ---
        local CtrlShift = reaper.JS_Mouse_GetState(12);
        ----
        if CTRL == 0 then CtrlShift = 4 end;
        ----
        if CtrlShift == 12 then;
            reaper.DeleteExtState(section,"SaveHeightARRANGE",false);
            CtrlShift = 4;
        end;
        
        if CtrlShift == 4 then; -- Ctrl
            if not reaper.HasExtState(section,"SaveHeightARRANGE")then;
                local start_zoom, end_zoom = reaper.GetSet_ArrangeView2(0,0,0,0);
                reaper.SetExtState(section,"SaveHeightARRANGE", start_zoom..'&'..end_zoom,false);
                Arrange();
                Arc.SetToggleButtonOnOff(1);
            else;
                local rest = reaper.GetExtState(section,"SaveHeightARRANGE");
                local start_zoom, end_zoom = string.match(rest,"(.-)&(.-)$")
                local START = (start_zoom-(end_zoom-start_zoom)/150)-(INDENT_START / 100);
                local END = (end_zoom + (end_zoom-start_zoom)/50)+ (INDENT_END / 100);
                reaper.GetSet_ArrangeView2(0,1,0,0, START, END);
                reaper.DeleteExtState(section,"SaveHeightARRANGE",false);
                Arc.SetToggleButtonOnOff(0);
            end;
        else;
            Arrange();
        end;  
    end;    
    reaper.UpdateArrange();
    Arc.no_undo();
    
    
    
    function loop();
        local CursorContext = reaper.GetCursorContext2(true);
        local HasExtStateTCP = reaper.HasExtState(section,"SaveHeightTCP");
        local HasExtStateARRANGE = reaper.HasExtState(section,"SaveHeightARRANGE");
        if not HasExtStateTCP and not HasExtStateARRANGE then Arc.no_undo()return end;
        local BUTTON_ARANGE,BUTTON_TCP;
        --- / TCP / ---
        if CursorContext <= 0 then;
            BUTTON_ARANGE = nil;
            if not HasExtStateTCP then;
                if BUTTON_TCP ~= 0 then;
                    if GetSetToggleButtonOnOff(0,false) ~= 0 then;
                        Arc.SetToggleButtonOnOff(0);
                    end;
                    BUTTON_TCP = 0;
                end;
            elseif HasExtStateTCP then;
                if BUTTON_TCP ~= 1 then;
                    if GetSetToggleButtonOnOff(0,false) ~= 1 then;
                        Arc.SetToggleButtonOnOff(1);
                    end;
                    BUTTON_TCP = 1;
                end;  
            end;
            -------------------
        else;
            --- / ARRANGE / ---
            BUTTON_TCP = nil;
            if not HasExtStateARRANGE then;
                if BUTTON_ARANGE ~= 0 then;
                    if GetSetToggleButtonOnOff(0,false) ~= 0 then;
                        Arc.SetToggleButtonOnOff(0);
                    end;
                    BUTTON_ARANGE = 0;
                end;
            elseif HasExtStateARRANGE then;    
                if BUTTON_ARANGE ~= 1 then;
                    if GetSetToggleButtonOnOff(0,false) ~= 1 then;
                        Arc.SetToggleButtonOnOff(1);
                    end;
                    BUTTON_ARANGE = 1;
                end;
            end;
        end;
        ------
        reaper.defer(loop);
        --t=(t or 0)+1
    end;
    loop();