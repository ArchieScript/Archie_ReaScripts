--[[
   * Category:    Track
   * Description: Move all selected tracks to the last selected folder
   * Author:      Archie
   * Version:     1.03
   * AboutScript: Move all selected tracks to the last selected folder
   * О скрипте:   Переместить все выбранные дорожки в последнюю выбранную папку
   * GIF:         http://clck.ru/EbWRT
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    smrz1(Rmm/forum)
   * Gave idea:   smrz1(Rmm/forum)
   * changelog:
   *              + Fixed bug when moving subfolders / v.1.02 [300419]
   *              + Исправлена ошибка при перемещении подпапок / v.1.02 [300419]

   *              + Added the ability to move tracks to the beginning or end of a folder / v.1.1
   *              + Добавлена возможность выбора перемещения треков в начало или конец папки / v.1.1
--==================================================================================================
SYSTEM  REQUIREMENTS:  Reaper v.5.96 |  SWS v.2.9.7  (and above)
СИСТЕМНЫЕ ТРЕБОВАНИЯ:  Reaper v.5.96 |  SWS v.2.9.7     (и выше)
--============================================================]]



    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local Move_to_Start_or_End = 1
                            -- = 0  Переместить выделенные треки в начало папки
                            -- = 0  Move the selected tracks to the beginning of the folder

                            -- = 1  Переместить выделенные треки в конец папки
                            -- = 1  Move the selected tracks to the end of the folder



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    ------------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end;
    ------------------------------------------------------------------------------



    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;


    local FoldGUID;

    for i = reaper.CountSelectedTracks(0)-1,0,-1 do;
        local SelTrack = reaper.GetSelectedTrack(0,i);
        local fold = reaper.GetMediaTrackInfo_Value(SelTrack,"I_FOLDERDEPTH");
        if fold == 1 then;
            local Depth = reaper.GetTrackDepth(SelTrack);
            if Depth == 0 then;
                FoldGUID = reaper.GetTrackGUID(SelTrack);
                break;
            else;
                local numb = reaper.GetMediaTrackInfo_Value(SelTrack,"IP_TRACKNUMBER");
                FoldGUID = reaper.GetTrackGUID(SelTrack);
                for i = numb-1,0,-1 do;
                    local Track = reaper.GetTrack(0,i);
                    local fold = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH");
                    if fold == 1 then;
                        local Depth2 = reaper.GetTrackDepth(Track);
                        if Depth2 < Depth then;
                            local Sel = (reaper.IsTrackSelected(Track)and 1 or 0);
                            if Sel == 1 then;
                                FoldGUID = reaper.GetTrackGUID(Track);
                                Depth = Depth2;
                            end;
                        end;
                        if Depth2 == 0 then goto exit1 end;
                    end;
                end;
            end;
        end;
    end;
    ::exit1::


    if not FoldGUID then no_undo() return end;



    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();


    local track = reaper.BR_GetMediaTrackByGUID(0,FoldGUID);
    reaper.SetTrackSelected(track,0);
    reaper.ReorderSelectedTracks(0,0);


    local numb;
    if Move_to_Start_or_End == 1 then; --/ End /--
        local DepthFirst = reaper.GetTrackDepth(track);
        numb = reaper.GetMediaTrackInfo_Value(track,"IP_TRACKNUMBER");
        for i = numb,reaper.CountTracks(0)-1 do;
            local Track = reaper.GetTrack(0,i);
            local DepthLast = reaper.GetTrackDepth(Track);
            local fold = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH");
            if fold < 0 then;
                if DepthFirst == DepthLast - 1 then;
                    numb = reaper.GetMediaTrackInfo_Value(Track,"IP_TRACKNUMBER");
                    break;
                end;
            end;
        end;
    else; --/ Start /--
         numb = reaper.GetMediaTrackInfo_Value(track,"IP_TRACKNUMBER");
    end;


    reaper.ReorderSelectedTracks(numb,2);
    reaper.SetTrackSelected(track,1);

    reaper.Undo_EndBlock("Move all selected tracks to the last selected folder",-1);
    reaper.PreventUIRefresh(-1);