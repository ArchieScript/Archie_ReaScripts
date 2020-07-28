--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    View
   * Description: View; Toggle Open toolbar n at mouse cursor - close.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Provides:
   *              [nomain] .
   *              [main] . > Archie_View;  Toggle Open toolbar 1 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 2 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 3 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 4 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 5 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 6 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 7 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 8 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 9 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 10 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 11 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 12 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 13 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 14 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 15 at mouse cursor - close.lua
   *              [main] . > Archie_View;  Toggle Open toolbar 16 at mouse cursor - close.lua
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [120520]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    local nameScr = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)");
    local Toolbar = tonumber(nameScr:match("Archie_.-toolbar%s-(%S+)%s-.-%.lua$"))or 1;
    
    
    local --Open/close toolbar (Toggle)
    closeT = {41679,41680,41681,41682,41683,41684,41685,41686,
             41936,41937,41938,41939,41940,41941,41942,41943};
    
    local --Open toolbar at mouse cursor
    OpenT =  {41111,41112,41113,41114,41655,41656,41657,41658,
             41960,41961,41962,41963,41964,41965,41966,41967}
    
    
    local open = reaper.GetToggleCommandStateEx(0,closeT[Toolbar])==1;
    if open then;
        reaper.Main_OnCommand(closeT[Toolbar],0);
    else;
        reaper.Main_OnCommand(OpenT[Toolbar],0);
    end;
    
    reaper.defer(function()end);
    
    
    
    