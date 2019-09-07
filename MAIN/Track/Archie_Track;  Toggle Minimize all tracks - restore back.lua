--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Toggle Minimize all tracks - recover back
   * Author:      Archie
   * Version:     1.01
   * AboutScript: ---
   * О скрипте:   Переключение Минимизировать все треки - восстановить назад
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Krikets(RMM)
   * Gave idea:   Krikets(RMM)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.01 [07.09.19]
   *                  + Remove desync when saving between "Minimize all tracks","Minimize selected tracks"
   
   *              v.1.0 [07.09.19]
   *                  + initialе
--]]
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    
    local function GetHeightTrack(track);
        -- Внутри "PreventUIRefresh" не работает.
        -- Возвращает тоже самое что и "I_HEIGHTOVERRIDE" только без нуля.
        local height = reaper.GetMediaTrackInfo_Value(track,"I_HEIGHTOVERRIDE");
        if height == 0 then;
            reaper.InsertTrackAtIndex(reaper.CountTracks(0),false);
            local track = reaper.GetTrack(0,reaper.CountTracks(0)-1);
            height = reaper.GetMediaTrackInfo_Value(track,"I_WNDH");
            reaper.DeleteTrack(track);
            for i = 1,reaper.CountTracks(0) do;
                local track = reaper.GetTrack(0,i-1);
                local h = reaper.GetMediaTrackInfo_Value(track,"I_HEIGHTOVERRIDE");
                if h == 0 then;
                    reaper.SetMediaTrackInfo_Value(track,"I_HEIGHTOVERRIDE",height);
                end;  
            end;  
        end;
        return height;
    end;
    
    
    
    local extname = "ArchieMinimizeTracksRecoverBackHeight"
    -------
    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then no_undo() return end;
    local val = tonumber(({reaper.GetProjExtState(0,extname,"CountTrack")})[2])or CountTrack+1;
    if CountTrack ~= val then;
        for i = 1,math.huge do;
            local retval,key,val = reaper.EnumProjExtState(0,extname,i-1);
            if retval and key ~= "COUNTTRACK" then;
                local tr = reaper.BR_GetMediaTrackByGUID(0,key);
                if not tr then;
                    reaper.SetProjExtState(0,extname,key,"");
                end;
            end;
            if not retval then break end;
        end;
        reaper.SetProjExtState(0,extname,"CountTrack",CountTrack);
    end;
    -------
    
    
    
    -------------
    local CountTrack = reaper.CountTracks(0);
    if CountTrack == 0 then no_undo() return end;
    
    local Height;
    for i = 1,CountTrack do;
        local track = reaper.GetTrack(0,i-1);
        Height = GetHeightTrack(track);
        if Height > 30 then break end;
    end;
    -------------
    
    
    
    
    --------------------
    if Height > 30 then;
        
        for i = 1,reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            local height = GetHeightTrack(Track);
            if height > 30 then;
                local GUID = reaper.GetTrackGUID(Track);
                reaper.SetProjExtState(0,extname,GUID,height);
                reaper.SetMediaTrackInfo_Value(Track,"I_HEIGHTOVERRIDE",30);
            end;
        end;
    else;
         
        for i = 1,reaper.CountTracks(0) do;
            local Track = reaper.GetTrack(0,i-1);
            local GUID = reaper.GetTrackGUID(Track);
            local val = tonumber(({reaper.GetProjExtState(0,extname,GUID)})[2]);
            if val then;
                reaper.SetMediaTrackInfo_Value(Track,"I_HEIGHTOVERRIDE",val);
            else
                reaper.SetMediaTrackInfo_Value(Track,"I_HEIGHTOVERRIDE",0);
            end; 
        end;
    end;
    
    reaper.UpdateArrange();
    reaper.TrackList_AdjustWindows(false);
    --------------------------------------
    no_undo();