--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item; Glue selected items to separate track - Midi in midi - Audio in audio.lua
   * Author:      Archie
   * Version:     1.0
   * GIF:         http://avatars.mds.yandex.net/get-pdb/1953170/f580edb8-1f89-41df-94b1-3ba5cd86019d/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    drumwizard(rmm)
   * Gave idea:   drumwizard(rmm)
   * Extension:   Reaper 6.14+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.3.0.2+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.0 [031120]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("3.0.2",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    local ArcFileIni = reaper.GetResourcePath():gsub('\\','/')..'/reaper-Archie.ini';
    --=========================================
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;
     
    local title = 'Glue selected items to separate track - Midi in midi - Audio in audio'
    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();
    
    --------------------------------
    local _,st= Arc.Save_Selected_Items_Slot(1); 
    local midiItem  = {};
    local audioItem = {};
    local audioTrack;
    local midiTrack;
    local NewMidiItem;
    local NewAudioItem;
   
    for i = 1,#st do;
        local take = reaper.GetActiveTake(st[i]);
        if take then;
            local midi = reaper.TakeIsMIDI(take);
            if midi then;
                if not midiTrack then;
                    if audioTrack then;
                        midiTrack = audioTrack;
                    else;
                        midiTrack = reaper.GetMediaItem_Track(st[i]);
                    end;
                    ----
                    local numb = reaper.GetMediaTrackInfo_Value(midiTrack,'IP_TRACKNUMBER');
                    reaper.InsertTrackAtIndex(numb-1,true);
                    midiTrack = reaper.GetTrack(0,numb-1);
                end;
                local retval,str = reaper.GetItemStateChunk(st[i],'',false);
                str = str:gsub('BYPASS%s+%d+%s+%d+','BYPASS 1 1');
                local nItem = reaper.CreateNewMIDIItemInProj(midiTrack,0,1,false);
                reaper.SetItemStateChunk(nItem,str,false);
                midiItem[#midiItem+1] = nItem;
            else;
                if not audioTrack then;
                    if midiTrack then;
                        audioTrack = midiTrack;
                    else;
                        audioTrack = reaper.GetMediaItem_Track(st[i]);
                    end;
                    ---
                    local numb = reaper.GetMediaTrackInfo_Value(audioTrack,'IP_TRACKNUMBER');
                    reaper.InsertTrackAtIndex(numb-1,true);
                    audioTrack = reaper.GetTrack(0,numb-1);
                end;
                local retval,str = reaper.GetItemStateChunk(st[i],'',false);
                local nItem = reaper.CreateNewMIDIItemInProj(audioTrack,0,1,false);
                reaper.SetItemStateChunk(nItem,str,false);
                audioItem[#audioItem+1] = nItem;
            end;
        end;
    end;
    --------------------------------
    
    --------------------------------
    local CountSelItem2 = reaper.CountSelectedMediaItems(0);
    if CountSelItem == CountSelItem2 then;
        reaper.Undo_EndBlock(title,-1);
        reaper.PreventUIRefresh(-1);
        return;
    end;
    --------------------------------
    
    ---MIDI-------------------------
    if #midiItem > 0 then;
        reaper.SelectAllMediaItems(0,0);
        for i = 1,#midiItem do;
            reaper.SetMediaItemInfo_Value(midiItem[i],'B_UISEL',1);
        end;
        reaper.Main_OnCommand(42353,0);--Items: Set all take FX offline for selected media items
        reaper.Main_OnCommand(40257,0);--Item: Glue items, ignoring time selection, including leading fade-in and trailing fade-out
        NewMidiItem = reaper.GetSelectedMediaItem(0,0);
    end;
    --------------------------------
     
    ---AUDIO------------------------
    if #audioItem > 0 then;
        reaper.SelectAllMediaItems(0,0);
        for i = 1,#audioItem do;
            reaper.SetMediaItemInfo_Value(audioItem[i],'B_UISEL',1);
        end;
        reaper.Main_OnCommand(40257,0);--Item: Glue items, ignoring time selection, including leading fade-in and trailing fade-out
        NewAudioItem = reaper.GetSelectedMediaItem(0,0);
    end;
    --------------------------------
    
    --------------------------------
    if NewMidiItem then;
        reaper.SetMediaItemInfo_Value(NewMidiItem,'B_UISEL',1);
    end;
    if NewAudioItem then;
        reaper.SetMediaItemInfo_Value(NewAudioItem,'B_UISEL',1);
    end;
    --------------------------------
    
    --------------------------------
    reaper.Undo_EndBlock(title,-1);
    reaper.PreventUIRefresh(-1);
    --reaper.UpdateArrange();
    --------------------------------
    
    