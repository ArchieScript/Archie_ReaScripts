--[[
   * Category:    Item
   * Description: Ungroup item under mouse cursor
   * Author:      Archie
   * Version:     1.05
   * AboutScript: Ungroup item under mouse cursor (to assign to the mouse wheel)
   * О скрипте:   Разгруппировать элемент под курсором мыши (назначить на колесо мыши)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Supa75 (RMM Forum)
   * Gave idea:   Supa75 (RMM Forum)
   * Changelog:   +  Fixed paths for Mac/ v.1.03 [29.01.19]
   *              +  Исправлены пути для Mac/ v.1.03 [29.01.19]

   *              +  initialе / v.1.0 [28.12.18]

   ===========================================================================================\
   -------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   ===========================================================================================|
   + Reaper v.5.965 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   + SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   + Arc_Function_lua v.2.2.2 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
   - Visual Studio С++ 2015 ---| --------- http://clck.ru/Eq5o6 ----------|(and above |и выше)|
--===========================================================================================]]





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



    local window, segment, details = reaper.BR_GetMouseCursorContext();
    local item = reaper.BR_GetMouseCursorContext_Item();
    if not item then Arc.no_undo() return end;

    local group = reaper.GetMediaItemInfo_Value(item,"I_GROUPID");
    if group ~= 0 then;
        reaper.Undo_BeginBlock();
        reaper.SetMediaItemInfo_Value(item,"I_GROUPID",0);
        reaper.Undo_EndBlock("Ungroup item under mouse cursor",-1);
        reaper.UpdateArrange()
    else;
        Arc.no_undo();
    end;