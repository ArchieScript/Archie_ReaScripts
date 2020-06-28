--[[
   * Category:    Group
   * Description: Toggle Mute Unmute all tracks in group n
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Toggle Mute Unmute all tracks in group n
   * О скрипте:   Переключить Mute Unmute все треки в группе n
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Maestro Sound(RMM Forum)
   * Gave idea:   Maestro Sound(RMM Forum)
   * Provides:    
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 01 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 02 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 03 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 04 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 05 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 06 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 07 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 08 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 09 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 10 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 11 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 12 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 13 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 14 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 15 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 16 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 17 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 18 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 19 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 20 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 21 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 22 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 23 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 24 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 25 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 26 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 27 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 28 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 29 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 30 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 31 (`).lua
   *              [main] . > Archie_Group;  Toggle Mute Unmute all tracks in group 32 (`).lua
   * Changelog:   
   *              +  initialе / v.1.0 [27.12.18]
   
   
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




    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
	

   


    
    local
    Action = {40804,40805,40806,40807,40808,40809,40810,40811,40812,40813,
        40814,40815,40816,40817,40818,40819,40820,40821,40822,40823,40824,
        40825, 40826,40827,40828,40829,40830,40831,40832,40833,40834,40835};
        -- Select all tracks in group
    
    local
    ActionIdx = tonumber(({reaper.get_action_context()})[2]:match(".+[\\/](.+)"):match("group (%d+)"));

    if (ActionIdx or -1) >= 1 and (ActionIdx or -1) <= 32 then else;
        reaper.MB("Rus:\n * Неверное имя скрипта\n\nEng:\n * Invalid script name","Error!",0);
        Arc.no_undo() return;
    end;
 
    
   
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
    Arc.Action(Action[ActionIdx]);
    ---------------------------------------------------
    if SelMaster ~= 0 then;
       reaper.SetMediaTrackInfo_Value(MasterTrack,"I_SELECTED",0);
    end;
    ---------------
    local ON, Undo, Work_once;
    local CountSelTrack = reaper.CountSelectedTracks(0);
    for i = 1,CountSelTrack do;
       local SelTrack = reaper.GetSelectedTrack(0,i-1);
       local mute = reaper.GetMediaTrackInfo_Value(SelTrack,"B_MUTE");
       if mute <= 0 then;
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
           reaper.SetMediaTrackInfo_Value(SelTrack,"B_MUTE",1);
           if Button_State_On_Off ~= 0 then;
               if not Work_once then;
                   Arc.SetToggleButtonOnOff(1);
                   Work_once = "Active"
               end;
           end;
           Undo = "Mute all tracks in group -"..ActionIdx;
       else;
           reaper.SetMediaTrackInfo_Value(SelTrack,"B_MUTE",0); 
           if Button_State_On_Off ~= 0 then;
               if not Work_once then;
                   Arc.SetToggleButtonOnOff(0);
                   Work_once = "Active"
               end;
           end;
           Undo = "Unmute all tracks in group -"..ActionIdx;
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
       reaper.Undo_EndBlock(" ! No Group / Mute all tracks in group -"..ActionIdx,-1);
    end;
    ----
    reaper.PreventUIRefresh(-1);
    -----------
    
    -- counter = 0
    local ProjState_X,ProjState;
    local function loop();
        if #GUID_T > 0 then;
            ProjState = reaper.GetProjectStateChangeCount(0);
            if ProjState ~= ProjState_X then;
                ProjState_X = ProjState
                for i = 1,#GUID_T do;
                    local Track = reaper.BR_GetMediaTrackByGUID(0,GUID_T[i]);
                    if Track then;
                        if reaper.GetMediaTrackInfo_Value(Track,"B_MUTE") <= 0 then;
                            Arc.SetToggleButtonOnOff(0);
                            Arc.no_undo() return;
                        end;
                    end;
                end;
                -- counter = counter + 1;
            end;
            reaper.defer(loop);
        end;
    end;
    ----
    if Button_State_On_Off ~= 0 then;
       loop();
    end;
    ----