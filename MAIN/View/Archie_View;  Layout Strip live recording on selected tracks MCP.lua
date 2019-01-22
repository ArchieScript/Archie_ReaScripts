--[[
   * Category:    View 
   * Description: Layout Strip live recording on selected tracks MCP 
   * Author:      Archie
   * Version:     1.01
   * AboutScript: Layout Strip live recording on selected tracks MCP 
   * О скрипте:   Макет полосы живой записи на выбранных дорожках MCP
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---
   * Gave idea:   ---
   * Changelog:   +  initialе / v.1.0
--===========================================================
SYSTEM REQUIREMENTS: / СИСТЕМНЫЕ ТРЕБОВАНИЯ: 
    Reaper v.5.961 -------- \http://www.reaper.fm/download.php -------\(and above \ и выше)\
    SWS v.2.9.7 ------------ \ http://www.sws-extension.org/index.php -\(and above \ и выше)\
    ReaPack v.1.2.2 --------- \  http://reapack.com/repos --------------\(and above \ и выше)\
    Arc_Function_lua v.1.0.4 - \ http://clck.ru/EjERc -------------------\(and above \ и выше)\
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



 

    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then Arc.no_undo() return end;
    local layoutName,Active = "ec --- Strip Live Recording";


    for i = CountSelTrack-1,0,-1 do;
        local SelTrack = reaper.GetSelectedTrack(0,i);
        local _,str = reaper.GetTrackStateChunk(SelTrack,"",true);
        if select(2,str:match('(LAYOUTS ".-") (".-")')) ~= '"'..layoutName..'"' then
            Active = "Active"
        end;
    end;

    if not Active then Arc.no_undo() return end


    reaper.Undo_BeginBlock()
  

    for i = CountSelTrack-1,0,-1 do;
        local SelTrack = reaper.GetSelectedTrack(0,i);

        local _,str = reaper.GetTrackStateChunk(SelTrack,"",true);
        ----
        if select(2,str:match('(LAYOUTS ".-") (".-")')) ~= '"'..layoutName..'"' then
    
            Arc.SetShow_HideTrackMCP(SelTrack,0); 
            local Layout = str:match('LAYOUTS ".-" ".-"');
            if not Layout then Layout = 'LAYOUTS "" ""' end;
            if Layout == 'LAYOUTS "" ""' then;
                local Perf = str:match('PERF %d+');
                str = str:gsub(Perf, Perf..'\n'..Layout);
            end;
            ---
            local LayTCP, MCP = str:match('(LAYOUTS ".-") (".-")');
            local str2 = string.gsub(str, '(LAYOUTS ".-") (".-")',LayTCP.." "..'"'..layoutName..'"');
            reaper.SetTrackStateChunk(SelTrack, str2, true);
            Arc.SetShow_HideTrackMCP(SelTrack,1);
        end;
    end;

    reaper.Undo_EndBlock("Layout Strip live recording on selected tracks MCP",-1);