--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item; Unselect all items except first selected in track
   * Author:      Archie
   * Version:     1.02
   * Описание:    Отменить выбор всех элементов, кроме первого выбранного в треке
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Maxim Kokarev(VK)
   * Gave idea:   Maxim Kokarev(VK)
   * Extension:   Reaper 6.04+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [050320]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local TIME_SELECTION = false;
                     --  = true;  | Учитывать выбор времени
                     --  = false; | Игнорировать выбор времени
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;
    
    
    
    local t = {};
    local tblTrack = {};
    for i = 1, CountSelItem do;
        local item = reaper.GetSelectedMediaItem(0,i-1);
        local track = reaper.GetMediaItem_Track(item);
        if not t[tostring(track)]then;
            t[tostring(track)] = track;
            tblTrack[#tblTrack+1] = track;
        end;
    end;
    
    local UNDO;
    local timeSelStart,timeSelEnd = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    if TIME_SELECTION ~= true then timeSelStart = timeSelEnd end;
    
    if timeSelStart == timeSelEnd then;
        ----
        for i = 1, #tblTrack do;
            
            local unsel,sel;
            
            local CountTrItem = reaper.CountTrackMediaItems(tblTrack[i]);
            for it = 1, CountTrItem do;
                
                local itemTr = reaper.GetTrackMediaItem(tblTrack[i],it-1);
                
                if unsel then;
                    reaper.SetMediaItemInfo_Value(itemTr,'B_UISEL',0);
                    if not UNDO then;
                        reaper.Undo_BeginBlock();
                        reaper.PreventUIRefresh(1);
                        UNDO = true;
                    end;
                else;
                    sel = reaper.IsMediaItemSelected(itemTr);
                end;
                
                if sel then;
                    unsel = true;
                end;
            end;
        end;
        ----
    else;
        ----
        for i = 1, #tblTrack do;
            
            local unsel,sel;
            
            local CountTrItem = reaper.CountTrackMediaItems(tblTrack[i]);
            for it = 1, CountTrItem do;
                
                local itemTr = reaper.GetTrackMediaItem(tblTrack[i],it-1);
                local posIt = reaper.GetMediaItemInfo_Value(itemTr,'D_POSITION');
                local lenIt = reaper.GetMediaItemInfo_Value(itemTr,'D_LENGTH');
                
                if posIt < timeSelEnd and posIt+lenIt > timeSelStart then;
                    if unsel then;
                        reaper.SetMediaItemInfo_Value(itemTr,'B_UISEL',0);
                        if not UNDO then;
                            reaper.Undo_BeginBlock();
                            reaper.PreventUIRefresh(1);
                            UNDO = true;
                        end;
                    else;
                        sel = reaper.IsMediaItemSelected(itemTr);
                    end;
                    
                    if sel then;
                        unsel = true;
                    end;
                end;
                
                if posIt >= timeSelEnd then break end; 
            end;
        end;
        ----
    end;
    
    
    if UNDO then;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock("Unselect all items except first selected in track",-1);
    else;
        no_undo();
    end;
    
    reaper.UpdateArrange();
    
    