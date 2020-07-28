--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item; Remove last selected item in tracks
   * Author:      Archie
   * Version:     1.0
   * Описание:    Удалить последний выбранный элемент в треках
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
            
            local CountTrItem = reaper.CountTrackMediaItems(tblTrack[i]);
            for it = CountTrItem-1,0,-1 do;
                
                local itemTr = reaper.GetTrackMediaItem(tblTrack[i],it);
                local sel = reaper.IsMediaItemSelected(itemTr);
                if sel then;
                    local Del = reaper.DeleteTrackMediaItem(tblTrack[i],itemTr);
                    if not UNDO and Del then;
                        reaper.Undo_BeginBlock();
                        reaper.PreventUIRefresh(1);
                        UNDO = true;
                    end;
                    break;
                end;  
            end;
        end;
        ----
    else;
        ----
        for i = 1, #tblTrack do;
            
            local unsel,sel;
            
            local CountTrItem = reaper.CountTrackMediaItems(tblTrack[i]);
            for it = CountTrItem-1,0,-1 do;
                
                local itemTr = reaper.GetTrackMediaItem(tblTrack[i],it);
                local posIt = reaper.GetMediaItemInfo_Value(itemTr,'D_POSITION');
                
                if posIt < timeSelEnd and posIt >= timeSelStart then;
                    
                    local sel = reaper.IsMediaItemSelected(itemTr);
                    if sel then;
                        local Del = reaper.DeleteTrackMediaItem(tblTrack[i],itemTr);
                        if not UNDO and Del then;
                            reaper.Undo_BeginBlock();
                            reaper.PreventUIRefresh(1);
                            UNDO = true;
                        end;
                        break;
                    end;
                    
                end;
                
                if posIt < timeSelStart then break end;
            end;
        end;
        ----
    end;
    
    
    if UNDO then;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock("Remove last selected item in tracks",-1);
    else;
        no_undo();
    end;
    
    reaper.UpdateArrange();
    
    
    
    