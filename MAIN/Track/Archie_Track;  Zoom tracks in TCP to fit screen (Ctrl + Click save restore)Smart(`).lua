--[[
   * Category:    Track
   * Description: Zoom tracks in TCP to fit screen (Ctrl + Click save restore)Smart
   * Author:      Archie
   * Version:     1.05
   * AboutScript: Zoom tracks in TCP to fit screen (Ctrl + Click save restore)Smart
   * О скрипте:   Масштабировать треки в TCP по размеру экрана (Ctrl + клик сохранить восстановить)умный
   * GIF:         http://archiescript.github.io/ReaScriptSiteGif/html/ZoomTracksInTCPToFitScreenCtrl+ClickSaveRestoreSmart.html
   *              https://avatars.mds.yandex.net/get-pdb/1863019/d5e261f6-626e-4b59-a6dc-68f4d1eedcf6/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    AlexLazer(RMM)$
   * Gave idea:   AlexLazer(RMM)
   * Changelog:   
   *              v.1.05 [12052019]
   *                + Added the ability to not scale tracks with enabled 'Lock track height'
   *                + Добавлена возможность не масштабировать треки с включенным "Lock track height"
   
   *              v.1.03 [03.02.2019]
   *                + Added the ability to adjust the indentation from the bottom 
   *                + Добавлена возможность регулирования отступа снизу 
   *              v.1.0 [29.01.2019]
   *                +  initialе
   
   
   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.965 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.4.1 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   + reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]
    
    
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
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
                 -- | Отрегулируйте отступ снизу как вам удобно в пикселях
                 -- | shrink = 0; shrink = 10; shrink = 20; и т.д.
                          ----------------------------------------
                 -- | Adjust the padding at the bottom as you like in pixels
                 -- | shrink = 0; shrink = 10; shrink = 20; etc.
                 -----------------------------------------------
    
    
    
    local ScrollTop = 1
                 -- = 0 | Отключить прокрутку вверх
                 -- = 1 | Включить прокрутку вверх
                          ------------------------
                 -- = 0 | Disable scroll up
                 -- = 1 | Enable scroll up
                 -------------------------
    
    
    
    local  heigh_lock = 1
                   -- = 0 | ОТКЛ ЗАМОК (ТРЕКИ С ВКЛЮЧЕННЫМ LOCK TRACK HEIGHT БУДУТ МАСШТАБИРОВАТЬСЯ)
                   -- = 1 | ВКЛ ЗАМОК (ТРЕКИ С ВКЛЮЧЕННЫМ LOCK TRACK HEIGHT НЕ БУДУТ МАСШТАБИРОВАТЬСЯ) 
                            --------------------------------------------------------------------------
                   -- = 0 | OFF LOCK (TRACKS WITH INCLUDED LOCK TRACK HEIGHT WILL BE SCALE)
                   -- = 1 | ON LOCK (TRACKS WITH INCLUDED LOCK TRACK HEIGHT WILL NOT BE SCALE)
                   ---------------------------------------------------------------------------
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.4.1",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ============== 
    
    
    shrink = shrink + 7;
    local Api_js = Arc.js_ReaScriptAPI(true,0.986);
    local Api_sws = Arc.SWS_API(true);
    if not Api_js or not Api_sws then Arc.no_undo() return end;
    
    
    
    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then Arc.no_undo() return end;
    
    
    local function ZoomTracksInTCPToFitScreen();
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
        end;

        reaper.TrackList_AdjustWindows(false);

        if ScrollTop == 1 then;
            reaper.CSurf_OnScroll(0,-1000);
            reaper.CSurf_OnScroll(0, 1   );
            reaper.CSurf_OnScroll(0, -1  );
        end;

        reaper.PreventUIRefresh(-1);
    end;
    
    
    
    
    local TrackVal;
    local section = ({reaper.get_action_context()})[2]:match('.*[/\\](.+)%..*$');
    local CtrlShift = reaper.JS_Mouse_GetState(12);
    if CtrlShift == 12 then;
        reaper.DeleteExtState(section,"SaveHeight",false);
        CtrlShift = 4;
    end;
    
    if CtrlShift == 4 then; -- Ctrl
        if not reaper.HasExtState(section,"SaveHeight")then;
            for i = 1, reaper.CountTracks(0) do;
                local Track = reaper.GetTrack(0,i-1);
                local GUID = reaper.GetTrackGUID(Track);
                local HeightS = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH");
                TrackVal = (TrackVal or "").."{"..GUID..HeightS .."}";  
            end;
            reaper.SetExtState(section,"SaveHeight",TrackVal,false);
            ZoomTracksInTCPToFitScreen();
            Arc.SetToggleButtonOnOff(1);
        else;
            reaper.PreventUIRefresh(1);
            local rest = reaper.GetExtState(section,"SaveHeight");
            for GUID, Height  in string.gmatch(rest,"{({.-})(.-)}") do;
                local Track = reaper.BR_GetMediaTrackByGUID(0,GUID);
                if Track then;
                    reaper.SetMediaTrackInfo_Value(Track,"I_HEIGHTOVERRIDE",Height);
                end;
            end;
            reaper.DeleteExtState(section,"SaveHeight",false);
            Arc.SetToggleButtonOnOff(0);
            
            if ScrollTop == 1 then;
                reaper.CSurf_OnScroll(0,-1000);
                reaper.CSurf_OnScroll(0, 1   );
                reaper.CSurf_OnScroll(0, -1  );
            end;
            
            reaper.PreventUIRefresh(-1);
        end;
    else;
        ZoomTracksInTCPToFitScreen();
    end;
    reaper.TrackList_AdjustWindows(false);
    Arc.no_undo();