--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Fx
   * Description: Reduce fade by 100 ms
   * Author:      Archie
   * Version:     1.02
   * Описание:    Уменьшить затухание на 100 мс
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.01+ http://www.reaper.fm/
   * Changelog:   v.1.0 [12.12.19]
   *                  + initialе
--]]

    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local ReduceOn = 100  -- ms


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------



    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;

    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);

    for i = 1,CountSelItem do;
        local SelItem = reaper.GetSelectedMediaItem(0,i-1);
        local fadeIn = reaper.GetMediaItemInfo_Value(SelItem,"D_FADEINLEN");
        fadeIn = fadeIn-(ReduceOn/1000);
        if fadeIn < 0 then fadeIn = 0 end;
        reaper.SetMediaItemInfo_Value(SelItem,"D_FADEINLEN",fadeIn);
        local fadeOut = reaper.GetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN");
        fadeOut = fadeOut-(ReduceOn/1000);
        if fadeOut < 0 then fadeOut = 0 end;
        reaper.SetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN",fadeOut);
        reaper.UpdateItemInProject(SelItem);
    end;

    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("Reduce fade by 100 ms",-1);

    reaper.UpdateArrange();