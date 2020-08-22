--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Restore all track mute solo state slot 1
   * Author:      Archie
   * Version:     1.10
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.05+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [100620]
   *                  + ----

   *              v.1.0 [230320]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================

    local SLOT = 1; -- 1..100
    local CLEAN = false; -- true/false

    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    --=========================================
    SLOT = tonumber(SLOT)or 1;
    if SLOT < 1 or SLOT > 100 then slot = 1 end;
    local extname = 'ARCHIE_TRACK_MUTE_SOLO_STATE_SLOT '..SLOT;
    --=========================================


    local UNDO;
    reaper.PreventUIRefresh(1);

    local i=0;
    while true do;
        i = i + 1;
        local retval,key,val = reaper.EnumProjExtState(0,extname,i-1);
        if not retval or i>1e+4 then break end;
        local track = reaper.BR_GetMediaTrackByGUID(0,key);
        if track then;
            if not UNDO then;
                reaper.Undo_BeginBlock();UNDO=true;
            end;
            local mute,solo = val:match('(%S+)%s+(%S+)');
            reaper.SetMediaTrackInfo_Value(track,'B_MUTE',mute or 0);
            reaper.SetMediaTrackInfo_Value(track,'I_SOLO',solo or 0);
        end;
    end;

    reaper.PreventUIRefresh(-1);

    if CLEAN then;
        reaper.SetProjExtState(0,extname,'','');
    end;

    reaper.DeleteExtState(extname,'SaveState',false);--button

    if UNDO then;
        reaper.Undo_EndBlock('Restore mute solo slot '..SLOT,-1);
    else;
        reaper.defer(function()end);
    end;




