--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Duplicate selected area of items back
   * Author:      Archie
   * Version:     1.02
   * Описание:    Дублировать выделенную область элементов обратно
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Ильмир Азгамов(VK)
   * Gave idea:   Ильмир Азгамов(VK)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [13.02.20]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local EditCursor = 0
                  -- = 0 | Оставить на месте
                  -- = 1 | Переместить в начало выбранной области
                  -- = 2 | Переместить в конец выбранной области


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local timeSelStart,timeSelEnd = reaper.GetSet_LoopTimeRange(0,0,0,0,0);--В Ар
    if timeSelStart == timeSelEnd then no_undo()return end;

    if timeSelStart < (timeSelEnd-timeSelStart)then no_undo() return end;

    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;

    local CurPos = reaper.GetCursorPosition();

    local tIt={};
    for i = 1,CountSelItem do;
        local itemSel = reaper.GetSelectedMediaItem(0,i-1);
        local posIt = reaper.GetMediaItemInfo_Value(itemSel,"D_POSITION");
        local lenIt = reaper.GetMediaItemInfo_Value(itemSel,"D_LENGTH");
        tIt[i]={};
        tIt[i].item = itemSel;
        tIt[i].posI = posIt;
        tIt[i].lenI = lenIt;
        if posIt < timeSelEnd and (posIt+lenIt) > timeSelStart then;
            tIt[1].found = true;
        end;
    end;

    if tIt[1].found ~= true then no_undo() return end;

    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);

    local GetCurCont = reaper.GetCursorContext2(true);

    for i = 1,#tIt do;
        if tIt[i].posI+tIt[i].lenI<timeSelStart or tIt[i].posI>timeSelEnd then;
            reaper.SetMediaItemInfo_Value(tIt[i].item,"B_UISEL",0);
        end;
    end;

    local trackSelT = {};
    for i = reaper.CountSelectedTracks(0)-1,0,-1 do;
        local tr = reaper.GetSelectedTrack(0,i);
        table.insert(trackSelT,tr);
        reaper.SetMediaTrackInfo_Value(tr,'I_SELECTED',0);
    end;

    reaper.SetCursorContext(1,'');

    reaper.Main_OnCommand(41383,0);--Copy items/tracks/envelope points (depending on focus)

    local time = timeSelStart-(timeSelEnd-timeSelStart);
    reaper.SetEditCurPos(time,true,false);

    reaper.GetSet_LoopTimeRange(1,0,time,timeSelStart,0);

    local itSelFirst = reaper.GetSelectedMediaItem(0,0);
    local tr = reaper.GetMediaItem_Track(itSelFirst);
    reaper.SetMediaTrackInfo_Value(tr,'I_SELECTED',1);
    reaper.Main_OnCommand(40914,0);--Set first sel tr last touched track

    reaper.Main_OnCommand(40058,0);--Paste items/tracks

    reaper.Main_OnCommand(40297,0);-- Unselect all tracks

    for i = 1,#trackSelT do;
        reaper.SetMediaTrackInfo_Value(trackSelT[i],'I_SELECTED',1);
    end;


    if EditCursor == 1 then;
        reaper.SetEditCurPos(time,false,false);
    elseif EditCursor == 2 then;
        reaper.SetEditCurPos(timeSelStart,false,false);
    else;
        reaper.SetEditCurPos(CurPos,false,false);
    end;

    if GetCurCont ~= 1 then;
        reaper.SetCursorContext(GetCurCont,'');
    end;

    reaper.PreventUIRefresh(-1);

    reaper.Undo_EndBlock("Duplicate selected area of items back",-1);
    reaper.UpdateArrange();



