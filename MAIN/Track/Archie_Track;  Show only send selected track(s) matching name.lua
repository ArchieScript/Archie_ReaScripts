--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Show only send selected track(s) matching name
   * Author:      Archie
   * Version:     1.02
   * Описание:    Показать только отправленные выбранные треки с соответствующим названием
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Antibio(Rmm)
   * Gave idea:   Antibio(Rmm)
   * Extension:   Reaper 6.0+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.0 [10.12.19]
   *                  + initialе
--]]
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local function RetNumbTable(T);local x=0;for key,val in pairs(T)do;x=x+1;end;return x;end;
    
    
    
    --========================================================================
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;
    
    
    local T         = {};
    local selTrackT = {};
    local totalT    = {};
    local nameSetT  = {};
    local Undo;
    local NAME_Coincides;
    
    
    for i = 1, CountSelTrack do;
        local SendTrack = reaper.GetSelectedTrack(0,i-1);
        local GUID = reaper.GetTrackGUID(SendTrack);
        local _,stringNeedBig = reaper.GetSetMediaTrackInfo_String(SendTrack,"P_NAME",0,0);
        selTrackT[GUID]=SendTrack
        nameSetT[stringNeedBig]=stringNeedBig;  
    end;
    
    
    
    for i = 1, CountSelTrack do;
    
        local TrackSel = reaper.GetSelectedTrack(0,i-1);
        ----
        local NumSends = reaper.GetTrackNumSends(TrackSel,0);
        
        for i = 1, NumSends do;
            local SendTrack = reaper.BR_GetMediaTrackSendInfo_Track(TrackSel,0,i-1,1);
            local GUID = reaper.GetTrackGUID(SendTrack);
            T[GUID] = SendTrack;
        end;
        
        
        ----------------------------
        ::ToLookFurther::
        local x = RetNumbTable(T);
        
        for key, val in pairs(T) do;
            local NumSends = reaper.GetTrackNumSends(val,0);
            for i = 1, NumSends do;
                local SendTrack = reaper.BR_GetMediaTrackSendInfo_Track(val,0,i-1,1);
                local GUID = reaper.GetTrackGUID(SendTrack);
                T[GUID] = SendTrack;
            end;
        end
        
        if x ~= RetNumbTable(T) then goto ToLookFurther end;
        ----------------------------
        
        
        for key, val in pairs(T) do;
            totalT[key] = val;
        end;
        
        T = {};
    end;
    --========================================================================
    
    
    
    
    if RetNumbTable(totalT) > 0 then;
        local CountTracks = reaper.CountTracks(0);
        for i = 1, CountTracks do;
            local Track = reaper.GetTrack(0,i-1);
            local GUID = reaper.GetTrackGUID(Track);
        
            if totalT[GUID] then;
                local _,trName = reaper.GetSetMediaTrackInfo_String(Track,"P_NAME",0,0);
                for key, val in pairs(nameSetT) do;  
                    NAME_Coincides = trName:match(val);
                    if NAME_Coincides then break end;
                end;
            end;
            if NAME_Coincides then break end;
        end; 
    end;
    if not NAME_Coincides then no_undo() return end;
    
    
    
    if NAME_Coincides then;
        reaper.Undo_BeginBlock();
        -------------------------
        local CountTracks = reaper.CountTracks(0);
        for i = 1, CountTracks do;
            local NAME_Coincides;
            local Track = reaper.GetTrack(0,i-1);
            local GUID = reaper.GetTrackGUID(Track);
            
            
            if (totalT[GUID] or selTrackT[GUID]) then;
                local _,trName = reaper.GetSetMediaTrackInfo_String(Track,"P_NAME",0,0);
                for key, val in pairs(nameSetT) do;
                    NAME_Coincides = trName:match(val);
                    if NAME_Coincides then break end;
                end;
            end;
            
            
            if (totalT[GUID] or selTrackT[GUID]) and NAME_Coincides then;
                
                local show = reaper.GetMediaTrackInfo_Value(Track,"B_SHOWINTCP");
                if show ~= 1 then;
                    reaper.SetMediaTrackInfo_Value(Track,"B_SHOWINTCP",1);
                end;
            else;
                
                local show = reaper.GetMediaTrackInfo_Value(Track,"B_SHOWINTCP");
                if show ~= 0 then;
                    reaper.SetMediaTrackInfo_Value(Track,"B_SHOWINTCP",0);
                end;
            end;   
        end;
        reaper.TrackList_AdjustWindows(false);
        -------------------------
        reaper.Undo_EndBlock('Show only send selected track(s) matching name',-1);
        Undo = true;
    end;
    
    reaper.UpdateArrange();
    
    if not Undo then;
        no_undo();
    end;