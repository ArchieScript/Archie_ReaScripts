--[[
   * Category:    Track
   * Description: Render selected tracks on one separate track(mute originals)(Pre master)
   * Author:      Archie
   * Version:     1.0
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
   * Changelog:   +  initialе / v.1.0
--============================================================================================|
----------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.0.3 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
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




    --Mod ##########  Mod  ##########  Mod  ########  Mod  ##########  Mod  ##########  Mod  ##########  Mod  ################
    local function GetSubdirectoriesUpToLevelFive(Path);----------------------------------------------------------------------#
      local T,Enu,s,h = {Path},reaper.EnumerateSubdirectories,"\\",math.huge;--------------------------------------------------#
      for i=0,h do;f1 = Enu(Path,i);if f1 then;T[#T+1]=Path..s..f1;-------------------------------------------------------------#
        for i2=0,h do;f2=Enu(Path..s..f1,i2)if f2 then T[#T+1]=Path..s..f1..s..f2;-----------------------------------------------#
          for i3=0,h do;f3=Enu(Path..s..f1..s..f2,i3)if f3 then T[#T+1]=Path..s..f1..s..f2..s..f3;--------------------------------#
            for i4=0,h do;f4 = Enu(Path..s..f1..s..f2..s..f3,i4)if f4 then T[#T+1]=Path..s..f1..s..f2..s..f3..s..f4;---------------#
              for i5=0,h do;f5=Enu(Path..s..f1..s..f2..s..f3..s..f4,i5)if f5 then T[#T+1]=Path..s..f1..s..f2..s..f3..s..f4..s..f5;--#
              ---------------------------------------------------------#------------------------------------------------------------#
              end;if not f5 then break end;end;---- #######----#######--------#####------##-----##----##----########------##--------#
            end;if not f4 then break end;end;----- ########----########------#######-----##-----##----##----########------##--------#
          end;if not f3 then break end;end;-------##-----##----##-----##----##-----##----##-----##----------##------------##--------#
        end;if not f2 then break end;end;---------##-----##----##-----##----##-----------#########----##----########------##--------#
      end;if not f1 then return T end;end;--------#########----########-----##-----------#########----##----########------##--------#
    end;------------------------------------------#########----#######------##-----##----##-----##----##----##----------------------#
    ----------------------------------------------##-----##----##----##------#######-----##-----##----##----########------##--------#
    local function GetModule(Path,file);----------##-----##----##-----##------#####------##-----##----##----########------##--------#
    local FolPath,mod,Way = GetSubdirectoriesUpToLevelFive(Path);-------------------------------------------------------------------#
    FolPath[-1]=Path..'/Scripts/Archie-ReaScripts/Functions';FolPath[0]=select(2,reaper.get_action_context()):match("(.+)[\\]");----#
    for i=-1,#FolPath do;for i2 = 0,math.huge do; local f = reaper.EnumerateFiles(FolPath[i],i2);-----------------------------------#
    if f == file then mod=true Way=FolPath[i]break end;if not f then break end;end; if mod then return mod,Way end;end;end;---------#
    --------------------------------------------------------------------------------------------------------------------------------#
    local found_mod,ScriptPath,Arc = GetModule(reaper.GetResourcePath():gsub('%\\','/'),"Arc_Function_lua.lua")---------------------#
    if not found_mod then reaper.ClearConsole()reaper.ShowConsoleMsg('Missing file "Arc_Function_lua",\nDownload from'..-----------#
    'repository Archie-ReaScript and put in resources of Reaper.\nОтсутствует файл "Arc_Function_lua",\nСкачайте из '..-----------#
    'репозитория Archie-ReaScript и поместите в ресурсы Reaper') return end------------------------------------------------------#
    package.path = package.path..";"..ScriptPath.."/?.lua"----------------------------------------------------------------------#
    Arc = require "Arc_Function_lua"-------------------------------------------------------------------------------------------#
    Arc.VersionArc_Function_lua("2.0.3",ScriptPath,"")------------------------------------------------------------------------#
    --=====================================================================================================================--#
    --#######################################################################################################################




    local CountSelectedTrack = reaper.CountSelectedTracks(0);
    if CountSelectedTrack == 0 then Arc.no_undo() return end;

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