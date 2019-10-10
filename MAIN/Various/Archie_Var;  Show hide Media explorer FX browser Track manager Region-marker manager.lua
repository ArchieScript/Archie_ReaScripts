--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Show hide Media explorer FX browser Track manager Region-marker manager
   * Author:      Archie
   * Version:     1.01
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Snjuk(Rmm)
   * Gave idea:   Snjuk(Rmm)
   * Changelog:   
   *              v.1.01 [10.10.19]
   *                  + The closure of the dock (Performance degradation):(
   
   *              v.1.0 [10.10.19]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    -------------------------------------------------
    function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------
    
    
    local MediaExplorer = reaper.GetToggleCommandStateEx(0,50124);
    local ShowFXBrowser = reaper.GetToggleCommandStateEx(0,40271);
    local ShowTrackMana = reaper.GetToggleCommandStateEx(0,40906);
    local ShowRegioMark = reaper.GetToggleCommandStateEx(0,40326);
    
    
    if MediaExplorer == 1 or ShowFXBrowser == 1 or ShowTrackMana == 1 or ShowRegioMark == 1 then;
        
        --Двойное нажатие из-за не работы в доке
        reaper.Main_OnCommand(50124,0);
        local MediaExplorer = reaper.GetToggleCommandStateEx(0,50124);
        if MediaExplorer == 1 then;
            reaper.Main_OnCommand(50124,0);
        end;
        
        reaper.Main_OnCommand(40271,0);
        local ShowFXBrowser = reaper.GetToggleCommandStateEx(0,40271);
        if ShowFXBrowser == 1 then;
            reaper.Main_OnCommand(40271,0);
        end;
        
        reaper.Main_OnCommand(40906,0);
        local ShowTrackMana = reaper.GetToggleCommandStateEx(0,40906);
        if ShowTrackMana == 1 then;
            reaper.Main_OnCommand(40906,0);
        end;
        
        reaper.Main_OnCommand(40326,0);
        local ShowRegioMark = reaper.GetToggleCommandStateEx(0,40326);
        if ShowRegioMark == 1 then;
            reaper.Main_OnCommand(40326,0);
        end;
        
    else;
        
        if MediaExplorer == 0 then;
            reaper.Main_OnCommand(50124,0);
        end;
        if ShowFXBrowser == 0 then;
            reaper.Main_OnCommand(40271,0);
        end;
        if ShowTrackMana == 0 then;
            reaper.Main_OnCommand(40906,0);
        end;
        if ShowRegioMark == 0 then;
            reaper.Main_OnCommand(40326,0);
        end;
    end;
    
    no_undo();