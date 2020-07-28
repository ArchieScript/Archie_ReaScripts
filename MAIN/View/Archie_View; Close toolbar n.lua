--[[ 
   * Category:    View 
   * Description: Close toolbar n 
   * Author:      Archie 
   * Version:     1.0 
   * AboutScript: --- 
   * О скрипте:   Закрыть панель инструментов n 
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    ---(---) 
   * Gave idea:   ---(---) 
   * Provides: 
   *              [nomain] . 
   *              [main] . > Archie_View; Close toolbar main.lua 
   *              [main] . > Archie_View; Close toolbar 1.lua 
   *              [main] . > Archie_View; Close toolbar 2.lua 
   *              [main] . > Archie_View; Close toolbar 3.lua 
   *              [main] . > Archie_View; Close toolbar 4.lua 
   *              [main] . > Archie_View; Close toolbar 5.lua 
   *              [main] . > Archie_View; Close toolbar 6.lua 
   *              [main] . > Archie_View; Close toolbar 7.lua 
   *              [main] . > Archie_View; Close toolbar 8.lua 
   *              [main] . > Archie_View; Close toolbar 9.lua 
   *              [main] . > Archie_View; Close toolbar 10.lua 
   *              [main] . > Archie_View; Close toolbar 11.lua 
   *              [main] . > Archie_View; Close toolbar 12.lua 
   *              [main] . > Archie_View; Close toolbar 13.lua 
   *              [main] . > Archie_View; Close toolbar 14.lua 
   *              [main] . > Archie_View; Close toolbar 15.lua 
   *              [main] . > Archie_View; Close toolbar 16.lua 
   * Changelog:   v.1.0 [14.06.2019] 
   *                  + initialе 
     
     
    --======================================================================================= 
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:          
    (+) - required for installation      | (+) - обязательно для установки 
    (-) - not necessary for installation | (-) - не обязательно для установки 
    ----------------------------------------------------------------------------------------- 
    (+) Reaper v.5.975 +            --| http://www.reaper.fm/download.php 
    (-) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php 
    (+) ReaPack v.1.2.2 +           --| http://reapack.com/repos 
    (-) Arc_Function_lua v.2.4.4 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc   
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw     
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6 
    =======================================================================================]]  
     
     
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
    ------------------------------------------------------- 
    local function no_undo()reaper.defer(function()end)end; 
    ------------------------------------------------------- 
     
     
    local nameScr = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)"); 
     
     
    local numbToolbar = nameScr:match("Archie.-toolbar%s-(%S-)%s-%.lua$")or ""; 
    if numbToolbar:upper() == "MAIN" then numbToolbar = 0 end; 
    numbToolbar = tonumber(numbToolbar); 
    if not numbToolbar or numbToolbar < 0 or numbToolbar > 16 then; 
        reaper.MB("RUS:\n\nНеверное имя скрипта.\n".. 
                  "Имя скрипта должно быть одно из следующих ***.\n".. 
                  "n = Номер от 1 до 16\n\n\n".. 
                  "ENG:\n\nInvalid script name.\n".. 
                  "The script name must be one of the following ***.\n".. 
                  "n = Number from 1 to 16\n\n\n***\n".. 
                  "Archie_View;  Close toolbar main.lua\n Или / Or\n".. 
                  "Archie_View;  Close toolbar n.lua","Error",0) 
        no_undo() return; 
    end; 
     
    local Toolbar_T = {[0]=41651,41679,41680,41681,41682,41683,41684,41685, 
                      41686,41936,41937,41938,41939,41940,41941,41942,41943}; 
     
     
    reaper.PreventUIRefresh(1); 
     
     
    local stateTopDock = (reaper.GetToggleCommandState(41297)==1); 
    if stateTopDock then; 
        reaper.Main_OnCommand(41297,0); 
    end; 
     
     
    local state = reaper.GetToggleCommandState(Toolbar_T[numbToolbar]); 
    if state == 1 then; 
        reaper.Main_OnCommand(Toolbar_T[numbToolbar],0); 
    end; 
     
     
    local stateTopDock_End = (reaper.GetToggleCommandState(41297)==1); 
    if stateTopDock_End ~= stateTopDock then; 
        reaper.Main_OnCommand(41297,0); 
    end; 
     
    reaper.PreventUIRefresh(-1); 
     
     
    reaper.Undo_BeginBlock(); 
    if numbToolbar == 0 then numbToolbar = "Main" end; 
    reaper.Undo_EndBlock('Close toolbar'..numbToolbar,0); 