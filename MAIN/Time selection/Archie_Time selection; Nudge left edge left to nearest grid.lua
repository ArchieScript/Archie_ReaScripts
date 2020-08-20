--[[
   * Category:    Time selection
   * Description: Nudge left edge left to nearest grid
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Nudge left edge left to nearest grid
   * О скрипте:   Подтолкнуть левый край влево к ближайшей сетке
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Supa75(RMM)
   * Gave idea:   Supa75(RMM)
   * Changelog:   +  initialе / v.1.0 [30.01.2019]

   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   - Arc_Function_lua v.2.1.5 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    ------------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end;
    ------------------------------------------------------------------------------



    local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    if startLoop == endLoop then no_undo() return end;


    local ToggleGridLines = reaper.GetToggleCommandState(40145);
    if ToggleGridLines == 1 then;

        reaper.Undo_BeginBlock();

        local Grid = reaper.BR_GetPrevGridDivision(startLoop);
        reaper.GetSet_LoopTimeRange(1,0,Grid,endLoop,0);

        reaper.Undo_EndBlock("Nudge left edge left to nearest grid",-1);

    else;
        no_undo() return;
    end;

    reaper.UpdateTimeline();