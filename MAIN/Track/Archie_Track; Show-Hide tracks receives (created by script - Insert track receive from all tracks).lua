--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Show-Hide tracks receives (created by script - Insert track receive from all tracks)
   * Author:      Archie
   * Version:     1.02
   * Описание:    Показать-скрыть треки приемы (созданные скриптом - вставить трек-прием со всех треков)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Snjuk(Rmm)
   * Gave idea:   Snjuk(Rmm)
   * Extension:   Reaper 5.984+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [04.12.19]
   *                  + initialе
--]]


    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local TCP = true   -- true / false

    local MCP = true   -- true / false


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    --------------------------------------------------------
    local function no_undo() reaper.defer(function()end)end;
    --------------------------------------------------------

    if not TCP and not MCP then no_undo()return end;

    local t = {};
    local Visible;

    for i = 1, math.huge do;
        local ret,key,value = reaper.EnumProjExtState(0,"IS_RETURN_TRACK",i-1);
        if not ret then break end;

        local track = reaper.BR_GetMediaTrackByGUID(0,key);
        if track then;
            t[#t+1]= track;
            if not Visible then;
                Visible = reaper.IsTrackVisible(track,false);
                if not Visible then;
                    Visible = reaper.IsTrackVisible(track,true);
                end;
            end;
        end;
    end;


    if #t > 0 then;

        reaper.PreventUIRefresh(1);

        for i = 1, #t do;
            if Visible then;
                if TCP then;
                    reaper.SetMediaTrackInfo_Value(t[i],"B_SHOWINTCP",0);
                end;
                if MCP then;
                    reaper.SetMediaTrackInfo_Value(t[i],"B_SHOWINMIXER",0);
                end;
                if TCP or MCP then;
                    reaper.SetMediaTrackInfo_Value(t[i],"I_SELECTED",0);
                end;
            else;
                if TCP then;
                    reaper.SetMediaTrackInfo_Value(t[i],"B_SHOWINTCP",1);
                end;
                if MCP then;
                    reaper.SetMediaTrackInfo_Value(t[i],"B_SHOWINMIXER",1);
                end;
            end;
        end;
        reaper.TrackList_AdjustWindows(false);

        reaper.PreventUIRefresh(-1);
    end;

    no_undo();