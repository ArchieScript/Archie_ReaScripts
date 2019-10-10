--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Show hide Media explorer FX browser Track manager Region-marker manager
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Snjuk(Rmm)
   * Gave idea:   Snjuk(Rmm)
   * Changelog:   v.1.0 [10.10.19]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    local title = "Media explorer FX browser Track manager Region-marker manager";
    local MediaExplorer = reaper.GetToggleCommandStateEx(0,50124);
    local ShowFXBrowser = reaper.GetToggleCommandStateEx(0,40271);
    local ShowTrackMana = reaper.GetToggleCommandStateEx(0,40906);
    local ShowRegioMark = reaper.GetToggleCommandStateEx(0,40326);
    reaper.Undo_BeginBlock();
    
    if MediaExplorer == 1 or ShowFXBrowser == 1 or ShowTrackMana == 1 or ShowRegioMark == 1 then;
    
        if MediaExplorer == 1 then;
            reaper.Main_OnCommand(50124,0);
        end;
        if ShowFXBrowser == 1 then;
            reaper.Main_OnCommand(40271,0);
        end;
        if ShowTrackMana == 1 then;
            reaper.Main_OnCommand(40906,0);
        end;
        if ShowRegioMark == 1 then;
            reaper.Main_OnCommand(40326,0);
        end;
        reaper.Undo_EndBlock("Hide "..title,-1);
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
        reaper.Undo_EndBlock("Show "..title,-1);
    end;