--[[
   * Category:    Preferences
   * Description: Draw edges on peaks
   * Author:      Archie
   * Version:     1.01
   * AboutScript: Preferences -> Peaks/Waveforms -> Name Script
   * О скрипте:   Рисовать кромки на вершинах
   * GIF:         http://avatars.mds.yandex.net/get-pdb/1871571/d68e51ad-bf58-431c-a6d4-f188ee76af83/s1200
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    smrz1[RMM]
   * Gave idea:   smrz1[RMM]
   * Changelog:   
   *              v.1.01 [05062019]
   *                  +! Update peaks when switching
   *                  +! Обновление пиков при переключении
   
   *              v.1.0 [05062019]
   *                  +  initialе
   
   
   --=======================================================================================
         SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.975 +           --| http://www.reaper.fm/download.php                     
   (+) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                              
   (+) Arc_Function_lua v.2.4.1 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
   (-) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                
   =======================================================================================]] 
    
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    --============== FUNCTION / MODULE: Arc_Function_lua ==============================================================================================
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');------
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.4.1",Fun,"")then Arc.no_undo() return end;-------------------------------------------------------
    --==============================================▲=▲=▲====================================================== FUNCTION MODULE FUNCTION / My_Lib =====
    
    
    
    
    local SWS = Arc.SWS_API(true);
    if not SWS then Arc.no_undo() return end;
    
    Arc.HelpWindowWhenReRunning(2,"Arc_Function_lua",false);
    
    
    local SetConfigVar,title;
    local ConfigVar = reaper.SNM_GetIntConfigVar("peaksedges",0);
    if ConfigVar&1 == 0 then;
       SetConfigVar = ConfigVar | 1;
       title = "On - Draw edges on peaks";
    else;
        SetConfigVar = ConfigVar &~ (ConfigVar&1);
        title = "Off - Draw edges on peaks";
    end;
    
    reaper.Undo_BeginBlock();
    reaper.SNM_SetIntConfigVar("peaksedges",SetConfigVar);
    Arc.Action(40047);--Build any missing peaks
    reaper.Undo_EndBlock(title,-1);
    
    local _,_,sec,cmd,_,_,_ = reaper.get_action_context();
    local ActiveOn,ActiveOff;
    
    function loop();
        
        local peaksedges = reaper.SNM_GetIntConfigVar("peaksedges",0)&1;
        
        if peaksedges == 0 then;
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