--[[
   * Category:    Item
   * Description: Move selected items to each other
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Move the selected items to each other (from first selected in track)
   *              NOTE THE SETTINGS BELOW
   * О скрипте:   Перемещение выбранных элементов друг к другу (от первого выбранного в треке)
   *              ОБРАТИТЕ ВНИМАНИЕ НА НАСТРОЙКИ НИЖЕ
   * GIF:         http://clck.ru/EiSgF
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    HDVulcan [Rmm/forum]
   * Gave idea:   HDVulcan [Rmm/forum]
   * Changelog:   + Fix bug with undo / v.1.01 [04122018]
   *              + initialе / v.1.0
--============================================================================================|
----------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   + Reaper v.5.962 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.1.1.6 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local Time_interval = 0
                     -- = УСТАНОВИТЕ ИНТЕРВАЛ ОТСТУПА ДРУГ ОТ ДРУГА ПРИ ПЕРЕМЕЩЕНИИ "В СЕКУНДАХ"
                     -- = SET THE OFFSET INTERVAL FROM EACH OTHER WHEN MOVING IN SECONDS
                     -------------------------------------------------------------------


    local interval_Start_End = 1
                          -- = 0 ЭЛЕМЕНТ БУДЕТ ПЕРЕМЕЩАТЬСЯ К ПРЕДЫДУЩЕМУ К НАЧАЛЬНОЙ ПОЗИЦИИ
                          -- = 1 ЭЛЕМЕНТ БУДЕТ ПЕРЕМЕЩАТЬСЯ К ПРЕДЫДУЩЕМУ К КОНЕЧНОЙ ПОЗИЦИИ
                                                                       ---------------------
                          -- = 0 THE ITEM WILL MOVE TO THE PREVIOUS STARTING POSITION
                          -- = 1 THE ITEM WILL MOVE TO THE PREVIOUS TARGET POSITION  
                          --------------------------------------------------------


    local fade_in = 0
               -- = УСТАНОВИТЕ ПОСТЕПЕННОЕ УСИЛЕНИЕ В СЕКУНДАХ НА ВЫДЕЛЕННЫХ ЭЛЕМЕНТАХ
               -- = SET FADE IN IN SECONDS ON SELECTED ITEMS
               ---------------------------------------------


    local fade_out = 0
               -- = УСТАНОВИТЕ ПОСТЕПЕННОЕ ЗАТУХАНИЕ В СЕКУНДАХ НА ВЫДЕЛЕННЫХ ЭЛЕМЕНТАХ
               -- = SET FADE OUT IN SECONDS ON SELECTED ITEMS




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --======================================= FUNCTION MODULE FUNCTION =============================================================
    local Path,Mod,T,Way = reaper.GetResourcePath()--================== FUNCTION MODULE FUNCTION ===================================
    T = {Path..'\\Scripts\\Archie-ReaScripts\\Functions',(select(2,reaper.get_action_context()):match("(.+)[\\]")),Path};--=========
    for i=1,#T do;for j=0,math.huge do;Mod=reaper.EnumerateFiles(T[i],j);--=========================================================
        if Mod=="Arc_Function_lua.lua"then Way=T[i]break end;if not Mod then break end;end;if Way then break end;--=================
    end;if not Way then reaper.MB ('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in \n'..T[1]
    ..'\n\nОтсутствует файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..T[1],"Error.",0)else;--
    package.path = package.path..";"..Way.."/?.lua";Arc=require"Arc_Function_lua";Arc.VersionArc_Function_lua("2.1.8",Way,"")end;---
    --=========================================================================================================▲▲▲▲▲================




    local CountSelItem,Start = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then Arc.no_undo()return end;

    reaper.Undo_BeginBlock();

    if Time_interval < 0 then Time_interval = 0 end;local numb = Time_interval;
    if interval_Start_End == 0 then Start = "Active" end;

    local CountTrack,shift = reaper.CountTracks(0);
    if CountTrack == 0 then Arc.no_undo()return end;
    for j = 1,CountTrack do;
        local track = reaper.GetTrack(0,j-1);
        local CountTrSelItem,Pos2,End = Arc.CountTrackSelectedMediaItems(track);
        if CountTrSelItem > 1 then;
            for i = 1,CountTrSelItem do;
                local SelTrItem = Arc.GetTrackSelectedMediaItems(track,i-1);
                local Pos = Arc.GetMediaItemInfo_Value(SelTrItem,"D_POSITION");
                if Pos2 then;
                    if Pos >= Pos2 then;
                        if Start then shift = Pos2 else shift = End end;
                        reaper.SetMediaItemInfo_Value(SelTrItem,"D_POSITION",shift+numb);
                    end;
                end;
                Pos2 = Arc.GetMediaItemInfo_Value(SelTrItem,"D_POSITION");
                End = Arc.GetMediaItemInfo_Value(SelTrItem,"D_END");
            end;
        end;
    end;


    for i = 1,CountSelItem do;  
        local SelItem = reaper.GetSelectedMediaItem(0,i-1);
        if fade_in >= 0 then;
            reaper.SetMediaItemInfo_Value(SelItem,"D_FADEINLEN",fade_in);
        end;
        if fade_out >= 0 then;
            reaper.SetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN",fade_out);    
        end;
    end;  

    reaper.UpdateArrange(); 
    reaper.Undo_EndBlock("Move selected items to each other",4);