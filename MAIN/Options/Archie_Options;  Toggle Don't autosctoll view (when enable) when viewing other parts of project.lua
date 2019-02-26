--[[
   * Category:    Options
   * Description: Toggle Don't autosctoll view (when enable) when viewing other parts of project     
   * Author:      Archie
   * Version:     1.0
   * AboutScript: ---
   * О скрипте:   ---
   * GIF:         http://s8.hostingkartinok.com/uploads/images/2019/02/c9c4cf3b1169e89ccb633ba45516dbc9.png
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Supa75[RMM]
   * Gave idea:   Supa75[RMM]
   * Changelog:   +  initialе / v.1.0 [240219]
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
    if not Arc.VersionArc_Function_lua("2.2.2",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================
    
    
    
    
    local SWS = Arc.SWS_API(true);
    Arc.HelpWindowWhenReRunning(2,"",false);


    local _,_,sec,cmd,_,_,_ = reaper.get_action_context();
    local Undo,ActiveOn,ActiveOff;
    local title = "Don't autosctoll view (when enable) when viewing other parts of project"
    local viewadvance = reaper.SNM_GetIntConfigVar("viewadvance",0);
    reaper.Undo_BeginBlock()
    if viewadvance == 7 then;
        reaper.SNM_SetIntConfigVar("viewadvance",3); 
        Undo = 1; 
    elseif viewadvance == 15 then;
        reaper.SNM_SetIntConfigVar("viewadvance",11);
        Undo = 1; 
    elseif viewadvance == 3 then;
        reaper.SNM_SetIntConfigVar("viewadvance",7);
    elseif viewadvance == 11 then;
        reaper.SNM_SetIntConfigVar("viewadvance",15);
    end;
    
    if Undo == 1 then;
        reaper.Undo_EndBlock("On / "..title,-1)
    else
        reaper.Undo_EndBlock("Off / "..title,-1)
    end;
    
    function loop();
        
        local viewadvance = reaper.SNM_GetIntConfigVar("viewadvance",0);
        if viewadvance == 7 or viewadvance == 15 then;
            if not ActiveOn then;
                reaper.SetToggleCommandState(sec,cmd,0);
                reaper.RefreshToolbar2(sec, cmd);
                ActiveOn = 1;
                ActiveOff = nil;
            end;
        elseif viewadvance == 3 or viewadvance == 11 then;
            if not ActiveOff then;
                reaper.SetToggleCommandState(sec,cmd,1);
                reaper.RefreshToolbar2(sec, cmd);
                ActiveOff = 1;
                ActiveOn = nil;
            end;
        end;
        reaper.defer(loop);
    end;
    
    loop();
    reaper.atexit(loop);