--[[
   * Category:    Group
   * Description: Toggle Solo Unsolo all tracks in group 16
   * Author:      Archie
   * Version:     1.01
   * AboutScript: Toggle Solo Unsolo all tracks in group 16
   * О скрипте:   Переключить Соло Unsolo все треки в группе 16
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Maestro Sound(RMM Forum)
   * Gave idea:   Maestro Sound(RMM Forum)
   * Changelog:   +  Fixed paths for Mac/ v.1.0 [29.01.19] 
   *              +  Исправлены пути для Mac/ v.1.0 [29.01.19]  
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




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions',select(2,reaper.get_action_context()):match("(.+)[\\/]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.2.2",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================

   


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
    Arc.Action(40819); -- Select all tracks in group 16
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
           Undo = "Solo all tracks in group 16";
       else;
           reaper.SetMediaTrackInfo_Value(SelTrack,"I_SOLO",0); 
           if Button_State_On_Off ~= 0 then;
               if not Work_once then;
                   Arc.SetToggleButtonOnOff(0);
                   Work_once = "Active"
               end;
           end;
           Undo = "Unsolo all tracks in group 16";
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
       reaper.Undo_EndBlock(" ! No Group / Solo all tracks in group 16",-1);
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
   
