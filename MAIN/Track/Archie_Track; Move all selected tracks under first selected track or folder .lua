--[[
   * Category:    Track
   * Description: Move all selected tracks under the first selected track or folder
   * Oписание:    Переместить все выбранные треки под первый выбранный трек или папку
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Author:      Archie
   * Version:     1.02
   * customer:    ---
   * gave idea:   smrz1(Rmm/forum)
   * ---------:
   * changelog:   /***/
--==================================================]]



    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    ------------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end;
    ------------------------------------------------------------------------------



    local SelTrack = reaper.GetSelectedTrack(0,0);
    if not SelTrack then no_undo() return end;


    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();

    local FoldGUID = reaper.GetTrackGUID(SelTrack);
    reaper.SetTrackSelected(SelTrack,0);

    reaper.ReorderSelectedTracks(reaper.CountTracks(0),0);
    local track = reaper.BR_GetMediaTrackByGUID(0,FoldGUID);
    local numb = reaper.GetMediaTrackInfo_Value(track,"IP_TRACKNUMBER");
    reaper.SetTrackSelected(track,1);
    reaper.ReorderSelectedTracks(numb,0);

    local Undo = "Move all selected tracks under the first selected track or folder";
    reaper.Undo_EndBlock(Undo,-1);
    reaper.PreventUIRefresh(-1);