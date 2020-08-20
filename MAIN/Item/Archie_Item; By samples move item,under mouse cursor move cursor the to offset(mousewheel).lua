--[[
   * Category:    Item
   * Description: By samples move item,under mouse cursor move cursor the to offset(mousewheel)
                                        (for convenience, assigned to the mouse wheel)
   * Oписание:    По образцам перемещайте элемент, под курсором мыши перемещайте курсор к смещению
                                               (для удобства назначается на колесо мыши)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Author:      Archie
   * Version:     1.02
   * customer:    zookthespook(Cocos forum)
   * gave idea:   zookthespook(Cocos forum) http://forum.cockos.com/showpost.php?p=2324839&postcount=48
--==========================================]]



    --======================================================================================
    --////////////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --======================================================================================


    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local window, segment, details = reaper.BR_GetMouseCursorContext();
    local item = reaper.BR_GetMouseCursorContext_Item();
    if not item then no_undo()return end;


    for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do;
        local it = reaper.GetSelectedMediaItem(0,i);
        reaper.SetMediaItemSelected(it,0);
    end


    reaper.SetMediaItemSelected(item,1);


    local item_pos = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
    local Snap = reaper.GetMediaItemInfo_Value(item,'D_SNAPOFFSET');


    local ripplePerTrack = reaper.GetToggleCommandState(40310);
                                  --Set ripple editing per-track
    local rippleAllTracks = reaper.GetToggleCommandState(40311);
                                  --Set ripple editing all tracks


    local _, _, _, _, _, _, val = reaper.get_action_context();


    local RS = 1/reaper.GetSetProjectInfo(0,'PROJECT_SRATE',0,0);

    if val > 0 then;
        reaper.SetMediaItemPosition(item,item_pos+RS,true);
        reaper.SetEditCurPos(item_pos+Snap+RS,false,false);
    else;
        reaper.SetMediaItemPosition(item,item_pos-RS,true);
        reaper.SetEditCurPos(item_pos+Snap-RS,false,false);
    end;


    if rippleAllTracks == 0 and ripplePerTrack == 1 then;

       local it_track = reaper.GetMediaItem_Track(item);
       local CountTrItem = reaper.CountTrackMediaItems(it_track);

       for i = CountTrItem-1,0,-1 do;

           local item2 = reaper.GetTrackMediaItem(it_track,i);
           local item_pos2 = reaper.GetMediaItemInfo_Value(item2,"D_POSITION");

           if item2 ~= item then;

               if item_pos2 >= item_pos then;

                   if val > 0 then;
                      reaper.SetMediaItemPosition(item2,item_pos2+RS,true);

                   else;
                       reaper.SetMediaItemPosition(item2,item_pos2-RS,true);
                   end;
               end;
           end;
       end;
    end;


    if rippleAllTracks == 1 and ripplePerTrack == 0 then;

       local CountItems = reaper.CountMediaItems(0);
       for i = CountItems-1,0,-1 do;

           local item2 = reaper.GetMediaItem(0,i);
           local item_pos2 = reaper.GetMediaItemInfo_Value(item2,"D_POSITION");

           if item2 ~= item then;

               if item_pos2 >= item_pos then;

                   if val > 0 then;
                       reaper.SetMediaItemPosition(item2,item_pos2+RS,true);
                   else;
                      reaper.SetMediaItemPosition(item2,item_pos2-RS,true);
                   end;
               end;
           end;
       end;
    end;
    reaper.UpdateArrange();
    no_undo();
