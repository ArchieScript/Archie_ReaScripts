--[[
   * Category:    Item
   * Description: Move selected items Down one track
   * Author:      Archie   
   * Version:     1.0
   * AboutScript: Move selected items Down one track
   * О скрипте:   Переместить выбранные элементы на одну дорожку Вниз 
   * GIF:         http://clck.ru/Eddqc
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Maestro Sound[RMM Forum] 
   * Gave idea:   Maestro Sound[RMM Forum]
   * Changelog:   + initialе / v.1.0
--=======================================]] 

 
 
    local HowMuchDown = 1
                -- = Введите значение на сколько треков Вниз переместить элементы
                -- = Enter the value on how many tracks down move the items
    
    
    
    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------


    
    local CountSelItem = reaper.CountSelectedMediaItems( 0 )
    if CountSelItem == 0 then no_undo() return end
    
    
    local HowMuchDown,Undo = tonumber(HowMuchDown)
    if not tonumber(HowMuchDown) or HowMuchDown < 1 then HowMuchDown = 1 end 
    
    local CountTrack = reaper.CountTracks(0)
    for i = CountTrack-1,0,-1 do
        local track = reaper.GetTrack(0,i)
        local Numb = reaper.GetMediaTrackInfo_Value( track, "IP_TRACKNUMBER") 
       
        local CountTrItem = reaper.CountTrackMediaItems(track)
        for i2 = CountTrItem-1,0,-1 do
            local item = reaper.GetTrackMediaItem(track,i2)
            local sel = reaper.GetMediaItemInfo_Value(item,"B_UISEL")
            if sel == 1 then
                local Down_track = reaper.GetTrack(0,Numb-1+HowMuchDown)
                if Down_track then
                    reaper.MoveMediaItemToTrack( item,Down_track)
                    Up_track = nil
                    Undo = 1
                end 
            end
        end
    end    
    
    if Undo == 1 then
        reaper.Undo_BeginBlock()   
        reaper.Undo_EndBlock("Move selected items Down "..HowMuchDown.." track",-1)
    else
        no_undo()
    end  
    reaper.UpdateArrange()

 
