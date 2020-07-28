--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Toggle Monitoring track exclusive.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Maestro Sound(rmm)
   * Gave idea:   Maestro Sound(rmm)
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [040620]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
     
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;
    
    
    local mntrng = 0;
    for i = 1,CountSelTrack do;
        local track_sel = reaper.GetSelectedTrack(0,i-1);
        local mon = reaper.GetMediaTrackInfo_Value(track_sel,'I_RECMON');
        if mon == 0 then;
            mntrng = 1;
            break;
        end;
    end;
    
    
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    
    for i = 1, reaper.CountTracks(0) do;
        local Track = reaper.GetTrack(0,i-1);
        local sel = reaper.GetMediaTrackInfo_Value(Track,'I_SELECTED')==1;
        if sel then;
            reaper.SetMediaTrackInfo_Value(Track,'I_RECMON',mntrng);
        else;
            reaper.SetMediaTrackInfo_Value(Track,'I_RECMON',0);
        end;
    end;
    
    local Title;
    if mntrng == 1 then;
        Title = 'Monitoring ON track exclusive';
    else;
        Title = 'Monitoring OFF track exclusive';
    end;
    
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock(Title,-1);
    
    
    
    