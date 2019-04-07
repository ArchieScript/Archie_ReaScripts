--[[
   * Category:    Preferences
   * Description: Don't autosctoll view (when enable) when viewing other parts of project
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Preferences > Playback > Name Script
   * О скрипте:   ---
   * GIF:         http://clck.ru/FWaoF
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Supa75[RMM]
   * Gave idea:   Supa75[RMM]
   * Changelog:   +  initialе / v.1.0 [07042019]
   
   
   --=======================================================================================
         SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.965 +           --| http://www.reaper.fm/download.php                     
   (+) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                              
   (+) Arc_Function_lua v.2.2.9 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
   (-) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                
   =======================================================================================]] 
    
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    --============== FUNCTION / MODULE: Arc_Function_lua ==============================================================================================
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');------
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.2.9",Fun,"")then Arc.no_undo() return end;-------------------------------------------------------
    --==============================================▲=▲=▲====================================================== FUNCTION MODULE FUNCTION / My_Lib =====
    
    
    
    
    local SWS = Arc.SWS_API(true);
    if not SWS then Arc.no_undo() return end;
    
    Arc.HelpWindowWhenReRunning(2,"Arc_Function_lua",false);

    
    
    local _,_,sec,cmd,_,_,_ = reaper.get_action_context();
    local ActiveOn,ActiveOff,GetViewadvance,SetViewadvance;
    
    GetViewadvance = reaper.SNM_GetIntConfigVar("viewadvance",0);-- // &4 / 0 on / 4 off /
    
    if (GetViewadvance&4) ~= 0 then;
        SetViewadvance = GetViewadvance & ~ (GetViewadvance&4);
    else;
        SetViewadvance = GetViewadvance | 4;
    end;
    
    reaper.SNM_SetIntConfigVar("viewadvance",SetViewadvance);
    
    

    function loop();
        
        local viewadvance = reaper.SNM_GetIntConfigVar("viewadvance",0)&4;
        if viewadvance ~= 0 then;
            if not ActiveOff then;
                reaper.SetToggleCommandState(sec,cmd,0);
                reaper.RefreshToolbar2(sec, cmd);
                ActiveOn = nil;
                ActiveOff = true;
            end;
        else;
            if not ActiveOn then;
                reaper.SetToggleCommandState(sec,cmd,1);
                reaper.RefreshToolbar2(sec, cmd);
                ActiveOff = nil;
                ActiveOn = true;
            end;
        end;
        reaper.defer(loop);
    end;
    
    Arc.no_undo();
    loop();
    reaper.atexit(loop);