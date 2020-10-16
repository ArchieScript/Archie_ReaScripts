--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item; Select items under edit cursor in selected tracks.lua
   * Author:      Archie
   * Version:     1.02
   * AboutScript: ---
   * О скрипте:   ---
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Provides:    [main=main,midi_editor] .
   * Customer:    BRG(Rmm)
   * Gave idea:   BRG(Rmm)
   * Provides:
   * Extension:   Reaper 6.14+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [161020]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
     
     
    ---------------------------------------------------------
    local function no_undo();reaper.defer(function()end);end;
    ---------------------------------------------------------
     
    
    local CountSelTracks = reaper.CountSelectedTracks(0);
    if CountSelTracks == 0 then no_undo()return end;
    
    local Cur = reaper.GetCursorPosition();
    
    
    local UNDO;
    for i = 1,CountSelTracks do;
        local SelTrack = reaper.GetSelectedTrack(0,i-1);
        local CountTrItems = reaper.CountTrackMediaItems(SelTrack);
        for ii = 1,CountTrItems do;
            local item = reaper.GetTrackMediaItem(SelTrack,ii-1);
            local pos = reaper.GetMediaItemInfo_Value(item,'D_POSITION');
            local len = reaper.GetMediaItemInfo_Value(item,'D_LENGTH');
            if pos <= Cur and pos+len > Cur then;
                if not UNDO then;
                    reaper.Undo_BeginBlock();
                    reaper.PreventUIRefresh(1);
                    reaper.SelectAllMediaItems(0,0);
                    UNDO = true;
                end;
                reaper.SetMediaItemInfo_Value(item,'B_UISEL',1);
            end;
        end;
    end;
    
    if UNDO then;
        reaper.UpdateArrange();
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Select items under edit cursor in selected tracks',-1);
    else;
        no_undo();
    end;
    
    
    