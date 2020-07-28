--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Hide child tracks of selected folders in MCP.lua
   * Author:      Archie
   * Version:     1.0
   * Описание:    Трек;  Скрыть дочерние треки выбранных папок в MCP
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.05+ http://www.reaper.fm/
   * Changelog:
   *              v.1.0 [290320]
   *                  + initialе
--]]
  --======================================================================================
  --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
  --======================================================================================


    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local CountSelTracks = reaper.CountSelectedTracks(0);
    if CountSelTracks == 0 then no_undo() return end;

    local UNDO;

    for i = 1,CountSelTracks do;
        local trackSel = reaper.GetSelectedTrack(0,i-1);
        local fold = (reaper.GetMediaTrackInfo_Value(trackSel,'I_FOLDERDEPTH')==1);
        if fold then;--FOLD
            local numb = reaper.GetMediaTrackInfo_Value(trackSel,'IP_TRACKNUMBER');
            local depth = reaper.GetTrackDepth(trackSel);
            local CountTracks = reaper.CountTracks(0);
            for i2 = numb--[[-1]],CountTracks-1 do;
                local track2 = reaper.GetTrack(0,i2);
                local depth2 = reaper.GetTrackDepth(track2);
                if depth2 > depth --[[or fold--]] then;
                    --fold=nil;
                    if not UNDO then;
                        reaper.Undo_BeginBlock();
                        reaper.PreventUIRefresh(1);
                        UNDO = true;
                    end;
                    reaper.SetMediaTrackInfo_Value(track2,'B_SHOWINMIXER',0);
                else;
                    break;
                end;
            end;
        end;--FOLD END
    end;


    if UNDO then;
        reaper.TrackList_AdjustWindows(true);
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Hide child tracks of selected folders in MCP',-1);
    else;
        no_undo();
    end;

