--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Insert track holding the mouse into empty TCP and rename, random color
   * Author:      Archie
   * Version:     1.02
   * Описание:    Вставить трек удерживая мышь в пустой TCP и переименуйте, случайный цвет
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    shprot(Rmm)
   * Gave idea:   shprot(Rmm)
   * Extension:   Reaper 5.984+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:   v.1.0 [28.11.19]
   *                  + initialе
--]]


    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local interval = .5   -- second


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    ---------------------------------
    local function rand();
        local x = math.random(1,9);
        for i = 1,16 do;
            x = x..math.random(0,9);
        end;
        math.randomseed(x);
        return math.random(0,255);
    end;
    ---------------------------------


    ---------------------------------
    local function body();
        ------
        reaper.Undo_BeginBlock();
        reaper.PreventUIRefresh(1);
        local CountTrack = reaper.CountTracks(0);
        reaper.InsertTrackAtIndex(CountTrack,true);
        local lstTrack = reaper.GetTrack(0,CountTrack);
        local col = reaper.ColorToNative(rand(),rand(),rand());
        reaper.SetMediaTrackInfo_Value(lstTrack,"I_CUSTOMCOLOR",col|0x1000000);

        reaper.SetOnlyTrackSelected(lstTrack);
        reaper.PreventUIRefresh(-1);
        reaper.Main_OnCommand(40696,0);--Rename last
        reaper.Undo_EndBlock("New Track/random color/rename",-1)
        ------
    end;
    ---------------------------------



    ------------------------------------------------------------
    ----v / mouse button is clamped / кнопка мыши зажата / v----
    ------------------------------------------------------------


    ---------------------------------
    local empty;
    local timeAct;
    if not tonumber(interval)then interval = .5 end;

    local function loop();

        local window, segment, details = reaper.BR_GetMouseCursorContext();
        if (window == "tcp" or window == "mcp") and
           segment == "empty" and (not details or details == "") then;

            local Mouse_GState = reaper.JS_Mouse_GetState(127);

            if Mouse_GState == 0 then empty = true end;
            if Mouse_GState ~= 0 and Mouse_GState ~= 1 then empty = nil end;

            if Mouse_GState == 1 and not timeAct and empty then;
                timeAct = os.clock();
            end;

            if Mouse_GState ~= 1 then;
                timeAct = nil;
            end;

            if timeAct and (os.clock() - timeAct) >= interval then;
                ----
                --t=(t or 0)+1;
                ----
                body();
                ----
                empty   = nil;
                timeAct = nil;
            end;

        else;
            empty   = nil;
            timeAct = nil;
        end;
        reaper.defer(loop);
    end;
    ---------------------------------


    ---------------------------------
    function SetToggleButtonOnOff(numb);
        local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context();
        reaper.SetToggleCommandState(sec,cmd,numb or 0);
        reaper.RefreshToolbar2(sec,cmd);
    end;
    ---------------------------------


    ---------------------------------
    SetToggleButtonOnOff(1);
    reaper.defer(loop);
    reaper.atexit(SetToggleButtonOnOff);
    ---------------------------------
