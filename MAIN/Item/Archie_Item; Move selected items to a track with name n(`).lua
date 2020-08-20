--[[
   * Category:    Item
   * Description: Move selected items to a track with name "n"
   * Oписание:    Переместить выбранные элементы на дорожку с именем "n"
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Author:      Archie
   * Version:     1.02
   * customer:    Maestro Sound[RMM Forum]
   * gave idea:   Maestro Sound[RMM Forum]
--=======================================]]



    local NameTrack = 1
                 -- = 1 Показать окно для ввода имени трека,
                 --  Или введите имя трека
                 --  Например: NameTrack = "Drums"



    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local name_script = [[Move selected items to a track with name "n"]]
    local CountSelItem = reaper.CountSelectedMediaItems( 0 )
    if CountSelItem == 0 then no_undo() return end

    local retval, retvals_csv,desttr,par_ID,Undo
    if not NameTrack then NameTrack = 1 end

    if NameTrack == 1 then
          retval, retvals_csv = reaper.GetUserInputs( "Move selected items to a track with name 'n'", 1,
                                        "                Name track:,extrawidth=40", "Name_Track" )
        if retval == false then no_undo() return end
    else
        retvals_csv = NameTrack
    end

    local CountTrack = reaper.CountTracks( 0 )
    for i = 1,CountTrack do
        local track = reaper.GetTrack(0,i-1)
        local retval, stringNeedBig = reaper.GetSetMediaTrackInfo_String( track, "P_NAME", "", 0 )
        if stringNeedBig == retvals_csv then
            par_ID =  reaper.CSurf_TrackToID( track, true )
            desttr = reaper.CSurf_TrackFromID( par_ID, true )
            break
        end
    end


    if par_ID and desttr then
        for i = 1,CountTrack do
            local track = reaper.GetTrack(0,i-1)
            local CountTrItem = reaper.CountTrackMediaItems( track )
            for i = CountTrItem-1,0,-1 do
                local item = reaper.GetTrackMediaItem( track, i )
                local sel = reaper.GetMediaItemInfo_Value( item, "B_UISEL" )
                if sel == 1 then
                    reaper.MoveMediaItemToTrack( item,desttr)
                    Undo = 1
                end
            end
        end
    end

    if Undo == 1 then
        reaper.Undo_BeginBlock()
        reaper.Undo_EndBlock(name_script,1)
    else
        no_undo()
    end

    reaper.UpdateArrange()


