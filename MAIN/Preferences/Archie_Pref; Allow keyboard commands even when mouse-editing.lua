--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Preferences 
   * Description: Pref; Allow keyboard commands even when mouse-editing.lua 
   * ***          Preferences > General > Advanced UI / ... 
   * Author:      Archie 
   * Version:     1.02 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   *              http://vk.com/reaarchie 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    smrz1(Rmm) 
   * Gave idea:   smrz1(Rmm) 
   * Extension:   Reaper 6.10+ http://www.reaper.fm/ 
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php 
   *              ReaPack v.1.2.2 +  http://reapack.com/repos 
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw 
   *              Arc_Function_lua v.2.8.4+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc 
   * Changelog:    
   *              v.1.0 [230320] 
   *                  + initialе 
--]] 
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
     
    --========================================= 
    local function MODULE(file); 
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end; 
        if not A.VersArcFun("2.8.5",file,'')then A.no_undo()return;end;return A; 
    end;local Arc=MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/')); 
    if not Arc then return end; 
    local ArcFileIni = reaper.GetResourcePath():gsub('\\','/')..'/reaper-Archie.ini'; 
    --========================================= 
     
     
     
    ----------------------------------------------------------- 
    local alwkb = reaper.SNM_GetIntConfigVar('alwaysallowkb',0); 
    local alwkb = math.abs(alwkb-1); 
    reaper.SNM_SetIntConfigVar('alwaysallowkb',alwkb); 
    ----------------------------------------------------------- 
     
     
     
    --========================================= 
    local x; 
    local function tmr(ckl); 
        x=(x or 0)+1; 
        if x>=ckl then x=0 return true end;return false;    
    end; 
    --========================================= 
     
     
     
    local ActiveOn,ActiveOff; 
     
     
    local ActiveDoubleScr,stopDoubleScr; 
    local _,extnameProj,sec,cmd,_,_,_ = reaper.get_action_context(); 
    local scriptPath,scriptName = extnameProj:match("^(.+)[/\\](.+)"); 
     
    local function loop(); 
         
        ----- stop Double Script ------- 
        if not ActiveDoubleScr then; 
            stopDoubleScr = (tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr"))or 0)+1; 
            reaper.SetExtState(extnameProj,"stopDoubleScr",stopDoubleScr,false); 
            ActiveDoubleScr = true; 
        end; 
         
        local stopDoubleScr2 = tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr")); 
        if stopDoubleScr2 > stopDoubleScr then  return  end; 
        -------------------------------- 
         
        if tmr(20) then; 
         
            local alwkb = reaper.SNM_GetIntConfigVar('alwaysallowkb',0); 
             
            if alwkb == 0 then; 
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
        end; 
        reaper.defer(loop); 
    end; 
      
    reaper.defer(function();loop(); 
    Arc.GetSetTerminateAllInstancesOrStartNewOneKB_ini(1,516,scriptPath,scriptName)end); 
     
     
     
     
     