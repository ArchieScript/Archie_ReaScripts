--[[
   * Category:    Track
   * Description: Move selected tracks in up on one 
   * Oписание:    Переместить выбранные треки вверх на один 
   * GIF:         http://goo.gl/n72Fb6
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.09
   * customer:    smrz1(Rmm/forum) 
   * gave idea:   smrz1(Rmm/forum) 
   * ---------:
   * changelog:   !!! OUTDATED 
   
                  +! Fixed error when moving the last folder / v.1.02
                  +! Устранена ошибка при перемещении последней папки / v.1.02
                  + Переделан скролл / Redesigned scroll / v.1.01
--=========================================================================]]
 
 
 
                 ----------------/ SCROLL /---------------------
    local Scrol = 1
            --  = 0 | OFF | ВЫКЛЮЧИТЬ СКРОЛЛИНГ \ DISABLE SCROLLING
            --  = 1 | ON  | ВКЛЮЧИТЬ СКРОЛЛИНГ  \ ENABLE SCROLLING

     
    local First_request = 0
                     -- = 2 | ПОКАЗАТЬ ЗАПРОС С ВЫБОРОМ  
                     -- = 1 | ЕСЛИ ТРЕК ПОД КОТОРЫЙ ПЕРЕМЕЩАЕМ ЯВЛЯЕТСЯ ПОСЛЕДНИМ В ПАПКЕ ТО ПОМЕСТИТЬ В ПАПКУ
                     -- = 0 | ЕСЛИ ТРЕК ПОД КОТОРЫЙ ПЕРЕМЕЩАЕМ ЯВЛЯЕТСЯ ПОСЛЕДНИМ В ПАПКЕ ТО НЕ ПОМЕЩАТЬ В ПАПКУ
                      
                     -- = 2 | PROMPT WITH A CHOICE
                     -- = 1 | IF THE TRACK UNDER WHICH ROAMING IS THE LATEST IN A FOLDER THEN PUT TO FOLDER
                     -- = 0 | IF THE TRACK UNDER WHICH ROAMING IS THE LATEST IN A FOLDER THAT IS NOT PLACED IN FOLDER
                     ------------------------------------------------------------------------------------------------
     
     
    local Second_query = 2
                    -- = 2 | ПОКАЗАТЬ ЗАПРОС С ВЫБОРОМ  
                    -- = 1 | ЕСЛИ ПЕРЕМЕЩАЕМЫЙ ТРЕК НАХОДИТСЯ ПЕРЕД ПОСЛЕДНИМ В ПАПКЕ ТО ПОМЕСТИТЬ В ПАПКУ НА ПОСЛЕДНЮЮ ПОЗИЦИЮ
                    -- = 0 | ЕСЛИ ПЕРЕМЕЩАЕМЫЙ ТРЕК НАХОДИТСЯ ПЕРЕД ПОСЛЕДНИМ В ПАПКЕ ТО ПОМЕСТИТЬ ДАЛЕЕ
                     
                    -- = 2 | PROMPT WITH A CHOICE
                    -- = 1 | IF THE DROP IS BEFORE THE LAST TRACK IN A FOLDER THEN PUT IT IN A FOLDER ON THE LAST POSITION
                    -- = 0 | IF THE DROP IS BEFORE THE LAST TRACK IN A FOLDER THEN PUT FORTH
                    ------------------------------------------------------------------------
  
  
  
    
    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================
 


    ------------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end;
    ------------------------------------------------------------------------------
    
     
    
    local SaveSelTracksGuid = function(slot); 
        for i = 1, reaper.CountSelectedTracks(0) do; 
            local track = reaper.GetSelectedTrack(0, i - 1);
            slot[i] = reaper.GetTrackGUID( track );
        end; 
    end;
    --- 
    
    
    local RestoreSelTracksGuid = function(slot); 
        local tr = reaper.GetTrack(0,0); 
        reaper.SetOnlyTrackSelected(tr); 
        reaper.SetTrackSelected(tr, 0); 
        for i = 1, #slot do;
            local track = reaper.BR_GetMediaTrackByGUID(0,slot[i]);
            if track then;
                reaper.SetTrackSelected(track,1); 
            end;
        end;  
    end;
    ---
    
    
    
    local CountSel = reaper.CountSelectedTracks(0);
    if CountSel == 0 then no_undo() return end;
 
    
    local sel_tracks1 = {};  
    SaveSelTracksGuid(sel_tracks1); 
     
    reaper.PreventUIRefresh(1); 
    reaper.Undo_BeginBlock();   
     
    local Numb,Un_Track,fold,Un_Track,UnTrack,FirstBlock,PenultimateInFolder,Tr,Tr2,fol,fol2
    ---
    reaper.InsertTrackAtIndex(0,false);
    local Track = reaper.GetTrack(0,0);
    local GUID = reaper.GetTrackGUID(Track);
    ---
    local CountTracks = reaper.CountTracks(0);
    for i = 1, CountTracks do;
        local Track = reaper.GetTrack(0, i-1);
        local SEL = reaper.GetMediaTrackInfo_Value(Track,"I_SELECTED");
        if SEL == 1 then;
            fold = reaper.GetMediaTrackInfo_Value( Track, "I_FOLDERDEPTH");
            Numb = reaper.GetMediaTrackInfo_Value( Track, "IP_TRACKNUMBER");
            for i2 = Numb, reaper.CountTracks(0)-1 do;
                Un_Track = reaper.GetTrack(0, i2);
                reaper.SetTrackSelected(Un_Track,0);
            end     
            Tr = reaper.GetTrack(0, Numb-3);
            if Tr then;
                fol = reaper.GetMediaTrackInfo_Value( Tr, "I_FOLDERDEPTH");
                local _, buf = reaper.GetTrackName( Track, '' )
                if fol < 0 then;
                    -------------
                    if First_request == 2 then;
                        local MB = reaper.MB
                             ('PUT IT IN A FOLDER ?\nПОМЕСТИТЬ В ПАПКУ ?\n Track № '
                                        ..math.floor(Numb)..' - '..buf,'Move selected tracks...',4)
                        if MB == 7 then; --NO
                            PenultimateInFolder = 0;
                        elseif MB == 6 then;  --YES    
                            PenultimateInFolder = 2;  
                        end 
                    elseif First_request == 1 then; 
                        PenultimateInFolder = 2;   
                    else;
                        PenultimateInFolder = 0;
                    end;
                    Numb_X = Numb - 2;    
                    ---------------   
                else;
                    Tr2 = reaper.GetTrack(0, Numb-2);
                    fol2 = reaper.GetMediaTrackInfo_Value( Tr2, "I_FOLDERDEPTH");
                    if fol2 < 0 then;
                        -------------
                        -------------
                        if Second_query == 2 then;
                            local MB = reaper.MB
                                 ('PUT IT IN A FOLDER ON THE LAST POSITION ?\n'
                                   ..'ПОМЕСТИТЬ В ПАПКУ НА ПОСЛЕДНЮЮ ПОЗИЦИЮ  ?\n Track № '
                                   ..math.floor(Numb)..' - '..buf,'Move selected tracks...',4);
                            if MB == 7 then;  --NO
                                Numb_X = Numb - 2; PenultimateInFolder = 0;
                            elseif MB == 6 then; --YES    
                                Numb_X = Numb - 1; PenultimateInFolder = 2;  
                            end; 
                        elseif Second_query == 1 then;
                            Numb_X = Numb - 1; PenultimateInFolder = 2;
                        else;
                            Numb_X = Numb - 2; PenultimateInFolder = 0;
                        end;     
                    end;
                end;
            end;  
            if fold == 1 then; 
                Depth = reaper.GetTrackDepth(Track);
                for i = Numb, reaper.CountTracks(0)-1 do;
                    TrackDepth = reaper.GetTrack(0, i);
                    if TrackDepth then;
                       Depth2 = reaper.GetTrackDepth(TrackDepth);
                       if Depth2 <= Depth then;
                           Numb_j = (reaper.GetMediaTrackInfo_Value( TrackDepth, "IP_TRACKNUMBER")-1);
                           break;
                       end;
                    end;
                end;
                if not Numb_j then Numb_j = reaper.CountTracks(0)-1 end;
            else;
                Numb_j = Numb;       
            end;
            if not PenultimateInFolder then PenultimateInFolder = 0 end;
            if not Numb_X then Numb_X = Numb-2 end;

            if Numb > 1 then;
                reaper.ReorderSelectedTracks(Numb_X,PenultimateInFolder);
            end;
                
            RestoreSelTracksGuid(sel_tracks1);   
            for ij = Numb_j-1, 0,-1 do;
                UnTrack = reaper.GetTrack(0, ij);
                reaper.SetTrackSelected(UnTrack,0);
            end; 
        end;
        Numb_j,Numb_X = nil,nil; 
    end;
    
    local track = reaper.BR_GetMediaTrackByGUID(0,GUID);
    reaper.SetOnlyTrackSelected(track);
    reaper.ReorderSelectedTracks(reaper.CountTracks(0),0);
    reaper.DeleteTrack( track );
    
    RestoreSelTracksGuid(sel_tracks1); 
    
    ---
    local SelTr = reaper.GetSelectedTrack(0,0);
    local Numb = reaper.GetMediaTrackInfo_Value(SelTr,"IP_TRACKNUMBER");
    if Numb == 1 then Scrol = 0;reaper.CSurf_OnScroll(0,-5);end;

    if Scrol == 1 then;
        reaper.PreventUIRefresh(-1);
        reaper.PreventUIRefresh( 1);
        local First = reaper.GetSelectedTrack(0,0);
        reaper.SetOnlyTrackSelected(First);
        reaper.Main_OnCommand(40696,0);-- rename
        reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_ARRANGE_WND'),0);
        reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_TRACKS'),0);
        RestoreSelTracksGuid(sel_tracks1);
        if reaper.CountTracks(0) > 30 then;
            reaper.CSurf_OnScroll(0,-1);
        end; 
    end;
    ---
    reaper.Main_OnCommand(40914,0);
    reaper.Undo_EndBlock("Move selected tracks in up on one",1);
    reaper.PreventUIRefresh(-1); 

 


     ExtState = reaper.GetExtState('['..({reaper.get_action_context()})[2]:match(".+[\\/](.+)")..']',"outdated")
     
     if ExtState == "" then
         reaper.MB(
                "Rus:\n\n"..
                "  *  Скрипт устарел, используйте\n"..
                "  *  Archie_Track;  Move selected tracks up by one visible(`).lua \n"..
                "  *  Archie_Track;  Move selected tracks up by one visible (skip folders)(`).lua\n"..
                "  *  Archie_Track;  Move selected tracks up by one visible (request to skip folders)(`).lua\n"..
                "  *  Данный Скрипт будет удален 31.04.2019\n\n"..
                "Eng\n\n"..
                "  * The script is outdated, use\n" ..
                "  *  Archie_Track;  Move selected tracks up by one visible(`).lua \n"..
                "  *  Archie_Track;  Move selected tracks up by one visible (skip folders)(`).lua\n"..
                "  *  Archie_Track;  Move selected tracks up by one visible (request to skip folders)(`).lua\n"..
                "  * This Script will be deleted. 31.04.2019 \n",
               "OUTDATED!",0)
     end;
     
     ValueExt = (tonumber(ExtState)or 0)+1
     if ValueExt > 3 then ValueExt = "" end
     
     reaper.SetExtState( '['..({reaper.get_action_context()})[2]:match(".+[\\/](.+)")..']',"outdated" ,ValueExt,false)