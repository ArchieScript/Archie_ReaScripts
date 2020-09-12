--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Select all sent and parent tracks from the selected tracks.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    AlexLazer(Rmm)
   * Gave idea:   AlexLazer(Rmm)
   * Extension:   Reaper 6.12+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   *              ReaPack v.1.2.2 +  http://reapack.com/repos
   * Changelog:   
   *              v.1.0 [120920]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo()return end;

    local
    t = {};

    for i = CountSelTrack-1,0,-1 do;
        local selTrack = reaper.GetSelectedTrack(0,i);
        local NumSend = reaper.GetTrackNumSends(selTrack,0);
        for s = 1, NumSend do;
            local trSend = reaper.GetTrackSendInfo_Value(selTrack,0,s-1,'P_DESTTRACK');
            t[#t+1] = trSend;
        end;
    end;


    for i = CountSelTrack-1,0,-1 do;
        local selTrack = reaper.GetSelectedTrack(0,i);
    
        for i = 1,math.huge do;
            local parTr = reaper.GetMediaTrackInfo_Value(selTrack,'P_PARTRACK');
            if type(parTr)=='userdata' then;
                t[#t+1] = parTr;
                selTrack = parTr;
            else;
                break;
            end;
        end;
    end;


    if #t>0 then;
        reaper.Undo_BeginBlock();
        reaper.PreventUIRefresh(1);
    end;

    for i = 1,#t do;
        reaper.SetMediaTrackInfo_Value(t[i],'I_SELECTED',1);
    end


    if #t>0 then;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Select all sent and parent tracks from the selected tracks', -1);
    else;
        no_undo();
    end;
    