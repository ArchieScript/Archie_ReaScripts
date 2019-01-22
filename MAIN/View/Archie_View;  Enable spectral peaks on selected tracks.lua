--[[
   * Category:    View
   * Description: Enable spectral peaks on selected tracks
   * Author:      Archie
   * Version:     1.01
   * AboutScript: Enable spectral peaks only on selected tracks
   * О скрипте:   Включить спектральные пики только на выбранных дорожках
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    smrz1(RMM Forum)
   * Gave idea:   smrz1(RMM Forum)
   * Changelog:   + initialе / v.1.0
--=========================================================== 
SYSTEM REQUIREMENTS: / СИСТЕМНЫЕ ТРЕБОВАНИЯ: 
    Reaper v.5.962 -------- \http://www.reaper.fm/download.php -------\(and above \ и выше)\
    SWS v.2.9.7 ------------ \ http://www.sws-extension.org/index.php -\(and above \ и выше)\
    ReaPack v.1.2.2 --------- \  http://reapack.com/repos --------------\(and above \ и выше)\
    Arc_Function_lua v.1.0.8 - \ http://clck.ru/EjERc -------------------\(and above \ и выше)\
--===========================================================================================]]




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --======================================= FUNCTION MODULE FUNCTION =============================================================
    local Path,Mod,T,Way = reaper.GetResourcePath()--================== FUNCTION MODULE FUNCTION ===================================
    T = {Path..'\\Scripts\\Archie-ReaScripts\\Functions',(select(2,reaper.get_action_context()):match("(.+)[\\]")),Path};--=========
    for i=1,#T do;for j=0,math.huge do;Mod=reaper.EnumerateFiles(T[i],j);--=========================================================
        if Mod=="Arc_Function_lua.lua"then Way=T[i]break end;if not Mod then break end;end;if Way then break end;--=================
    end;if not Way then reaper.MB ('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in \n'..T[1]
    ..'\n\nОтсутствует файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..T[1],"Error.",0)else;--
    package.path = package.path..";"..Way.."/?.lua";Arc=require"Arc_Function_lua";Arc.VersionArc_Function_lua("2.1.8",Way,"")end;---
    --=========================================================================================================▲▲▲▲▲================





    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then Arc.no_undo() return end;

    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then Arc.no_undo() return end;

    reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock()

    local id = 42073;
    local Spectral = reaper.GetToggleCommandState(id);
    if Spectral == 0 then Arc.Action(id) end;

    for i = 1,CountTrack do
        local Track = reaper.GetTrack(0,i-1)
        local _,str = reaper.GetTrackStateChunk(Track,"",false);
        local sel,Perf = reaper.IsTrackSelected(Track)
        if sel == true then
            Perf = 0
        else
            Perf = 4
        end
        local str2 = str:gsub('PERF %d+', "PERF".." "..Perf)
        reaper.SetTrackStateChunk(Track, str2, false)
    end 

    reaper.Undo_EndBlock("Enable spectral peaks on selected tracks",-1)
    reaper.PreventUIRefresh(-1)