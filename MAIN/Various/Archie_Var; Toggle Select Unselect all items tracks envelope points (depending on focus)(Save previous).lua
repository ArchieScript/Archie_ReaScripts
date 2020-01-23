--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Toggle Select all items tracks envelope points (depending on focus)(Save previous)
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Vax(Rmm)
   * Gave idea:   Vax(Rmm)
   * Extension:   Reaper 6.01+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   v.1.0 [23.01.20]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local MASTER = false  -- true / false
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    
    
    ----------------------------------------------
    local function Track(MASTER);
        
        reaper.Undo_BeginBlock();
        reaper.PreventUIRefresh(1);
        
        ---
        local section = ({reaper.get_action_context()})[2]:match('.+[/\\](.+)');
        
        local CountTrack = reaper.CountTracks(0);
        local CountSelectedTrack = reaper.CountSelectedTracks(0);
        
        local ExtState = reaper.GetExtState(section,'Track_guideSel');
        if ExtState == '' then;
            
            local str = '';
            if MASTER == true then;
                local masterTrack = reaper.GetMasterTrack(0);
                local selMaster = reaper.GetMediaTrackInfo_Value(masterTrack,'I_SELECTED');
                local GUID = reaper.GetTrackGUID(masterTrack);
                str = GUID..selMaster;
            end;
            
            for i = 1, CountTrack do;
                local Track = reaper.GetTrack(0,i-1);
                local GUID = reaper.GetTrackGUID(Track);
                local sel = reaper.GetMediaTrackInfo_Value(Track,'I_SELECTED');
                str = str..GUID..sel;
            end;
                
            reaper.SetExtState(section,'Track_guideSel',str,false);
             
            for i = 1, CountTrack do;
                local Track = reaper.GetTrack(0,i-1);
                reaper.SetMediaTrackInfo_Value(Track,'I_SELECTED',1);
            end;
            if MASTER == true then;
                local masterTrack = reaper.GetMasterTrack(0);
                reaper.SetMediaTrackInfo_Value(masterTrack,'I_SELECTED',1);
            end;
            
        else;
            
            reaper.Main_OnCommand(40297,0);--Unselect all tracks
            
            for guid,sel in string.gmatch(ExtState,"({.-})(%d+%.*%d*)")do;
                if guid and sel then;
                    TrackByGUID = reaper.BR_GetMediaTrackByGUID(0,guid);
                 
                    if not TrackByGUID then;
                        local masterTrack = reaper.GetMasterTrack(0);
                        local GUID = reaper.GetTrackGUID(masterTrack);
                        if guid == GUID then TrackByGUID = masterTrack end;   
                    end;
                  
                    if TrackByGUID then;
                        reaper.SetMediaTrackInfo_Value(TrackByGUID,'I_SELECTED',sel);
                    end;
                end;
            end;
            reaper.DeleteExtState(section,'Track_guideSel',false);
        end;
        ---
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Toggle Select all track Save previous',-1);  
    end;
    ----------------------------------------------
    
    
    
    ----------------------------------------------
    local function Items();
        
        reaper.Undo_BeginBlock();
        reaper.PreventUIRefresh(1);
        
        ----
        local section = ({reaper.get_action_context()})[2]:match('.+[/\\](.+)');
         
        local CountItem = reaper.CountMediaItems(0);
        local CountSelItem = reaper.CountSelectedMediaItems(0);
        
        local ExtState = reaper.GetExtState(section,'Item_guideSel');
        if ExtState == '' then;
            
            local str = '';
            for i = 1, CountItem do;
                local item = reaper.GetMediaItem(0,i-1);
                local GUID = reaper.BR_GetMediaItemGUID(item);
                local sel = reaper.GetMediaItemInfo_Value(item,'B_UISEL');
                str = str..GUID..sel;
            end;
                
            reaper.SetExtState(section,'Item_guideSel',str,false);
            
            for i = 1, CountItem do;
                local item = reaper.GetMediaItem(0,i-1);
                reaper.SetMediaItemInfo_Value(item,'B_UISEL',1);
            end;
            
            reaper.UpdateArrange();
                 
        else;
            
            reaper.SelectAllMediaItems(0,0);
            
            for guid,sel in string.gmatch(ExtState,"({.-})(%d+%.*%d*)")do;
                if guid and sel then;
                    local itemByGUID = reaper.BR_GetMediaItemByGUID(0,guid);
                    
                    if itemByGUID then;
                        reaper.SetMediaItemInfo_Value(itemByGUID,'B_UISEL',sel);
                    end;
                end; 
            end;
            
            reaper.DeleteExtState(section,'Item_guideSel',false);
            reaper.UpdateArrange();
        end;
        ----
        
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Toggle Select all items Save previous',-1);  
        reaper.UpdateArrange();
    end;
    ----------------------------------------------
    
    
    
    ----------------------------------------------
    local function Envelope();
        local Env = reaper.GetSelectedEnvelope(0);
        if Env then;
            --reaper.Undo_BeginBlock();
            reaper.Main_OnCommand(41595,0);-- Toggle select/unselect all points    
            --reaper.Undo_EndBlock('Toggle Select all point',-1);  
        end;
    end;
    ----------------------------------------------
    
    
    
    
    
    
    ----------------------------------------------
    local CursorContext = reaper.GetCursorContext2(true);
    if CursorContext == 0 then;--track
        ---
        Track(MASTER);
        ---
    elseif CursorContext == 1 then;--item
        ---
        Items();
        ---
    elseif CursorContext == 2 then;--env
        Envelope();
    end;
    ----------------------------------------------