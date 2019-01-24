--[[
   * Category:    View 
   * Description: Layout Standard expanding, popup fader on selected tracks TCP
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Layout Standard expanding, popup fader on selected tracks TCP
   * О скрипте:   Макет Стандартное расширение, всплывающий фейдер на выбранных дорожках TCP
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




    --============================ FUNCTION MODULE FUNCTION ================================ FUNCTION MODULE FUNCTION ========================================
    local Fun,scr,dir,MB,Arc,Load=reaper.GetResourcePath()..'\\Scripts\\Archie-ReaScripts\\Functions',select(2,reaper.get_action_context()):match("(.+)[\\]"),
    reaper.GetResourcePath();package.path=Fun.."/?.lua"..";"..scr.."/?.lua"..";"..dir.."/?.lua"..";"..package.path;Load,Arc=pcall(require,"Arc_Function_lua");
    if not Load then reaper.MB('Missing file "Arc_Function_lua",\nDownload from repository Archie-ReaScript and put in\n'..Fun..'\n\n'..'Отсутствует '..--====
    'файл "Arc_Function_lua",\nСкачайте из репозитория Archie-ReaScript и поместите в \n'..Fun,"Error.",0)return end;--=======================================
    if not Arc.VersionArc_Function_lua("2.1.8",Fun,"")then Arc.no_undo() return end;--==================================== FUNCTION MODULE FUNCTION ==========
    --==================================▲=▲=▲=================================================================================================================



 

    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then Arc.no_undo() return end;
    local layoutName,Active = "af --- Standard expanding, popup fader";


    for i = CountSelTrack-1,0,-1 do;
        local SelTrack = reaper.GetSelectedTrack(0,i);
        local _,str = reaper.GetTrackStateChunk(SelTrack,"",true);
        if select(2,str:match('(LAYOUTS) (".-")')) ~= '"'..layoutName..'"' then;
            Active = "Active";
        end;
    end;

    if not Active then Arc.no_undo() return end;


    reaper.Undo_BeginBlock()

    for i = CountSelTrack-1,0,-1 do;
        local SelTrack = reaper.GetSelectedTrack(0,i);
        local _,str = reaper.GetTrackStateChunk(SelTrack,"",true);
        ----
        if select(2,str:match('(LAYOUTS) (".-")')) ~= '"'..layoutName..'"' then
            -------
            local Layout = str:match('LAYOUTS ".-" ".-"');
            if not Layout then Layout = 'LAYOUTS "" ""' end;
            if Layout == 'LAYOUTS "" ""' then;
                local Perf = str:match('PERF %d+');
                str = str:gsub(Perf, Perf..'\n'..Layout);
            end;
            ---
            local Lay, TCP, MCP = str:match('(LAYOUTS) (".-") (".-")');
            local str2 = string.gsub(str, '(LAYOUTS) (".-") (".-")',Lay.." "..'"'..layoutName..'"'.." "..MCP);
            reaper.SetTrackStateChunk(SelTrack, str2, true);
            --------
        end;
    end;

    reaper.Undo_EndBlock("Layout Standard expanding, popup fader on selected tracks TCP",-1);