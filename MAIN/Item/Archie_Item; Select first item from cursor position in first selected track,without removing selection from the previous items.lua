--[[
   * Category:    Item
   * Description: Select first item from cursor position in first selected track,
                              without removing selection from the previous items
   * Oписание:    Выбрать первый элемент от позиции курсора в первом выбранном
                              треке,не снимая выделения с предыдущих элементов
   * GIF:         http://goo.gl/j8Kh4U
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Author:      Archie
   * Version:     1.02
   * customer:    ---
   * gave idea:   HDVulcan(RMM Forum)
--==========================================]]



    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local SelTrack = reaper.GetSelectedTrack( 0, 0 )
    if not SelTrack then no_undo() return end



    local CountTrItem = reaper.CountTrackMediaItems( SelTrack )
    if CountTrItem > 0 then
        local Cur = reaper.GetCursorPosition()
        for i = 1,CountTrItem do
            local Tr_item =  reaper.GetTrackMediaItem( SelTrack, i-1 )
            local pos = reaper.GetMediaItemInfo_Value( Tr_item, 'D_POSITION' )
            if pos >= Cur   then
                reaper.SetMediaItemSelected( Tr_item, 1 )
                undo = 1
                break
            end
        end
    end

    if undo == 1 then
        reaper.Undo_BeginBlock()
        reaper.Undo_EndBlock( [[Select first item from cursor
                              position in first selected track]],-1)
    else
        no_undo()
    end
    reaper.UpdateArrange()
