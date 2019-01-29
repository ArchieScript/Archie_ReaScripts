--[[
   * Category:    Track
   * Description: Toggle Track height A-B Collapse Uncollapse Folder under mouse cursor
   * Author:      Archie
   * Version:     1.01
   * AboutScript: Switch the height of track A-B;Collapse Uncollapse Folder under mouse cursor
   * О скрипте:   Переключить высоту дорожки A-B;Свернуть Развернуть Папку под курсором мыши
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Supa75(RMM)
   * Gave idea:   Supa75(RMM)
   * Changelog:   +  Fixed paths for Mac/ v.1.01 [29.01.19] 
   *              +  Исправлены пути для Mac/ v.1.01 [29.01.19]  

   *              +  initialе / v.1.0 [24.01.2019]
   
   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.965 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.2.2 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local HEIGHT_A = 60
    local HEIGHT_B = 180
    --------------------- | УСТАНОВИТЕ ВЫСОТУ ТРЕКА А-Б В ПИКСЕЛЯХ.
        ----------------  | SET HEIGHT OF TRACK A-B IN PIXELS.
            --------------------------------------------------


    local COLAPSE_TCP = 0   
    ----------------- = 0 | СЖАТИЕ ПАПКИ; НОРМАЛЬНЫЙ - КРОШЕЧНЫЕ ДЕТИ.
        ------------- = 1 | СЖАТИЕ ПАПКИ; НОРМАЛЬНЫЙ - МАЛЕНЬКИЕ ДЕТИ.
            --------- = 2 | СЖАТИЕ ПАПКИ; НОРМАЛЬНЫЙ - МАЛЕНЬКИЕ ДЕТИ - КРОШЕЧНЫЕ ДЕТИ.
                          -------------------------------------------------------------
                ----- = 0 | FOLDER COMPRESSION; NORMAL - TINY CHILDREN.
                   -- = 1 | FOLDER COMPRESSION; NORMAL - SMALL KIDS.
                   -- = 2 | FOLDER COMPRESSION; NORMAL - SMALL CHILDREN - TINY CHILDREN.
                          --------------------------------------------------------------


    local COLAPSE_MCP = 0
    ----------------- = 0 |  НЕ СВОРАЧИВАТЬ ДОРОЖКУ В МИКШЕРЕ.
        ------------- = 1 |  СВОРАЧИВАТЬ ДОРОЖКУ В МИКШЕРЕ.
                          ---------------------------------
            --------- = 0 | NOT TO TURN TRACK IN THE MIXER.
                ----- = 1 | TO TURN OFF TRACK IN THE MIXER.
                    ---------------------------------------



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




    local retval,context,position = reaper.BR_TrackAtMouseCursor();
    if not retval then Arc.no_undo() return end;

    if context == 0 and position == -1  and retval then;

        local FoldTrack = reaper.GetMediaTrackInfo_Value(retval,"I_FOLDERDEPTH");
        if FoldTrack == 1 then;

            local Colapse = reaper.GetMediaTrackInfo_Value(retval,"I_FOLDERCOMPACT");

            if COLAPSE_TCP == 0 then;
                if Colapse == 2 then;
                    reaper.SetMediaTrackInfo_Value(retval,"I_FOLDERCOMPACT",0);
                    if COLAPSE_MCP == 1 then;
                        Arc.SetCollapseFolderMCP(retval,1,0);
                    end;
                else;
                    reaper.SetMediaTrackInfo_Value(retval,"I_FOLDERCOMPACT",2);
                    if COLAPSE_MCP == 1 then;
                        Arc.SetCollapseFolderMCP(retval,1,1);
                    end;
                end;
                ----
            elseif COLAPSE_TCP == 1 then;
                ----
                if Colapse == 1 or Colapse == 2 then;
                    reaper.SetMediaTrackInfo_Value(retval,"I_FOLDERCOMPACT",0);
                else;
                    reaper.SetMediaTrackInfo_Value(retval,"I_FOLDERCOMPACT",1);   
                end;
                ----
            elseif COLAPSE_TCP == 2 then;
                ----
                if Colapse == 0 then;
                    reaper.SetMediaTrackInfo_Value(retval,"I_FOLDERCOMPACT",1);
                    if COLAPSE_MCP == 1 then;
                        Arc.SetCollapseFolderMCP(retval,1,0);
                    end;
                elseif Colapse == 1 then;
                    reaper.SetMediaTrackInfo_Value(retval,"I_FOLDERCOMPACT",2);
                    if COLAPSE_MCP == 1 then;
                        Arc.SetCollapseFolderMCP(retval,1,1);
                    end;
                else;
                    reaper.SetMediaTrackInfo_Value(retval,"I_FOLDERCOMPACT",0);
                    if COLAPSE_MCP == 1 then;
                        Arc.SetCollapseFolderMCP(retval,1,0);
                    end;
                end;
                ----
            end;
        else;
            ----
            local height = reaper.GetMediaTrackInfo_Value(retval,"I_WNDH");

            if height == HEIGHT_B then;
                reaper.SetMediaTrackInfo_Value(retval,"I_HEIGHTOVERRIDE",HEIGHT_A);
            else;
                reaper.SetMediaTrackInfo_Value(retval,"I_HEIGHTOVERRIDE",HEIGHT_B);
            end;
            ----   
        end;
    end;

    reaper.TrackList_AdjustWindows(false);
    Arc.no_undo();
    -------------