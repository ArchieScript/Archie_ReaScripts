--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Mixer
   * Description: Toggle Auto zoom height selected tracks in MCP
   * Author:      Archie
   * Version:     1.04
   * AboutScript: Toggle Auto zoom height selected tracks in MCP
   *              CTRL + CLICK:         SET HEIGHT OF SELECTED TRACKS MCP TO HEIGHT MASTER TRACK*
   *              SHIFT + CLICK:        SET HEIGHT OF ALL UNSELECTED TRACKS MCP TO HEIGHT MASTER TRACK*
   *              CTRL + SHIFT + CLICK: SET HEIGHT OF ALL TRACKS MCP TO HEIGHT MASTER TRACK*
   *              * Requires extension "reaper_js_ReaScript API"(repository "ReaTeam Extensions")
   * О скрипте:   Переключатель Автоматическое увеличение высоты выбранных дорожек в MCP
   *              CTRL + CLICK:         УСТАНОВИТЬ ВЫСОТУ ВЫБРАННЫХ ТРЕКОВ MCP НА ВЫСОТУ МАСТЕР-ТРЕКА*
   *              SHIFT + CLICK:        УСТАНОВИТЬ ВЫСОТУ ВСЕХ НЕВЫБРАННЫХ ТРЕКОВ MCP НА ВЫСОТУ МАСТЕР-ТРЕКА*
   *              CTRL + SHIFT + CLICK: УСТАНОВИТЬ ВЫСОТУ ВСЕХ ТРЕКОВ MCP НА ВЫСОТУ МАСТЕР-ТРЕКА*
   *              * Требуется расширение "reaper_js_ReaScript API"(репозиторий  "ReaTeam Extensions")
   * GIF:         http://avatars.mds.yandex.net/get-pdb/1599133/98ce76fb-ab33-468d-8db2-21c8c38edbc9/orig
   *              https://avatars.mds.yandex.net/get-pdb/1926958/c1fb2758-7147-4771-a0fa-a5f07d3f4abb/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    YuriOl(RMM) / Алексей Левин(VK)
   * Gave idea:   YuriOl(RMM) / Алексей Левин(VK)
   * Changelog:
   *              v.1.02 [060320]
   *                 + Added scroll shift
   *                 ! Fixed bug

   *              v.1.01 [13.06.19]
   *                 ---
   *              v.1.0 [12.06.19]
   *                  +  initialе

   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.975 +           --| http://www.reaper.fm/download.php
   (+) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos
   (+) Arc_Function_lua v.2.4.4 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc
   (+) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6
   =======================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local HEIGHT = 100
              -- = Увеличеть на
              -- = Zoom in on
              ---------------


    local MIX_Track_SHIFT = 0 -- Сдвинуть на кол-во треков 0...20

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
	


    if not tonumber(MIX_Track_SHIFT) then MIX_Track_SHIFT = 0 end;
    if MIX_Track_SHIFT < 0 or MIX_Track_SHIFT > 20 then MIX_Track_SHIFT = 0 end;

    local Api_sws = Arc.SWS_API(true);
    if not Api_sws then Arc.no_undo()return end;


    Arc.HelpWindowWhenReRunning(2,"Arc_Function_lua",false);



    HEIGHT = (HEIGHT or 50)/1000;
    local TrT = {};
    local stop;
    local ProjectState2;
    local StartScript = reaper.GetLastTouchedTrack();
    local changes; --изменения
    local section = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)");



    local function loop();

        ---- / Toggle >/ ----
        local Tog = reaper.GetExtState(section,"toggle");
        if Tog == "" then Arc.no_undo() return end;
        ------ T< -----------

        local ProjectState = reaper.GetProjectStateChangeCount(0);
        if ProjectState ~= ProjectState2 then;
            ProjectState2 = ProjectState;
            ----

            for i = #TrT,1,-1 do;
                local ByGUID = reaper.BR_GetMediaTrackByGUID(0,TrT[i]);
                if ByGUID then;
                    local Sel = reaper.GetMediaTrackInfo_Value(ByGUID,"I_SELECTED");
                    if Sel == 0 then;
                        local height = Arc.GetSetHeigthMCPTrack(ByGUID,nil,0);
                        Arc.GetSetHeigthMCPTrack(ByGUID,height+HEIGHT,1);
                        table.remove(TrT,i);
                        changes = 1;
                    end;
                end;
            end;
            ----

            local CountSelTrack = reaper.CountSelectedTracks(0);
            for i = 1, CountSelTrack do;
                local Track = reaper.GetSelectedTrack(0,i-1);
                local GUID = reaper.GetTrackGUID(Track);

                for i2 = 1, #TrT do;
                    if TrT[i2] == GUID then;
                        stop = 1;
                    end;
                end;

                if not stop then;
                    local Sel = reaper.GetMediaTrackInfo_Value(Track,"I_SELECTED");
                    local height = Arc.GetSetHeigthMCPTrack(Track,nil,0);
                    Arc.GetSetHeigthMCPTrack(Track,height-HEIGHT,1);
                    reaper.defer(function() reaper.SetMediaTrackInfo_Value(Track,"I_SELECTED",Sel) end);
                    TrT[#TrT+1] = GUID;
                    changes = 1;
                end;
                stop=nil;
            end;

            --- / Scrol Mixer >/ ---
            if changes == 1 then;
                local Toggle = reaper.GetToggleCommandStateEx(0,40221);--Mixer scroll
                if Toggle == 1 then;
                    if StartScript ~= reaper.GetLastTouchedTrack()then;
                        local window,segment,details = reaper.BR_GetMouseCursorContext();
                        if window ~= "mcp" then;
                            local GetLast = reaper.GetLastTouchedTrack();
                            if GetLast and GetLast ~= GetLast2 then;
                                reaper.defer(function()reaper.SetMixerScroll(GetLast);end);
                                GetLast2 = GetLast;
                            end;
                        else;
                            --r=(r or 0)+1;
                            local GetMixerScrol = reaper.GetMixerScroll();
                            reaper.defer(function()reaper.SetMixerScroll(GetMixerScrol);end);
                        end;
                        StartScript = nil;
                    end;
                end;
            end;
            ----- SM< --------------
            changes = nil;
            --t=(t or 0)+1;
        end;


        if MIX_Track_SHIFT > 0 then;
            local Toggle = reaper.GetToggleCommandStateEx(0,40221);--Mixer scroll
            if Toggle == 1 then;
                local CountSelTrack_ = reaper.CountSelectedTracks(0);
                if CountSelTrack_ == 1 then;
                    local TrMix = reaper.GetMixerScroll()
                    if TrMix then
                        local Sel = reaper.GetMediaTrackInfo_Value(TrMix,"I_SELECTED");
                        if Sel == 1 then;
                            numb = reaper.GetMediaTrackInfo_Value(TrMix,"IP_TRACKNUMBER")-1;
                            for imix = MIX_Track_SHIFT,0,-1 do;
                                TrShift = reaper.GetTrack(0,numb-imix);
                                if TrShift then
                                    Vis = reaper.IsTrackVisible( TrShift, true )
                                    if Vis then
                                        --reaper.SetMixerScroll(TrShift)
                                        reaper.defer(function()reaper.SetMixerScroll(TrShift);end);
                                        break
                                    end
                                end
                            end
                        end;
                    end;
                end;
            end;
        end;

        reaper.defer(loop);
    end;



    local function exit();
        local CountSelTrack = reaper.CountSelectedTracks(0);
        for i = 1, CountSelTrack do;
            local Track = reaper.GetSelectedTrack(0,i-1);
            local height = Arc.GetSetHeigthMCPTrack(Track,nil,0);
            Arc.GetSetHeigthMCPTrack(Track,height+HEIGHT,1);
        end;
    end;



    --- / CTRL -- Shift -- CTRL+Shift / ---
    if reaper.APIExists("JS_Mouse_GetState") then;
        local GetState = reaper.JS_Mouse_GetState(127);
        local Path = ({reaper.get_action_context()})[2]:match(".+[\\/]");
        local ret,err,name;
        if GetState == 4 then;--Ctrl
            name = "Archie_Mixer; Set height of selected tracks MCP to height master track.lua";
            ret,err = pcall(dofile,Path..name);
            if ret then Arc.no_undo() return end;
        elseif GetState == 8 then;--Shift
            name = "Archie_Mixer; Set height of all unselected tracks MCP to height master track.lua";
            ret,err = pcall(dofile,Path..name);
            if ret then Arc.no_undo() return end;
        elseif GetState == 12 then;--Ctrl+Shift
            name = "Archie_Mixer; Set height of all tracks MCP to height master track.lua";
            ret,err = pcall(dofile,Path..name);
            if ret then Arc.no_undo() return end;
        end;
        if not ret and name then;
            reaper.MB("ENG:\n\nMissing script\n"..name.."\nAlong the way\n"..Path.."...\n\n\n"..
                      "RUS:\n\nОтсутствует скрипт\n"..name.."\nпо пути\n"..Path.."...","ERROR",0);
            Arc.no_undo() return;
        end;
    end;



    ---- / Toggle >/ ----
    local Toggle = tonumber(reaper.GetExtState(section,"toggle"))or 0;
    if Toggle == 0 then;
        reaper.SetExtState(section,"toggle",1,false);
        ---
        local IdByName = Arc.GetIDByScriptName("Archie_Mixer; Toggle Auto zoom height tracks rec-armed in MCP(`).lua");
        local Toggle2 = reaper.GetToggleCommandState(reaper.NamedCommandLookup(IdByName));
        if Toggle2 == 1 then;
            reaper.Main_OnCommand(reaper.NamedCommandLookup(IdByName),0);
        end;
        ---
        loop();
        Arc.GetSetToggleButtonOnOff(1,1);
    elseif Toggle == 1 then;
        reaper.DeleteExtState(section,"toggle",false);
        exit();
        Arc.GetSetToggleButtonOnOff(0,1);
        Arc.no_undo()return;
     end;
     ------ T< -----------