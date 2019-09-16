--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    View
   * Description: Zoom TCP to fit screen
   * Author:      Archie
   * Version:     1.01
   * Описание:    Масштабирование TCP по размеру экрана
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    YuriOl(RMM)
   * Gave idea:   YuriOl(RMM)
   * Extension:   Reaper 5.983+ http://www.reaper.fm/
   *              Arc_Function_lua v.2.6.1+  (Repository Archie-ReaScripts)  http://clck.ru/EjERc
   * Changelog:   
   *              v.1.01 [15.09.2019]
   *                + Scroll selected tracks to the center
   
   *              v.1.0 [14.09.2019]
   *                + initialе
--]]
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    local shrink = 255
    local shrink_FullScreen = 180
                 -- | Отрегулируйте отступ снизу как вам удобно
                 -- | shrink = 0 / shrink = 100 / shrink = 200 и т.д.
                          -----------------------------------------
                 -- | Adjust the padding at the bottom as you like
                 -- | shrink = 0 / shrink = 10 / shrink = 20 etc.
                 ------------------------------------------------
    
    
    
    local ScrollTop = 0
                 -- = 0 | Отключить прокрутку вверх
                 -- = 1 | Включить прокрутку вверх
                          ------------------------
                 -- = 0 | Disable scroll up
                 -- = 1 | Enable scroll up
                 -------------------------
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.6.1",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ============== 
    
    
    
    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then Arc.no_undo() return end;
    
    
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context();
    
    
    -----------------------------------------------------
    local function FitAllTracksToFullScreen(shrink,minHeigth);
        if not tonumber(minHeigth)then minHeigth = 24 end;
        local TrackT, minHeigth, DepthFold = {},24;
        local TotalHeightLock = 0;
        -----
        local Toggle = reaper.GetToggleCommandStateEx(0,40346);--Toggle fullscreen
        if Toggle == 1 then shrink = shrink_FullScreen end;
        -----
        for i = 1, reaper.CountTracks(0) do;
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
        local HeightAll;
        for i = 1, reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            local showTCP = reaper.GetMediaTrackInfo_Value(Track,"B_SHOWINTCP");
            if showTCP == 1 then; 
                local Height = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH");
                HeightAll = (HeightAll or 0)+Height;
            end;
        end;
        return HeightAll;
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
    
    
    ----
    local Restart = tonumber(reaper.GetExtState(filename,"Restart"))or -1;
    local HeightAllTrack = GetHeightAllTrack();
    if HeightAllTrack ~= Restart then;
        FitAllTracksToFullScreen(shrink,"",shrink_FullScreen)
        HeightAllTrack = GetHeightAllTrack();
        reaper.DeleteExtState(filename,"Restart",false);
        reaper.SetExtState(filename,"Restart",HeightAllTrack,false);
        ---
        reaper.PreventUIRefresh(1);
        
        if ScrollTop == 1 then;
            reaper.CSurf_OnScroll(0,-1000);
            reaper.CSurf_OnScroll(0, 1   );
            reaper.CSurf_OnScroll(0, -1  );
        else;    
            VerticalScrollSelectedTracksIntoView();
        end;
        
        reaper.PreventUIRefresh(-1);
    end;
    -----------------------------------------------------
    
    
    Arc.no_undo();