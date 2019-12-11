--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Pre-reverb
   * Author:      Archie
   * Version:     1.0
   * Описание:    Предварительная реверберация
   * GIF:         Пошаговое выполнение скрипта  http://avatars.mds.yandex.net/get-pdb/2745165/83870370-824b-4932-a4c6-a4aa6fa4fc5e/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.01+ http://www.reaper.fm/
   * Changelog:   v.1.0 [11.12.19]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    local Tail_Rever = true;
                 --  = true | показать окно ввода времени
                 --  = .5   | или введите время в сек
     
     
    
    local NameTemplates = "ArchiePreVerb"  -- Имя шаблона(Необходимо при дублировании скрипта для другого ревера)
    
    
    local PreFxTrack = false 
                  -- = true  Перед эффектами на треке
                  -- = false После эффектов на треке
               
               
    local Channel = 2
               -- = 1 Track: Render selected area of tracks to mono post-fader stem tracks (and mute originals)
               -- = 2 Track: Render selected area of tracks to stereo post-fader stem tracks (and mute originals)
               -- = 3 Track: Render selected area of tracks to multichannel post-fader stem tracks (and mute originals)
    
    
    local snapToGrid = true
                  -- = true  | Ровнять по ближайшей сетке
                  -- = false | Не ровнять по сетке, рендерить четко по времени (Tail_Rever) 
    
    
    local FADEIN  = true
              --  = true  | on fade in
              --  = false | off fade in
    
    
    local FADEOUT = true
             --  = true  |  on fade out
             --  = false | off fade out
    
    
    local IN_SHAPE  = 0  -- 0..6, 0=linear, -1 default
    local OUT_SHAPE = 2  -- 0..6, 0=linear, -1 default
    
    
    
        
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================

 
 
 
 
 
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    
    
    --==================================================================================================================
    if type(NameTemplates)~="string" or #NameTemplates:gsub("%s","")==0 then NameTemplates = "ArchiePreVerb" end;
    local TemplatesPath = reaper.GetResourcePath():gsub("\\","/").."/TrackTemplates/"..NameTemplates..".RTrackTemplate";
    local file = io.open(TemplatesPath);
    local strTemplate;
    if not file then;
        reaper.MB("Eng:\n\nThe script did not find a track template named '"..NameTemplates.."' \n"..
                  "Save a track template with a customized reverb named '"..NameTemplates.."'\n\n\n"..
                  "Rus:\n\nСкрипт не нашел шаблон трека с именем '"..NameTemplates.."' \n"..
                  "Сохраните шаблон трека с настроенным ревербератором с именем '"..NameTemplates.."'"
                  ,"Woops",0);
        no_undo() return;
    else;
        strTemplate = file:read("a");
        file:close();
    end;
    --==================================================================================================================
    
    
    
    --=====================================================
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then;
        reaper.MB("No selected items !\n\nНет выбранных элементов !","Woops",0);
        no_undo()return;
    end;
    --=====================================================
    
    
    
    --=====================================================
    local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    if startLoop == endLoop then;
        reaper.MB("No time selection !\n\nНет выбора времени !","Woops",0);
        no_undo() return;
    end;
    --=====================================================
    
    
    
    --=====================================================
    local SelItemT = {};
    local selInTimeSel;
    for i = 1,CountSelItem do;
        local SelItem = reaper.GetSelectedMediaItem(0,i-1);
        local posIt = reaper.GetMediaItemInfo_Value(SelItem,"D_POSITION");
        local lenIt = reaper.GetMediaItemInfo_Value(SelItem,"D_LENGTH");
        if posIt < endLoop and posIt+lenIt > startLoop then;
            selInTimeSel = true;
            SelItemT[#SelItemT+1]=SelItem;
        end;
    end;
    
    if not selInTimeSel then;
        reaper.MB("No items in time selection !\n\nНет элементов в выборе времени !","Woops",0);
        no_undo() return;
    end;
    --=====================================================
    
    
    
    --=====================================================
    if not tonumber(Tail_Rever)or Tail_Rever <= 0 then Tail_Rever = true end;
    if Tail_Rever == true then;
        local val = tonumber(reaper.GetExtState("ArchiePreReverbScRiPt","valueTailSec"))or .5;
        ::rest::;
        local retval,retvals_csv = reaper.GetUserInputs("Pre Verb",1,"Value Sec",val);
        if not retval then no_undo() return end;
        if not tonumber(retvals_csv) then;
            reaper.MB("Invalid value, expected number !\n\nНедопустимое значение, ожидаемое число !","Woops",0);
            goto rest;
        end;
        Tail_Rever=retvals_csv;
    end;
    --=====================================================
    
    
    
    --=====================================================
    if startLoop - Tail_Rever < 0 then;
        reaper.MB("The tail does not fit, there is too little space at the beginning !\n\nХвост не влазит, слишком мало место в начале !","Woops !!!",0);
        no_undo() return;
    end;
    --=====================================================
    
    
    
    --=========================
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    --=========================
    
    
    
    --=====================================================
    reaper.Main_OnCommand(40297,0);-- Unselect all tracks
    
    for i = 1,#SelItemT do;
        local Track = reaper.GetMediaItem_Track(SelItemT[i]);
        reaper.SetMediaTrackInfo_Value(Track,"I_SELECTED",1);
    end;
    --=====================================================
    
    
    
    --=====================================================
    -- / Save mute Fx tr / -- 
    local CountSelTrack = reaper.CountSelectedTracks(0);
    local STrT = {};
    for i = 1,CountSelTrack do;
        STrT[i] = {};
        STrT[i].SelTrack = reaper.GetSelectedTrack(0,i-1);
        STrT[i].Mute = reaper.GetMediaTrackInfo_Value(STrT[i].SelTrack,"B_MUTE");
        STrT[i].Solo = reaper.GetMediaTrackInfo_Value(STrT[i].SelTrack,"I_SOLO");
        
        if PreFxTrack == true then;
            local CountFX = reaper.TrackFX_GetCount(STrT[i].SelTrack);
            local Instrument = reaper.TrackFX_GetInstrument(STrT[i].SelTrack);
            STrT[i].FxEnabled = {};
            
            for ifx = 1,CountFX do;
                STrT[i].FxEnabled[ifx] = reaper.TrackFX_GetEnabled(STrT[i].SelTrack,ifx-1);
                if ifx-1 ~= Instrument then;
                    reaper.TrackFX_SetEnabled(STrT[i].SelTrack,ifx-1,false);
                end;
            end;
        end;
    end;
    --=====================================================
    
    
    
    --=====================================================
    if Channel~=1 and Channel~=2 and Channel~=3 then Channel=2 end;
    local ChanT = {41718,41716,41717}
    reaper.Main_OnCommand(ChanT[Channel],0);--render
    reaper.SelectAllMediaItems(0,0);
    --=====================================================
    
    
    
    --=====================================================
    local SelTrack = reaper.GetSelectedTrack(0,0);
    local numb = reaper.GetMediaTrackInfo_Value(SelTrack,"IP_TRACKNUMBER");
    reaper.InsertTrackAtIndex(numb-1,false);
    local TrackPreVerb = reaper.GetTrack(0,numb-1);
    reaper.SetTrackStateChunk(TrackPreVerb,strTemplate,false);
    --=====================================================
    
    
    
    --=====================================================
    local CountTrItems = reaper.CountTrackMediaItems(TrackPreVerb);
    for i = 1,CountTrItems do;
        local item = reaper.GetTrackMediaItem(TrackPreVerb,i-1);
        reaper.DeleteTrackMediaItem(TrackPreVerb,item);
    end; 
    --=====================================================
    
    
    
    --=====================================================
    for i = reaper.CountSelectedTracks(0)-1,0,-1 do;
        local SelTrack = reaper.GetSelectedTrack(0,i);
        local CountTrItems = reaper.CountTrackMediaItems(SelTrack);
        for ii = 1,CountTrItems do;
            local item = reaper.GetTrackMediaItem(SelTrack,ii-1);
            reaper.MoveMediaItemToTrack(item,TrackPreVerb);
        end;
    end;
    reaper.Main_OnCommand(40005,0);--Track: Remove tracks 
    --=====================================================
    
    
    
    --=====================================================
    local CountTrItems = reaper.CountTrackMediaItems(TrackPreVerb);
    for i = 1,CountTrItems do;
        local item = reaper.GetTrackMediaItem(TrackPreVerb,i-1);
        reaper.SetMediaItemInfo_Value(item,"B_UISEL",1);
    end;
    reaper.Main_OnCommand(41051,0); -- Toggle take reverse
    --=====================================================
    
    
    
    --=====================================================
    local Tail;
    if snapToGrid == true then;
        Tail = reaper.SnapToGrid(0,endLoop+Tail_Rever);
    else;
        Tail = endLoop+Tail_Rever;
    end;
    reaper.GetSet_LoopTimeRange(1,0,startLoop,Tail,0);
    --=====================================================
    
    
    
    --=====================================================
    reaper.SetOnlyTrackSelected(TrackPreVerb);
    reaper.SetMediaTrackInfo_Value(TrackPreVerb,"D_VOL",1);
    reaper.SetMediaTrackInfo_Value(TrackPreVerb,"D_PAN",0);
    reaper.Main_OnCommand(ChanT[Channel],0);--render
    local TrackPreVerbReady = reaper.GetSelectedTrack(0,0);
    reaper.SetOnlyTrackSelected(TrackPreVerb);
    reaper.Main_OnCommand(40005,0);--Track: Remove tracks 
    reaper.SetOnlyTrackSelected(TrackPreVerbReady);
    
    reaper.GetSet_LoopTimeRange(1,0,startLoop,endLoop,0);
    
    local CountTrItems = reaper.CountTrackMediaItems(TrackPreVerbReady);
    for i = 1,CountTrItems do;
        local item = reaper.GetTrackMediaItem(TrackPreVerbReady,i-1);
        local pos = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
        local len = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
        reaper.SetMediaItemInfo_Value(item,"D_POSITION",pos-((pos+len)-endLoop));
        reaper.SetMediaItemInfo_Value(item,"B_UISEL",1);
    end;
    
    reaper.Main_OnCommand(41051,0); -- Toggle take reverse
    --=====================================================
    
    
    
    --=====================================================
    -- / fade in out / --
    if FADEIN == true or FADEOUT == true then;
        local CountSelItem = reaper.CountSelectedMediaItems(0);
        for i = 1,CountSelItem do;
            local SelItem = reaper.GetSelectedMediaItem(0,i-1);
            if FADEIN == true then;
                if tonumber(IN_SHAPE) and IN_SHAPE >= 0 and IN_SHAPE <= 6 then;
                    reaper.SetMediaItemInfo_Value(SelItem,"C_FADEINSHAPE",IN_SHAPE);
                end;
                reaper.SetMediaItemInfo_Value(SelItem,"D_FADEINLEN",Tail-endLoop);
            end;
            
            if FADEOUT == true then;
                if tonumber(OUT_SHAPE)and OUT_SHAPE >= 0 and OUT_SHAPE <= 6 then;
                    reaper.SetMediaItemInfo_Value(SelItem,"C_FADEOUTSHAPE",OUT_SHAPE);
                end;
                reaper.SetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN",endLoop-startLoop);
            end;
        end;
    end;
    --=====================================================
    
    
    
    --=====================================================
    for i = 1,#STrT do;
        reaper.SetMediaTrackInfo_Value(STrT[i].SelTrack,"B_MUTE",STrT[i].Mute);
        reaper.SetMediaTrackInfo_Value(STrT[i].SelTrack,"I_SOLO",STrT[i].Solo);
        if PreFxTrack == true then;
            for ifx = 1, #STrT[i].FxEnabled do;
                reaper.TrackFX_SetEnabled(STrT[i].SelTrack,ifx-1,STrT[i].FxEnabled[ifx]);
            end;
        end;
    end;
    --=====================================================
    
    
    reaper.Undo_EndBlock("Pre-reverb",-1);
    reaper.PreventUIRefresh(-1);
    reaper.UpdateArrange();