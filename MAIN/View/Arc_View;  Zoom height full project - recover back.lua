--[[
   * Тест только на windows / Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    View
   * Features:    Startup
   * Description: Zoom height full project - recover back
   * Author:      Archie
   * Version:     1.04
   * О скрипте:   Масштабировать высоту под полный проект-Восстановление назад
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Krikets(RMM)
   * Gave idea:   Krikets(RMM)
   * Extension:   Reaper 5.983+ http://www.reaper.fm/
   *              Arc_Function_lua v.2.6.5+   Repository - (Archie-ReaScripts)  http://clck.ru/EjERc
   *              SWS v.2.10.0+ http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.04 [24.09.19]
   *                  ---
   
   *              v.1.03 [21.09.19]
   *                  ! not show help window at startup reaper
   *              v.1.02 [16.09.19]
   *                  ! Fix bug flickering button  
   *              v.1.01 [15.09.19]
   *                  ! Performance: Break previous copy "defer"
   *                  + Added ability to zoom on selected tracks
   *              v.1.0 [14.09.19]
   *                  + initialе
--]]
    
        
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    --Скрипт масштабирует все треки под размер экрана или от первого выделенного до последнего выделенного
    --The script scales all tracks to fit the screen or from the first selected to the last selected
    
    
    local shrink = 255
    local shrink_FullScreen = 195
                 -- | Отрегулируйте отступ снизу как вам удобно
                 -- | shrink = 0 / shrink = 100 / shrink = 200 и т.д.
                 -- | Нужно отнять расстояние от верха монитора до начала видимости трека, снизу также*
                      --------------------------------------------------------------------------------
                 -- | Adjust the padding at the bottom as you like
                 -- | shrink = 0 / shrink = 10 / shrink = 20 etc.
                 -- | You need to subtract the distance from the top of the monitor to the beginning of the track visibility, from the bottom also
                      ----------------------------------------------------------------------------------------------------------------------------
                 -- *Screen: http://avatars.mds.yandex.net/get-pdb/2011865/f84c2b64-f46a-4e2a-bc36-a1a23d6fa1e5/s1200
                 ---------------------------------------------------------------------------------------------
    
    
    
    local ZOOM_SELECTED_TRACK = 1
                           -- = 0 | Игнорировать выделенные треки и масштабировать только все треки
                           -- = 1 | Масштабировать по выделенным трекам, если нет выделенных, то все треки.
                                    -----------------------------------------------------------------------
                           -- = 0 | Scale by selected tracks, if not selected, then all tracks.
                           -- = 1 | Ignore selected tracks and scale only all tracks.
                           ----------------------------------------------------------
    
    
    
    local
    STARTUP = 1
         -- = 0 Отключить автозапуск скрипта*
         -- = 1 Включить автозапуск скрипта*
         -- * После изменения запустите скрипт, что бы изменения вступили в силу
              ------------------------------------------------------------------
         -- = 0 Disable script autorun*
         -- = 1 Enable script autorun*
         -- * After the change, run the script so that the changes take effect
         ----------------------------------------------------------------------
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.6.5",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ============== 
    
   
    
    
   
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context();
    local extnameProj = filename:match(".+[/\\](.+)");
    
    
    -----------------------------------------------------
    local function FitAllTracksToFullScreen(shrink,shrink_FullScreen,minHeigth);
        if not tonumber(minHeigth)then minHeigth = 24 end;------*
        local TrackT = {};
        local DepthFold;
        local TotalHeightLock = 0;
        -----
        local Toggle = reaper.GetToggleCommandStateEx(0,40346);--Toggle fullscreen
        if Toggle == 1 then shrink = shrink_FullScreen end;
        -----
        
        local numbFirst,numbLast;
        local FirstSelTrack = reaper.GetSelectedTrack(0,0);
        if FirstSelTrack and ZOOM_SELECTED_TRACK == 1 then;
            local LastSelTrack = reaper.GetSelectedTrack(0,reaper.CountSelectedTracks(0)-1);
            numbFirst = reaper.GetMediaTrackInfo_Value(FirstSelTrack,"IP_TRACKNUMBER");
            numbLast = reaper.GetMediaTrackInfo_Value(LastSelTrack,"IP_TRACKNUMBER");
        else;
            numbFirst = 1;
            numbLast = reaper.CountTracks(0);
        end;
        
        -----
        for i = numbFirst, numbLast do;
        --for i = 1, reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            local Height = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH");
            local showTCP = reaper.GetMediaTrackInfo_Value(Track,"B_SHOWINTCP");
            local HeightLock = reaper.GetMediaTrackInfo_Value(Track,"B_HEIGHTLOCK");
            -----
            if HeightLock == 1 and showTCP == 1 then;
                TotalHeightLock = TotalHeightLock + Height;
            end;
            -----
            if DepthFold then;
                local DepthChild = reaper.GetTrackDepth(Track);
                if DepthChild <= DepthFold then;
                    DepthFold = nil;
                else;
                    if showTCP == 1 and HeightLock == 0 then;
                        TotalHeightLock = TotalHeightLock + Height;
                    end;
                end;
            end;
            -----
            if not DepthFold and HeightLock == 0 and showTCP == 1 then;
                table.insert(TrackT,Track);
            end;
            -----  
            if not DepthFold then;
                local Fold = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH");
                if Fold == 1 then;
                    local FoldCom = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERCOMPACT");
                    if FoldCom > 0 then; DepthFold = reaper.GetTrackDepth(Track);end;
                end;
            end;
        end;
        -----
        local _,_, scr_x, scr_y = reaper.my_getViewport(0,0,0,0,0,0,0,0,true);
        local heightAll = math.floor(((scr_y-TotalHeightLock-(shrink or 245))/#TrackT));
        if heightAll < minHeigth then heightAll = minHeigth end;
        -----
        ::RecountGOTO::;
        --X=(X or 0)+1;
        for i = 1, #TrackT do;
            Arc.SetHeightTrack_Env_TCP(TrackT[i],heightAll,minHeigth);
        end;
        reaper.TrackList_AdjustWindows(false);
        -----
        local Recalculate = 0;
        for i = #TrackT,1,-1 do;
            local Height = reaper.GetMediaTrackInfo_Value(TrackT[i],"I_WNDH");
            if Height > heightAll then;
                Recalculate = Recalculate + (Height - heightAll);
            end;
            if Height > heightAll or Height <= minHeigth then;
                table.remove(TrackT,i);
            end;
        end;
        -----
        if Recalculate > 0 then;
           heightAll = math.floor((heightAll-(Recalculate/#TrackT))+.5);
           if heightAll < minHeigth then heightAll = minHeigth end;
           goto RecountGOTO;
        end;
    end;
    -----------------------------------------------------
    
    
    -----------------------------------------------------
    local function GetHeightAllTrack();
        local Track1 = reaper.GetTrack(0,0);
        local Track2 = reaper.GetTrack(0,reaper.CountTracks(0)-1);
        if Track1 and Track2 then;
            local Height1 = reaper.GetMediaTrackInfo_Value(Track1,"I_TCPY");
            local Height2 = reaper.GetMediaTrackInfo_Value(Track2,"I_TCPY");
            local Height3 = reaper.GetMediaTrackInfo_Value(Track2,"I_WNDH");
            return(Height2-Height1+Height3);
        else;
            return 0;
        end;
    end;
    -----------------------------------------------------    
    
    
    -----------------------------------------------------
    local function SaveHeightAllTrack(isSet);
        local SaveGuidHeight;
        for i = 1, reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            local showTCP = reaper.GetMediaTrackInfo_Value(Track,"B_SHOWINTCP");
            if showTCP == 1 then;
                local Height = reaper.GetMediaTrackInfo_Value(Track,"I_TCPH");
                local GUID = reaper.GetTrackGUID(Track);
                SaveGuidHeight = (SaveGuidHeight or "").."{"..GUID..Height.."}";
            end;
        end;
        reaper.SetProjExtState(0,extnameProj,"SaveGuidHeight",SaveGuidHeight);
    end;
    -----------------------------------------------------
    
    
    -----------------------------------------------------
    local function RestoreHeightAllTrack();
        local _,ExtState= reaper.GetProjExtState(0,extnameProj,"SaveGuidHeight")
        for val in ExtState:gmatch("{{.-}.-}")do;
            local Guid,Height = val:match("{({.-})(.-)}");
            local Track = reaper.BR_GetMediaTrackByGUID(0,Guid);
            if Track then;
                reaper.SetMediaTrackInfo_Value(Track,"I_HEIGHTOVERRIDE",Height);
            end;   
        end;
        reaper.TrackList_AdjustWindows(false);
    end;
    -----------------------------------------------------
    
    
    -----------------------------------------------------
    local function VerticalScrollSelectedTracksIntoView();
        local track = reaper.GetTrack(0,0);
        local sel = reaper.GetMediaTrackInfo_Value(track,"I_SELECTED");
        if sel == 1 then;
            reaper.CSurf_OnScroll(0,-1000);
        else;
            reaper.Main_OnCommand(40913,0)--Vertical scroll selected tracks into view
        end;
    end;
    -----------------------------------------------------
    
    
    -----------------------------------------------------
    local function scroll();
        if not reaper.GetSelectedTrack(0,0)then;
            reaper.CSurf_OnScroll(0,-1000);
        else;
            VerticalScrollSelectedTracksIntoView();
        end;
    end;
    -----------------------------------------------------
    
    
    -----------------------------------------------------
    local function loop();
        
        ----- stop Double Script -------
        local ActiveDoubleScr,stopDoubleScr;
        if not ActiveDoubleScr then;
            stopDoubleScr = (tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr"))or 0)+1;
            reaper.SetExtState(extnameProj,"stopDoubleScr",stopDoubleScr,false);
            ActiveDoubleScr = true;
        end;
        local stopDoubleScr2 = tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr"));
        if stopDoubleScr2 > stopDoubleScr then return end;
        --------------------------------
        
        local ToggleSaveHeight = tonumber(({reaper.GetProjExtState(0,extnameProj,"ToggleSaveHeight")})[2])or -1;
        local HeightAllTrack = GetHeightAllTrack();
        local Toggle = reaper.GetToggleCommandStateEx(sectionID,cmdID);
        if HeightAllTrack == ToggleSaveHeight then;
            if Toggle ~= 1 then;
                reaper.SetToggleCommandState(sectionID,cmdID,1);--t=(t or 0)+1
                reaper.RefreshToolbar2(sectionID,cmdID);
            end;
        else;
            if Toggle ~= 0 then;
                reaper.SetToggleCommandState(sectionID,cmdID,0);--t2=(t2 or 0)+1
                reaper.RefreshToolbar2(sectionID,cmdID);
            end;
        end;
        reaper.defer(loop);
    end;
    -----------------------------------------------------
    
    
    
    ---___-----------------------------------------------
    if STARTUP == 1 then;
        --reaper.DeleteExtState(extnameProj,"FirstRun",false);
        local FirstRun = reaper.GetExtState(extnameProj,"FirstRun")=="";
        if FirstRun then;
            reaper.SetExtState(extnameProj,"FirstRun",1,false);
        end;
    end;
    -----------------------------------------------------
    
    
    loop();
    
    
    -----------------------------------------------------
    if not FirstRun then;
        Arc.HelpWindowWhenReRunning(2,"Arc_Function_lua",false,"/ "..extnameProj);
        local CountTrack = reaper.CountTracks(0);
        if CountTrack == 0 then Arc.no_undo() return end;
        
        local ToggleSaveHeight = tonumber(({reaper.GetProjExtState(0,extnameProj,"ToggleSaveHeight")})[2])or -1;
        local HeightAllTrack = GetHeightAllTrack();
        if HeightAllTrack ~= ToggleSaveHeight then;
            reaper.SetToggleCommandState(sectionID,cmdID,1);
            reaper.RefreshToolbar2(sectionID,cmdID);
            SaveHeightAllTrack();
            FitAllTracksToFullScreen(shrink,shrink_FullScreen)
            HeightAllTrack = GetHeightAllTrack();
            reaper.SetProjExtState(0,extnameProj,"ToggleSaveHeight",HeightAllTrack);
            scroll();
        else;
            reaper.SetToggleCommandState(sectionID,cmdID,0);
            reaper.RefreshToolbar2(sectionID,cmdID);
            reaper.SetProjExtState(0,extnameProj,"ToggleSaveHeight","");
            RestoreHeightAllTrack();
            scroll();
        end;
    end;
    -----------------------------------------------------
    
    
    
    
    
    ---___-----------------------------------------------
    local scriptPath,scriptName = filename:match("(.+)[/\\](.+)");
    local id = Arc.GetIDByScriptName(scriptName,scriptPath);
    if id == -1 or type(id) ~= "string" then Arc.no_undo()return end;
    local check_Id, check_Fun = Arc.GetStartupScript(id);
    
    if STARTUP == 1 then;
        if not check_Id then;
            Arc.SetStartupScript(scriptName,id);
        end;
    else;
        if check_Id then;
            Arc.SetStartupScript(scriptName,id,nil,"ONE");
        end;
    end;
    -----------------------------------------------------