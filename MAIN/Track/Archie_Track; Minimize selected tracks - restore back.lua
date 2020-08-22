--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Minimize selected tracks - recover back
   * Author:      Archie
   * Version:     1.02
   * AboutScript: ---
   * О скрипте:   Минимизировать выбранные треки - восстановить назад
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Krikets(RMM)
   * Gave idea:   Krikets(RMM)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [19.09.19]
   *                  + initialе
--]]


    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local minHeight = 24;


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------



    local extname = "ArchieMinimizeTracksRecoverBackHeight"
    -------
    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then no_undo() return end;
    local val = tonumber(({reaper.GetProjExtState(0,extname,"CountTrack")})[2])or CountTrack+1;
    if CountTrack ~= val then;
        for i = 1,math.huge do;
            local retval,key,val = reaper.EnumProjExtState(0,extname,i-1);
            if retval and key ~= "COUNTTRACK" then;
                local tr = reaper.BR_GetMediaTrackByGUID(0,key);
                if not tr then;
                    reaper.SetProjExtState(0,extname,key,"");
                end;
            end;
            if not retval then break end;
        end;
        reaper.SetProjExtState(0,extname,"CountTrack",CountTrack);
    end;
    -------


    -------------
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;

    local Height;
    for i = 1,CountSelTrack do;
        local trackSel = reaper.GetSelectedTrack(0,i-1);
        Height = reaper.GetMediaTrackInfo_Value(trackSel,"I_HEIGHTOVERRIDE");
        if Height == 0 then;
            Height = reaper.GetMediaTrackInfo_Value(trackSel,"I_TCPH");
        end;
        if Height > minHeight then break end;
    end;
    -------------


    --------------------
    if Height > minHeight then;
        for i = 1,reaper.CountSelectedTracks(0) do;
            local SelTrack = reaper.GetSelectedTrack(0,i-1);
            local height = reaper.GetMediaTrackInfo_Value(SelTrack,"I_TCPH");
            local GUID = reaper.GetTrackGUID(SelTrack);
            reaper.SetProjExtState(0,extname,GUID,height);
            reaper.SetMediaTrackInfo_Value(SelTrack,"I_HEIGHTOVERRIDE",minHeight);
        end;
    else;
        for i = 1,reaper.CountSelectedTracks(0) do;
            local SelTrack = reaper.GetSelectedTrack(0,i-1);
            local GUID = reaper.GetTrackGUID(SelTrack);
            local val = tonumber(({reaper.GetProjExtState(0,extname,GUID)})[2]);
            if val then;
                if val < minHeight then val = minHeight end;
                reaper.SetMediaTrackInfo_Value(SelTrack,"I_HEIGHTOVERRIDE",val);
                reaper.SetProjExtState(0,extname,GUID,"");
            end;
        end;
    end;

    reaper.UpdateArrange();
    reaper.TrackList_AdjustWindows(false);
    --------------------------------------
    no_undo();