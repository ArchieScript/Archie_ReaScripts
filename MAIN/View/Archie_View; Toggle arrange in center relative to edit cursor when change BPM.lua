--[[ 
   * Category:    View 
   * Description: Toggle arrange in center relative to edit cursor when you change BPM 
   * Author:      Archie 
   * Version:     1.02 
   * AboutScript: Toggle arrange in center relative to edit cursor when you change BPM 
   * О скрипте:   Переключение расположения по центру относительно курсора редактирования при изменении BPM 
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Zit[RMM] 
   * Gave idea:   Zit[RMM] 
   * Changelog:    
   *              +  initialе / v.1.0 [15032019] 
 
 
   --======================================================================================== 
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\ 
   ----------------------------------------------------------------------------------------|| 
    ˅ - (+) - обязательно для установки / (-) - не обязательно для установки               || 
      -------------------------------------------------------------------------------------|| 
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                    || 
   (+) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php               || 
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                             || 
   (+) Arc_Function_lua v.2.3.1 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc || 
   (-) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr || 
                                                                    http://clck.ru/Eo5Lw   || 
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                || 
      -------------------------------------------------------------------------------------|| 
    ˄ - (+) - required for installation / (-) - not necessary for installation             || 
   ----------------------------------------------------------------------------------------|| 
   --\\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// 
   ========================================================================================]] 
     
     
 
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --======================================================================================  
     
     
     
    --========================================= 
    local function MODULE(file); 
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end; 
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A; 
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/')); 
    if not Arc then return end; 
    --========================================= 
	 
 
     
     
    if not Arc.SWS_API(true)then; 
        Arc.no_undo() return; 
    end 
     
    Arc.HelpWindowWhenReRunning(1,"dfgd",false); 
   
    local function exit(); 
        Arc.SetToggleButtonOnOff(0); 
        do Arc.no_undo() return end; 
    end; 
     
     
    local function Loop(); 
         
        -- ProjectState = reaper.GetProjectStateChangeCount(0); 
        -- if ProjectState ~= ProjectStateX then; 
            local bpm, bpi = reaper.GetProjectTimeSignature2(0); 
              
            if bpm ~= bpm_x then; 
         
                if bpm_x then 
                 
                    local cursor = reaper.GetCursorPosition(); 
                    local start_time, end_time = reaper.GetSet_ArrangeView2(0,0,0,0); 
                    local width = (end_time - start_time) / 2; 
                    
                    if start_time ~= cursor - width and end_time ~= cursor + width then; 
                         
                        reaper.BR_SetArrangeView(0,cursor - width,cursor + width); 
                    end; 
                end; 
                bpm_x = bpm; 
            end; 
            -- ProjectStateX = ProjectState;  
        -- end;  
        -- i=(i or 0)+1; 
        reaper.defer(Loop); 
    end; 
     
     
    Arc.SetToggleButtonOnOff(1); 
    Loop(); 
    reaper.atexit(exit); 