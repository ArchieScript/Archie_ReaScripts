-- NoIndex: true
--[[
   * Category:    Track
   * Description: Render project in time selection on a separate created track (Pre master)
   * Author:      Archie
   * Version:     1.03
   * AboutScript: Render project in time selection on a separate created track (Pre master)
   *              NOTE THE SETTINGS BELOW
   * О скрипте:   Рендер проекта в выборе времени на отдельный созданный трек (перед мастер треком)
   *              ОБРАТИТЕ ВНИМАНИЕ НА НАСТРОЙКИ НИЖЕ
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Dimilyan (Rmm/forum)
   * Gave idea:   Dimilyan (Rmm/forum)
   * Changelog:   
   *              !+ Fixed volume issues / v.1.03 [11.02.19] 
   *              !+ Исправлены проблемы с громкостью / v.1.03 [11.02.19] 
   
   *              !+ Fixed paths for Mac/ v.1.02 [29.01.19] 
   *              !+ Исправлены пути для Mac/ v.1.02 [29.01.19]  
   *              ++ initialе / v.1.0

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




    local SelOriginalTrack = 1
                          -- 0 ОСТАВИТЬ ВЫДЕЛЕНИЕ НА ПРЕДЫДУЩИХ ТРЕКАХ
                          -- 1 ВЫДЕЛИТЬ ОТРЕНДЕРЕННЫЙ ТРЕК
                          -- 2 ВЫДЕЛИТЬ ОТРЕНДЕРЕННЫЙ ТРЕК И ОСТАВИТЬ 
                          --                  ВЫДЕЛЕНИЕ НА ПРЕДЫДУЩИХ ТРЕКАХ
                                              ------------------------------
                          -- 0 TO LEAVE THE SELECTION TO THE PREVIOUS TRACKS
                          -- 1 TO SELECT THE RENDERED TRACK
                          -- 2 TO SELECT THE RENDERED TRACK AND LEAVE 
                          --            THE SELECTION TO THE PREVIOUS TRACKS
                          --================================================


    local SelOriginalItems = 1
                    -- 0 ОСТАВИТЬ ВЫДЕЛЕНИЕ НА ПРЕДЫДУЩИХ ЭЛЕМЕНТАХ
                    -- 1 ВЫБРАТЬ ОТРЕНДЕРЕННЫЙ ЭЛЕМЕНТ
                    -- 2 ВЫБРАТЬ ОТРЕНДЕРЕННЫЙ ЭЛЕМЕНТ И ОСТАВИТЬ ВЫДЕЛЕНИЕ
                    --                              НА ПРЕДЫДУЩИХ ЭЛЕМЕНТАХ
                                                    -----------------------
                    -- 0 TO LEAVE THE SELECTION TO THE PREVIOUS ITEMS
                    -- 1 SELECT THE RENDERED ITEMS
                    -- 2 SELECT THE RENDERED ITEMS AND LEAVE THE SELECTION
                    --                                  THE PREVIOUS ITEMS
                    --====================================================




    --=========================================================================================
    --/////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\\\
    --=========================================================================================




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions',select(2,reaper.get_action_context()):match("(.+)[\\/]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.2.2",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================




    if not tonumber(SelOriginalItems)then SelOriginalItems = 1 end;

    local CountMediaItem = reaper.CountMediaItems(0);
    if CountMediaItem == 0 then Arc.no_undo() return end;

    local ItemInTimeSelection;
    local Start, End = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    if Start == End then;
        local Message = reaper.ShowMessageBox("Eng:\n   No time selection\n   "..
                                    "Set time selection for entire project ?\n"..
                                      "Rus:\n   Отсутствует выбор времени\n   "..
                            "Установить выбор времени на весь проект ?",
                            "Render all tracks in time selection on one .....",1);
        if Message == 2 then;
            Arc.no_undo() return;
        elseif Message == 1 then;
            local PosFirstIt,EndLastIt = Arc.GetPositionOfFirstItemAndEndOfLast();
            if PosFirstIt and EndLastIt then;
                reaper.GetSet_LoopTimeRange(1,0,0,EndLastIt,0);
                ItemInTimeSelection = "Active";
            end;
        end;
    else;
        for i = 1,CountMediaItem do;
            local item = reaper.GetMediaItem(0,i-1);
            local PosIt = Arc.GetMediaItemInfo_Value(item,"D_POSITION");
            local EndIt = Arc.GetMediaItemInfo_Value(item,"D_END");
            if EndIt > Start and PosIt < End then;
                ItemInTimeSelection = "Active";
            end;
        end;
    end;

    if not ItemInTimeSelection then;
        local Message = reaper.ShowMessageBox("Eng:\n   There are no items in time selection\n   "..
                                              "Set time selection for entire project ?\n"..
                                              "Rus:\n   Отсутствуют элементы в выборе времени\n   "..
                                    "Установить выбор времени на весь проект ?",
                                    "Render all tracks in time selection on one .....",1);
         if Message == 2 then;
             Arc.no_undo() return;
         elseif Message == 1 then;
             local PosFirstIt,EndLastIt = Arc.GetPositionOfFirstItemAndEndOfLast();
             if PosFirstIt and EndLastIt then;
                 reaper.GetSet_LoopTimeRange(1,0,0,EndLastIt,0);
             end;
         end;
    end;
    ---

    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);


    for i = 1,reaper.CountTracks(0) do;
        local Track = reaper.GetTrack(0,i-1);
        local Depth = reaper.GetTrackDepth(Track);
        if Depth == 0 then;
            local fold = reaper.GetMediaTrackInfo_Value(Track,'I_FOLDERDEPTH');
            if fold < 0 then;
                reaper.SetMediaTrackInfo_Value(Track,'I_FOLDERDEPTH',0);
            end;
        end;
    end;


    reaper.InsertTrackAtIndex(0,false);
    local Track = reaper.GetTrack(0,0);
    reaper.SetMediaTrackInfo_Value(Track,'I_FOLDERDEPTH',1);
    reaper.GetSetMediaTrackInfo_String(Track,"P_NAME","-RenderProjPreMaster-",1);
    local Vol = reaper.GetMediaTrackInfo_Value(Track,"D_VOL");
    reaper.SetMediaTrackInfo_Value(Track,"D_VOL",1);
    reaper.SetMediaTrackInfo_Value(Track,"D_PAN",0);

    

    Arc.SaveSelTracksGuidSlot(1);
    reaper.SetOnlyTrackSelected(Track);
    Arc.Action(41716);
    -- Render selected area of tracks to stereo post-fader stem tracks (and mute originals)


    reaper.SetMediaTrackInfo_Value(Track,'I_FOLDERDEPTH',0);
    reaper.DeleteTrack(Track);


    local Track = reaper.GetTrack(0,0);
    reaper.SetMediaTrackInfo_Value(Track,"D_VOL",Vol);
    local item = reaper.GetTrackMediaItem(Track,0);
    local Take = reaper.GetActiveTake(item); 
    reaper.GetSetMediaItemTakeInfo_String(Take,"P_NAME","-RenderProjectPreMaster-",1);

    if SelOriginalTrack == 0 then;
        Arc.RestoreSelTracksGuidSlot(1,true);
    elseif SelOriginalTrack == 2 then;
        Arc.RestoreSelTracksGuidSlot(1,true);
        reaper.SetMediaTrackInfo_Value(Track,'I_SELECTED',1);
    end;


    if SelOriginalItems == 1 then;
        reaper.SelectAllMediaItems(0,0);
        for i = reaper.CountTrackMediaItems(Track)-1,0,-1 do;
            local item = reaper.GetTrackMediaItem(Track,i);
            reaper.SetMediaItemInfo_Value(item,"B_UISEL",1);
        end; 
    elseif SelOriginalItems == 2 then;
        for i = reaper.CountTrackMediaItems(Track)-1,0,-1 do;
            local item = reaper.GetTrackMediaItem(Track,i);
            reaper.SetMediaItemInfo_Value(item,"B_UISEL",1);
        end; 
    end;

    SaveSelTr_1 = nil;
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("Render project in time selection on a".. 
                         "separate created track (Pre master)",-1);
    reaper.UpdateArrange();