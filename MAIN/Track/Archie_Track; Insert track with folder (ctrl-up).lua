--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Insert track with folder (ctrl-up).lua
   * Author:      Archie
   * Version:     1.02
   * О скрипте:   Вставить трек с папкой (ctrl вверх)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.0+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:
   *              v.1.0 [290620]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================

    local Number_of_tracks = 1; -- Количество треков в папке (1...1000)

    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------
    local function SetAsLastTouchedTrack(track);
        local sel = reaper.GetMediaTrackInfo_Value(track,"I_SELECTED");
        reaper.SetMediaTrackInfo_Value(track,"I_SELECTED",math.abs(sel-1));
        reaper.SetMediaTrackInfo_Value(track,"I_SELECTED",sel);
    end;
    -------------------------------------------


    Number_of_tracks = tonumber(Number_of_tracks)or 1;
    if Number_of_tracks < 1 or Number_of_tracks > 1000 then Number_of_tracks = 1 end;
    ----
    local LastTrack = reaper.GetLastTouchedTrack()or(reaper.GetTrack(0,reaper.CountTracks(0)-1));
    ----
    local numb;
    if LastTrack then;
        numb = reaper.GetMediaTrackInfo_Value(LastTrack,"IP_TRACKNUMBER");
    else;
        numb = 0;
    end;
    ----


    ----
    if reaper.APIExists('JS_Mouse_GetState')then;
        local Mouse_State = reaper.JS_Mouse_GetState(127);
        if Mouse_State == 4 or Mouse_State == 5 then;
            numb = numb - 1;
        end;
    else;
        reaper.MB('Missing extension: JS_ReaScriptAPI','Error API',0);
    end;
    ----
    if numb < 0 then numb = 0 end;
    ----


    ----
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    ----


    ----
    reaper.InsertTrackAtIndex(numb,false);
    local trackF = reaper.GetTrack(0,numb);
    reaper.SetOnlyTrackSelected(trackF);
    reaper.SetMediaTrackInfo_Value(trackF,"I_FOLDERDEPTH",1);
    numb = reaper.GetMediaTrackInfo_Value(trackF,"IP_TRACKNUMBER");

    local track;
    for i = 1,Number_of_tracks do;
        reaper.InsertTrackAtIndex(numb,true);
        track = reaper.GetTrack(0,numb);
        reaper.SetMediaTrackInfo_Value(track,"I_SELECTED",1);
        numb = numb+1;
    end;
    reaper.SetMediaTrackInfo_Value(track,"I_FOLDERDEPTH",-1);
    SetAsLastTouchedTrack(track);
    ----


    ----
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("Insert track with folder (ctrl-up)",-1);
    ----


