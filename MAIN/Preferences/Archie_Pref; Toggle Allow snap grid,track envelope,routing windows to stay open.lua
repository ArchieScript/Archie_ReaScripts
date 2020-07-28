--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Preferences (Preferences > General > Advanced UI/system tweaks)
   * Description: Toggle Allow snap grid,track envelope,routing windows to stay open
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Allow snap grid/track envelope/routing windows to stay open
   * О скрипте:   Разрешить привязку сетки / конверта дорожки / окна маршрутизации, чтобы оставаться открытыми
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    denlozikevich(Rmm)
   * Gave idea:   denlozikevich(Rmm)
   * Extension:   SWS v.2.10.0  http://www.sws-extension.org/index.php
   * Changelog:   v.1.0 [22.08.19]
   *                  + initialе
--]]


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    -------------------------------------------------
    function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------


    local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context();
      AllowRroutingWinStayOpen = reaper.SNM_GetIntConfigVar("autoclosetrackwnds",0);
    if AllowRroutingWinStayOpen == 1 then;
        reaper.SNM_SetIntConfigVar("autoclosetrackwnds",0);
        reaper.SetToggleCommandState(sec,cmd,1)
    else;
        reaper.SNM_SetIntConfigVar("autoclosetrackwnds",1);
        reaper.SetToggleCommandState(sec,cmd,0);
    end;

    reaper.RefreshToolbar2(sec,cmd);

    no_undo();