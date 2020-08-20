--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Time selection
   * Description: Remove all contents of time selection
   * Author:      Archie
   * Version:     1.02
   * AboutScript: ---
   * О скрипте:   Удалить все содержимое выбора времени
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    AlexLazer(Rmm)
   * Gave idea:   AlexLazer(Rmm)
   * Changelog:   v.1.0 [17.07.2019]
   *                  + initialе

    -- Тест только на windows  /  Test only on windows.
    --=======================================================================================
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:
    (+) - required for installation      | (+) - обязательно для установки
    (-) - not necessary for installation | (-) - не обязательно для установки
    -----------------------------------------------------------------------------------------
    (+) Reaper v.5.975 +            --| http://www.reaper.fm/download.php
    (-) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php
    (-) ReaPack v.1.2.2 +           --| http://reapack.com/repos
    (-) Arc_Function_lua v.2.4.4 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]]



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local function InsertPointsByTimeForAllTracks(Time);
        local samplerate = reaper.GetSetProjectInfo(0,"PROJECT_SRATE",0,0);
        for i = 1, reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            local CountTrEnv = reaper.CountTrackEnvelopes(Track);
            for i2 = 1, CountTrEnv do;
                local InsertPointActive;
                local EnvTrack = reaper.GetTrackEnvelope(Track,i2-1);
                ----
                local AutomationItems = reaper.CountAutomationItems(EnvTrack);
                for i3 = 1, AutomationItems do;
                    local posAutoIt = reaper.GetSetAutomationItemInfo(EnvTrack,i3-1,"D_POSITION",0,0);
                    local lenAutoIt = reaper.GetSetAutomationItemInfo(EnvTrack,i3-1,"D_LENGTH",0,0);
                    if posAutoIt > Time then break end;
                    if posAutoIt < Time and posAutoIt+lenAutoIt > Time then;
                        local retval,value,_,_,_ = reaper.Envelope_Evaluate(EnvTrack,Time,samplerate,0);
                        reaper.InsertEnvelopePointEx(EnvTrack,i3-1,Time,value,0,0,0,false);
                        InsertPointActive = true;
                        break;
                    end;
                end;
                ----
                if not InsertPointActive then;
                    local retval,value,_,_,_ = reaper.Envelope_Evaluate(EnvTrack,Time,samplerate,0);
                    reaper.InsertEnvelopePoint(EnvTrack,Time,value,0,0,false,false);
                end;
                ----
            end;
        end;
    end;



    local function RemovePartOfRegionByTime(startTime,endTime);
        local retval,num_markers,num_regions = reaper.CountProjectMarkers(0);
        if type(num_regions) == "number" and num_regions > 0 then;
            for i = retval,0,-1 do;
                local retval_,isrgn,pos,rgnend,name,markrgnindexnumber = reaper.EnumProjectMarkers(i);
                if isrgn == true then;
                    if pos < endTime and rgnend > startTime then;
                        reaper.DeleteProjectMarker(0,markrgnindexnumber,true);
                    end;
                    if pos < startTime and rgnend > startTime then;
                        reaper.AddProjectMarker(0,true,pos,startTime,name,-1);
                    end;
                    if pos < endTime and rgnend > endTime then;
                        reaper.AddProjectMarker(0,true,endTime,rgnend,name,-1);
                    end;
                end;
            end;
        end;
    end;


    local startLoop,endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    if startLoop == endLoop then no_undo() return end;


    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();

    InsertPointsByTimeForAllTracks(startLoop-0.0000001);
    InsertPointsByTimeForAllTracks(endLoop  +0.0000001);
    RemovePartOfRegionByTime(startLoop,endLoop);
    reaper.Main_OnCommand(40200,0)--Insert empty
    reaper.GetSet_LoopTimeRange(1,0,endLoop,(endLoop-startLoop)+endLoop,0);
    reaper.Main_OnCommand(40201,0)--Remove contents
    reaper.GetSet_LoopTimeRange(1,0,startLoop,endLoop,0);

    reaper.Undo_EndBlock("Remove all contents of time selection",-1);
    reaper.PreventUIRefresh(-1);