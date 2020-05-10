--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Archie
   * Description: UI of all FX in send n of selected tracks.lua
   * Author:      Archie
   * Version:     1.0
   * Описание:    Показать пользовательский интерфейс всех FX в send 1 из выбранных треков
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    YuriOl(Rmm)
   * Gave idea:   YuriOl(Rmm)
   * Provides:
   *              [nomain] .
   *              [main] . > Archie_FX;  Toggle Show UI of all FX in send 1 of selected tracks.lua
   *              [main] . > Archie_FX;  Toggle Show UI of all FX in send 2 of selected tracks.lua
   *              [main] . > Archie_FX;  Toggle Show UI of all FX in send 3 of selected tracks.lua
   *              [main] . > Archie_FX;  Toggle Show UI of all FX in send 4 of selected tracks.lua
   *              [main] . > Archie_FX;  Toggle Show UI of all FX in send 5 of selected tracks.lua
   *              [main] . > Archie_FX;  Toggle Show UI of all FX in send 6 of selected tracks.lua
   *              [main] . > Archie_FX;  Toggle Show UI of all FX in send 7 of selected tracks.lua
   *              [main] . > Archie_FX;  Toggle Show UI of all FX in send 8 of selected tracks.lua
   *              [main] . > Archie_FX;  Show UI of all FX in send 1 of selected tracks.lua
   *              [main] . > Archie_FX;  Show UI of all FX in send 2 of selected tracks.lua
   *              [main] . > Archie_FX;  Show UI of all FX in send 3 of selected tracks.lua
   *              [main] . > Archie_FX;  Show UI of all FX in send 4 of selected tracks.lua
   *              [main] . > Archie_FX;  Show UI of all FX in send 5 of selected tracks.lua
   *              [main] . > Archie_FX;  Show UI of all FX in send 6 of selected tracks.lua
   *              [main] . > Archie_FX;  Show UI of all FX in send 7 of selected tracks.lua
   *              [main] . > Archie_FX;  Show UI of all FX in send 8 of selected tracks.lua
   *              [main] . > Archie_FX;  Hide UI of all FX in send 1 of selected tracks.lua
   *              [main] . > Archie_FX;  Hide UI of all FX in send 2 of selected tracks.lua
   *              [main] . > Archie_FX;  Hide UI of all FX in send 3 of selected tracks.lua
   *              [main] . > Archie_FX;  Hide UI of all FX in send 4 of selected tracks.lua
   *              [main] . > Archie_FX;  Hide UI of all FX in send 5 of selected tracks.lua
   *              [main] . > Archie_FX;  Hide UI of all FX in send 6 of selected tracks.lua
   *              [main] . > Archie_FX;  Hide UI of all FX in send 7 of selected tracks.lua
   *              [main] . > Archie_FX;  Hide UI of all FX in send 8 of selected tracks.lua
   * Extension:   Reaper 6.09+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.0 [100520]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --====================================================================================== 
    
    
    
    local scrName = debug.getinfo(1,"S").source:match('.+[/\\](.+)');
    local send_idx = scrName:match('^Archie_FX;%s-[Toggle Show Hide]* UI of all FX in send (%d+) of selected tracks.lua$');
    local showHide = (scrName:match('^Archie_FX;%s-(%S+)')or''):upper();
    if showHide == 'HIDE' then showHide = 0 end;
    if showHide == 'SHOW' then showHide = 1 end;
    showHide = tonumber(showHide);
    
    
    local function showUIOfAllFXInSend_n_OfSelectedTracks(send_idx,showHide);--1show;2Hide;else toggle
        
        if not tonumber(send_idx)then return false end;
        
        ----------------------------------------------------
        local CountSelTrack = reaper.CountSelectedTracks(0);
        if CountSelTrack == 0 then return false end;
        ----------------------------------------------------
        
        
        --==================================================
        --==================================================
        local SEND,CLOSE,OPEN;
        
        --[
        if showHide ~= 1 then;
            --- Close ------------------------------------------
            for i = 1,CountSelTrack do;
                local trackSel = reaper.GetSelectedTrack(0,i-1);
                local TrackSend = reaper.GetTrackSendInfo_Value(trackSel,0,send_idx-1,'P_DESTTRACK');
                if TrackSend and type(TrackSend) == 'userdata' then;
                    ---
                    local CountFx = reaper.TrackFX_GetCount(TrackSend);
                    if CountFx > 0 then;
                        SEND = true;
                        ---
                        for i = 1, CountFx do;
                            local OpenFx = reaper.TrackFX_GetOpen(TrackSend,i-1);
                            if OpenFx then;
                                reaper.TrackFX_Show(TrackSend,i-1,0);
                                reaper.TrackFX_Show(TrackSend,i-1,2);
                                CLOSE = true;
                            end;
                        end;
                        ---
                    end;
                end;
            end;
            ----------------------------------------------------
        end;
        
        if showHide ~= 0 then;
            if showHide == 1 then SEND = true end;
            --- Open -------------------------------------------
            if SEND and not CLOSE then;
                for i = 1,CountSelTrack do;
                    local trackSel = reaper.GetSelectedTrack(0,i-1);
                    local TrackSend = reaper.GetTrackSendInfo_Value(trackSel,0,send_idx-1,'P_DESTTRACK');
                    if TrackSend and type(TrackSend) == 'userdata' then;
                        local CountFx = reaper.TrackFX_GetCount(TrackSend);
                        if CountFx > 0 then;
                            for i = 1, CountFx do;
                                local OpenFx = reaper.TrackFX_GetOpen(TrackSend,i-1);
                                if not OpenFx then;
                                    reaper.TrackFX_Show(TrackSend,i-1,3);
                                    OPEN = true;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            ----------------------------------------------------
        end;
        --]]
        --==================================================
        
        --==================================================
        --[[
        if showHide ~= 0 then;
            --- Open -------------------------------------------
            for i = 1,CountSelTrack do;
                local trackSel = reaper.GetSelectedTrack(0,i-1);
                local TrackSend = reaper.GetTrackSendInfo_Value(trackSel,0,send_idx-1,'P_DESTTRACK');
                if TrackSend and type(TrackSend) == 'userdata' then;
                    ---
                    local CountFx = reaper.TrackFX_GetCount(TrackSend);
                    if CountFx > 0 then;
                        SEND = true;
                        ---
                        for i = 1, CountFx do;
                            local OpenFx = reaper.TrackFX_GetOpen(TrackSend,i-1);
                            if not OpenFx then;
                                reaper.TrackFX_Show(TrackSend,i-1,3);
                                OPEN = true;
                            end;
                        end;
                        ---
                    end;
                end;
            end;
            ----------------------------------------------------
        end;
        
        if showHide ~= 1 then;
            if showHide == 0 then SEND = true end;
            --- Close ------------------------------------------
            if SEND and not OPEN then;
                for i = 1,CountSelTrack do;
                    local trackSel = reaper.GetSelectedTrack(0,i-1);
                    local TrackSend = reaper.GetTrackSendInfo_Value(trackSel,0,send_idx-1,'P_DESTTRACK');
                    if TrackSend and type(TrackSend) == 'userdata' then;
                        local CountFx = reaper.TrackFX_GetCount(TrackSend);
                        if CountFx > 0 then;
                            for i = 1, CountFx do;
                                local OpenFx = reaper.TrackFX_GetOpen(TrackSend,i-1);
                                if OpenFx then;
                                    reaper.TrackFX_Show(TrackSend,i-1,0);
                                    reaper.TrackFX_Show(TrackSend,i-1,2);
                                    CLOSE = true;
                                end;
                            end;
                        end;
                    end;
                end;
            end;
            ----------------------------------------------------
        end;
        --]]
        --==================================================
        --==================================================
    end;
    
    reaper.defer(function()showUIOfAllFXInSend_n_OfSelectedTracks(send_idx,showHide)end);
    
    
    
    
    
    
    