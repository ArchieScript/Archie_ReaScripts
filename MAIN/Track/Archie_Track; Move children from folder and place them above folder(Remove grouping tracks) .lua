--[[
   * Category:    Track
   * Description: Move selected children from folder and place them above folder(Remove grouping tracks)
   * Oписание:    Переместить выбранных детей из папки и поместить их над папкой(Удалить группировку треков)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Author:      Archie
   * Version:     1.02
   * customer:    Supa75 (Rmm/forum)
   * gave idea:   Supa75 (Rmm/forum)
--=================================]]



    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    ------------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end;
    ------------------------------------------------------------------------------



    local sel_tracks,track;

    local SaveSelTracksGuid = function(slot);
        for i = 1, reaper.CountSelectedTracks(0) do;
            track = reaper.GetSelectedTrack(0, i - 1);
            slot[i] = reaper.GetTrackGUID( track );
        end;
    end;
    ---

    local RestoreSelTracksGuid = function(slot);
        local tr = reaper.GetTrack(0,0);
        reaper.SetOnlyTrackSelected(tr);
        reaper.SetTrackSelected(tr, 0);
        ---
        for i = 1, #slot do;
            track = reaper.BR_GetMediaTrackByGUID(0,slot[i]);
            if track then;
                reaper.SetTrackSelected(track,1);
            end;
        end;
    end;
    ----


    local Ungroup = function();
        Seltrack = reaper.GetSelectedTrack(0, 0);
        fold = reaper.GetMediaTrackInfo_Value(Seltrack,"I_FOLDERDEPTH");
        reaper.Main_OnCommand(reaper.NamedCommandLookup("_S&M_REMOVE_TR_GRP"),0)
        --SWS/S&M: Remove track grouping for selected tra
        if fold == 1 then
            local Depth = reaper.GetTrackDepth(Seltrack);
            local Numb = reaper.GetMediaTrackInfo_Value( Seltrack, "IP_TRACKNUMBER");
            for i = Numb, reaper.CountTracks(0) do;
                local Track = reaper.GetTrack(0, i);
                local Depth2 = reaper.GetTrackDepth(Track);
                if Depth < Depth2 then
                    sel_tracks2 = {}
                    SaveSelTracksGuid(sel_tracks2)
                    reaper.SetTrackSelected(Track,1);
                    reaper.Main_OnCommand(reaper.NamedCommandLookup("_S&M_REMOVE_TR_GRP"),0)
                    RestoreSelTracksGuid(sel_tracks2)
                else
                    break
                end
            end
        end
    end


    local CountSel = reaper.CountSelectedTracks(0);
    if CountSel == 0 then no_undo() return end;

    reaper.PreventUIRefresh(1);
    sel_tracks1 = {};
    SaveSelTracksGuid(sel_tracks1);

    local Numb,F_track,fold,F_Numb,track,Depth,Depth2,
          fold2,Numb2,SEL,Track,undo,UnSel_track,UnSel_tr;
    for i = 1, reaper.CountTracks(0) do;
        Track = reaper.GetTrack(0, i-1);
        SEL = reaper.GetMediaTrackInfo_Value(Track,"I_SELECTED");
        if SEL == 1 then;
            local Depth = reaper.GetTrackDepth(Track);
            if Depth > 0 then;
                Numb = reaper.GetMediaTrackInfo_Value( Track, "IP_TRACKNUMBER");
                ----
                for i2 = Numb-2, 0,-1 do;
                    F_track = reaper.GetTrack(0, i2);
                    fold = reaper.GetMediaTrackInfo_Value( F_track, "I_FOLDERDEPTH");
                    if fold == 1 then;
                        F_Numb = reaper.GetMediaTrackInfo_Value( F_track, "IP_TRACKNUMBER");
                        for i3 = Numb,reaper.CountTracks(0)-1 do;
                            UnSel_track = reaper.GetTrack(0, i3);
                            reaper.SetTrackSelected(UnSel_track,0);
                        end;
                        Ungroup()
                        reaper.ReorderSelectedTracks( F_Numb-1,0);
                        undo = 1
                        break;
                    end;
                end;
                ---
                RestoreSelTracksGuid(sel_tracks1);
                for i3 = Numb-1, 0,-1 do;
                    UnSel_tr = reaper.GetTrack(0,i3);
                    reaper.SetTrackSelected(UnSel_tr,0);
                end;
                ---
            else;
                reaper.SetTrackSelected(Track,0);
            end;
        end;
    end;
    RestoreSelTracksGuid(sel_tracks1);


    if undo == 1 then;
        reaper.Undo_BeginBlock();
        reaper.Undo_EndBlock("Move selected children from folder and place them above folder(Remove grouping tracks) ",1);
    else
        no_undo()
    end;
    reaper.PreventUIRefresh(-1);

