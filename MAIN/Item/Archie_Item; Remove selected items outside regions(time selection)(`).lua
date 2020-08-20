--[[
   * Category:    Item
   * Description: Remove selected items outside regions(time selection)
   * Oписание:    Удалить выбранные объекты за пределами регионов(выбор времени)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Author:      Archie
   * Version:     1.02
   * customer:    PianoIst(RMM Forum)
   * gave idea:   PianoIst(RMM Forum)
--=================================================]]



     local TimeSel = 1
                  -- = 0 Выключить выбор времени
                  -- = 1 Включить выбор времени
                                       --------
                  -- = 0 Disable time selection
                  -- = 1 Enable time selection
                  ----------------------------



    --===========================================================================
    --////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local CountSelItem = reaper.CountSelectedMediaItems( 0 )
    if CountSelItem == 0 then no_undo() return end


    reaper.AddProjectMarker(0,1,   -10,    -9,"",11111)
    reaper.AddProjectMarker(0,1,100000,100001,"",22222)


    local _, _, num_regions = reaper.CountProjectMarkers( 0 )
    if num_regions == 0 then no_undo() return end



    local rgpos,rgnend = {},{}
    local retval,isrgn,name,rgnindenumb,color,undo

    for i = 1, num_regions do
        retval     ,
        isrgn      ,
        rgpos[i]   ,
        rgnend[i]  ,
        name       ,
        rgnindenumb,
        color      =
        reaper.EnumProjectMarkers3( 0, i-1 )
    end
    ---

    local start, finish = reaper.GetSet_LoopTimeRange(false,false,0,0,false)
    if tonumber(TimeSel)then
       if TimeSel == 0 then start = finish end
    end


    -- SplitReg
    for i = CountSelItem-1,0,-1 do
        local SelItem = reaper.GetSelectedMediaItem( 0, i )
        local posIt = reaper.GetMediaItemInfo_Value( SelItem, "D_POSITION" )
        local endIt = posIt + reaper.GetMediaItemInfo_Value( SelItem, "D_LENGTH" )
        ----
        for i2 = #rgpos,1,-1 do
            ----
            if start ~= finish then
                ----
                if posIt <= rgnend[i2]and endIt > rgnend[i2] then
                    if rgnend[i2] < finish and rgnend[i2] > start then
                        reaper.SplitMediaItem( SelItem, rgnend[i2] )
                    end
                end
                ---
                if posIt <= rgpos[i2] and endIt >  rgpos[i2] then
                    if rgpos[i2] < finish and rgpos[i2] > start then
                        reaper.SplitMediaItem( SelItem, rgpos[i2] )
                    end
                end
                ---
            else
                if posIt <= rgnend[i2]and endIt > rgnend[i2] then
                    reaper.SplitMediaItem( SelItem, rgnend[i2] )
                end
                if posIt <= rgpos[i2] and endIt >  rgpos[i2] then
                    reaper.SplitMediaItem( SelItem, rgpos[i2] )
                end
            end
        end
    end
    ---


    -- SplitTimeSel
    if start ~= finish then
        local CountSelItem = reaper.CountSelectedMediaItems( 0 )
        for i = CountSelItem-1,0,-1 do
            local SelItem = reaper.GetSelectedMediaItem( 0, i )
            local posIt = reaper.GetMediaItemInfo_Value( SelItem, "D_POSITION" )
            local endIt = posIt + reaper.GetMediaItemInfo_Value( SelItem, "D_LENGTH" )
            ----
            if posIt < finish and endIt > finish then
                for i2 = #rgpos,1,-1 do
                    if rgnend[i2] <= finish and  rgpos[i2+1] >= finish then
                        reaper.SplitMediaItem( SelItem, finish )
                        break
                    end
                end
            end
            if posIt < start and endIt > start then
                for i2 = 1,#rgpos do
                    if start <= rgpos[i2] and rgnend[i2-1] <= start then
                        reaper.SplitMediaItem( SelItem, start )
                    end
                end
            end

        end
    end
    ---


    -- RemoveItems
    local CountTrack = reaper.CountTracks(0)
    for i = 1,CountTrack do
        local track = reaper.GetTrack(0, i-1)
        local CountTrItem = reaper.CountTrackMediaItems(track)
        for i2 = CountTrItem-1,0,-1 do
            local TrItem = reaper.GetTrackMediaItem(track, i2)
            if reaper.IsMediaItemSelected(TrItem)== true then
                local posIt = reaper.GetMediaItemInfo_Value(TrItem, "D_POSITION")
                local endIt = posIt + reaper.GetMediaItemInfo_Value(TrItem, "D_LENGTH")
                ---
                if start ~= finish then
                    ---
                    if posIt >= start and endIt <= finish then
                        for i3 = #rgpos,1,-1 do
                            if posIt >= rgnend[i3]and  endIt <= rgpos[i3+1] then
                                reaper.DeleteTrackMediaItem(track, TrItem)
                                undo = 1
                                break
                            end
                        end
                    end
                else
                    for i3 = #rgpos,1,-1 do
                        if posIt >= rgnend[i3]and  endIt <= rgpos[i3+1] then
                            reaper.DeleteTrackMediaItem(track, TrItem)
                            undo = 1
                            break
                        end
                    end
                end
            end
        end
    end
    reaper.DeleteProjectMarker( 0,11111, true )
    reaper.DeleteProjectMarker( 0,22222, true )

    if undo == 1 then
        local name_script =
        "Remove selected items outside regions(time selection)"
        reaper.Undo_BeginBlock()
        reaper.Undo_EndBlock(name_script,1)
    else
        no_undo()
    end
    reaper.UpdateArrange()