--[[
   * Category:    Track
   * Description: Zoom tracks in TCP to fit screen (Ctrl + Click save restore)Smart
   * Author:      Archie
   * Version:     1.03
   * AboutScript: Zoom tracks in TCP to fit screen (Ctrl + Click save restore)Smart
   * О скрипте:   Масштабировать треки в TCP по размеру экрана (Ctrl + клик сохранить восстановить)умный
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    AlexLazer(RMM)$
   * Gave idea:   AlexLazer(RMM)
   * Changelog:   
   *              + Added the ability to adjust the indentation from the bottom  / v.1.03 [03.02.2019]
   *              + Добавлена возможность регулирования отступа снизу  / v.1.03 [03.02.2019]

   *              +  initialе / v.1.0 [29.01.2019]
   
   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.965 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.2.2 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
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
                 -- | Отрегулируйте отступ снизу как вам удобно 
                 -- | shrink = 0 / shrink = 10 / shrink = 20 и т.д.
                          -----------------------------------------
                 -- | Adjust the padding at the bottom as you like
                 -- | shrink = 0 / shrink = 10 / shrink = 20 etc.
                 ------------------------------------------------



    local ScrollTop = 1
                 -- = 0 | Отключить прокрутку вверх
                 -- = 1 | Включить прокрутку вверх
                          ------------------------
                 -- = 0 | Disable scroll up
                 -- = 1 | Enable scroll up
                 -------------------------


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 



   --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions',select(2,reaper.get_action_context()):match("(.+)[\\/]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.2.2",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================




    if not reaper.JS_Mouse_GetState then reaper.MB(
    'There is no file "reaper_js_ReaScriptAPI.dll" \nInstall repository "ReaTeam Extensions"\n\n'..
    'Отсутствует файл "reaper_js_ReaScriptAPI.dll" \nУстановите репозиторий "ReaTeam Extensions"'
    ,"Error",0) return end;
    -----------------------


    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then Arc.no_undo() return end;
        
        
        
   local function ZoomTracksInTCPToFitScreen();  
        reaper.PreventUIRefresh(1);    

        local HeightPlus, TrackT, DepthFold, DepthChild = 0,{};

        for i = 1, CountTrack do;
            local Track = reaper.GetTrack(0,i-1);
            local showTCP = reaper.GetMediaTrackInfo_Value(Track,"B_SHOWINTCP");
            ----
            if DepthFold then;
                DepthChild = reaper.GetTrackDepth(Track); 
                if DepthChild <= DepthFold then;
                    DepthFold = nil;
                else;
                    if showTCP == 1 then;
                        local Height = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH");
                        HeightPlus = HeightPlus + Height;
                    end;
                end;
            end;

            if not DepthFold then;
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

        if ScrollTop == 1 then;
            reaper.CSurf_OnScroll(0,-1000);
            reaper.CSurf_OnScroll(0, 1   );
            reaper.CSurf_OnScroll(0, -1  );
        end;

        reaper.PreventUIRefresh(-1);
    end;


    local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context();
    local CtrlShift = reaper.JS_Mouse_GetState(12);
      if CtrlShift == 12 then;
          reaper.DeleteExtState("CTRL_TrackScr648257","CTRL_Scr648257",false);
          CtrlShift = 4;
      end;
      if CtrlShift == 4 then; -- Ctrl

        if not reaper.HasExtState("CTRL_TrackScr648257","CTRL_Scr648257")then;

            local TrackVal = "";
            for i = 1, reaper.CountTracks(0) do;
                local Track = reaper.GetTrack(0,i-1);
                local GUID = reaper.GetTrackGUID(Track);
                --local HeightS = reaper.GetMediaTrackInfo_Value(Track,"I_HEIGHTOVERRIDE");
                local HeightS = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH");
                TrackVal = TrackVal.."{"..GUID..HeightS .."}";  
            end;
            reaper.SetExtState("CTRL_TrackScr648257","CTRL_Scr648257",TrackVal,false);
            ZoomTracksInTCPToFitScreen();
            reaper.SetToggleCommandState(sec, cmd,1);
            reaper.RefreshToolbar2(sec, cmd);
        else;   
            reaper.PreventUIRefresh(1);  

            local rest = reaper.GetExtState("CTRL_TrackScr648257","CTRL_Scr648257"); 
            for GUID, Height  in string.gmatch(rest,"{({.-})(.-)}") do;
                local Track = reaper.BR_GetMediaTrackByGUID(0,GUID);
                if Track then;
                    reaper.SetMediaTrackInfo_Value(Track,"I_HEIGHTOVERRIDE",Height);
                end;
            end;
            reaper.DeleteExtState("CTRL_TrackScr648257","CTRL_Scr648257",false);
            reaper.SetToggleCommandState(sec, cmd,0);
            reaper.RefreshToolbar2(sec, cmd);
            
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