--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Copy track color
   * Author:      Archie
   * Version:     1.02
   * Описание:    Копировать цвет дорожки
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   * Changelog:
   *              v.1.0 [030320]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================

    local TOOLTIP = true;

    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------



    local SelTrack = reaper.GetSelectedTrack(0,0);
    if not SelTrack then no_undo() return end;


    local HasExtState = reaper.HasExtState("Archie_Track_CopyPasteFSCOLOR_TRACK","COLOR_TRACK");
    if HasExtState then;
        reaper.DeleteExtState("Archie_Track_CopyPasteFSCOLOR_TRACK","COLOR_TRACK",false);
    end;

    local Color = reaper.GetMediaTrackInfo_Value(SelTrack,'I_CUSTOMCOLOR');

    reaper.SetExtState("Archie_Track_CopyPasteFSCOLOR_TRACK","COLOR_TRACK",Color,false);

    if TOOLTIP then;
        local x, y = reaper.GetMousePosition();
        local numb = string.match(reaper.GetMediaTrackInfo_Value(SelTrack,'IP_TRACKNUMBER'),'%d+');
        reaper.TrackCtl_SetToolTip('Copy Track '..'('..numb..')'..' Color',x, y,true);
    end;

    no_undo();

