--[[
   * Category:    Track
   * Description: Toggle height selected tracks in 24 pixel/revert to average values
   * Author:      Archie
   * Version:     1.04
   * AboutScript: Toggle height selected tracks in 24 pixel/revert to average values
   * О скрипте:   Переключить высоту выбранных треков в 24 пикселя / вернуться к средним значениям
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    borisuperful (RMM Forum)
   * Gave idea:   borisuperful (RMM Forum)
   * Changelog:   +  Nothing / v.1.03 [30.12.18]
   *              +  Added lock "lock track height" / v.1.01 [30.12.18]
   *              +  initialе / v.1.0 [30.12.18]
==============================================================================================
----------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.1.2 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local  heigh_lock = 1
                   -- = 0 | ОТКЛ ЗАМОК (ТРЕКИ С ВКЛЮЧЕННЫМ LOCK TRACK HEIGHT БУДУТ МАСШТАБИРОВАТЬСЯ)
                   -- = 1 | ВКЛ ЗАМОК (ТРЕКИ С ВКЛЮЧЕННЫМ LOCK TRACK HEIGHT НЕ БУДУТ МАСШТАБИРОВАТЬСЯ) 
                            --------------------------------------------------------------------------
                   -- = 0 | OFF LOCK (TRACKS WITH INCLUDED LOCK TRACK HEIGHT WILL BE SCALE)
                   -- = 1 | ON LOCK (TRACKS WITH INCLUDED LOCK TRACK HEIGHT WILL NOT BE SCALE)
                   ---------------------------------------------------------------------------




    --======================================================================================
    --////////////  ОПИСАНИЕ  \\\\\\\\\\\\  DESCRIPTION  ////////////  ОПИСАНИЕ  \\\\\\\\\\\
    --======================================================================================


    --[[
    Если среди выделенных треков есть хоть один большего размера чем 24 пикселя, 
                          то выделенные треки уменьшатся в значения 24 пикселя.
    Если все выделенные треки 24 пикселя, то увеличатся к "среднему значению"*    ​
    * КАК УВЕЛИЧИВАЮТСЯ:
    Если все невыделенные треки одного размера и больше 24 пикселей, 
           то выделенные треки станут такого же размера как и невыделенные.
    Если все невыделенные треки одного размера и 24 пикселя, то выделенные треки станут 81 пиксель.
    Если все невыделенные треки разного размера "все разного", то выделенные треки станут 81 пиксель.
    Если невыделенные треки разного размера, но дублируются,​
    например:
    Пять невыделенных треков 30 пикселей, Пять невыделенных треков 40 пикселей,Пять невыделенных треков 50 пикселей, 
                                     то тут выделенные треки возьмут размер самого большого трека, 50 пикселей.
    А если десять невыделенных треков например 25 пикселей, Пять невыделенных треков 40 пикселей,Пять невыделенных
    треков 50 пикселей, то тут уже выделенные треки возьмут размер наибольшего количества треков, то есть 25 пикселей.
    ------------------------------------------------------------------------------------------------------------------
    If among the selected tracks there is at least one larger than 24 pixels,
    then the selected tracks will decrease to 24 pixels.
    If all selected tracks are 24 pixels, they will increase to the "average value" *
    * HOW TO INCREASE:
    If all unselected tracks are the same size and more than 24 pixels,
    then the selected tracks will become the same size as the unselected ones.
    If all unselected tracks are the same size and 24 pixels, then the selected tracks will be 81 pixels.
    If all unselected tracks of different sizes "all different", then the selected tracks will be 81 pixels.
    If unselected tracks are of different sizes, but duplicated,
    for example:
    Five unselected tracks 30 pixels, Five unselected tracks 40 pixels, Five unselected tracks 50 pixels,
    then the selected tracks will take the size of the largest track, 50 pixels.
    And if ten unselected tracks, for example, 25 pixels, Five unselected tracks, 40 pixels, Five unallocated
    tracks of 50 pixels, then the already selected tracks will take the size of the largest number of tracks, that is, 25 pixels.
    ===========================================================================================================================]]




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load=reaper.GetResourcePath()..'\\Scripts\\Archie-ReaScripts\\Functions',select(2,reaper.get_action_context()):match("(.+)[\\]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.1.8",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================





    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then Arc.no_undo() return end;
    ----------------------------------------------------
    local reduce;
    for i = 1, CountSelTrack do;
        local SelTrack = reaper.GetSelectedTrack(0,i-1);
        local height = reaper.GetMediaTrackInfo_Value(SelTrack,"I_WNDH");
        if height > 24 then;
            local HeightLock = reaper.GetMediaTrackInfo_Value(SelTrack,"B_HEIGHTLOCK");
            if heigh_lock == 0 then HeightLock = 0 end;
            if HeightLock == 0 then;
                reduce = "Active";
                break;
            end;
        end;
    end;
    ---------------------------
    if reduce == "Active" then;
        for i = 1, CountSelTrack do;
            local SelTrack = reaper.GetSelectedTrack(0,i-1);
            local HeightLock = reaper.GetMediaTrackInfo_Value(SelTrack,"B_HEIGHTLOCK");
            if heigh_lock == 0 then HeightLock = 0 end;
            if HeightLock == 0 then;
                reaper.SetMediaTrackInfo_Value(SelTrack,"I_HEIGHTOVERRIDE",24);
            end;
        end;
    else;
        local Height_T = {};
        local CountTrack = reaper.CountTracks(0);
        for i = 1, CountTrack do;
            local Track = reaper.GetTrack(0,i-1);
            local Sel = reaper.GetMediaTrackInfo_Value(Track,"I_SELECTED");
            if Sel == 0 then;
                local HeightLock = reaper.GetMediaTrackInfo_Value(Track,"B_HEIGHTLOCK");
                if heigh_lock == 0 then HeightLock = 0 end;
                if HeightLock == 0 then;
                    local Height = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH");
                    if Height > 24 then;
                        Height_T[#Height_T+1] = Height;
                    end;
                end;
            end;
        end;
        ----------------------------------------------------------------
        local HeightRest = Arc.ValueFromMaxRepsIn_Table(Height_T,"MAX");
        -------------------------------------------
        if not HeightRest or HeightRest <= 24 then;
            HeightRest = 81;
        end;
        ----------------------------
        for i = 1, CountSelTrack do;
            local SelTrack = reaper.GetSelectedTrack(0,i-1);
            local HeightLock = reaper.GetMediaTrackInfo_Value(SelTrack,"B_HEIGHTLOCK");
            if heigh_lock == 0 then HeightLock = 0 end;
            if HeightLock == 0 then;
                reaper.SetMediaTrackInfo_Value(SelTrack,"I_HEIGHTOVERRIDE",HeightRest);
            end;
        end;
    end;
    --------------------------------------
    reaper.TrackList_AdjustWindows(false);
    --------------------------------------
    Arc.no_undo();
    --------------