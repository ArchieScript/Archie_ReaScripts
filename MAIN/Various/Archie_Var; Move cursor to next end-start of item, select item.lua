--[[
   * Category:    Various
   * Description: Move cursor to next end-start of item, select item
   * Author:      Archie
   * Version:     1.02
   * О скрипте:   Переместить курсор на следующий конец-начало элемента, выбрать элемент
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    HDVulcan(RMM)
   * Gave idea:   HDVulcan(RMM)
   * Changelog:
   *              v.1.0 [30.10.2019]
   *                  initialе
--]]

    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================


    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local CountSelTrack = reaper.CountSelectedTracks(0);
    local CountSelItems = reaper.CountSelectedMediaItems(0);

    if CountSelTrack == 0 and CountSelItems == 0 then;
        no_undo()return;
    end;


    local editCursor = reaper.GetCursorPosition();

    -----
    local Track,Undo;
    if CountSelTrack ~= 0 then;
        Track = reaper.GetSelectedTrack(0,0);
    else;
        local SelItem = reaper.GetSelectedMediaItem(0,0);
        Track = reaper.GetMediaItemTrack(SelItem);
    end;


    local CountTrItem = reaper.CountTrackMediaItems(Track);

    reaper.PreventUIRefresh(1);

    for i = 1,CountTrItem do;
        local item = reaper.GetTrackMediaItem(Track,i-1);
        local pos = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
        local len = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");

        if pos > editCursor or pos+len > editCursor then;
            if pos > editCursor then;
                reaper.SetEditCurPos(pos,true,false);
                Undo = "Move cursor to next START of item, select item";
            end;

            if pos+len > editCursor and pos <= editCursor then;
                reaper.SetEditCurPos(pos+len,true,false);
                Undo = "Move cursor to next END of item, select item";
            end;
            reaper.SelectAllMediaItems(0,0);
            reaper.SetMediaItemInfo_Value(item,"B_UISEL",1);
            reaper.Undo_BeginBlock();
            break;
        end;
    end;

    reaper.PreventUIRefresh(-1);

    if Undo then;
        reaper.Undo_EndBlock(Undo,-1);
    else;
        no_undo();
    end;

    reaper.UpdateArrange();