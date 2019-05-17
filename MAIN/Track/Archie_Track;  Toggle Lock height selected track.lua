--[[
   * Category:    Track
   * Description: Toggle Lock height selected track
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Toggle Lock height selected track
   * О скрипте:   Переключатель блокировки высоты выбранного трека
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    YuriOl(RMM)
   * Gave idea:   YuriOl(RMM)
   * Changelog:   
   *              v.1.01 [17.05.19]
   *                  + fixed bug when delete track
   *                  + Исправлена ошибка при удалении трека
   
   *              v.1.0 [17.05.19]
   *                  +  initialе
  
   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.975 +           --| http://www.reaper.fm/download.php                     
   (-) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                              
   (+) Arc_Function_lua v.2.3.2 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
   (-) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                
   =======================================================================================]] 
    
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.4.1",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    
    
    
    local function GetSelectedTracksOfLastTouchOrFirstSelected();
        local TouchedTrack = reaper.GetLastTouchedTrack();
        if TouchedTrack then;
            local Sel = reaper.IsTrackSelected(TouchedTrack);
        end;
        if Sel then;
            return TouchedTrack;
        else;
            return reaper.GetSelectedTrack(0,0);
        end;
    end;
    
    
    
    local ProjectState2,Toggle2;
    local function loop();
        local ProjectState = reaper.GetProjectStateChangeCount(0);
        if ProjectState2 ~= ProjectState then;
            ProjectState2 = ProjectState;
            -----------
            local Toggle;
            local Track = GetSelectedTracksOfLastTouchOrFirstSelected();
            if Track  then;
                local heightLock = reaper.GetMediaTrackInfo_Value(Track,"B_HEIGHTLOCK");
                if heightLock == 1 then Toggle = 1 else Toggle = 0 end;
            else;
                Toggle = 0;
            end;
            
            if Toggle ~= Toggle2 then;
                if Toggle == 1 then;
                    Arc.SetToggleButtonOnOff(1);
                else;
                    Arc.SetToggleButtonOnOff(0);
                end;
                Toggle2 = Toggle;
            end;
            -- t=(t or 0)+1;
        end;
        reaper.defer(loop);
    end;
    
    
    ----------------------------------------------------
    
    Arc.HelpWindowWhenReRunning(2, "Arc_Function_lua", false);
    
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack > 0 then;
        local Track = GetSelectedTracksOfLastTouchOrFirstSelected();
        local heightLock = reaper.GetMediaTrackInfo_Value(Track,"B_HEIGHTLOCK");
        
        for i = 1, CountSelTrack do;
            local SelTrack = reaper.GetSelectedTrack(0,i-1);
            if heightLock == 0 then;
                local height = reaper.GetMediaTrackInfo_Value(SelTrack,"I_HEIGHTOVERRIDE");
                if height == 0 then;
                    height = reaper.GetMediaTrackInfo_Value(SelTrack,"I_WNDH");
                    if height < 24 then;
                        height = nil;
                    end;
                end;
                if height then;
                    reaper.SetMediaTrackInfo_Value(SelTrack,"I_HEIGHTOVERRIDE",height);
                    reaper.SetMediaTrackInfo_Value(SelTrack,"B_HEIGHTLOCK",1);
                end;
            else;
                reaper.SetMediaTrackInfo_Value(SelTrack,"B_HEIGHTLOCK",0);
            end;
            
            
        end;
        
    end;
    Arc.no_undo();
    loop();