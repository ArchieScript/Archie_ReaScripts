--[[
   * Category:    Item
   * Description: Unselect all items to left of time selection
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Unselect all items to left of time selection
   * О скрипте:   Отменить выбор всех элементов слева от выбора времени
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    HDVulcan[RMM]
   * Gave idea:   HDVulcan[RMM]
   * Changelog:
   *              +  initialе / v.1.0 [01042019]


   -- Тест только на windows  /  Test only on windows.
   --========================================================================================
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\
   ----------------------------------------------------------------------------------------||
    ˅ - (+) - обязательно для установки / (-) - не обязательно для установки               ||
      -------------------------------------------------------------------------------------||
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                    ||
   (-) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php               ||
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                             ||
   (-) Arc_Function_lua v.2.3.1 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc ||
   (-) reaper_js_ReaScriptAPI     --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr ||
                                                                    http://clck.ru/Eo5Lw   ||
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                ||
      -------------------------------------------------------------------------------------||
    ˄ - (+) - required for installation / (-) - not necessary for installation             ||
   ----------------------------------------------------------------------------------------||
   --\\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: /////
   ========================================================================================]]





    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================




    local Split_Item_TimeSel = 0
                          -- = 0 Не разрезать элементы по выбору времени
                          -- = 1 Разрезать элементы по выбору времени
                                 ------------------------------------
                          -- = 0 Not split items in time selection
                          -- = 1 Split items in time selection
                          ------------------------------------




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    ---------------------------------------------------------
    local function no_undo();reaper.defer(function()end);end;
    ---------------------------------------------------------



    local StartTimeSel, EndTimeSel = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    if StartTimeSel == EndTimeSel then no_undo() return end;


    local CountSelItem = reaper.CountSelectedMediaItems(0)
    if CountSelItem == 0 then no_undo() return end;


    if Split_Item_TimeSel == 1 then;
        for i = CountSelItem-1,0,-1 do;
            local SelItem = reaper.GetSelectedMediaItem(0,i);
            local PosIt = reaper.GetMediaItemInfo_Value(SelItem,"D_POSITION");
            local EndIt = PosIt + reaper.GetMediaItemInfo_Value(SelItem,"D_LENGTH");

            if EndIt > EndTimeSel and PosIt < EndTimeSel then;
                reaper.SplitMediaItem(SelItem,EndTimeSel);
                if not Undo then reaper.Undo_BeginBlock()Undo = 1 end;
            end;
            if PosIt < StartTimeSel and EndIt > StartTimeSel then;
                reaper.SplitMediaItem(SelItem,StartTimeSel);
                if not Undo then reaper.Undo_BeginBlock()Undo = 1 end;
            end;
        end;
    end;



    for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do;
        local SelItem = reaper.GetSelectedMediaItem(0,i);
        local PosIt = reaper.GetMediaItemInfo_Value(SelItem,"D_POSITION");
        if PosIt < StartTimeSel then;
            reaper.SetMediaItemInfo_Value(SelItem,"B_UISEL",0);
            if not Undo then reaper.Undo_BeginBlock()Undo = 1 end;
        end;
    end;

    if Undo then;
        reaper.Undo_EndBlock("Unselect all items to left of time selection",-1);
    else;
        no_undo();
    end;
    reaper.UpdateArrange();