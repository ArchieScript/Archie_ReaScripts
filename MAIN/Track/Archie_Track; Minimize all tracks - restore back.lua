--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Minimize all tracks - recover back
   * Author:      Archie
   * Version:     1.02
   * AboutScript: ---
   * О скрипте:   Минимизировать все треки - восстановить назад
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


    local extname = "ArchieMinimizeTracksRecoverBackHeight";
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
    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then no_undo() return end;

    local Height;
    for i = 1,CountTrack do;
        local track = reaper.GetTrack(0,i-1);
        Height = reaper.GetMediaTrackInfo_Value(track,"I_HEIGHTOVERRIDE");
        if Height == 0 then;
            Height = reaper.GetMediaTrackInfo_Value(track,"I_TCPH");
        end;
        if Height > minHeight then break end;
    end;
    -------------



    --------------------
    if Height > minHeight then;
        for i = 1,reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            local height = reaper.GetMediaTrackInfo_Value(Track,"I_TCPH");
            local GUID = reaper.GetTrackGUID(Track);
            reaper.SetProjExtState(0,extname,GUID,height);
            reaper.SetMediaTrackInfo_Value(Track,"I_HEIGHTOVERRIDE",minHeight);
        end;
    else;
        for i = 1,reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            local GUID = reaper.GetTrackGUID(Track);
            local val = tonumber(({reaper.GetProjExtState(0,extname,GUID)})[2]);
            if val then;
                if val < minHeight then val = minHeight end;
                reaper.SetMediaTrackInfo_Value(Track,"I_HEIGHTOVERRIDE",val);
                reaper.SetProjExtState(0,extname,GUID,"");
            end;
        end;
    end;

    reaper.UpdateArrange();
    reaper.TrackList_AdjustWindows(false);
    --------------------------------------
    no_undo();
    --reaper.Main_OnCommand(40913,0)--scroll center