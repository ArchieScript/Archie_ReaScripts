--[[
   * Category:    Track
   * Description: Toggle height selected tracks in 24 pixel/revert to average values
   * Author:      Archie
   * Version:     1.03
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




    --Mod ##########  Mod  ##########  Mod  ########  Mod  ##########  Mod  ##########  Mod  ##########  Mod  ################
    local function GetSubdirectoriesUpToLevelFive(Path);----------------------------------------------------------------------#
      local T,Enu,s,h = {Path},reaper.EnumerateSubdirectories,"\\",math.huge;--------------------------------------------------#
      for i=0,h do;f1 = Enu(Path,i);if f1 then;T[#T+1]=Path..s..f1;-------------------------------------------------------------#
        for i2=0,h do;f2=Enu(Path..s..f1,i2)if f2 then T[#T+1]=Path..s..f1..s..f2;-----------------------------------------------#
          for i3=0,h do;f3=Enu(Path..s..f1..s..f2,i3)if f3 then T[#T+1]=Path..s..f1..s..f2..s..f3;--------------------------------#
            for i4=0,h do;f4 = Enu(Path..s..f1..s..f2..s..f3,i4)if f4 then T[#T+1]=Path..s..f1..s..f2..s..f3..s..f4;---------------#
              for i5=0,h do;f5=Enu(Path..s..f1..s..f2..s..f3..s..f4,i5)if f5 then T[#T+1]=Path..s..f1..s..f2..s..f3..s..f4..s..f5;--#
              -----------------------------------------------------------------------------------------------------------------------#
              end;if not f5 then break end;end;-- #########  ##     ##  ## ####      #####     ##       ##    #####    # #####    ## #
            end;if not f4 then break end;end;--- #########  ##     ##  ########    #######    ##       ##   ##   ##   ########   ##  #
          end;if not f3 then break end;end;---- ##         ##     ##  ##     ##  ##     ##   ##           ##     ##  ##     ##  ##   #
        end;if not f2 then break end;end;----- ##         ##     ##  ##     ##  ##         #####     ##  ##     ##  ##     ##  ##    #
      end;if not f1 then return T end;end;--- #########  ##     ##  ##     ##  ##          ##       ##  ##     ##  ##     ##  ##     #
    end;------------------------------------ #########  ##     ##  ##     ##  ##     ##   ##   ##  ##  ##     ##  ##     ##          #
    --------------------------------------- ##          #######   ##     ##   #######     #####   ##   ##   ##   ##     ##  ##       #
    local function GetModule(Path,file);-- ##           #####    ##     ##    #####       ###    ##    #####    ##     ##  ##        #
    local FolPath,mod,Way = GetSubdirectoriesUpToLevelFive(Path);--------------------------------------------------------------------#
    FolPath[-1]=Path..'/Scripts/Archie-ReaScripts/Functions';FolPath[0]=select(2,reaper.get_action_context()):match("(.+)[\\]");-----#
    for i=-1,#FolPath do;for i2 = 0,math.huge do; local f = reaper.EnumerateFiles(FolPath[i],i2);------------------------------------#
    if f == file then mod=true Way=FolPath[i]break end;if not f then break end;end; if mod then return mod,Way end;end;end;----------#
    ---------------------------------------------------------------------------------------------------------------------------------#
    local found_mod,ScriptPath,Arc = GetModule(reaper.GetResourcePath():gsub('%\\','/'),"Arc_Function_lua.lua")---------------------#
    if not found_mod then reaper.ClearConsole()reaper.ShowConsoleMsg('Missing file "Arc_Function_lua",\nDownload from'..-----------#
    'repository Archie-ReaScript and put in resources of Reaper.\nОтсутствует файл "Arc_Function_lua",\nСкачайте из '..-----------#
    'репозитория Archie-ReaScript и поместите в ресурсы Reaper') return end------------------------------------------------------#
    package.path = package.path..";"..ScriptPath.."/?.lua"----------------------------------------------------------------------#
    Arc = require "Arc_Function_lua"-------------------------------------------------------------------------------------------#
    Arc.VersionArc_Function_lua("2.1.2",ScriptPath,"")------------------------------------------------------------------------#
    --=====================================================================================================================--#
    --####################################################################################################################### 





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