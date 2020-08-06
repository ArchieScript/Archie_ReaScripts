--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Take
   * Description: Take; Copy source Active take.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.12+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.9.0+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.0 [070820]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --=========================================
    local function MODULE(file);
       local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
       if not A.VersArcFun("2.9.0",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    local ArcFileIni = reaper.GetResourcePath():gsub('\\','/')..'/reaper-Archie.ini';
    --=========================================
    
    
    
    local item = reaper.GetSelectedMediaItem(0,0);
    if not item then no_undo() return end;
    -----
    -----
    reaper.DeleteExtState('CopyPasteSourceActiveTakeInActiveTake','strCPSATAT',false);
    ----
    ----
    local filenamebuf;
    local take = reaper.GetActiveTake(item);
    local IsMIDI = reaper.TakeIsMIDI(take);
    if not IsMIDI then;
        local source = reaper.GetMediaItemTake_Source(take);
        local source2 = reaper.GetMediaSourceParent(source);
        local source = source2 or source;
        filenamebuf = reaper.GetMediaSourceFileName(source,'');
    end;
    
    if type(filenamebuf)=='string' and filenamebuf ~= ''then;
        reaper.SetExtState('CopyPasteSourceActiveTakeInActiveTake','strCPSATAT',filenamebuf,false);
    end;
    
    no_undo();
    
    
    
    
    