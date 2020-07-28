--[[
   * Category:    Item
   * Description: Pitch up one semitone all midi items(all midi take)
   * Author:      Archie
   * Version:     1.01
   * AboutScript: Pitch up one semitone all midi items(all midi take)
   * О скрипте:   Шаг вверх один полутон все миди элементы (все миди тейки)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Ga_rY(Rmm/forum)
   * Gave idea:   Ga_rY(Rmm/forum)
   * Changelog:   !+ fix bug / v.1.01[23122018]
   *              + initialе / v.1.0 [23122018]
--============================================================================================|
----------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   + Reaper v.5.963 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   - Arc_Function_lua v.2.0.6 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]




    --=========================================================================================
    --/////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\\\
    --=========================================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local CountItem = reaper.CountMediaItems(0);
    if CountItem == 0 then no_undo() return end;


    for i = 1,CountItem do;
        local item = reaper.GetMediaItem(0,i-1);
        local CountTake = reaper.CountTakes(item);
        for i2 = 1,CountTake do;
            local take = reaper.GetMediaItemTake(item,i2-1);
            local midi = reaper.TakeIsMIDI(take);
            if midi then;
                local Pitch = reaper.GetMediaItemTakeInfo_Value(take,"D_PITCH");
                reaper.SetMediaItemTakeInfo_Value(take,"D_PITCH",Pitch+1);
                Undo_BegBlock = "Active";
            end;
        end
    end;

    reaper.UpdateArrange();

    if Undo_BegBlock == "Active" then;
        reaper.Undo_BeginBlock();
        reaper.Undo_EndBlock("Pitch up one semitone all midi items(all midi take)",-1);
    else;
        no_undo();
    end;