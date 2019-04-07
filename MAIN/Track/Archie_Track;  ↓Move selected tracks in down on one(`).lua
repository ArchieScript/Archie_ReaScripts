--[[
   * Category:    Track
   * Description: Move selected tracks in down on one
   * Oписание:    Переместить выбранные треки вниз на один
   * GIF:         http://goo.gl/DM4uku
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.09
   * customer:    smrz1 (Rmm/forum)
   * gave idea:   smrz1 (Rmm/forum)
   * ---------:
   * changelog:   !!! OUTDATED [deleted. 30.04.2019]
   
                     Переделан скролл / Redesigned scroll / v.1.01           
--============================================================]]



             ----------------/ SCROLL /---------------------------
    local Scrol = 1
            --  = 0 | OFF | ВЫКЛЮЧИТЬ СКРОЛЛИНГ \ DISABLE SCROLLING                            
            --  = 1 | ON  | ВКЛЮЧИТЬ СКРОЛЛИНГ  \ ENABLE SCROLLING                                  


    local First_request = 0
                     -- = 2 | ПОКАЗАТЬ ЗАПРОС С ВЫБОРОМ  
                     -- = 1 | ЕСЛИ ТРЕК ПРЕДПОСЛЕДНИЙ В ПАПКЕ ТО ПРИ ПЕРЕМЕЩЕНИИ ИЗВЛЕЧЬ ИЗ ПАПКИ
                     -- = 0 | ЕСЛИ ТРЕК ПРЕДПОСЛЕДНИЙ В ПАПКЕ ТО ПРИ ПЕРЕМЕЩЕНИИ ОСТАВИТЬ В ПАПКЕ

                     -- = 2 | PROMPT WITH A CHOICE
                     -- = 1 | IF THE TRACK IS PRE-LAST IN THE MOTOR FOLDER, REMOVE OF FOLDER
                     -- = 0 | IF THE TRACK IS PREVIOUS IN THE FOLDER, MOVE FROM WHEN YOU MOVE TO LEAVE OUT THE FOLDER
                     ------------------------------------------------------------------------------------------------


    local Second_query = 2
                    -- = 2 | ПОКАЗАТЬ ЗАПРОС С ВЫБОРОМ  
                    -- = 1 | ЕСЛИ ТРЕК ПОСЛЕДНИЙ В ПАПКЕ ТО ИЗВЛЕЧЬ ТРЕК И ОСТАВИТЬ НА ЭТОЙ ЖЕ ПОЗИЦИИ
                    -- = 0 | ПЕРЕМЕСТИТЬ ДАЛЕЕ

                    -- = 2 | PROMPT WITH A CHOICE
                    -- = 1 | IF THE LAST TRACK IN A FOLDER THEN OUTPUT THE TRACK FROM FOLDER AND LEAVE IN THE SAME POSITION
                    -- = 0 | TO MOVE FURTHER 
                     -------------------------------------------------------------------------------------------------------




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

    local Depth,LastBlock,Numb,PenultimateInFolder,fol,fold,track
    ---
    reaper.InsertTrackAtIndex(reaper.CountTracks(0),false);
    local Track = reaper.GetTrack(0,reaper.CountTracks(0)-1);
    local GUID = reaper.GetTrackGUID(Track);
    ---
    local CountTracks = reaper.CountTracks(0);
    for i = CountTracks-1,0,-1 do;    
        local Track = reaper.GetTrack(0, i);
        local SEL = reaper.GetMediaTrackInfo_Value(Track,"I_SELECTED");
        if SEL == 1 then; 
            fold = reaper.GetMediaTrackInfo_Value( Track, "I_FOLDERDEPTH");
            Numb = reaper.GetMediaTrackInfo_Value( Track, "IP_TRACKNUMBER");
            Depth = reaper.GetTrackDepth(Track);
            -- Get relocatable track 
            if Depth > 0 then; 
                if fold ~= 1 then; 
                    for i2 = Numb-1,0,-1 do;        
                        local Tr = reaper.GetTrack(0, i2);
                        local fol = reaper.GetMediaTrackInfo_Value( Tr, "I_FOLDERDEPTH");
                        if fol == 1 then; 
                            local SEL_fol = reaper.GetMediaTrackInfo_Value(Tr,"I_SELECTED");
                            if SEL_fol == 1 then;
                                Numb = reaper.GetMediaTrackInfo_Value( Tr, "IP_TRACKNUMBER"); 
                            end;
                            break;
                        end;
                    end;
                end;
            end;
            local Track = reaper.GetTrack(0,Numb-1);
            reaper.SetOnlyTrackSelected(Track);
            fol = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH");
            ---
            -- Get last track in folder 
            if fol == 1 then; 
                local Depth = reaper.GetTrackDepth(Track);
                for i2 = Numb, reaper.CountTracks(0)-1 do;
                    local Track = reaper.GetTrack(0,i2);
                    local Depth2 = reaper.GetTrackDepth(Track);
                    if Depth >= Depth2 then; 
                        Numb = (reaper.GetMediaTrackInfo_Value(Track,"IP_TRACKNUMBER")-1); 
                        break;
                    end
                end;
            end;
            ---
            -- Get values from the user
            local Track_F_preLast = reaper.GetTrack(0,Numb-1);
            local Fol_pre_Last = reaper.GetMediaTrackInfo_Value(Track_F_preLast,"I_FOLDERDEPTH");
            local Sel_pre_Last = reaper.GetMediaTrackInfo_Value(Track_F_preLast,"I_SELECTED");
            local Track_Fold_Last = reaper.GetTrack(0,Numb);
            if Track_Fold_Last then;
                local Fol_Last = reaper.GetMediaTrackInfo_Value(Track_Fold_Last,"I_FOLDERDEPTH");
                -- local Sel_Last = reaper.GetMediaTrackInfo_Value(Track_Fold_Last,"I_SELECTED");
                local retval, stringNeedBig = reaper.GetSetMediaTrackInfo_String(Track,"P_NAME",0,0);
                ---
                if Fol_Last < 0 and Fol_pre_Last == 0 and Sel_pre_Last == 1 then; 
                    if First_request == 2 then; 
                        local MB = reaper.MB 
                                ('OUTPUT TRACK FROM FOLDER ?        \n\n'
                               ..'ИЗВЛЕЧЬ ТРЕК ИЗ ПАПКИ ? \n\nTrack № '
                               ..math.floor(Numb)..'   /   '..stringNeedBig,'Move selected tracks... ↓',4);
                        if MB == 7 then; -- NO
                            PenultimateInFolder = 2;
                        elseif MB == 6 then; -- YES
                            PenultimateInFolder = 0; 
                        end;  
                    elseif First_request == 1 then;;
                        PenultimateInFolder = 0; 
                    else;
                        PenultimateInFolder = 2;
                    end;                        
                end;
                ---
                if Fol_pre_Last < 0 and Sel_pre_Last == 1 then;
                    if Second_query == 2 then;
                        local MB = reaper.MB 
                                ('OUTPUT THE TRACK FROM FOLDER AND LEAVE IN THE SAME POSITION ?        \n'
                               ..'ИЗВЛЕЧЬ ТРЕК ИЗ ПАПКИ И ОСТАВИТЬ НА ЭТОЙ ЖЕ ПОЗИЦИИ ? \n\n Track № '
                               ..math.floor(Numb)..'   /   '..stringNeedBig,'Move selected tracks... ↓',4);
                        if MB == 7 then; -- NO
                            Numb = Numb ; PenultimateInFolder = 0; 
                        elseif MB == 6 then; -- YES
                            Numb = Numb - 1; PenultimateInFolder = 0; 
                        end;
                    elseif Second_query == 1 then;;
                        Numb = Numb - 1; PenultimateInFolder = 0; 
                    else;
                        Numb = Numb ; PenultimateInFolder = 0;
                    end;
                end;
            end;
            ---
            
            if not PenultimateInFolder then PenultimateInFolder = 0 end;
            reaper.ReorderSelectedTracks( Numb+1,PenultimateInFolder); 

            RestoreSelTracksGuid(sel_tracks1);

            for i = Numb, reaper.CountTracks(0)-1 do;
                local Track = reaper.GetTrack(0,i);
                reaper.SetTrackSelected(Track,0);
            end;
        end;
    end;
    
    local track = reaper.BR_GetMediaTrackByGUID(0,GUID);
    reaper.SetOnlyTrackSelected(track)
    reaper.ReorderSelectedTracks(reaper.CountTracks(0),0);
    reaper.DeleteTrack(track)
    
    RestoreSelTracksGuid(sel_tracks1);
    
   
    local SelTr = reaper.GetSelectedTrack(0,reaper.CountSelectedTracks(0)-1);
    local Numb = reaper.GetMediaTrackInfo_Value(SelTr,"IP_TRACKNUMBER");
    if Numb == reaper.CountTracks(0) then Scrol = 0 end;
    ---
    
    if Scrol == 1 then;
        reaper.PreventUIRefresh(-1);
        reaper.PreventUIRefresh( 1);
        local Last = reaper.GetSelectedTrack(0,reaper.CountSelectedTracks(0)-1);
        reaper.SetOnlyTrackSelected(Last);
        reaper.Main_OnCommand(40696,0);-- rename
        reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_ARRANGE_WND'),0)
        reaper.Main_OnCommand(reaper.NamedCommandLookup('_BR_FOCUS_TRACKS'),0)
        RestoreSelTracksGuid(sel_tracks1);
      if reaper.CountTracks(0) > 30 then;
            reaper.CSurf_OnScroll(0,1);  
        end;
    end;
    ---
    reaper.Main_OnCommand(40914,0);
    reaper.Undo_EndBlock("Move selected tracks in down on one ",-1);
    reaper.PreventUIRefresh(-1);
    
    
    
    
    
    
    
    ExtState = reaper.GetExtState('['..({reaper.get_action_context()})[2]:match(".+[\\/](.+)")..']',"outdated")
       
       if ExtState == "" then
           reaper.MB(
                  "Rus:\n\n"..
                  "  *  Скрипт устарел, используйте\n"..
                  "  *  Archie_Track;  Move selected tracks down by one visible(`).lua \n"..
                  "  *  Archie_Track;  Move selected tracks down by one visible (skip folders)(`).lua\n"..
                  "  *  Archie_Track;  Move selected tracks down by one visible (request to skip folders)(`).lua\n"..
                  "  *  Данный Скрипт будет удален 30.04.2019\n\n"..
                  "Eng\n\n"..
                  "  * The script is outdated, use\n" ..
                  "  *  Archie_Track;  Move selected tracks down by one visible(`).lua \n"..
                  "  *  Archie_Track;  Move selected tracks down by one visible (skip folders)(`).lua\n"..
                  "  *  Archie_Track;  Move selected tracks down by one visible (request to skip folders)(`).lua\n"..
                  "  * This Script will be deleted. 30.04.2019 \n",
                 "OUTDATED!",0)
       end;
       
       ValueExt = (tonumber(ExtState)or 0)+1
       if ValueExt > 3 then ValueExt = "" end
       
       reaper.SetExtState( '['..({reaper.get_action_context()})[2]:match(".+[\\/](.+)")..']',"outdated" ,ValueExt,false)
    
    
    
    