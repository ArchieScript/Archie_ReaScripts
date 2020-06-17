--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Fx
   * Description: Fx;  Rename all fx in selected tracks with specific name in specific name.lua
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Переименовать все fx в выбранных треках с определенным именем в определенное имя
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    RJHollins(Cocos forum)
   * Gave idea:   RJHollins(Cocos forum)
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.8.5+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.0 [170620]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then A.no_undo()return;end;return A;
    end;local Arc=MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    local ArcFileIni = reaper.GetResourcePath():gsub('\\','/')..'/reaper-Archie.ini';
    --=========================================
    
    
    local countSelTrack = reaper.CountSelectedTracks(0);
    if countSelTrack == 0 then no_undo()return end;
    
    
    local name;
    for i_tr = 1,countSelTrack do;
        local selTrack = reaper.GetSelectedTrack(0,i_tr-1);
        local CountFX = reaper.TrackFX_GetCount(selTrack);
        if CountFX > 0 then;
            local idxSelFx = reaper.TrackFX_GetChainVisible(selTrack) or -1;
            if idxSelFx < 0 then;
                local retval,str = reaper.GetTrackStateChunk(selTrack,"",false);
                idxSelFx = tonumber(string.match(str,"LASTSEL (%d)")) or idxSelFx;
            end;
            if idxSelFx >= 0 then;
                local NameDefault, Name = Arc.TrackFX_GetFXNameEx(selTrack,idxSelFx);
                if Name == '' then Name = NameDefault end;
                if Name ~= '' then name = Name break end;
            end;
        end;
    end;
    
    ::res::;
    local retval, retvals_csv = reaper.GetUserInputs('',1,'Previous name:,extrawidth=250',name or '');
    if not retval then no_undo()return end;
    if #retvals_csv:gsub('%s','')==0 then goto res end;
    name = retvals_csv;
    
    if not name or name == '' then no_undo()return end;
    
    
    ::res2::;
    local retval, retvals_csv = reaper.GetUserInputs('',1,'New Name:,extrawidth=250',name);
    if not retval then no_undo()return end;
    if #retvals_csv:gsub('%s','')==0 then goto res2 end;
    
    
    for i_tr = 1,countSelTrack do;
        local selTrack = reaper.GetSelectedTrack(0,i_tr-1);
        CountFX = reaper.TrackFX_GetCount(selTrack);
        if CountFX > 0 then;
            for i = 1,CountFX do;
                local NameDefault, Name = Arc.TrackFX_GetFXNameEx(selTrack,i-1);
                if Name == '' then Name = NameDefault end;
                if Name == name or Name:gsub('^.-:','')==name:gsub('^.-:','')then;
                    if not UNDO then;
                        reaper.PreventUIRefresh(1);
                        reaper.Undo_BeginBlock();
                        UNDO = true;
                    end;
                    Arc.TrackFx_Rename(selTrack,i-1,retvals_csv);
                end;
            end;
        end;
    end;
    
    
    if UNDO then;
        reaper.Undo_EndBlock("Rename all fx in selected tracks with specific name in specific name",-1);
        reaper.PreventUIRefresh(-1);
    else;
        no_undo();
    end;
    
    
    