--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Unselect items if track not selected
   * Author:      Archie
   * Version:     1.02
   * Описание:    Отменить выбор элементов если трек не выбран
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    J T(Rmm)
   * Gave idea:   J T(Rmm)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   * Changelog:   v.1.0 [29.01.20]
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

    for i = CountSelItem-1,0,-1 do;

        local SelItem = reaper.GetSelectedMediaItem(0,i);
        local track = reaper.GetMediaItem_Track(SelItem);
        local sel_tr = reaper.GetMediaTrackInfo_Value(track,'I_SELECTED');
        if sel_tr == 0 then;
            reaper.SetMediaItemInfo_Value(SelItem,"B_UISEL",0);
        end;
    end;

    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock('Unselect items if track not selected',-1);

    reaper.UpdateArrange();