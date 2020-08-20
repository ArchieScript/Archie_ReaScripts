--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Fx
   * Description: Enlarge fade by 100 ms
   * Author:      Archie
   * Version:     1.02
   * Описание:    Увеличить затухание на 100 мс
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


    local EnlargeOn = 100  -- ms


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------



    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;


    EnlargeOn = EnlargeOn/1000;
    for i = 1,CountSelItem do;
        local SelItem = reaper.GetSelectedMediaItem(0,i-1);
        local len = reaper.GetMediaItemInfo_Value(SelItem,"D_LENGTH");
        local fadeIn = reaper.GetMediaItemInfo_Value(SelItem,"D_FADEINLEN");
        local fadeOut = reaper.GetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN");
        if (len - fadeOut) >= fadeIn+EnlargeOn then;
            reaper.SetMediaItemInfo_Value(SelItem,"D_FADEINLEN",fadeIn+EnlargeOn);
            if not Undo then; reaper.Undo_BeginBlock();reaper.PreventUIRefresh(1); Undo = true; end;
        end;
        if (len - fadeIn) >= fadeOut+EnlargeOn then;
            reaper.SetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN",fadeOut+EnlargeOn);
        end;
        reaper.UpdateItemInProject(SelItem);
    end;


    if Undo then;
        reaper.Undo_EndBlock("Enlarge fade by 100 ms",-1);
        reaper.PreventUIRefresh(-1);
    else;
        no_undo();
    end;

    reaper.UpdateArrange();