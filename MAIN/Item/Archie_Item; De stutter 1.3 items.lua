--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: De stutter 1.3 items
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Use with Stutter 1.3 items
   * О скрипте:   Использовать с Stutter 1.3 items
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    borisuperful(Rmm)
   * Gave idea:   borisuperful(Rmm)
   * Changelog:   v.1.0 [16.08.19]
   *                  + initialе

    -- Тест только на windows  /  Test only on windows.
    --=======================================================================================
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:
    (+) - required for installation      | (+) - обязательно для установки
    (-) - not necessary for installation | (-) - не обязательно для установки
    -----------------------------------------------------------------------------------------
    (+) Reaper v.5.981 +            --| http://www.reaper.fm/download.php
    (-) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php
    (-) ReaPack v.1.2.2 +           --| http://reapack.com/repos
    (-) Arc_Function_lua v.2.4.4 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]]



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    --------------------------------------------------------
    local function no_undo() reaper.defer(function()end)end;
    --------------------------------------------------------


    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then no_undo() return end;

    reaper.PreventUIRefresh(1);

    for l = 1, CountTrack do;
        local track = reaper.GetTrack(0,l-1);

        local CountTr_Item = reaper.CountTrackMediaItems(track);
        local delTrT,x = {};
        for i = 1, CountTr_Item do;
            local item = reaper.GetTrackMediaItem(track,i-1);
            local sel = reaper.GetMediaItemInfo_Value(item,"B_UISEL");
            if sel == 1 then;
                x = (x or 0)+1;
                if x ~= 1 then delTrT[#delTrT+1] = item end;
                if x >= 3 then x = 0 end;
            end;
        end;

        local DeleteTrack,Undo;
        for i = 1, #delTrT do;
           DeleteTrack = reaper.DeleteTrackMediaItem(track,delTrT[i]);
        end;

        if DeleteTrack then;
            if not Undo then reaper.Undo_BeginBlock()Undo = true end;
            local CountTr_Item = reaper.CountTrackMediaItems(track);
            for i = 1, CountTr_Item do;
                local item = reaper.GetTrackMediaItem(track,i-1);
                local sel = reaper.GetMediaItemInfo_Value(item,"B_UISEL");
                if sel == 1 then;
                    local len = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
                    reaper.SetMediaItemInfo_Value(item,"D_LENGTH",len*3);
                end;
            end;
        end;
        DeleteTrack = nil;
        x = nil;
    end;

    reaper.PreventUIRefresh(-1);
    reaper.UpdateArrange();

    if Undo then;
        reaper.Undo_EndBlock("De Stutter 1/3 items",-1);
    else;
        no_undo();
    end;