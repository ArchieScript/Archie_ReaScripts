--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Fx
   * Description: Delete fade in selected items
   * Author:      Archie
   * Version:     1.0
   * Описание:    Удалить затухание в выбранных элементах
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.01+ http://www.reaper.fm/
   * Changelog:   v.1.0 [12.12.19]
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


    for i = 1,CountSelItem do;
        local SelItem = reaper.GetSelectedMediaItem(0,i-1);
        local fadeIn = reaper.GetMediaItemInfo_Value(SelItem,"D_FADEINLEN");
        if fadeIn ~= 0 then;
            if not Undo then; reaper.Undo_BeginBlock();reaper.PreventUIRefresh(1); Undo = true; end;
            reaper.SetMediaItemInfo_Value(SelItem,"D_FADEINLEN",0);
        end;
        local fadeOut = reaper.GetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN");
        if fadeOut ~= 0 then;
            if not Undo then; reaper.Undo_BeginBlock();reaper.PreventUIRefresh(1); Undo = true; end;
            reaper.SetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN",0);
        end;
        reaper.UpdateItemInProject(SelItem);
    end;


    if Undo then;
        reaper.Undo_EndBlock("Delete fade in selected items",-1);
        reaper.PreventUIRefresh(-1);
    else;
        no_undo();
    end;

    reaper.UpdateArrange();