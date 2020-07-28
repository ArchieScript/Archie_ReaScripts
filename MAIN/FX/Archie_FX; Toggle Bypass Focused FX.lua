--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Fx
   * Description: Fx; Toggle Bypass Focused FX.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Mr. Green/tdc(forum cocos)
   * Gave idea:   Mr. Green/tdc(forum cocos)
   * Extension:   Reaper 6.08+ http://www.reaper.fm/
   *              SWS v.2.11.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [090420]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    local retval,tracknumber,itemnumber,fxnumber = reaper.GetFocusedFX();
    if retval > 0 then;
        reaper.PreventUIRefresh(1);
        reaper.Undo_BeginBlock();
        if itemnumber >= 0 then;
            local track = reaper.GetTrack(0,tracknumber-1);
            local item = reaper.GetTrackMediaItem(track,itemnumber);
            local takeIdx = fxnumber>>16;--take
            local fxIdx   = fxnumber&0xFFFF;--fx
            local take = reaper.GetTake(item,takeIdx);
            local enabled = reaper.TakeFX_GetEnabled(take,fxIdx);
            reaper.TakeFX_SetEnabled(take,fxIdx,enabled==false);
        else;
            local track;
            if tracknumber == 0 then;
                track = reaper.GetMasterTrack(0);
            else;
                track = reaper.GetTrack(0,tracknumber-1);
            end;
            local enabled = reaper.TrackFX_GetEnabled(track,fxnumber);
            reaper.TrackFX_SetEnabled(track,fxnumber,enabled==false);     
        end;
        reaper.UpdateArrange();
        reaper.Undo_EndBlock("Toggle Bypass Focused FX",-1);
    else;
        reaper.defer(function()end); 
    end;
    
    
    