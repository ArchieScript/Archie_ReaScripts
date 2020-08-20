--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Invert items selection on selected tracks
   * Author:      Archie
   * Version:     1.02
   * Описание:    Инвертировать выделение элементов на выбранных дорожках
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    arkaine(Rmm)
   * Gave idea:   arkaine(Rmm)
   * Changelog:
   *              v.1.0 [22.10.19]
   *                  + initialе
--]]


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================


    --------------------------------------------------------
    local function no_undo() reaper.defer(function()end)end;
    --------------------------------------------------------

    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;

    local Undo;

    for t = 1, CountSelTrack do;

        local track = reaper.GetSelectedTrack(0,t-1);
        local CountTrItem = reaper.CountTrackMediaItems(track);
        if CountTrItem > 0 and not Undo then;
            reaper.Undo_BeginBlock();Undo = true;
        end;

        for i = CountTrItem-1,0,-1 do;
            local item = reaper.GetTrackMediaItem(track,i);
            reaper.SetMediaItemSelected(item, not reaper.IsMediaItemSelected(item));
        end;
    end;


    if Undo then;
        reaper.Undo_EndBlock("Invert items selection on selected tracks",-1);
    else;
        no_undo();
    end;
    reaper.UpdateArrange();