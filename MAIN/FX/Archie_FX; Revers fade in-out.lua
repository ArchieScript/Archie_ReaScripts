--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Fx
   * Description: Fx; Revers fade in-out.lua
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.12+ http://www.reaper.fm/
   * Changelog:   v.1.0 [20.07.20]
   *                  + initialе
--]]
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
        local SelItem  = reaper.GetSelectedMediaItem(0,i-1);
        local fadeIn   = reaper.GetMediaItemInfo_Value(SelItem,"D_FADEINLEN"   );
        local shapeIn  = reaper.GetMediaItemInfo_Value(SelItem,"C_FADEINSHAPE" );
        local fadeOut  = reaper.GetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN"  );
        local shapeOut = reaper.GetMediaItemInfo_Value(SelItem,"C_FADEOUTSHAPE");
        reaper.SetMediaItemInfo_Value(SelItem,"D_FADEINLEN"   ,fadeOut );
        reaper.SetMediaItemInfo_Value(SelItem,"C_FADEINSHAPE" ,shapeOut);
        reaper.SetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN"  ,fadeIn  );
        reaper.SetMediaItemInfo_Value(SelItem,"C_FADEOUTSHAPE",shapeIn );
    end;

    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("Revers fade in-out",-1);

    reaper.UpdateArrange();




