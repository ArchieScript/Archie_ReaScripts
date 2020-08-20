--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Description: Take; Copy active take to new items at time selection
   * Author:      Archie
   * Version:     1.02
   * Описание:    Копировать активный дубль в новые элементы при выборе времени
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    odinzavseh(Rmm)
   * Gave idea:   odinzavseh(Rmm)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [19.02.20]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local New_Items_Selected = true -- true/false

    local Previous_Items_Selected = true -- true/false


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================


    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;


    local timeSelStart,timeSelEnd = reaper.GetSet_LoopTimeRange(0,0,0,0,0); -- В Аранже
    if timeSelStart == timeSelEnd then no_undo() return end;


    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);


    local t = {};
    for i = 1,CountSelItem do;
        local itemSel = reaper.GetSelectedMediaItem(0,i-1);
        local posIt = reaper.GetMediaItemInfo_Value(itemSel,'D_POSITION');
        local lenIt = reaper.GetMediaItemInfo_Value(itemSel,'D_LENGTH');
        if posIt+lenIt<=timeSelStart or posIt>=timeSelEnd then;
            t[#t+1] = itemSel;
        else;
            t[-1] = true;
        end;
    end;


    if t[-1] ~= true then no_undo() return end;

    --save prev--
    local SVTr={};
    if Previous_Items_Selected == true then;
        for i = 1,reaper.CountSelectedMediaItems(0)do;
            SVTr[i]=reaper.GetSelectedMediaItem(0,i-1);
        end;
    end;
    -------------

    for i = 1,#t do;
        reaper.SetMediaItemInfo_Value(t[i],'B_UISEL',0);
    end;


    local itemNewT={};
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    for i = CountSelItem-1,0,-1 do;
        local itemSel = reaper.GetSelectedMediaItem(0,i);
        local _, itChunk = reaper.GetItemStateChunk(itemSel,'',false);
        itChunk = itChunk:gsub('POOLEDEVTS {.-}','POOLEDEVTS '..reaper.genGuid());
        local track = reaper.GetMediaItem_Track(itemSel);
        local itemNew = reaper.AddMediaItemToTrack(track);
        reaper.SetItemStateChunk(itemNew,itChunk,false);
        itemNewT[#itemNewT+1]=itemNew;
        reaper.SetMediaItemInfo_Value(itemNew,'B_UISEL',0);
        reaper.SetMediaItemInfo_Value(itemSel,'B_UISEL',0);
        -----
        local posIt = reaper.GetMediaItemInfo_Value(itemNew,'D_POSITION');
        local lenIt = reaper.GetMediaItemInfo_Value(itemNew,'D_LENGTH');
        local Edges,EdgLen;
        if posIt<timeSelStart then Edges=timeSelStart else Edges=posIt end;
        if posIt+lenIt>timeSelEnd then EdgLen=timeSelEnd else EdgLen=posIt+lenIt end;
        reaper.BR_SetItemEdges(itemNew,Edges,EdgLen);
        ---
        reaper.SetMediaItemInfo_Value(itemNew,'I_CUSTOMCOLOR',0x0037FF7A|0x1000000);
        ---
    end;


    for i = 1,#itemNewT do;
        reaper.SetMediaItemInfo_Value(itemNewT[i],'B_UISEL',1);
    end;

    reaper.Main_OnCommand(40131,0); -- Crop act take


    if New_Items_Selected ~= true then;
        reaper.SelectAllMediaItems(0,0);
    end;

    --rest prev--
    if Previous_Items_Selected == true then;
        for i = 1,#SVTr do;
            reaper.SetMediaItemInfo_Value(SVTr[i],'B_UISEL',1);
        end;
    end;
    -------------


    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock('Copy active take to new items at time selection',-1);
    reaper.UpdateArrange();


