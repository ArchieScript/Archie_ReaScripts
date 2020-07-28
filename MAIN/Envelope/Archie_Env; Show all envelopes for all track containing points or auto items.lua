--[[ 
   * Category:    Envelope 
   * Description: Show all envelopes for all track containing points or auto items 
   * Author:      Archie 
   * Version:     1.0 
   * AboutScript: Show all envelopes for all track containing points or auto items 
   * О скрипте:   Показать все конверты для всех треков, содержащих точки или элементы авто 
    
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    --- 
   * Gave idea:   --- 
   * Changelog:    
   *              +  initialе / v.1.0 [08042019] 
    
    
   --======================================================================================= 
         SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:          
   (+) - required for installation      | (+) - обязательно для установки 
   (-) - not necessary for installation | (-) - не обязательно для установки 
   ----------------------------------------------------------------------------------------- 
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                      
   (+) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                 
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                               
   (-) Arc_Function_lua v.2.3.2 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc   
   (-) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw     
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                 
   =======================================================================================]] 
    
    
        
     
    ------------------------------------------------------- 
    local function no_undo()reaper.defer(function()end)end; 
    ------------------------------------------------------- 
     
     
    local APISWS = reaper.APIExists("CF_GetSWSVersion"); 
    if not APISWS then; 
        reaper.MB("Rus:\n    Для работы скрипта требуется расширение SWS.\n".. 
                  "    ОТСУТСТВУЕТ  РАСШИРЕНИЕ  SWS !!!\n\n".. 
                  "Eng:\n    The script requires a SWS extension.\n".. 
                  "    NO SWS EXTENSION !!!" 
                  ,"ERROR",1); 
        no_undo() return; 
    end; 
     
   
    local CountTrack = reaper.CountTracks(0); 
    if CountTrack == 0 then no_undo() return end; 
     
     
    local Undo; 
    reaper.PreventUIRefresh(1); 
     
    local i = nil; 
    while true do; 
        i = (i or -1)+1; 
         
        local track = reaper.GetTrack(0,i); 
        if not track then break end; 
         
        local CountTrEnv = reaper.CountTrackEnvelopes(track); 
            
        for i = 1,CountTrEnv do; 
            local TrEnv = reaper.GetTrackEnvelope(track,i-1); 
            local CountEnvPoint = (reaper.CountEnvelopePoints(TrEnv)+1); 
            local CountAutoItem = reaper.CountAutomationItems(TrEnv); 
            if CountEnvPoint > 2 or CountAutoItem > 0 then; 
                local Alloc = reaper.BR_EnvAlloc(TrEnv,true); 
                local 
                act, 
                vis, 
                arm, 
                inLane, 
                laneHeight, 
                defaultShape, 
                minValue, 
                maxValue, 
                centerValue, 
                Type, 
                faderScaling = reaper.BR_EnvGetProperties(Alloc); 
                --- 
                if not Undo then if not vis then Undo = true reaper.Undo_BeginBlock(); end; end; 
                --- 
                reaper.BR_EnvSetProperties(Alloc,act,true,arm,inLane,laneHeight,defaultShape,faderScaling); 
                reaper.BR_EnvFree(Alloc,true); 
            end;       
        end;   
    end; 
     
    reaper.PreventUIRefresh(-1); 
     
    if Undo then 
        reaper.Undo_EndBlock("Show all envelopes for all track containing points or auto items",-1); 
    else; 
        no_undo(); 
    end; 