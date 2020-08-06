--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Take
   * Description: Take; Paste source in active take.lua
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
    
    
    
    
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;
    
    local filenameIn = reaper.GetExtState('CopyPasteSourceActiveTakeInActiveTake','strCPSATAT');
    if type(filenameIn)=='string' and filenameIn ~= ''then;
        for i = 1, CountSelItem do;
            local item = reaper.GetSelectedMediaItem(0,i-1);
            local take = reaper.GetActiveTake(item);
            reaper.BR_SetTakeSourceFromFile(take,filenameIn,false);
            reaper.UpdateItemInProject(item);
        end;
        ----
        --------------------------------------------------
        local ShowStatusWindow = reaper.SNM_GetIntConfigVar("showpeaksbuild",0);
        if ShowStatusWindow == 1 then;
            reaper.SNM_SetIntConfigVar("showpeaksbuild",0);
        end;
        ---
        Arc.Action(40047);--Build missing peaks
        ---
        if ShowStatusWindow == 1 then;
            reaper.SNM_SetIntConfigVar("showpeaksbuild",1);
        end;
        --------------------------------------------------
        ----
        reaper.UpdateArrange();
    end;
    no_undo();
    