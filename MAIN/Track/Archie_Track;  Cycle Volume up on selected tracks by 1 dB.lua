--[[
   * Category:    Track
   * Description: Cycle Volume up on selected tracks by 1 dB
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Cycle Volume up on selected tracks by 1 dB
   * О скрипте:   Цикл громкости вверх на выделенных дорожках на 1 дБ
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
    
    
    
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;
    
    
    reaper.Undo_BeginBlock();
    
    for i = 1, CountSelTrack do;
	   local SelTrack = reaper.GetSelectedTrack(0, i-1);
	   local vol = 20 * math.log(reaper.GetMediaTrackInfo_Value(SelTrack,"D_VOL"),10);
	    reaper.SetMediaTrackInfo_Value(SelTrack,"D_VOL",(10^((vol+1)/20)));
    end;
    
    reaper.Undo_EndBlock("Cycle Volume up on selected tracks by 1 dB",-1);
    
    reaper.UpdateArrange();