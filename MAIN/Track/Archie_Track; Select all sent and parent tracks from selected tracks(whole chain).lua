--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Select all sent and parent tracks from selected tracks(whole chain).lua
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
    
    
    for i2 = 1,math.huge do;
        local CountSelTrackTotal = reaper.CountSelectedTracks(0);
       
        ----------------------------------------------
        for i = 1,math.huge do;
            local Repeat;
            local CountSelTrack = reaper.CountSelectedTracks(0);
            for i = 1,CountSelTrack do;
                local trackSel = reaper.GetSelectedTrack(0,i-1);
                local parTr = reaper.GetMediaTrackInfo_Value(trackSel,'P_PARTRACK');
                if type(parTr)=='userdata' then;
                    local sel = reaper.GetMediaTrackInfo_Value(parTr,'I_SELECTED');
                    if sel <= 0 then;
                        ----
                        if not UNDO then;
                            reaper.Undo_BeginBlock();
                            reaper.PreventUIRefresh(1);
                            UNDO = true;
                        end;
                        ----
                        reaper.SetMediaTrackInfo_Value(parTr,'I_SELECTED',1);
                        Repeat = true;
                        break;
                    end;
                end;
            end;
            if not Repeat then break end;
        end;
        ----------------------------------------------
       
        ----------------------------------------------
        for i = 1,math.huge do;
            local Repeat;
            local CountSelTrack = reaper.CountSelectedTracks(0);
            for i = 1,CountSelTrack do;
                local trackSel = reaper.GetSelectedTrack(0,i-1);
                local NumSend = reaper.GetTrackNumSends(trackSel,0);
                for s = 1, NumSend do;
                    local trSend = reaper.GetTrackSendInfo_Value(trackSel,0,s-1,'P_DESTTRACK');
                    local sel = reaper.GetMediaTrackInfo_Value(trSend,'I_SELECTED');
                    if sel <= 0 then;
                        ----
                        if not UNDO then;
                            reaper.Undo_BeginBlock();
                            reaper.PreventUIRefresh(1);
                            UNDO = true;
                        end;
                        ----
                        reaper.SetMediaTrackInfo_Value(trSend,'I_SELECTED',1);
                        Repeat = true;
                    end;
                end;
                if Repeat then break end;
            end;
            if not Repeat then break end;
        end;
        ----------------------------------------------
       
        local CountSelTrackCheck = reaper.CountSelectedTracks(0);
        if CountSelTrackCheck == CountSelTrackTotal then break end;
    end;
    
    
    if UNDO then;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Select all sent and parent tracks from selected tracks(whole chain)', -1);
    else;
        no_undo();
    end;
        
    
    
    