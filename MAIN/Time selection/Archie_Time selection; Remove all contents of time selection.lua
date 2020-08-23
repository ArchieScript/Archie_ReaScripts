--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Time selection
   * Description: Remove all contents of time selection
   * Author:      Archie
   * Version:     1.05
   * AboutScript: ---
   * О скрипте:   Удалить все содержимое выбора времени
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    AlexLazer(Rmm)
   * Gave idea:   AlexLazer(Rmm)
   * Changelog:   
   *              v.1.05 [230820]
   *                  + fixed bug
   
   *              v.1.03 [220820]
   *                  + Completely redesigned
   *              v.1.0 [17.07.2019]
   *                  + initialе

    -- Тест только на windows  /  Test only on windows.
    --=======================================================================================
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:
    (+) - required for installation      | (+) - обязательно для установки
    (-) - not necessary for installation | (-) - не обязательно для установки
    -----------------------------------------------------------------------------------------
    (+) Reaper v.6.12 +             --| http://www.reaper.fm/download.php
    (-) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php
    (-) ReaPack v.1.2.2 +           --| http://reapack.com/repos
    (-) Arc_Function_lua v.2.4.4 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]]
    
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local RemoveTimeSel = true -- true / false

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
    
    
    
    local function RemovePartOfRegionByTime(startTime,endTime);
        local retval,num_markers,num_regions = reaper.CountProjectMarkers(0);
        for i = retval,0,-1 do;
            local retval_,isrgn,pos,rgnend,name,markrgnindexnumber = reaper.EnumProjectMarkers(i);
            if isrgn == true then;
                if pos < endTime and rgnend > startTime then;
                    reaper.DeleteProjectMarker(0,markrgnindexnumber,true);
                end;
                if pos < startTime and rgnend > startTime then;
                    reaper.AddProjectMarker(0,true,pos,startTime,name,-1);
                end;
                if pos < endTime and rgnend > endTime then;
                    reaper.AddProjectMarker(0,true,endTime,rgnend,name,-1);
                end;
            else;
                -----
                if pos < endTime and pos > startTime then;
                    reaper.DeleteProjectMarker(0,markrgnindexnumber,false);
                end;
                ----
            end;
        end;
    end;
    
    
    
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


    local countTrack = reaper.CountTracks(0);
    if countTrack == 0 then no_undo()return end;


    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    
    
    RemovePartOfRegionByTime(Start,End);
    
    local Cur = reaper.GetCursorPosition();

    SelAllAutoItems(0);


    for t = 1,countTrack do;

        local track = reaper.GetTrack(0,t-1);

        local CountTrItem = reaper.CountTrackMediaItems(track);
        for i = CountTrItem-1,0,-1 do;
            local Item = reaper.GetTrackMediaItem(track,i);
            reaper.SplitMediaItem(Item,End);
            reaper.SplitMediaItem(Item,Start);
        end;


        local CountTrItem = reaper.CountTrackMediaItems(track);
        for i = CountTrItem-1,0,-1 do;
            local Item = reaper.GetTrackMediaItem(track,i);
            local positi = reaper.GetMediaItemInfo_Value(Item,"D_POSITION");
            local length = reaper.GetMediaItemInfo_Value(Item,"D_LENGTH");
            
            if (positi > Start or compare(positi,Start)) and
               (((positi+length) < End) or compare((positi+length),End)) then;
                reaper.DeleteTrackMediaItem(track,Item);
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


        local CountTrEnv = reaper.CountTrackEnvelopes(track);
        for i = 1,CountTrEnv do;
           local TrackEnv = reaper.GetTrackEnvelope(track,i-1);
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
    end;
    
    
    if RemoveTimeSel == true then;
        reaper.GetSet_LoopTimeRange(1,0,0,0,0);
    end;
    reaper.SetEditCurPos(Cur,false,false);
     
    reaper.UpdateArrange();
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("Remove all contents of time selection",-1);
    --------------------------------------------------------------------------------