--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Remove items outside time selection in selected track
   * Author:      Archie
   * Version:     1.0
   * Описание:    Удаление элементов вне времени выбора в выбранном треке
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    arkaine(Rmm)
   * Gave idea:   arkaine(Rmm)
   * Changelog:   
   *              v.1.0 [22.10.19]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    --------------------------------------------------------
    local function no_undo() reaper.defer(function()end)end;
    --------------------------------------------------------
    
    
    local startTSel,endTSel = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    if startTSel == endTSel then no_undo() return end;
    
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;
    
    reaper.Undo_BeginBlock();
    
    for t = 1, CountSelTrack do;
        local track = reaper.GetSelectedTrack(0,t-1);
    
        -----
        local CountTrItem = reaper.CountTrackMediaItems(track);
        for i = CountTrItem-1,0,-1 do;
            
            local item  = reaper.GetTrackMediaItem(track,i);
            local posIt = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
            local lenIt = reaper.GetMediaItemInfo_Value(item, "D_LENGTH");
            
            if posIt+lenIt>endTSel and posIt<endTSel then;
                local it = reaper.SplitMediaItem(item,endTSel);
                if it then reaper.DeleteTrackMediaItem(track,it)end;
            end;
            
            if posIt<startTSel and posIt+lenIt>startTSel then;
                reaper.SplitMediaItem(item,startTSel);
                reaper.DeleteTrackMediaItem(track,item);
            end;
            
            if posIt>endTSel or posIt+lenIt<startTSel then;
                reaper.DeleteTrackMediaItem(track,item);
            end;  
        end;
        -----
    end;
    
    reaper.Undo_EndBlock("Remove items outside time selection in selected track",-1);
    reaper.UpdateArrange();