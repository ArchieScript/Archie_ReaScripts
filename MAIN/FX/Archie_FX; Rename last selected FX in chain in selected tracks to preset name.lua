--[[
   * Category:    Fx
   * Description: Rename last selected FX in chain in selected tracks to preset name
   * Author:      Archie
   * Version:     1.03
   * О скрипте:   Переименовать последний выбранный FX в цепочке в выбранных треках в имя пресета
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Дима Горелик[RMM]
   * Gave idea:   Дима Горелик[RMM]
   * Extension:
   *              Reaper 5.981+ http://www.reaper.fm/
   *              Arc_Function_lua v.2.6.7+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:
   *              v.1.01 [28.09.19]
   *                  +  initialе

   *              v.1.0 [260219]
   *                  +  initialе
--]]


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
	



    local countSelTrack = reaper.CountSelectedTracks(0);
    if countSelTrack == 0 then Arc.no_undo() return end;

    local undo;
    for i = 1,countSelTrack do;
        local selTrack = reaper.GetSelectedTrack(0,i-1);

        local idxSelFx = reaper.TrackFX_GetChainVisible(selTrack);
        if idxSelFx < 0 then;
            local retval,str = reaper.GetTrackStateChunk(selTrack,"",false);
            idxSelFx = tonumber(string.match(str,"LASTSEL (%d)"));
        end;

        if idxSelFx >= 0 then;
            local retval, presetname = reaper.TrackFX_GetPreset(selTrack,idxSelFx,"");
            local TracFx_Rename = Arc.TrackFx_Rename(selTrack,idxSelFx,presetname);
            if not undo and TracFx_Rename then;
                reaper.Undo_BeginBlock();
                undo = true;
            end;
        end;
    end;

    if undo then;
        reaper.Undo_EndBlock("Rename last selected FX in chain in selected tracks to preset name",-1);
    else;
        Arc.no_undo();
    end;