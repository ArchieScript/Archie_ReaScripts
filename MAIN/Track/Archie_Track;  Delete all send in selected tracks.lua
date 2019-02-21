--[[
   * Category:    Item
   * Description: Delete all send in selected tracks
   * Author:      Archie
   * Version:     1.0
   * AboutScript: ---
   * О скрипте:   ---
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---
   * Gave idea:   ---
   * Changelog:   +  initialе / v.1.0 [210219]
   ==========================================================================================
   
   
   --========================================================================================
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\
   ----------------------------------------------------------------------------------------||
   + Reaper v.5.965 +           --| http://www.reaper.fm/download.php                      ||
   + SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                 ||
   - ReaPack v.1.2.2 +          --| http://reapack.com/repos                               ||
   + Arc_Function_lua v.2.2.9 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc   ||
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
    if not Arc.VersionArc_Function_lua("2.2.9",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================
    
    
    
    local SWS = Arc.SWS_API(true);
    if not SWS then Arc.no_undo() return end;
    
      
    local CountSelTracks = reaper.CountSelectedTracks(0);
    if CountSelTracks == 0 then Arc.no_undo() return end;
    
    reaper.PreventUIRefresh(1);
    local Undo;
    for i = 1, CountSelTracks do;
        local Seltrack = reaper.GetSelectedTrack(0,i-1);
        if not Undo then;
            local CountSend = reaper.GetTrackNumSends(Seltrack,0);
            if CountSend > 0  then;
                reaper.Undo_BeginBlock();
                Undo = true;
            end;
        end;    
        Arc.RemoveAllSendTr(Seltrack,0);
    end;    
    reaper.PreventUIRefresh(-1);
     
    if Undo then;
        reaper.Undo_EndBlock("Delete all send in selected tracks",-1);
    else;
        Arc.no_undo();
    end;