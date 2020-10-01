--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item; Select items in selected tracks from cursor to end of project.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    babag(cocos forum)
   * Gave idea:   babag(cocos forum)
   * Extension:   Reaper 6.14+ http://www.reaper.fm/
   * Changelog:   v.1.0 [011020]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
     
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local CountSelTracks = reaper.CountSelectedTracks(0);
    if CountSelTracks == 0 then no_undo()return end;
    
    
    local cur = reaper.GetCursorPosition();
    local ProjectLength = reaper.GetProjectLength(0);
    if cur >= ProjectLength then no_undo()return end;
    
    
    local UNDO;
    for i = 1,CountSelTracks do;
        
        local track = reaper.GetSelectedTrack(0,i-1);
        local CountTrItems = reaper.CountTrackMediaItems(track);
        
        for ii = 1,CountTrItems do;
            
            item = reaper.GetTrackMediaItem(track,ii-1);
            local it_pos = reaper.GetMediaItemInfo_Value(item,'D_POSITION');
            local it_len = reaper.GetMediaItemInfo_Value(item,'D_LENGTH');
            if it_pos+it_len > cur then;
                if not UNDO then;
                    reaper.Undo_BeginBlock()reaper.PreventUIRefresh(1);
                    UNDO = true;
                end;
                reaper.SetMediaItemSelected(item,true);
                reaper.UpdateItemInProject(item);
            end;
        end;
    end;
    
    
    
    if UNDO then;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Select items in selected tracks from cursor to end of project',-1);
    else;
        no_undo();
    end;
    