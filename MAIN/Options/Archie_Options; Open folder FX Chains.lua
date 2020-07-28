--[[ 
   * Category:    Options 
   * Description: Open folder FX Chains 
   * Author:      Archie 
   * Version:     1.01 
   * AboutScript: Open folder FX Chains 
   * О скрипте:   Открыть папку FX цепочки 
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * Donation:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Дима Горелик[RMM] 
   * Gave idea:   Дима Горелик[RMM] 
   * Changelog:    
   *              +! Fixed incompatibility with Mac os / v.1.01 [27022019] 
   *              +! Исправлена несовместимость с Mac os / v.1.01 [27022019] 
    
   *              +  initialе / v.1.0 [26.02.2019] 
 
 
   --======================================================================================== 
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\ 
   ----------------------------------------------------------------------------------------|| 
   + Reaper v.5.967 +           --| http://www.reaper.fm/download.php                      || 
   - SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                 || 
   - ReaPack v.1.2.2 +          --| http://reapack.com/repos                               || 
   - Arc_Function_lua v.2.3.0 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc   || 
   - reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr   || 
                                                                    http://clck.ru/Eo5Lw   || 
   ? Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                  || 
   ----------------------------------------------------------------------------------------|| 
   --\\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// 
   ========================================================================================]] 
     
     
     
   --====================================================================================== 
   --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
   --======================================================================================  
 
 
    ------------------------------------------------------------------------------ 
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end; 
    ------------------------------------------------------------------------------ 
     
     
    local pathFile = reaper.GetResourcePath().."/FXChains"; 
    if reaper.GetOS() == "OSX32" or reaper.GetOS() == "OSX64" then; 
        os.execute('open "'..pathFile..'"'); 
    else; 
        os.execute('start "" '..pathFile); 
    end; 
    no_undo(); 