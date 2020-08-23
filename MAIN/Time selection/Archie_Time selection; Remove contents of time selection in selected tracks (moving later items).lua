--[[
   * Category:    Time selection
   * Description: Remove contents of time selection in selected tracks (moving later items)
   * Author:      Archie
   * Version:     1.05
   * AboutScript: ---
   * О скрипте:   Удалить содержимое выбора времени в выбранных дорожках (перемещение более поздних элементов)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    smrz1:[RMM];
   * Gave idea:   smrz1:[RMM];
   * Changelog:   
   *              v.1.05 [230820]
   *                  + fixed bug
   
   *              v.1.03 [30.12.19]
   *                  + fade in/out
   *              v.1.02 [30112019]
   *                  + fix bug automation: Add points to time selection
   *                  http://rmmedia.ru/threads/134701/post-2424819
   *              v.1.01 [05062019]
   *                  + Master track is selected, delete all content in time selection
   *                  + Мастер трек выбран, удалить все содержимое в выборе времени
   *              v.1.0 [04062019]
   *                  + Initialе;

   -- Тест только на windows  /  Test only on windows.
   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.975 +           --| http://www.reaper.fm/download.php
   (-) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos
   (-) Arc_Function_lua v.2.4.4 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc
   (-) reaper_js_ReaScriptAPI     --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6
   =======================================================================================]]



    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local AddPointsToTimeSel = true  -- true / false  | + v.1.02 http://rmmedia.ru/threads/134701/post-2424819


    local FADE = -1
            -- = < 0 fade in/out default (В зависимости от настроек reaper)
            -- = Иначе установите в миллисекундах


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    -------------------------------------------
    local function compare(x,y);
        local floatShare = 0.0000001;
        return math.abs(x-y) < floatShare;
    end;
    -------------------------------------------



    local function SelAllAutoItems(Sel);
        for i = 1, reaper.CountTracks(0) do;
            local track = reaper.GetTrack(0,i-1);
            for i2 = 1,reaper.CountTrackEnvelopes(track) do;
                local TrackEnv = reaper.GetTrackEnvelope(track,i2-1);
                for i3 = 1,reaper.CountAutomationItems(TrackEnv) do;
                    reaper.GetSetAutomationItemInfo(TrackEnv,i3-1,"D_UISEL",Sel,1);
                end;
            end;
        end;
    end;
    
    
    
    local function SelAllAutoItemsTrack(TrackEnv,Sel);
        for i3 = 1,reaper.CountAutomationItems(TrackEnv) do;
            reaper.GetSetAutomationItemInfo(TrackEnv,i3-1,"D_UISEL",Sel,1);
        end;
    end;


    local function no_undo();
        reaper.defer(function()end);
    end;
    
    
    
    local Start,End = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    if compare(Start,End) then reaper.MB("No Time Selected","ERROR",0)no_undo()return end;


    ----------------
    local MasterTrack = reaper.GetMasterTrack(0);
    local sel = reaper.GetMediaTrackInfo_Value(MasterTrack,"I_SELECTED");
    if sel == 1 then;
        reaper.Main_OnCommand(40201,0);--Remove contents of time selection
        return;
    end;
    ----------------

    local count_sel_track = reaper.CountSelectedTracks(0);
    if count_sel_track == 0 then no_undo()return end;


    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);

    local Cur = reaper.GetCursorPosition();

    SelAllAutoItems(0);


    for t = 1,count_sel_track do;
        
        local sel_track = reaper.GetSelectedTrack(0,t-1);
        
        local CountTrItem = reaper.CountTrackMediaItems(sel_track);
        for i = CountTrItem-1,0,-1 do;
            local Item = reaper.GetTrackMediaItem(sel_track,i);
            reaper.SplitMediaItem(Item,End);
            reaper.SplitMediaItem(Item,Start);
        end;
        
        
        local CountTrItem = reaper.CountTrackMediaItems(sel_track);
        for i = CountTrItem-1,0,-1 do;
            local Item = reaper.GetTrackMediaItem(sel_track,i);
            local positi = reaper.GetMediaItemInfo_Value(Item,"D_POSITION");
            local length = reaper.GetMediaItemInfo_Value(Item,"D_LENGTH");
            if (positi > Start or compare(positi,Start)) and 
               (((positi+length) < End) or compare((positi+length),End)) then;
                reaper.DeleteTrackMediaItem(sel_track,Item);
            end;
            
            --- v1.03 ---
            if tonumber(FADE)and FADE >= 0 then;
                if compare(positi,End) then;
                    reaper.SetMediaItemInfo_Value(Item,"D_FADEINLEN",FADE/1000);
                end;
                if compare(positi+length,Start) then;
                    reaper.SetMediaItemInfo_Value(Item,"D_FADEOUTLEN",FADE/1000);
                end;
            end;
            -------------
        end;
        
        
        local CountTrItem = reaper.CountTrackMediaItems(sel_track);
        for i = 1,CountTrItem do;
            local Item = reaper.GetTrackMediaItem(sel_track,i-1);
            local positi = reaper.GetMediaItemInfo_Value(Item,"D_POSITION");
            if positi > End or compare(positi,End) then;
                reaper.SetMediaItemInfo_Value(Item,"D_POSITION",positi-(End - Start));
            end;
        end;
        ---
        
        
        local CountTrEnv = reaper.CountTrackEnvelopes(sel_track);
        for i = 1,CountTrEnv do;
           local TrackEnv = reaper.GetTrackEnvelope(sel_track,i-1);
           reaper.SetCursorContext(2,TrackEnv);

           if AddPointsToTimeSel then;
               reaper.Main_OnCommand(40726,0);--Insert 4 envelope points at time selection
           end;
           
           reaper.Main_OnCommand(40089,0);--Delete all points in time selection

           SelAllAutoItemsTrack(TrackEnv,1);
           reaper.SetEditCurPos(Start,false,false);
           reaper.Main_OnCommand(42087,0);--Split automation items
           reaper.SetEditCurPos(End,false,false);
           reaper.Main_OnCommand(42087,0);--Split automation items
           SelAllAutoItemsTrack(TrackEnv,1);

           for i3 = 1,reaper.CountAutomationItems(TrackEnv) do;
               local posAutoIt = reaper.GetSetAutomationItemInfo(TrackEnv,i3-1,"D_POSITION",0,0);
               local lenAutoIt = reaper.GetSetAutomationItemInfo(TrackEnv,i3-1,"D_LENGTH",0,0);
               if ((posAutoIt+lenAutoIt) < Start)or compare((posAutoIt+lenAutoIt),Start)or
                   (posAutoIt > End) or compare(posAutoIt,End) then;   
                   reaper.GetSetAutomationItemInfo(TrackEnv,i3-1,"D_UISEL",0,1);
               end;
           end;
           reaper.Main_OnCommand(42086,0);--Delete automation items
           reaper.SetCursorContext(1,TrackEnv);
        end;


        local CountTrEnv = reaper.CountTrackEnvelopes(sel_track);
        for i = 1,CountTrEnv do;
            local TrackEnv = reaper.GetTrackEnvelope(sel_track,i-1);
            
            
            local CountEnvPoint = reaper.CountEnvelopePoints(TrackEnv);
            for i2 = 1,CountEnvPoint do;
                local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(TrackEnv,i2-1);
                if time > End or compare(time,End) then;
                    reaper.SetEnvelopePoint(TrackEnv,i2-1,time-(End-Start), valueIn,shape,tension,selected,true);
                end;
            end;
            
            for i3 = 1,reaper.CountAutomationItems(TrackEnv) do;
                local posAutoIt = reaper.GetSetAutomationItemInfo(TrackEnv,i3-1,"D_POSITION",0,0);
                if posAutoIt > End  or compare(posAutoIt,End) then;
                    reaper.GetSetAutomationItemInfo(TrackEnv,i3-1,"D_POSITION",posAutoIt-(End-Start),1);
                end;
            end;
            reaper.Envelope_SortPoints(TrackEnv);
        end;
    end;
    reaper.GetSet_LoopTimeRange(1,0,0,0,0);
    reaper.SetEditCurPos(Cur,false,false);
    
    reaper.PreventUIRefresh(-1);
    reaper.UpdateArrange();
    reaper.Undo_EndBlock("Remove contents of time selection in selected tracks(moving later items)",-1);
    --------------------------------------------------------------------------------