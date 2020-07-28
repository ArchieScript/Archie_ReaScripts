--[[
   * Category:    Track
   * Description: Delete folder(s) not removing child tracks
   * Author:      Archie
   * Version:     1.03
   * AboutScript: Only delete the folder(folders), not removing the child(nested) tracks
   * О скрипте:   Удалить только папку(папки), не удаляя дочерние(вложенные) треки
   * GIF:         http://clck.ru/Efwy4
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * customer:    borisuperful[RMM Forum]
   * gave idea:   borisuperful[RMM Forum]
   * Changelog:   +! Fixed bug when deleting last track / v.1.03/[12.11.18]
   *              +! Исправлена ошибка при удалении последнего трека / v.1.03/[12.11.18]
   *              +! Fixed a wrong move to subsequent tracks if you delete the subfolders in the folder without tracks / v.1.02/[10.11.18]
   *              +! Исправлено неправильное перемещение последующих треков при удалении подпапки в папке без треков / v.1.02/[10.11.18]
   *              +! Fixed incorrect movement of children when deleting the last subfolder / v.1.01
   *              +! Исправлено неправильное перемещение детей при удалении последней подпапки / v.1.01
   *              + initialе / v.1.0
--=================================================
SYSTEM  REQUIREMENTS:  Reaper v.5.96 |  SWS v.2.9.7  (and above)
СИСТЕМНЫЕ ТРЕБОВАНИЯ:  Reaper v.5.96 |  SWS v.2.9.7     (и выше)
--============================================================]]



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    ------------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end;
    ------------------------------------------------------------------------------




    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;



    for i = 1, CountSelTrack do;
        local selTrack = reaper.GetSelectedTrack(0,i-1);
        local fold = reaper.GetMediaTrackInfo_Value(selTrack, "I_FOLDERDEPTH");
        if fold == 1 then StartScript = 1 break end;
    end;
    if not StartScript then no_undo() return end; StartScript = nil;
    local sel_tracks = {};



    local SaveSelTracksGuid = function();
        for i = 1, reaper.CountSelectedTracks(0) do;
            local track = reaper.GetSelectedTrack(0,i-1);
            sel_tracks[i] = reaper.GetTrackGUID(track);
        end;
    end;



    local RestoreSelTracksGuid = function();
       local tr = reaper.GetTrack(0,0);
       reaper.SetOnlyTrackSelected(tr);
       reaper.SetTrackSelected(tr, 0);
       ---
       for i = 1, #sel_tracks do;
           local track = reaper.BR_GetMediaTrackByGUID(0,sel_tracks[i]);
           if track then;
               reaper.SetTrackSelected(track,1);
           end;
       end;
    end;
    ---



    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();
    SaveSelTracksGuid();

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
            RestoreSelTracksGuid();
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

    reaper.Undo_EndBlock("Delete folder(s) not removing child tracks",-1);
    reaper.PreventUIRefresh(-1);