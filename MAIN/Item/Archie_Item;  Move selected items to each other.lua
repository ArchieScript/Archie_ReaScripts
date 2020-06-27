--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item;  Move selected items to each other.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    daxliniere(cocos forum)
   * Gave idea:   daxliniere(cocos forum)http://forum.cockos.com/showpost.php?p=2310449&postcount=1
   * Provides:
   * Extension:   Reaper 6.12+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [270620]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    ---------------------------------------------------------
    local function no_undo();reaper.defer(function()end);end;
    ---------------------------------------------------------
    
    
    local count_sel_Item = reaper.CountSelectedMediaItems(0);
    if count_sel_Item == 0 then no_undo()return end;
    
    local movePoint = reaper.GetToggleCommandStateEx(0,40070);--Env points move with media items
    
    local t = {};
    local tbl = {}
    local item2,pos2,track2,len2,UNDO;
    
    reaper.PreventUIRefresh(1);
    
    for i = 1, count_sel_Item do;
        local item = reaper.GetSelectedMediaItem(0,i-1);
        local pos = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
        local len = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
        local track = reaper.GetMediaItem_Track(item);
        ----
        tbl[#tbl+1] = item;
        ----
        if track2 and track2 == track then;
            if pos > pos2+len then;
                pos = pos2+len2;
                --- 
                if movePoint == 0 then;
                    ----
                    reaper.SetMediaItemInfo_Value(item,"D_POSITION",pos);
                    ----
                elseif movePoint == 1 then;
                    ----
                    t[#t+1]       = {};
                    t[#t  ].item  = item;
                    t[#t  ].pos   = pos;
                    t[#t  ].len   = len;
                    t[#t  ].track = track;
                end;
                ----
                if not UNDO then;
                    reaper.Undo_BeginBlock(); 
                    UNDO = true;
                end;
                ----
            end;
        end;
        ----
        item2  = item;
        pos2   = pos;
        track2 = track;
        len2   = len;
    end;
    
    
    if movePoint == 1 and #t > 0 and #tbl > 0 then;
        local Cur = reaper.GetCursorPosition();
        reaper.SelectAllMediaItems(0,0);
        for i = 1, #t do;
            reaper.SetMediaItemInfo_Value(t[i].item,"B_UISEL",1);
            reaper.SetEditCurPos(t[i].pos,false,false);
            reaper.Main_OnCommand(41205,0);--Move position of item to edit cursor
            reaper.SetMediaItemInfo_Value(t[i].item,"B_UISEL",0);
        end;
        reaper.SetEditCurPos(Cur,false,false);
        ----
        for i = 1, #tbl do;
            reaper.SetMediaItemInfo_Value(tbl[i],"B_UISEL",1);
        end;
    end;
    
    reaper.PreventUIRefresh(-1);
    
    if UNDO then;
        reaper.Undo_EndBlock('Move selected items to each other',-1);
    else;
        no_undo();
    end;
    
    reaper.UpdateArrange();
    
    
    