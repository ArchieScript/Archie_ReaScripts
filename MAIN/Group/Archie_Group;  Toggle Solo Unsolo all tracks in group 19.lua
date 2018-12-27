--[[
   * Category:    Group
   * Description: Toggle Solo Unsolo all tracks in group 19
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Toggle Solo Unsolo all tracks in group 19
   * О скрипте:   Переключить Соло Unsolo все треки в группе 19
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Maestro Sound(RMM Forum)
   * Gave idea:   Maestro Sound(RMM Forum)
   * Changelog:   +  initialе / v.1.0 [27.12.18]
==============================================================================================
----------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.2.8 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local Button_State_On_Off = 1
                           -- = 0 | ОТКЛЮЧИТЬ ПОДСВЕТКУ КНОПКИ (УСКОРЯЕТ РАБОТУ СКРИПТА)
                           -- = 1 | ВКЛЮЧИТЬ ПОДСВЕТКУ КНОПКИ
                                    -------------------------
                           -- = 0 | DISABLE BUTTON BACKLIGHT (SPEEDS UP THE SCRIPT)
                           -- = 1 | ENABLE BUTTON BACKLIGHT
                           --------------------------------



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
    Arc.VersionArc_Function_lua("2.0.8",ScriptPath,"")------------------------------------------------------------------------#
    --=====================================================================================================================--#
    --####################################################################################################################### 
        
   


    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then Arc.no_undo() return end;



    if Button_State_On_Off ~= 0 then;
        Arc.HelpWindowWhenReRunning(2,"byf_HelpWindowWhenReRunning",reset);
    end;

    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();
    -------------------------
    local MasterTrack = reaper.GetMasterTrack(0);
    local SelMaster = reaper.GetMediaTrackInfo_Value(MasterTrack, "I_SELECTED");
    ----------------------------------------------------------------------------
    Arc.SaveSelTracksGuidSlot(1);
    Arc.Action(40822); -- Select all tracks in group 19
    ---------------------------------------------------
    if SelMaster ~= 0 then;
       reaper.SetMediaTrackInfo_Value(MasterTrack,"I_SELECTED",0);
    end;
    ---------------
    local ON, Undo;
    local CountSelTrack = reaper.CountSelectedTracks(0);
    for i = 1,CountSelTrack do;
       local SelTrack = reaper.GetSelectedTrack(0,i-1);
       local solo = reaper.GetMediaTrackInfo_Value(SelTrack,"I_SOLO");
       if solo <= 0 then;
           ON = 1;
           break;
       end;
    end;
    ------------------
    local GUID_T = {};
    for i = 1,CountSelTrack do;
       local SelTrack = reaper.GetSelectedTrack(0,i-1);
       GUID_T[i] = reaper.GetTrackGUID(SelTrack);
       if ON == 1 then;
           reaper.SetMediaTrackInfo_Value(SelTrack,"I_SOLO",1);
           if Button_State_On_Off ~= 0 then;
               if not Work_once then;
                   Arc.SetToggleButtonOnOff(1);
                   Work_once = "Active"
               end;
           end;
           Undo = "Solo all tracks in group 19";
       else;
           reaper.SetMediaTrackInfo_Value(SelTrack,"I_SOLO",0); 
           if Button_State_On_Off ~= 0 then;
               if not Work_once then;
                   Arc.SetToggleButtonOnOff(0);
                   Work_once = "Active"
               end;
           end;
           Undo = "Unsolo all tracks in group 19";
       end;
    end;
    -------------------------------------
    Arc.RestoreSelTracksGuidSlot(1,true);
    -----------------------
    if SelMaster ~= 0 then;
       reaper.SetMediaTrackInfo_Value(MasterTrack,"I_SELECTED",SelMaster);
    end;
    -------------
    if Undo then;
       reaper.Undo_EndBlock(Undo,-1);
    else
       reaper.Undo_EndBlock(" ! No Group / Solo all tracks in group 19",-1);
    end;
    ----
    reaper.PreventUIRefresh(-1);
    -----------
    -- counter = 0
    local function loop();
        if #GUID_T > 0 then;
            for i = 1,#GUID_T do;
                local Track = reaper.BR_GetMediaTrackByGUID(0,GUID_T[i]);
                if Track then;
                    if reaper.GetMediaTrackInfo_Value(Track,"I_SOLO") <= 0 then;
                        Arc.SetToggleButtonOnOff(0);
                        Arc.no_undo() return;
                    end;
                end;
            end;
            reaper.defer(loop);
            --counter = counter + 1;
        end;
    end;
    ----
    if Button_State_On_Off ~= 0 then;
       loop();
    end;
    ----
   
