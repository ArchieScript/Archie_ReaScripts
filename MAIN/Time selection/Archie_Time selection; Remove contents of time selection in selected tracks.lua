--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Time selection
   * Description: Remove contents of time selection in selected tracks
   * Author:      Archie
   * Version:     1.05
   * Описание:    Удалить содержимое выбора времени в выбранных дорожках
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    smrz1(RMM)
   * Gave idea:   smrz1(RMM)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.05 [230820]
   *                  + fixed bug
   
   *              v.1.03 [30.12.19]
   *                  + fade in/out
   *              v.1.0 [30.11.19]
   *                  + initialе
--]]

    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local RemoveTimeSel = false -- true / false

    local AddPointsToTimeSel = true  -- true / false  | + v.1.0 http://rmmedia.ru/threads/134701/post-2424819


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
        
        reaper.SetEditCurPos(Cur,false,false);
    end;
    
    if RemoveTimeSel == true then;
        reaper.GetSet_LoopTimeRange(1,0,0,0,0);
    end;
    
    reaper.UpdateArrange();
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("Remove contents of time selection in selected tracks",-1);
    --------------------------------------------------------------------------------