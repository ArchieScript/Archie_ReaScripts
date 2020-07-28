--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Var; Remove items tracks env points (depending on focus) select next.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.08+ http://www.reaper.fm/
   * Changelog:
   *              v.1.0 [170420]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------



    --======================================================
    local function DelSelTrackSelNext();
        local CountSelTrack = reaper.CountSelectedTracks(0);
        if CountSelTrack == 0 then no_undo() return end;
        local trTbl = {};
        for i = 1, CountSelTrack do;
            local selTrack = reaper.GetSelectedTrack(0,i-1);
            local fold = reaper.GetMediaTrackInfo_Value(selTrack,"I_FOLDERDEPTH")==1;
            local numb = reaper.GetMediaTrackInfo_Value(selTrack,"IP_TRACKNUMBER");
            if fold then;
                local depth = reaper.GetTrackDepth(selTrack);
                for i2 = numb,reaper.CountTracks(0)-1 do;
                    local tr = reaper.GetTrack(0,i2);
                    local depth2 = reaper.GetTrackDepth(tr);
                    if depth2 <= depth then;
                        trTbl[tostring(tr)] = tr;
                        break;
                    end;
                end;
            else;
                local tr = reaper.GetTrack(0,numb);
                trTbl[tostring(tr)] = tr;
            end;
        end;
        -----
        --Remove items/tracks/envelope points (depending on focus)
        reaper.Main_OnCommand(40697,0);
        -----
        for _,key in pairs(trTbl) do;
            pcall(reaper.SetMediaTrackInfo_Value,key,"I_SELECTED",1);
        end;
    end;
    --======================================================



    --======================================================
    local function DelSelItemSelNext();
        local CountSelItem = reaper.CountSelectedMediaItems(0);
        if CountSelItem == 0 then no_undo()return end;
        local itTbl = {};
        for i = 1, CountSelItem do;
            local SelItem = reaper.GetSelectedMediaItem(0,i-1);
            local track = reaper.GetMediaItem_Track(SelItem);
            local numb = reaper.GetMediaItemInfo_Value(SelItem,'IP_ITEMNUMBER');
            local it = reaper.GetTrackMediaItem(track,numb+1);
            itTbl[tostring(it)] = it;
        end;
        -----
        --Remove items/tracks/envelope points (depending on focus)
        reaper.Main_OnCommand(40697,0);
        -----
        for _,key in pairs(itTbl)do;
            pcall(reaper.SetMediaItemInfo_Value,key,"B_UISEL",1);
        end;
    end;
    --======================================================



    --======================================================
    local function DelSelEnvPointSelNext();
        local env = reaper.GetSelectedEnvelope(0);
        if not env then no_undo()return end;
        local t = {};
        local CountAutoIt = reaper.CountAutomationItems(env);
        for i = -1,CountAutoIt-1 do;
            local cntRemPnt = 0;
            local CountEnvPoint = reaper.CountEnvelopePointsEx(env,i);
            for i2 = 0,CountEnvPoint-1 do;
                local ret,time,val,shape,tens,sel = reaper.GetEnvelopePointEx(env,i,i2);
                if sel and not SEL then;
                    if not t[i]then t[i] = {} end;
                    t[i][#t[i]+1] = i2 - cntRemPnt;
                    SEL = true;
                elseif not sel then;
                    SEL = nil;
                end;
                if sel then cntRemPnt = cntRemPnt + 1 end;
            end;
        end;
        -----
        --Remove items/tracks/envelope points (depending on focus)
        reaper.Main_OnCommand(40697,0);
        -----
        for k,v in pairs(t)do;
            for k2,v2 in pairs(t[k])do;
                local _,time,val,shape,tens,sel = reaper.GetEnvelopePointEx(env,k,v2);
                reaper.SetEnvelopePointEx(env,k,v2,time,val,shape,tens,true,true);
            end;
            reaper.Envelope_SortPointsEx(env,k);
        end;
    end;
    --======================================================



    --======================================================
    local Context = reaper.GetCursorContext2(true);
    if Context == 0 then; -- tr
        DelSelTrackSelNext();
    elseif Context == 1 then; -- it
        DelSelItemSelNext();
    elseif Context == 2 then; -- env
        DelSelEnvPointSelNext();
    end;

    reaper.UpdateArrange();
    --======================================================





