--[[
   * Category:    Track
   * Description: Render selected tracks on one separate track(mute originals)(Pre master)
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Render selected tracks on one separate track(mute originals)(Pre master)
   *              NOTE THE SETTINGS BELOW
   * О скрипте:   Рендер выбранных дорожек на одну отдельную дорожку(отключение оригиналов)(Не учитывая Fx мастер канала)
   *              ОБРАТИТЕ ВНИМАНИЕ НА НАСТРОЙКИ НИЖЕ
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---
   * Gave idea:   Dimilyan (Rmm/forum) 
   * Changelog:   + Added a pop-up error when no tracks are selected / v 1.01[08122018]
   *              + Добавлена всплывающая ошибка при отсутствии выбранных треков / v 1.01[08122018]
     *              + initialе / v.1.0[08122018]
--============================================================================================|
----------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.0.5 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================




    local SelOriginalTrack = 1
                    -- 0 ОСТАВИТЬ ВЫДЕЛЕНИЕ НА ПРЕДЫДУЩИХ ТРЕКАХ
                    -- 1 ВЫБРАТЬ ОТРЕНДЕРЕННЫЙ ТРЕК
                    -- 2 ВЫБРАТЬ ОТРЕНДЕРЕННЫЙ ТРЕК И ОСТАВИТЬ ВЫДЕЛЕНИЕ
                    --                              НА ПРЕДЫДУЩИХ ТРЕКАХ
                                        --------------------------------
                    -- 0 TO LEAVE THE SELECTION TO THE PREVIOUS TRACKS
                    -- 1 SELECT THE RENDERED TRACK
                    -- 2 SELECT THE RENDERED TRACK AND LEAVE THE 
                    --            ALLOCATION ON THE PREVIOUS TRACKS
                    --=============================================


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
    local Fun,scr,dir,MB,Arc,Load=reaper.GetResourcePath()..'\\Scripts\\Archie-ReaScripts\\Functions',select(2,reaper.get_action_context()):match("(.+)[\\]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.1.8",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================




    local CountSelectedTrack = reaper.CountSelectedTracks(0);
    if CountSelectedTrack == 0 then;
        reaper.ShowMessageBox("Eng:\n   No tracks selected\n"..
                              "Rus:\n   Нет выделенных треков",
                              "Error",0);
        Arc.no_undo() return;
    end;

    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);

    if not tonumber(MuteOriginalTrack)then MuteOriginalTrack = 0 end;


    Arc.SaveSelTracksGuidSlot(1);
    Arc.SaveSoloMuteStateAllTracksGuidSlot(1);


    Arc.Action(41716);
    -- Render selected area of tracks to stereo post-fader stem tracks (and mute originals) 

    local FirstSelTrack = reaper.GetSelectedTrack(0,0);
    local NumFirstTrack = reaper.GetMediaTrackInfo_Value(FirstSelTrack,'IP_TRACKNUMBER');
    reaper.GetSetMediaTrackInfo_String(FirstSelTrack,"P_NAME", "-Render-",1);
    reaper.SetMediaTrackInfo_Value(FirstSelTrack,'I_SELECTED',0);

    for i = 1, reaper.CountSelectedTracks(0) do;
        local SelTrack = reaper.GetSelectedTrack(0,i-1);
        for i2 = reaper.CountTrackMediaItems(SelTrack)-1,0,-1 do;
            local item = reaper.GetTrackMediaItem(SelTrack,i2);
            reaper.MoveMediaItemToTrack(item,FirstSelTrack);  
        end;
    end;


    local CountTrack = reaper.CountTracks(0);
    reaper.ReorderSelectedTracks(CountTrack,0);
    for i = reaper.CountSelectedTracks(0)-1,0,-1 do;
        local SelTrack = reaper.GetSelectedTrack(0,i);
        reaper.DeleteTrack(SelTrack);
    end

    Arc.Save_Selected_Items_GuidSlot(1);
    reaper.SelectAllMediaItems(0,0);

    for i = 1,reaper.CountTrackMediaItems(FirstSelTrack) do;
        local item = reaper.GetTrackMediaItem(FirstSelTrack,i-1);
        reaper.SetMediaItemInfo_Value(item,'B_UISEL',1);
    end;
    
    Arc.Action(41588);
    -- Item: Glue items

    local item = reaper.GetTrackMediaItem(FirstSelTrack,0);
    local Take = reaper.GetActiveTake(item);
    reaper.GetSetMediaItemTakeInfo_String(Take,"P_NAME","-Render-",1);


    if SelOriginalTrack == 0 then;
        Arc.RestoreSelTracksGuidSlot(1,true);
    elseif SelOriginalTrack == 1 then;
        reaper.SetMediaTrackInfo_Value(FirstSelTrack,'I_SELECTED',1);
    elseif SelOriginalTrack == 2 then;
        Arc.RestoreSelTracksGuidSlot(1,true);
        reaper.SetMediaTrackInfo_Value(FirstSelTrack,'I_SELECTED',1);
    end;

    if SelOriginalItems == 0 then;
        Arc.Restore_Selected_Items_GuidSlot(1,true);     
    elseif SelOriginalItems == 2 then;
        SelIt = reaper.GetSelectedMediaItem(0,0);
        Arc.Restore_Selected_Items_GuidSlot(1,true); 
        reaper.SetMediaItemInfo_Value(SelIt,"B_UISEL",1)
    end;

    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("Render selected tracks on one separate track(mute originals)(Pre master)",-1);
    reaper.UpdateArrange();