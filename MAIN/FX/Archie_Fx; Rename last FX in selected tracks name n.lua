--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Fx
   * Description: Fx; Rename last FX in selected tracks name n.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    dhfotybt(Rmm)
   * Gave idea:   dhfotybt(Rmm)
   * Extension:   Reaper 6.12+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.9.7+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.0 [010920]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local MASTER = false; -- true/false
    
    local nameFx = 'My Name';
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.9.7",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
    
    
    local countSelTrack = reaper.CountSelectedTracks2(0,MASTER);
    if countSelTrack == 0 then Arc.no_undo() return end;
    
    local undo;
    
    for i = 1,countSelTrack do;
        local selTrack = reaper.GetSelectedTrack2(0,i-1,MASTER);
        local CountFX = reaper.TrackFX_GetCount(selTrack);
        local TracFx_Rename = Arc.TrackFx_Rename(selTrack,CountFX-1,nameFx);
        ----
        if not undo and TracFx_Rename then;
            reaper.Undo_BeginBlock();
            undo = true;
        end;
    end;
    
    if undo then;
        reaper.Undo_EndBlock("Rename last FX in selected tracks name n",-1);
    else;
        Arc.no_undo();
    end;
    
    
    