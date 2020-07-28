--[[ 
   * Category:    Track 
   * Description: Volume reset on all tracks (0 db) 
   * Author:      Archie 
   * Version:     1.0 
   * AboutScript: Volume reset on all tracks (0 db) 
   * О скрипте:   Сброс громкости на всех треках (0 дБ) 
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    --- 
   * Gave idea:   muzicgrand[RMM] 
   * Changelog:    
   *              +  initialе / v.1.0 [02042019] 
    
    
   -- Тест только на windows  /  Test only on windows. 
   --======================================================================================== 
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\ 
   ----------------------------------------------------------------------------------------|| 
    ˅ - (+) - обязательно для установки / (-) - не обязательно для установки               || 
	 -------------------------------------------------------------------------------------|| 
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                    || 
   (-) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php               || 
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                             || 
   (-) Arc_Function_lua v.2.3.1 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc || 
   (-) reaper_js_ReaScriptAPI     --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr || 
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
     
     
     
    --------------------------------------------------------- 
    local function no_undo();reaper.defer(function()end);end; 
    --------------------------------------------------------- 
     
     
     
    local CountTrack,Undo = reaper.CountTracks(0); 
    if CountTrack == 0 then no_undo() return end; 
     
     
    for i = 1, CountTrack do; 
	   local Track = reaper.GetTrack(0, i-1); 
	   local vol = reaper.GetMediaTrackInfo_Value(Track,"D_VOL")== 1; 
	   if not vol then; 
		  reaper.SetMediaTrackInfo_Value(Track,"D_VOL",1); 
		  if not Undo then reaper.Undo_BeginBlock()Undo=1 end; 
	   end; 
    end; 
     
     
    if Undo then; 
	   reaper.Undo_EndBlock("Volume reset on all tracks (0 db)",-1); 
    else; 
	   no_undo(); 
    end; 
    reaper.UpdateArrange(); 