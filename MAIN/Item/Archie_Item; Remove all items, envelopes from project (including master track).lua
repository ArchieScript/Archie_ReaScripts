--[[
   * Category:    Item
   * Description: Remove all items, envelopes from project (including master track)
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Remove all items, envelopes from project (including master track)
   * О скрипте:   Удалить все элементы, конверты из проекта (включая мастер-трек)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    BAYANBAYAN(Rmm/forum)
   * Gave idea:   BAYANBAYAN(Rmm/forum)
   * Changelog:   + initialе / v.1.0 [14.11.18]
--====================================================
SYSTEM  REQUIREMENTS:   Reaper v.5.96  |   SWS v.2.9.7
СИСТЕМНЫЕ ТРЕБОВАНИЯ:   Reaper v.5.96  |   SWS v.2.9.7
--===================================================]]




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);

    local CountTr =  reaper.CountTracks(0);
    for i = CountTr,0,-1 do;
        local track = reaper.GetTrack(0,i);
        if not track then;
            track = reaper.GetMasterTrack(0);
        end;
        ---
        local CountTrItems = reaper.CountTrackMediaItems(track);
        for i2 = CountTrItems-1,0,-1 do;
            local Items = reaper.GetTrackMediaItem(track,i2);
            reaper.DeleteTrackMediaItem(track,Items);
        end;
        ---
        local CountEnv = reaper.CountTrackEnvelopes(track);
        for i2 = CountEnv-1,0,-1 do;
            local TrackEnv = reaper.GetTrackEnvelope(track,i2);
            reaper.DeleteEnvelopePointRange(TrackEnv,0,9^9);

            local EnvAlloc = reaper.BR_EnvAlloc(TrackEnv,false);
            local active,
                  visible,
                  armed,
                  inLane,
                  laneHeight,
                  defaultShape,
                  minValue,
                  maxValue,
                  centerValue,
                  type_,
                  faderScaling = reaper.BR_EnvGetProperties(EnvAlloc);
            reaper.BR_EnvSetProperties(EnvAlloc,
                                       false,
                                       false,
                                       armed,
                                       inLane,
                                       laneHeight,
                                       defaultShape,
                                       faderScaling);
            reaper.BR_EnvFree(EnvAlloc,true);
        end;
    end;
    local undo = "Remove all items, envelopes from project (including master track)";
    reaper.Main_OnCommand(41138,0);--↓ 01%
    reaper.Main_OnCommand(41137,0);--↑ 01%
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock(undo,-1);