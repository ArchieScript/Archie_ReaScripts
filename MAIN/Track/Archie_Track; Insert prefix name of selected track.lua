--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Insert prefix name of selected track.lua
   * Author:      Archie
   * Version:     1.03
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
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


    local NAME_PREFIX = 'HIDE_'; -- Имя Вставляемого префикса


    local USER_INPUTS = true;
                   -- = false  -- Не показывать окно для вводи имени
                   -- = true   -- Показать окно для вводи имени


    local No_REGIST = true; -- Чувствительность к Регистру true/false


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    ---------------------------------------------------------
    local function no_undo();reaper.defer(function()end);end;
    ---------------------------------------------------------


    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;


    if USER_INPUTS then;
        local title = 'Insert prefix name of selected track';
        local retval,retvals_csv = reaper.GetUserInputs(title,1,'Inter name Prefix:,extrawidth=150',NAME_PREFIX or'');
        if not retval then no_undo() return end;
        NAME_PREFIX = retvals_csv;
    end;



    local UNDO;
    local name2;
    for i = CountSelTrack-1,0,-1 do;
        local SelTrack = reaper.GetSelectedTrack(0,i);
        local _,name = reaper.GetSetMediaTrackInfo_String(SelTrack,"P_NAME","",0);

        if No_REGIST then;
            name2 = (name:upper()):match('^'..(NAME_PREFIX:upper()));
        else;
            name2 = name:match('^'..NAME_PREFIX);
        end;

        if not name2 then;
            if not UNDO then;
                reaper.Undo_BeginBlock();
                reaper.PreventUIRefresh(1);
                UNDO = true;
            end;
            reaper.GetSetMediaTrackInfo_String(SelTrack,"P_NAME",NAME_PREFIX..name,1);
        end;
    end;


    if UNDO then;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Insert prefix name '..NAME_PREFIX,-1);
    else;
        no_undo();
    end;

