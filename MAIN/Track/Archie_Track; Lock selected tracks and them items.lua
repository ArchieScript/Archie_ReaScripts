--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Lock selected tracks and them items
   * @                    (Archie_Track;  Unlock selected tracks and restore them items.lua)
   * Author:      Archie
   * Version:     1.0
   * Описание:    Блокировка выбранных треков и их элементов
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)$
   * Gave idea:   Archie(---)$
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [26.02.20]
   *                  + initialе
--]]


    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local MUTETRACK_FXBYPASS = 2;
                          -- = 0 no mute/bypass fx
                          -- = 1    mute/bypass fx
                          -- = 2    user input


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    --------------------------------------------------------
    local function GetLockTrackState(TrackChunk);
        local bracket = 0;
        for var in string.gmatch(TrackChunk,".-\n") do;
            if var:match('^%s-%S')=='<'or var:match('^%s-%S')=='>'then;
                bracket = bracket+1;
            end;
            local ret = tonumber(var:match('^%s-LOCK%s+(%d*).-$'));
            if ret then return ret end;
            if bracket >= 2 then return 0 end;
        end;
    end;
    --------------------------------------------------------


    --------------------------------------------------------
    local function SetLockTrackState(TrackChunk,state);--0/1
        local t,bracket,ret,Write = {},0;
        for var in string.gmatch(TrackChunk..'\n',".-\n") do;
            if var:match('^%s-%S')=='<'or var:match('^%s-%S')=='>'then;
                bracket = bracket+1;
            end;
            if bracket < 2 and not ret then;
                ret = var:match('^%s-LOCK%s+%d');
                if ret then var = var:gsub('LOCK%s+%d','LOCK '..state,1)end;
            end;
            if bracket >= 2 and not ret then break end;
            t[#t+1]=var;
        end;
        ----
        if not ret then;
            t={};
            for var in string.gmatch(TrackChunk..'\n',".-\n") do;
                if not Write then;
                    Write = var:match('NAME.-\n');
                    if Write then;
                        var = var..'LOCK '..state..'\n';
                    end;
                end;
                t[#t+1]=var;
            end;
        end;
        return table.concat(t);
    end;
    --------------------------------------------------------


    --------------------------------------------------------
    local function GetEnabledAllFxTrackState(TrackChunk);
        local bracket = 0;
        for var in string.gmatch(TrackChunk,".-\n") do;

            if var:match('^%s-%S')=='<'or var:match('^%s-%S')=='>'then;
                bracket = bracket+1;
            end;
            local ret = tonumber(var:match('^%s-FX%s+(%d*).-$'));
            if ret then return ret end;
            if bracket >= 2 then return 0 end;
        end;
    end;
    --------------------------------------------------------


    --------------------------------------------------------
    local function SetEnabledAllFxTrackState(TrackChunk,state);--0/1
        local t,bracket,ret,Write = {},0;
        for var in string.gmatch(TrackChunk..'\n',".-\n") do;
            if var:match('^%s-%S')=='<'or var:match('^%s-%S')=='>'then;
                bracket = bracket+1;
            end;
            if bracket < 2 and not ret then;
                ret = var:match('^%s-FX%s+%d');
                if ret then var = var:gsub('FX%s+%d','FX '..state,1)end;
            end;
            if bracket >= 2 and not ret then break end;
            t[#t+1]=var;
        end;
        ----
        if not ret then;
            t={};
            for var in string.gmatch(TrackChunk..'\n',".-\n") do;
                if not Write then;
                    Write = var:match('TRACKIMGFN.-\n');
                    if Write then;
                        var = var..'FX '..state..'\n';
                    end;
                end;
                t[#t+1]=var;
            end;
        end;
        return table.concat(t);
    end;
    --------------------------------------------------------


    --------------------------------------------------------
    local function SetMuteTrackState(TrackChunk,state);--0/1
        local t,bracket,ret = {},0;
        for var in string.gmatch(TrackChunk..'\n',".-\n") do;
            if var:match('^%s-%S')=='<'or var:match('^%s-%S')=='>'then;
                bracket = bracket+1;
            end;
            if bracket < 2 and not ret then;
                ret = var:match('^%s-MUTESOLO%s+%d+.-$');
                if ret then var = var:gsub('^%s-MUTESOLO%s+%d','MUTESOLO '..state,1)end;
            end;
            t[#t+1]=var;
        end;
        return table.concat(t);
    end;
    --------------------------------------------------------


    --------------------------------------------------------
    local function SetSoloTrackState(TrackChunk,state);--0/1
        local t,bracket,ret = {},0;
        for var in string.gmatch(TrackChunk..'\n',".-\n") do;
            if var:match('^%s-%S')=='<'or var:match('^%s-%S')=='>'then;
                bracket = bracket+1;
            end;
            if bracket < 2 and not ret then;
                ret = var:match('^%s-MUTESOLO%s+%S+%s+%S+.-$');
                local nm = var:match('^%s-MUTESOLO%s+(%S+).-$');
                if ret then var = var:gsub('^%s-MUTESOLO%s+%S+%s+%S+','MUTESOLO '..nm..' '..state,1)end;
            end;
            t[#t+1]=var;
        end;
        return table.concat(t);
    end;
    --------------------------------------------------------


    --------------------------------------------------------
    local function cleanProjExtState();
        local i = 0;
        while true do;
            i=i+1;
            local retval,key,val = reaper.EnumProjExtState(0,'ARCHIE_LOCK_SEL_TRACK_ITEM',i-1);
            if retval then;
                local tr = reaper.BR_GetMediaTrackByGUID(0,key);
                if not tr then;
                    reaper.SetProjExtState(0,'ARCHIE_LOCK_SEL_TRACK_ITEM',key,'');
                end;
            else;
                break;
            end
        end;
    end;
    --------------------------------------------------------



    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;

    local soloIt,muteIt,GetEnabFx,MB,UNDO;

    for i = 1,CountSelTrack do;
        local SelTrack = reaper.GetSelectedTrack(0,i-1);
        local GUID_TR = reaper.GetTrackGUID(SelTrack);
        local _,str = reaper.GetTrackStateChunk(SelTrack,'',false);
        local GetLock = GetLockTrackState(str);

        if GetLock == 0 then;

            if not UNDO then;
                reaper.Undo_BeginBlock();
                reaper.PreventUIRefresh(1);
                UNDO = true;
            end;

            if MUTETRACK_FXBYPASS > 0 then;

                soloIt = reaper.GetMediaTrackInfo_Value(SelTrack,'I_SOLO');
                muteIt = reaper.GetMediaTrackInfo_Value(SelTrack,'B_MUTE');
                GetEnabFx = GetEnabledAllFxTrackState(str);

                if MUTETRACK_FXBYPASS == 2 then;
                    if muteIt == 0 or GetEnabFx == 1 then;
                        if not MB then;
                            MB = reaper.MB('Mute Track / Bybass Fx ?','Mute Track',1);
                            if MB == 1 then;
                                MUTETRACK_FXBYPASS = 1;
                            elseif MB == 2 then;
                                MUTETRACK_FXBYPASS = 0;
                            end;
                        end;
                    end;
                end;
            end;

            if MUTETRACK_FXBYPASS == 2 then MUTETRACK_FXBYPASS = 1 end;

            if MUTETRACK_FXBYPASS ~= 1 then;
                muteIt = -1;
                GetEnabFx = -1;

            else;
                if GetEnabFx == 1 then;
                    str = SetEnabledAllFxTrackState(str,0);
                end;
                if muteIt ~= 1 then;
                    str = SetMuteTrackState(str,1);
                end;
                if soloIt ~= 0 then;
                    str = SetSoloTrackState(str,0);
                end;
            end;

            local SetLock = SetLockTrackState(str,1);
            reaper.SetTrackStateChunk(SelTrack,SetLock,false);
            ----

            local CountTrItem = reaper.CountTrackMediaItems(SelTrack);
            local t={};
            for it = 1,CountTrItem do;
                local item = reaper.GetTrackMediaItem(SelTrack,it-1);
                local guidIt = reaper.BR_GetMediaItemGUID(item);
                local lockIt = reaper.GetMediaItemInfo_Value(item,'C_LOCK');
                t[#t+1]='{'..guidIt..lockIt..'}';
                -----
                reaper.SetMediaItemInfo_Value(item,'C_LOCK',1);
                ---
            end;
            local strIt = table.concat(t)or'';
            local SetProjStr = '{'..muteIt..'&&&'..GetEnabFx..'&&&'..soloIt..'&&&'..strIt..'}';
            reaper.SetProjExtState(0,'ARCHIE_LOCK_SEL_TRACK_ITEM',GUID_TR,SetProjStr);
        end;
    end;

    reaper.defer(cleanProjExtState);

    if UNDO then;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock("Lock selected tracks and them items",-1);
    else;
        no_undo();
    end;
    reaper.UpdateArrange();



