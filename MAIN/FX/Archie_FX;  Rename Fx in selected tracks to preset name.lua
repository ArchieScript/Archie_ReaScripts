--[[
   * Category:    Fx
   * Description: Rename Fx in selected tracks to preset name
   * Author:      Archie
   * Version:     1.01
   * О скрипте:   Переименовать Fx в выбранных треках в имя пресета
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Дима Горелик[RMM]
   * Gave idea:   Дима Горелик[RMM]
   * Extension:   
   *              Reaper 5.981+ http://www.reaper.fm/
   *              Arc_Function_lua v.2.6.7+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc 
   * Changelog:   
   *              v.1.01 [28.09.19]
   *                  +  initialе
   
   *              v.1.0 [260219]
   *                  +  initialе
--]]
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.6.8",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ============== 
    
    
    
    
    local countSelTrack = reaper.CountSelectedTracks(0);
    if countSelTrack == 0 then Arc.no_undo() return end;
    
    
    local Tr;
    local LastTouchedTrack = reaper.GetLastTouchedTrack();
    if LastTouchedTrack and reaper.GetMediaTrackInfo_Value(LastTouchedTrack,"I_SELECTED")==1 then;
        Tr = LastTouchedTrack else Tr = reaper.GetSelectedTrack(0,0);
    end;
    local retval,str = reaper.GetTrackStateChunk(Tr,"",false);
    local idxSelFx = tonumber(string.match(str,"LASTSEL (%d)"))+1 or 1;
    
    local
    retval,idxSelFx = reaper.GetUserInputs("Rename Fx in preset name.",1,"Enter number Fx:", idxSelFx);
    idxSelFx = idxSelFx - 1;
    
    
    local undo;
    for i = 1,countSelTrack do;
        local selTrack = reaper.GetSelectedTrack(0,i-1);
        local retval, presetname = reaper.TrackFX_GetPreset(selTrack,idxSelFx,"");
        local TracFx_Rename = Arc.TrackFx_Rename(selTrack,idxSelFx,presetname);
        if not undo and TracFx_Rename then;
            reaper.Undo_BeginBlock();
            undo = true;
        end;
    end;
    
    
    if undo then;
        reaper.Undo_EndBlock("Rename Fx in preset name",-1);
    else;
        Arc.no_undo();
    end;