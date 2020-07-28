--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Various 
   * Description: Toggle Select Unselect all items tracks envelope points (depending on focus) 
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
         
        local CountTrack = reaper.CountTracks(0); 
        local CountSelectedTrack = reaper.CountSelectedTracks(0); 
         
        local masterTrack = reaper.GetMasterTrack(0); 
        local selMaster = reaper.GetMediaTrackInfo_Value(masterTrack,'I_SELECTED'); 
        if MASTER ~= true then selMaster = 1 end; 
         
        if CountTrack == CountSelectedTrack and selMaster == 1 then; 
            for i = 1, CountTrack do; 
                local Track = reaper.GetTrack(0,i-1); 
                reaper.SetMediaTrackInfo_Value(Track,'I_SELECTED',0); 
            end; 
            if MASTER == true then; 
                reaper.SetMediaTrackInfo_Value(masterTrack,'I_SELECTED',0); 
            end; 
        else; 
            for i = 1, CountTrack do; 
                local Track = reaper.GetTrack(0,i-1); 
                reaper.SetMediaTrackInfo_Value(Track,'I_SELECTED',1); 
            end; 
            if MASTER == true then; 
                reaper.SetMediaTrackInfo_Value(masterTrack,'I_SELECTED',1); 
            end; 
        end; 
         
        reaper.PreventUIRefresh(-1); 
        reaper.Undo_EndBlock('Toggle Select all track',-1);   
    end; 
    ---------------------------------------------- 
     
     
     
    ---------------------------------------------- 
    local function Items(); 
         
        reaper.Undo_BeginBlock(); 
        reaper.PreventUIRefresh(1); 
         
        local CountItem = reaper.CountMediaItems(0); 
        local CountSelItem = reaper.CountSelectedMediaItems(0); 
         
        if CountItem == CountSelItem then; 
            for i = 1, CountItem do; 
                local item =  reaper.GetMediaItem(0,i-1); 
                reaper.SetMediaItemInfo_Value(item,'B_UISEL',0); 
            end; 
        else; 
            for i = 1, CountItem do; 
                local item =  reaper.GetMediaItem(0,i-1); 
                reaper.SetMediaItemInfo_Value(item,'B_UISEL',1); 
            end; 
        end; 
         
        reaper.PreventUIRefresh(-1); 
        reaper.Undo_EndBlock('Toggle Select all items',-1);   
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