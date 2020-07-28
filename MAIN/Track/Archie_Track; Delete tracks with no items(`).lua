--[[
   * Category:    Track
   * Description: Delete tracks with no items
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Delete tracks with no items
   * О скрипте:   Удаление треков без элементов
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Specifik[RMM]
   * Gave idea:   Specifik[RMM]
   * Changelog:
   *              +  initialе / v.1.0 [30032019]


   -- Тест только на windows  /  Test only on windows.
   --========================================================================================
   --///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\\
   ----------------------------------------------------------------------------------------||
    ˅ - (+) - обязательно для установки / (-) - не обязательно для установки               ||
      -------------------------------------------------------------------------------------||
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                    ||
   (-) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php               ||
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                             ||
   (-) Arc_Function_lua v.2.3.1 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc ||
   (-) reaper_js_ReaScriptAPI     --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr ||
                                                                    http://clck.ru/Eo5Lw   ||
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                ||
      -------------------------------------------------------------------------------------||
    ˄ - (+) - required for installation / (-) - not necessary for installation             ||
   ----------------------------------------------------------------------------------------||
   --\\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: ///// SYSTEM REQUIREMENTS: \\\\\ СИСТЕМНЫЕ ТРЕБОВАНИЯ: /////
   ========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================





    local Delete_Visible_or_All = 1
                             -- = 0 Удалить все треки без элементов
                             -- = 1 Удалить только видимые треки без элементов
                                    ------------------------------------------
                             -- = 0 Delete all tracks without items
                             -- = 1 Delete only visible tracks without items.
                             ------------------------------------------------




    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    ---------------------------------------------------------
    local function no_undo();reaper.defer(function()end);end;
    ---------------------------------------------------------



    if reaper.CountTracks(0) == 0 then no_undo()return end;
    reaper.PreventUIRefresh(1);


    local i, Undo;
    while true do;
        i = (i or  reaper.CountTracks(0))-1;
        local Track = reaper.GetTrack(0,i);
        if not Track then break end;
        local CountTrItem = reaper.CountTrackMediaItems(Track);
        if CountTrItem == 0 then;
            local TrackVisible = reaper.IsTrackVisible(Track,false);
            if Delete_Visible_or_All == 0 then TrackVisible = true end;
            if TrackVisible then;
                ---------------------------------------------------------------------
                --->>/Template delete track is not finished folder == 1(Track)/>>----
                local fold = reaper.GetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH");
                if fold == 0 then;
                    reaper.DeleteTrack(Track);
                    if not Undo then reaper.Undo_BeginBlock()Undo = 1 end;
                elseif fold < 0 then;
                --------------
                    local numb = (reaper.GetMediaTrackInfo_Value(Track,"IP_TRACKNUMBER")-1);
                    local TrackX_Prev = reaper.GetTrack(0,numb-1);
                    local TrackX_Next = reaper.GetTrack(0,numb+1);
                    local foldX = reaper.GetMediaTrackInfo_Value(TrackX_Prev,"I_FOLDERDEPTH");

                    if foldX == 0 then;
                        reaper.SetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH",0);
                        reaper.SetMediaTrackInfo_Value(TrackX_Prev,"I_FOLDERDEPTH",fold);
                        reaper.DeleteTrack(Track);
                        if not Undo then reaper.Undo_BeginBlock()Undo = 1 end;

                    elseif foldX < 0 then;
                        local DepthX_Next;
                        if TrackX_Next then;
                            DepthX_Next = reaper.GetTrackDepth(TrackX_Next);
                        else;
                            DepthX_Next = 0;
                        end;
                        local DepthX_Prev = reaper.GetTrackDepth(TrackX_Prev);
                        local last = DepthX_Next - DepthX_Prev;
                        reaper.SetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH",0);
                        reaper.SetMediaTrackInfo_Value(TrackX_Prev,"I_FOLDERDEPTH",last);
                        reaper.DeleteTrack(Track);
                        if not Undo then reaper.Undo_BeginBlock()Undo = 1 end;

                    elseif foldX == 1 then;

                        reaper.SetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH",0);
                        reaper.SetMediaTrackInfo_Value(TrackX_Prev,"I_FOLDERDEPTH",0);
                        reaper.DeleteTrack(Track);
                        if not Undo then reaper.Undo_BeginBlock()Undo = 1 end;
                    end;

                elseif fold == 1 then;--!!??

                    local numb = (reaper.GetMediaTrackInfo_Value(Track,"IP_TRACKNUMBER")-1);
                    local Depth = reaper.GetTrackDepth(Track);
                    if numb == reaper.CountTracks(0)-1 then;
                        reaper.DeleteTrack(Track);
                        if not Undo then reaper.Undo_BeginBlock()Undo = 1 end;
                    else;
                        local i2,FoldItem;
                        while true do;
                            i2 = (i2 or numb)+1;
                            local TrackXNext = reaper.GetTrack(0,i2);
                            if not TrackXNext then break end;
                            local DepthXNext = reaper.GetTrackDepth(TrackXNext);
                            if DepthXNext > Depth then;
                                local CountTrItem = reaper.CountTrackMediaItems(TrackXNext);
                                if CountTrItem > 0 then FoldItem = 1 break end;
                            else;
                                if not FoldItem then;
                                    reaper.DeleteTrack(Track);
                                    if not Undo then reaper.Undo_BeginBlock()Undo = 1 end;
                                end;
                                break;
                            end;
                            if i2 == 10^6 then return end;
                        end;
                    end;
                end;
                ---<< / Template delete track / <<---
                -------------------------------------
            end;
            if i == -10^6 then return end;
        end;
    end;

    reaper.PreventUIRefresh(-1);
    if Undo then;
        if Delete_Visible_or_All == 0 then vis = "All" else vis = "Visible"end;
        reaper.Undo_EndBlock("Delete tracks with no items ("..vis..")",-1);
    else;
        no_undo();
    end;