--[[     NEW INSTANCES;
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    FX
   * Description: FX; Offline all FX selected tracks - Restore previous.lua
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.0+ http://www.reaper.fm/
   * Changelog:
   *              v.1.0 [300620]
   *                  + initialе
--]]
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


    local ProjExtState = ('OFFLINE ALL FX SELECTED TRACKS - SAVE OR RESTORE PREVIOUS');

    local ExtState = tonumber(reaper.GetExtState(ProjExtState,'State'));
    if ExtState ~= 1 then;

        ----------------------------------------------------------
        local CountSelTrack2 = reaper.CountSelectedTracks2(0,true);
        if CountSelTrack2 == 0 then no_undo() return end;


        reaper.Undo_BeginBlock();
        reaper.PreventUIRefresh(1);

        for itr = 1,CountSelTrack2 do;

            local Track = reaper.GetSelectedTrack2(0,itr-1,true);

            if Track then;
                local GUID = reaper.GetTrackGUID(Track);
                local t = {};
                ---------------------------------------------
                local ret,str = reaper.GetProjExtState(0,ProjExtState,GUID);
                if ret == 1 and str ~= '' then;
                    ----
                    reaper.SetProjExtState(0,ProjExtState,GUID,'');
                    ----
                    for var in str:gmatch('{.-}%d*') do;
                        local GuidFx,Offline = var:match('({.*})(%d*)');
                        t[GuidFx] = tonumber(Offline);
                    end;

                    for ifx = 1, reaper.TrackFX_GetCount(Track) do;
                        local GUID = reaper.TrackFX_GetFXGUID(Track,ifx-1);
                        if t[GUID] then;
                            reaper.TrackFX_SetOffline(Track,ifx-1,t[GUID]);
                        end;
                    end;

                    for ifx = 1, reaper.TrackFX_GetCount(Track) do;
                        local GUID = reaper.TrackFX_GetFXGUID(Track,0x1000000+ifx-1);
                        if t[GUID] then;
                            reaper.TrackFX_SetOffline(Track,0x1000000+ifx-1,t[GUID]);
                        end;
                    end;
                end;
                ---------------------------------------------
            end;
        end;

        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Restory Offline all FX selected track',-1);
        -----------------------------------------------------------------

    else;


        reaper.DeleteExtState(ProjExtState,'State',false);

        local ActiveOn,ActiveOff;
        local ActiveDoubleScr,stopDoubleScr;
        --local _,extnameProj,sec,cmd,_,_,_ = reaper.get_action_context();
        local scrPath,scrName = debug.getinfo(1,'S').source:match("^@(.+)[/\\](.+)");
        local id = Arc.GetIDByScriptName(scrName,scrPath);
        local sec,cmd = 0,reaper.NamedCommandLookup(id);
        local extnameProj = ProjExtState;


        local function loop();

            ----- stop Double Script -------
            if not ActiveDoubleScr then;
                stopDoubleScr = (tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr"))or 0)+1;
                reaper.SetExtState(extnameProj,"stopDoubleScr",stopDoubleScr,false);
                ActiveDoubleScr = true;
            end;
            local stopDoubleScr2 = tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr"));
            if stopDoubleScr2 > stopDoubleScr then return end;
            --------------------------------

            if Arc.ChangesInProject(1)then;
                local Val;

                for i = 1,reaper.CountSelectedTracks2(0,true) do;
                    local Track = reaper.GetSelectedTrack2(0,i-1,true);
                    local GUID = reaper.GetTrackGUID(Track);
                    local ret,str = reaper.GetProjExtState(0,ProjExtState,GUID);
                    if ret == 1 and str ~= '' then;
                       ----
                       Val = 0;
                       for ifx = 1, reaper.TrackFX_GetCount(Track) do;
                           local Offline = reaper.TrackFX_GetOffline(Track,ifx-1)and 1 or 0;
                           if Offline == 1 then Val = 1 break end;
                       end;
                       ----
                       if Val == 1 then break end;
                       if Val == 0 then;
                           reaper.SetProjExtState(0,ProjExtState,GUID,'');
                       end;
                       ----
                    else;
                        Val = 0;
                    end;
                end;


                if Val == 1 then;
                    if not ActiveOff then;
                        reaper.SetToggleCommandState(sec,cmd,1);
                        reaper.RefreshToolbar2(sec, cmd);
                        ActiveOn = nil;
                        ActiveOff = true;
                    end;
                else;
                    if not ActiveOn then;
                        reaper.SetToggleCommandState(sec,cmd,0);
                        reaper.RefreshToolbar2(sec, cmd);
                        ActiveOff = nil;
                        ActiveOn = true;
                    end;
                end;
            end;
            reaper.defer(loop);
        end;
        reaper.defer(loop);
        reaper.defer(function();local ScrPath,ScrName = debug.getinfo(1,'S').source:match('^[@](.+)[/\\](.+)');Arc.GetSetTerminateAllInstancesOrStartNewOneKB_ini(1,516,ScrPath,ScrName)end);
    end;