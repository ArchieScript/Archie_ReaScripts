--[[
   * Category:    Track
   * Description: Move all selected tracks to last touched folder
   * Author:      Archie
   * Version:     1.03
   * AboutScript: Move all selected tracks to last touched folder
   * О скрипте:   Переместить все выбранные треки в последнюю коснувшуюся папку
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    smrz1(Rmm/forum)
   * Gave idea:   smrz1(Rmm/forum)
   * changelog:
   *              +  initialе / v.1.0 [300419]
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
    local LastTouchedTrack = reaper.GetLastTouchedTrack();
    local fold = reaper.GetMediaTrackInfo_Value(LastTouchedTrack,"I_FOLDERDEPTH");
    if fold == 1 then;
        local Depth = reaper.GetTrackDepth(LastTouchedTrack);
        if Depth == 0 then;
            FoldGUID = reaper.GetTrackGUID(LastTouchedTrack);
        else;
            local numb = reaper.GetMediaTrackInfo_Value(LastTouchedTrack,"IP_TRACKNUMBER");
            FoldGUID = reaper.GetTrackGUID(LastTouchedTrack);
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
    ::exit1::


    if not FoldGUID then;
        reaper.MB("RUS:\n\n"..
                  "Последним касались не папки !!!\nПапка отсутствует!\n\n"..
                  "Перед запуском скрипта коснитесь папки, в которую необходимо переместить все выбранные треки / папки\n\n\n"..
                  "ENG:\n\n"..
                  "The latter was not a folder !!!\nFolder is missing!\n\n"..
                  "Before running the script, tap the folder where you want to move all the selected tracks/folders"
                  ,"ERROR",0);
        no_undo() return;
    end;


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

    reaper.Undo_EndBlock("Move all selected tracks to last touched folder",-1);
    reaper.PreventUIRefresh(-1);