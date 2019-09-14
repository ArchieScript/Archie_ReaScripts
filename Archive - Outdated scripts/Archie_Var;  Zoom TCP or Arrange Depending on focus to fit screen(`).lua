-- NoIndex: true
--[[
   * Category:    Various
   * Description: Zoom TCP or Arrange Depending on focus to fit screen
   * Author:      Archie
   * Version:     1.00
   * AboutScript: Zoom TCP or Arrange Depending on focus to fit screen
   * О скрипте:   Увеличить TCP или Arrange В зависимости от фокуса, по размеру экрана 
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Microtonic (RMM)
   * Gave idea:   Microtonic (RMM)
   * Changelog:   
   *              v.1.00[13.05.2019]
   *                + initialе
   
   
   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.975 +           --| http://www.reaper.fm/download.php                     
   (+) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                
   (-) ReaPack v.1.2.2 -         --| http://reapack.com/repos                              
   (+) Arc_Function_lua v.2.4.1 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
   (-) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                
   =======================================================================================]] 
    
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    -------- / TCP / ---------------
    
    local shrink = 0
                 -- | Отрегулируйте отступ снизу как вам удобно 
                 -- | shrink = 0 / shrink = 10 / shrink = 20 и т.д.
                          -----------------------------------------
                 -- | Adjust the padding at the bottom as you like
                 -- | shrink = 0 / shrink = 10 / shrink = 20 etc.
                 ------------------------------------------------
    
    
    
    local ScrollTop = 1
                 -- = 0 | Отключить прокрутку вверх
                 -- = 1 | Включить прокрутку вверх
                          ------------------------
                 -- = 0 | Disable scroll up
                 -- = 1 | Enable scroll up
                 -------------------------
    
    
    
    local  heigh_lock = 1
                   -- = 0 | ОТКЛ ЗАМОК (ТРЕКИ С ВКЛЮЧЕННЫМ LOCK TRACK HEIGHT БУДУТ МАСШТАБИРОВАТЬСЯ)
                   -- = 1 | ВКЛ ЗАМОК (ТРЕКИ С ВКЛЮЧЕННЫМ LOCK TRACK HEIGHT НЕ БУДУТ МАСШТАБИРОВАТЬСЯ)
                            --------------------------------------------------------------------------
                   -- = 0 | OFF LOCK (TRACKS WITH INCLUDED LOCK TRACK HEIGHT WILL BE SCALE)
                   -- = 1 | ON LOCK (TRACKS WITH INCLUDED LOCK TRACK HEIGHT WILL NOT BE SCALE)
                   ---------------------------------------------------------------------------
    
    
    
    
    -------- / ARRANGE / ---------------
    
    
    local INDENT_END = 0
                    -- | ОТРЕГУЛИРУЙТЕ ОТСТУП В КОНЦЕ КАК ВАМ УДОБНО 
                         -------------------------------------------
                    -- | REGULATE REMEDY AT THE END AS CONVENIENT FOR YOU
                    -----------------------------------------------------
    
    
    
    local INDENT_START = -5
                    -- | ОТРЕГУЛИРУЙТЕ ОТСТУП В НАЧАЛЕ КАК ВАМ УДОБНО 
                         --------------------------------------------
                    -- | REGULATE RETIREMENT AT THE BEGINNING HOW YOU COMFORTABLE
                    -------------------------------------------------------------
    
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.4.1",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ============== 
    
    
    
    
    local function Arrange();
        local startTime,endTime;
        local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,1,0,0,0);
        local startTimeSel, endTimeSel = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
        if startLoop == endLoop then;
            startTime = startTimeSel;
            endTime = endTimeSel;
        else;
            startTime = startLoop;
            endTime = endLoop;
        end;
        
        local ProjectLength = reaper.GetProjectLength(0);
        
        if startTime == endTime then startTime = 0 endTime = ProjectLength end;
        
        local START = (startTime-(endTime-startTime)/150)-(INDENT_START / 100);
        local END = (endTime + (endTime-startTime)/50)+ (INDENT_END / 100);
        
        reaper.GetSet_ArrangeView2(0,1,0,0, START, END);
        reaper.UpdateTimeline();
    end;
    ----------------------------------------------------
    
    
    
    
    local function TCP();
        shrink = shrink + 7;
        local CountTrack = reaper.CountTracks(0);
        if CountTrack == 0 then Arc.no_undo() return end;
        
        reaper.PreventUIRefresh(1);
        
        local HeightPlus, TrackT, DepthFold, DepthChild = 0,{};
        
        for i = 1, CountTrack do;
            local Track = reaper.GetTrack(0,i-1);
            local showTCP = reaper.GetMediaTrackInfo_Value(Track,"B_SHOWINTCP");
            local HeightLock = reaper.GetMediaTrackInfo_Value(Track,"B_HEIGHTLOCK");
            ----
            
            if heigh_lock ~= 1 then HeightLock = 0 end;
            
            if HeightLock == 1 then;
                if showTCP == 1 then;
                    local Height = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH");
                    HeightPlus = HeightPlus + Height;
                end;
            end;
            
            if DepthFold then;
                DepthChild = reaper.GetTrackDepth(Track); 
                if DepthChild <= DepthFold then;
                    DepthFold = nil;
                else;
                    if showTCP == 1 then;
                        if HeightLock == 0 then;
                            local Height = reaper.GetMediaTrackInfo_Value(Track,"I_WNDH");
                            HeightPlus = HeightPlus + Height;
                        end;
                    end;
                end;
            end;
            
            if not DepthFold and HeightLock == 0 then;
                if showTCP == 1 then;
                    table.insert(TrackT,Track);
                end;
            end;
            
            if not DepthFold then;
                local Fold = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH");
                if Fold == 1 then;
                    local FoldCom = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERCOMPACT");
                    if FoldCom > 0 then;
                        DepthFold = reaper.GetTrackDepth(Track);  
                    end;
                end;
            end;
        end;
        
        local _,_, scr_x, scr_y = reaper.my_getViewport(0,0,0,0,0,0,0,0,true);
        --local heightAll = math.floor(((scr_y-HeightPlus-210)/#TrackT)+0.5);
        local heightAll = math.floor(((scr_y-HeightPlus-210-(shrink or 0))/#TrackT)+0.5);
        
        for i = 1, #TrackT do;
            reaper.SetMediaTrackInfo_Value(TrackT[i],"I_HEIGHTOVERRIDE",heightAll);
        end
        
        reaper.TrackList_AdjustWindows(false);
        
        if ScrollTop == 1 then;
            reaper.CSurf_OnScroll(0,-1000);
            reaper.CSurf_OnScroll(0, 1   );
            reaper.CSurf_OnScroll(0, -1  );
        end;
        
        reaper.PreventUIRefresh(-1);
    end;  
    ----------------
    
    
    
    local CursorContext = reaper.GetCursorContext2(true);
    if CursorContext > 0 then;
        Arrange();
    else;
        TCP();
    end;
    
    reaper.UpdateArrange();
    Arc.no_undo();
