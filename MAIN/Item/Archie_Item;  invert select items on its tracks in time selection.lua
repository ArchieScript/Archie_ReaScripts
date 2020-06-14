--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item;  invert select items on its tracks in time selection.lua
   * Author:      Archie
   * Version:     1.02
   * О скрипте:   инвертировать выделенные элементы на своих дорожках во временном выделении
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Dragonetti(cocos Forum) http://forum.cockos.com/showpost.php?p=2303125&postcount=10
   * Gave idea:   Dragonetti(cocos Forum)
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.02 [140620]
   *                  + fixes bug
   
   *              v.1.0 [10620]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local MODE = 0;
            -- = 0; Left: count items by end
            -- = 1; Left: count items by position
                    -----------------------------
            -- = 0; Слева: подсчет предметов по окончанию
            -- = 1; Слева: подсчет предметов по позициям
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    --=====================================================
    local function no_undo()reaper.defer(function()end)end;
    --=====================================================
    
    local timeSelStart,timeSelEnd = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    if timeSelStart==timeSelEnd then no_undo();return end;
    
    local CountSelItems = reaper.CountSelectedMediaItems(0);
    if CountSelItems == 0 then no_undo();return end;
    
    local t = {};
    local tbl = {};
    for i = 1, CountSelItems do;
        local itemSel = reaper.GetSelectedMediaItem(0,i-1);
        local pos = reaper.GetMediaItemInfo_Value(itemSel,"D_POSITION");
        local len = reaper.GetMediaItemInfo_Value(itemSel,"D_LENGTH");
        if MODE == 1 then len = 0.000000001 end;
        if pos < timeSelEnd and pos+len > timeSelStart then;
            local track = reaper.GetMediaItem_Track(itemSel);
            if not t[tostring(track)]then;
                t[tostring(track)]=track;
                tbl[#tbl+1] = track;
            end;
        end;
    end;
    
    
    if #tbl > 0 then;
        
        reaper.PreventUIRefresh(9978458);
        reaper.Undo_BeginBlock();
        
        for i = 1, #tbl do;
            local CountTrackItem = reaper.CountTrackMediaItems(tbl[i]);
            for i2 = 1, CountTrackItem do;
                local item = reaper.GetTrackMediaItem(tbl[i],i2-1);
                local pos = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
                local len = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
                if MODE == 1 then len = 0.000000001 end;
                if pos < timeSelEnd and pos+len > timeSelStart then;
                    local sel = reaper.GetMediaItemInfo_Value(item,"B_UISEL");
                    reaper.SetMediaItemInfo_Value(item,"B_UISEL",math.abs(sel-1));
                elseif pos > timeSelEnd then;
                    break;
                end;
            end;
        end;
        
        reaper.PreventUIRefresh(-9978458);
        reaper.Undo_EndBlock('invert select items on its tracks in time selection',-1);
        reaper.UpdateArrange();
    end;
    
    
    
    