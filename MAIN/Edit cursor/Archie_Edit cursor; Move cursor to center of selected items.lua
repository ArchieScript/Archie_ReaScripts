--[[    NEW INSTANCE
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Edit cursor
   * Description: Edit cursor; Move cursor to center of selected items.lua
   * Author:      Archie
   * Version:     1.0
   * Описание:    ---
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(Rmm)
   * Gave idea:   Archie(Rmm)
   * Extension:   
   *              Reaper 6.14+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.3.0.3+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.0 [301020]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("3.0.3",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --local ArcFileIni = reaper.GetResourcePath():gsub('\\','/')..'/reaper-Archie.ini';
    --=========================================
    
     
    local CountSelItems = reaper.CountSelectedMediaItems(0);
    if CountSelItems == 0 then no_undo()return end;
    
    
    local PosFirstIt,EndLastIt = 
    Arc.GetPositionOfFirstSelectedItemAndEndOfLast();
    
    local CursorPos = reaper.GetCursorPosition();
    
    local NewCursorPos = (EndLastIt-PosFirstIt)/2+PosFirstIt;
    
    if NewCursorPos ~= CursorPos then;
        reaper.Undo_BeginBlock();
        reaper.SetEditCurPos2(0,NewCursorPos,0,0)
        reaper.Undo_EndBlock('Move cursor to center of selected items', -1);
    else;
        no_undo();
    end;
    