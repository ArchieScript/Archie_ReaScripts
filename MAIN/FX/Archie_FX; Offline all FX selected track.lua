--[[     NEW INSTANCES;
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    FX
   * Description: FX; Offline all FX selected track.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.0+ http://www.reaper.fm/
   * Changelog:
   *              v.1.0 [310820]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local MASTER = true;
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
     
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.6",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
    
    
    MASTER=MASTER==true;
    
    local CountSelTrack2 = reaper.CountSelectedTracks2(0,MASTER);
    if CountSelTrack2 == 0 then no_undo()return end;
    
    
    for i = 1,CountSelTrack2 do;
        local Track = reaper.GetSelectedTrack2(0,i-1,MASTER);
        for ifx = 1,reaper.TrackFX_GetCount(Track) do;
            local Offline = reaper.TrackFX_GetOffline(Track,ifx-1);
            if not Offline then;
                if not UNDO then;
                    reaper.Undo_BeginBlock();
                    reaper.PreventUIRefresh(1);
                    UNDO = true;
                end;
                reaper.TrackFX_SetOffline(Track,ifx-1,true);
            end;
        end;
    end;
    
    if UNDO then;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Offline all FX selected track',-1);
    else;
        no_undo();
    end;
    
    