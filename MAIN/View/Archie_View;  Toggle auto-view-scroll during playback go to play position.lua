--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    View
   * Description: Toggle auto-view-scroll during playback go to play position
   * Author:      Archie / borisuperful
   * Version:     1.0
   * AboutScript: It works identically to the "Toggle auto-view-scroll during playback go to play position" script, only when turned on it scrolls the scroll to the play cursor
   * О скрипте:   Работает идентично скрипту "Toggle auto-view-scroll during playback go to play position", только при включении прокручивает скролл к плей курсору
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    AndiVax(Rmm)
   * Gave idea:   AndiVax(Rmm)
   * Changelog:   
   *             initialе
   *                + v.1.0 [19.10.19]
--]]
   
   
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    local Toggle = reaper.GetToggleCommandStateEx(0,40036);--auto-view-scroll during playback
    if Toggle == 0 then;
        local PlayState = reaper.GetPlayState();
        if PlayState&1 == 1 then;
            reaper.Main_OnCommand(40150,0); -- go to play position
        end;
        reaper.Main_OnCommand(40036,0);
    else;
        reaper.Main_OnCommand(40036,0);
    end;
    local _,_,sectionID,cmdID,_,_,_ = reaper.get_action_context();
    reaper.SetToggleCommandState(sectionID,cmdID,math.abs(Toggle-1));
    reaper.RefreshToolbar(cmdID); reaper.defer(function()end);