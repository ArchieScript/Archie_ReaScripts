--[[
   * Category:    Fx
   * Description: Rename Fx in preset name
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Rename Fx in preset name
   * О скрипте:   Переименовать FX в имя пресета
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Дима Горелик[RMM]
   * Gave idea:   Дима Горелик[RMM]
   * Changelog:   +  initialе / v.1.0 [260219]
   ==========================================================================================
   
   
   --========================================================================================
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\
   ----------------------------------------------------------------------------------------||
   + Reaper v.5.967 +           --| http://www.reaper.fm/download.php                      ||
   + SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                 ||
   - ReaPack v.1.2.2 +          --| http://reapack.com/repos                               ||
   + Arc_Function_lua v.2.3.0 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc   ||
   - reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr   ||
                                                                    http://clck.ru/Eo5Lw   ||
   ? Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                  ||
   ----------------------------------------------------------------------------------------||
   --\\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: /////
   ========================================================================================]]
    
    
    
    
   --======================================================================================
   --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
   --======================================================================================




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions',select(2,reaper.get_action_context()):match("(.+)[\\/]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.3.0",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================

 
    
    
    local SWS = Arc.SWS_API(true);
    if not SWS then Arc.no_undo() return end;    
    
    
    local countSelTrack = reaper.CountSelectedTracks(0);
    if countSelTrack == 0 then Arc.no_undo() return end;    
 
 
    local firstSelTrack = reaper.GetSelectedTrack(0,0);
    local retval,str = reaper.GetTrackStateChunk(firstSelTrack,"",false);
    local idxSelFx = tonumber(string.match(str,"LASTSEL (%d)"))+1 or "";
    
    local
    retval,idxSelFx = reaper.GetUserInputs("Rename selected Fx in preset name.", 1,[[
             Enter number Fx:]], idxSelFx )
    idxSelFx = idxSelFx - 1;
    
    local undo;
    for i = 1,countSelTrack do;
        local selTrack = reaper.GetSelectedTrack(0,i-1);
        local retval, presetname = reaper.TrackFX_GetPreset(selTrack,idxSelFx,"");
        if presetname == "" then presetname = "No preset" end;
        if #presetname > 0 then;
            local TracFx_Rename = Arc.TrackFx_Rename(selTrack,idxSelFx,presetname);
            if not undo and TracFx_Rename then;
                reaper.Undo_BeginBlock();
                undo = true;
            end;
        end;
    end;


    if undo then;
        reaper.Undo_EndBlock("Rename Fx in preset name",-1);
    else;
        Arc.no_undo();
    end;