--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:
   * Description: Toggle (Loop source OFF) - (SWS Loop section of selected item(s))
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.01+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   v.1.0 [27.01.20]
   *                  + initialе
--]]


    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local ToolTip = true;


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------



    local item_cnt = reaper.CountSelectedMediaItems(0);
    if item_cnt == 0 then no_undo()return end;


    local itemSelFirst = reaper.GetSelectedMediaItem(0,0);
    local item_loop = reaper.GetMediaItemInfo_Value(itemSelFirst,"B_LOOPSRC");

    local Tip;
    if item_loop == 1 then;
        reaper.Undo_BeginBlock();
        for i = 1,item_cnt do;
            local itemSel = reaper.GetSelectedMediaItem(0,i-1);
            reaper.SetMediaItemInfo_Value(itemSel,"B_LOOPSRC",0);
            reaper.UpdateItemInProject(itemSel);
        end;
        reaper.Undo_EndBlock('Loop source OFF',-1);
        Tip = 'Loop source OFF';
    else;
        reaper.Main_OnCommand(reaper.NamedCommandLookup('_SWS_LOOPITEMSECTION'),0);
        -- SWS: Loop section of selected item(s)
        Tip = 'SWS: Loop section of selected item(s)';
    end;

    reaper.UpdateArrange();


    if ToolTip == true then;
        local x, y = reaper.GetMousePosition();
        reaper.TrackCtl_SetToolTip(Tip,x+20,y-20,0);
    end;