--[[
   * Category:    Item
   * Description: adjust item length by grid (mousewheel)
   * Author:      Archie
   * Version:     1.0
   * AboutScript: adjust item length by grid (mousewheel)
   * О скрипте:   настроить длину элемента по сетке (колесико мыши)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Antibio[RMM]
   * Gave idea:   Antibio[RMM]
   * Changelog:
   *              +  initialе / v.1.0 [12042019]


   -- Тест только на windows  /  Test only on windows.
   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php
   (+) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos
   (-) Arc_Function_lua v.2.3.2 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc
   (-) reaper_js_ReaScriptAPI     --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6
   =======================================================================================]]




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    ---------------------------------------------------------------
    local function no_undo() reaper.defer(function()return end)end;
    ---------------------------------------------------------------


    local window, segment, details = reaper.BR_GetMouseCursorContext();
    local item = reaper.BR_GetMouseCursorContext_Item();
    if not item then no_undo() return end;

    local val = ({reaper.get_action_context()})[7];
    if val == 0 then no_undo() return end;


    reaper.Undo_BeginBlock();

    local posIt = reaper.GetMediaItemInfo_Value(item, "D_POSITION");
    local lenIt = reaper.GetMediaItemInfo_Value(item, "D_LENGTH");

    local Grid;
    if val > 0 then;
        Grid = reaper.BR_GetNextGridDivision(posIt+lenIt);
    elseif val < 0 then;
        Grid = reaper.BR_GetPrevGridDivision(posIt+lenIt);
    end;

    reaper.SetMediaItemInfo_Value(item,"D_LENGTH",Grid-posIt);

    reaper.Undo_EndBlock("adjust item length by grid (mousewheel)",-1);