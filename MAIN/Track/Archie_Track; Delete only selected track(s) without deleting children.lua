--[[
   * Category:    Track
   * Description: Delete only selected track(s) without deleting children.
   * Author:      Archie
   * Version:     1.03
   * AboutScript: Delete only selected track(s) without deleting children.
   * О скрипте:   Удалять только выбранную(ые) дорожку(и) без удаления детей.
   * GIF:         http://clck.ru/Efwy4
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * customer:    Maestro Sound [RMM Forum]
   * gave idea:   Maestro Sound [RMM Forum]
   * Changelog:   +! Fixed bug when deleting last track / v.1.02/[12.11.18]
   *              +! Исправлена ошибка при удалении последнего трека / v.1.02/[12.11.18]
   *              +! Fixed incorrect movement of subsequent tracks when deleting tracks in subfolders / v.1.01/[10.11.18]
   *              +! Исправлено неправильное перемещение последующих треков при удалении треков в подпапках / v.1.01/[10.11.18]
   *              + initialе / v.1.0
--=======================================
SYSTEM  REQUIREMENTS:  Reaper v.5.96 |  SWS v.2.9.7  (and above)
СИСТЕМНЫЕ ТРЕБОВАНИЯ:  Reaper v.5.96 |  SWS v.2.9.7     (и выше)
--============================================================]]



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    ------------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end;
    ------------------------------------------------------------------------------




    local CountSelTrack,Save,GUIDPre = reaper.CountSelectedTracks(0),{};
    if CountSelTrack == 0 then no_undo() return end;




    local SaveSelTracksGuid = function(slot);
        for i = 1, reaper.CountSelectedTracks(0) do;
            local track = reaper.GetSelectedTrack(0,i-1);
            slot[i] = reaper.GetTrackGUID(track);
        end;
    end;


    local RestoreSelTracksGuid = function(slot);
       local tr = reaper.GetTrack(0,0);
       reaper.SetOnlyTrackSelected(tr);
       reaper.SetTrackSelected(tr, 0);
       ---
       for i = 1, #slot do;
           local track = reaper.BR_GetMediaTrackByGUID(0,slot[i]);
           if track then;
               reaper.SetTrackSelected(track,1);
           end;
       end;
    end;
    ---


    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();
    SaveSelTracksGuid(Save);

    local track_end = reaper.GetTrack(0,reaper.CountTracks(0)-1);
    local fold_end = reaper.GetMediaTrackInfo_Value(track_end,"I_FOLDERDEPTH");
    if fold_end == 1 then
        local IsTrSel = reaper.IsTrackSelected(track_end)
        if not IsTrSel then
            reaper.SetMediaTrackInfo_Value(track_end,"I_FOLDERDEPTH",0);
       end
    end

    for i = CountSelTrack-1,0,-1 do;
        local selTrack = reaper.GetSelectedTrack(0,i);
        local fold = reaper.GetMediaTrackInfo_Value(selTrack, "I_FOLDERDEPTH");
        if fold == 1 then;

            local numbprev = (reaper.GetMediaTrackInfo_Value(selTrack, "IP_TRACKNUMBER")-1);
            reaper.SetOnlyTrackSelected(selTrack);
            reaper.InsertTrackAtIndex(numbprev,false)
            reaper.ReorderSelectedTracks(reaper.CountTracks(0),0);
            local firstSelTrack = reaper.GetSelectedTrack(0,0);
            reaper.SetMediaTrackInfo_Value(firstSelTrack, "I_FOLDERDEPTH",0);
            local numbEnd = reaper.GetMediaTrackInfo_Value(firstSelTrack, "IP_TRACKNUMBER");
            for i = numbEnd+1,reaper.CountTracks(0) do;
                local track = reaper.GetTrack(0,i-1);
                reaper.SetTrackSelected(track,1);
            end;
            reaper.DeleteTrack(selTrack);
            reaper.ReorderSelectedTracks(numbprev+1,2);
            Track = reaper.GetTrack(0,numbprev);
            reaper.DeleteTrack(Track);
            RestoreSelTracksGuid(Save);

        else;

            local Depth = reaper.GetTrackDepth(selTrack)
            if Depth == 0 then;
                reaper.DeleteTrack(selTrack);
            elseif Depth > 0 then;

                local GUID = reaper.GetTrackGUID(selTrack);
                local Numb = reaper.GetMediaTrackInfo_Value(selTrack, "IP_TRACKNUMBER");
                local Depth = reaper.GetTrackDepth(selTrack)
                for i = Numb,0,-1 do;
                    local track = reaper.GetTrack(0,i-1);
                    local Depth2 = reaper.GetTrackDepth(track)
                    if Depth2 < Depth then;
                        local Fold = reaper.GetMediaTrackInfo_Value(track, "I_FOLDERDEPTH");
                        if Fold == 1 then;
                            local NumbPre = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER");
                            reaper.InsertTrackAtIndex(NumbPre-1,false)
                            local trackPre = reaper.GetTrack(0,NumbPre-1);
                            GUIDPre = reaper.GetTrackGUID(trackPre);--insert
                            reaper.SetOnlyTrackSelected(track);
                            break
                        end;
                    end;
                end;

                reaper.ReorderSelectedTracks(reaper.CountTracks(0),0);
                local SelTr = reaper.GetSelectedTrack(0,0);
                local num = reaper.GetMediaTrackInfo_Value(SelTr, "IP_TRACKNUMBER");
                for i = num,reaper.CountTracks(0) do;
                    local tr = reaper.GetTrack(0,i-1);
                    local GUID2 = reaper.GetTrackGUID(tr);
                    if GUID2 == GUID then;
                        reaper.DeleteTrack(tr);
                        break
                    end
                end

                local tr = reaper.GetTrack(0,reaper.CountTracks(0)-1);
                local Depth = reaper.GetTrackDepth(tr);
                reaper.SetMediaTrackInfo_Value(tr,"I_FOLDERDEPTH",Depth-Depth*2);

                for i = 1,reaper.CountTracks(0) do;
                    local tr = reaper.GetTrack(0,i-1);
                    local GUID = reaper.GetTrackGUID(tr);
                    if GUID == GUIDPre then;
                        local num = reaper.GetMediaTrackInfo_Value(tr, "IP_TRACKNUMBER");
                        reaper.ReorderSelectedTracks(num,2);
                        local tr = reaper.GetTrack(0,num-1);
                        reaper.DeleteTrack(tr);
                        break
                    end;
                end;
                RestoreSelTracksGuid(Save);
            end;
        end;
    end;

    local track_end_j = reaper.GetTrack(0,reaper.CountTracks(0)-1);
    if track_end == track_end_j then;
        reaper.SetMediaTrackInfo_Value(track_end, "I_FOLDERDEPTH",fold_end);
    end;


    local CountTrack = reaper.CountTracks(0);
    for i = 1,CountTrack do;
        local Track = reaper.GetTrack(0,i-1);
        local Depth = reaper.GetTrackDepth(Track);
        if Depth == 0 then;
            local Fold = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH");
            if Fold < 0 then;
                reaper.SetMediaTrackInfo_Value(track_end, "I_FOLDERDEPTH",0);
            end;
        end;
    end;

    reaper.Undo_EndBlock("Delete only selected track(s) without deleting children.",-1);
    reaper.PreventUIRefresh(-1);