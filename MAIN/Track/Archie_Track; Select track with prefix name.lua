--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Select track with prefix name.lua
   * Author:      Archie
   * Version:     1.03
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Erundolog(Rmm)
   * Gave idea:   Erundolog(Rmm)
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.02 [160520]
   *                  + Case sensitivity

   *              v.1.0 [160520]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local NAME_PREFIX = 'HIDE_'; -- Имя префикса


    local USER_INPUTS = true;
                   -- = false  -- Не показывать окно для вводи имени
                   -- = true   -- Показать окно для вводи имени


    local No_REGIST = true  -- Чувствительность к Регистру


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    ---------------------------------------------------------
    local function no_undo();reaper.defer(function()end);end;
    ---------------------------------------------------------


    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then no_undo() return end;


    if USER_INPUTS then;
        local title = 'Select track with prefix name';
        local retval,retvals_csv = reaper.GetUserInputs(title,1,'Inter name Prefix:,extrawidth=150',NAME_PREFIX or'');
        if not retval then no_undo() return end;
        NAME_PREFIX = retvals_csv;
    end;


    local UNDO;
    local name2;
    local t = {};
    for i = CountTrack-1,0,-1 do;
        local Track = reaper.GetTrack(0,i);
        local _,name = reaper.GetSetMediaTrackInfo_String(Track,"P_NAME","",0);
        if No_REGIST then;
            name2 = (name:upper()):match('^'..(NAME_PREFIX:upper()));
        else;
            name2 = name:match('^'..NAME_PREFIX);
        end;
        if name2 then;
            if not UNDO then;
                reaper.Undo_BeginBlock();
                reaper.PreventUIRefresh(1);
                UNDO = true;
            end;
            local sel = reaper.GetMediaTrackInfo_Value(Track,'I_SELECTED')==1;
            if not sel then;
                reaper.SetMediaTrackInfo_Value(Track,'I_SELECTED',1);
            end;
        else;
            t[#t+1] = Track;
        end;
    end;


    if UNDO then;
        for i = 1,#t do;
            local sel = reaper.GetMediaTrackInfo_Value(t[i],'I_SELECTED')==1;
            if sel then;
                reaper.SetMediaTrackInfo_Value(t[i],'I_SELECTED',0);
            end;
        end;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Select track with prefix name '..NAME_PREFIX,-1);
    else;
        no_undo();
    end;



