--[[
   * Category:    Item
   * Description: Move selected items up one track   
   * Author:      Archie   
   * Version:     1.0
   * AboutScript: Move selected items up one track 
   * О скрипте:   Переместить выбранные элементы на одну дорожку вверх 
   * GIF:         http://clck.ru/Eddx2
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628   
   * customer:    Maestro Sound[RMM Forum] 
   * gave idea:   Maestro Sound[RMM Forum] 
   * Changelog:   + initialе / v.1.0  
--=======================================]]  

 
 
    local HowMuchUp = 1
                -- = Введите значение на сколько треков вверх переместить элементы
                -- = Enter a value on how many tracks move elements up
    
    
    
    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------


    
    local CountSelItem = reaper.CountSelectedMediaItems( 0 )
    if CountSelItem == 0 then no_undo() return end
    
    
    local HowMuchUp,Undo = tonumber(HowMuchUp)
    if not tonumber(HowMuchUp) or HowMuchUp < 1 then HowMuchUp = 1 end 
    
    local CountTrack = reaper.CountTracks(0)
    for i = 1,CountTrack do
        local track = reaper.GetTrack(0,i-1)
        local Numb = reaper.GetMediaTrackInfo_Value( track, "IP_TRACKNUMBER") 
       
        local CountTrItem = reaper.CountTrackMediaItems(track)
        for i2 = CountTrItem-1,0,-1 do
            local item = reaper.GetTrackMediaItem(track,i2)
            local sel = reaper.GetMediaItemInfo_Value(item,"B_UISEL")
            if sel == 1 then
                local Up_track = reaper.GetTrack(0,Numb-1-HowMuchUp)
                if Up_track then
                    reaper.MoveMediaItemToTrack( item,Up_track)
                    Up_track = nil
                    Undo = 1
                end 
            end
        end
    end    
    
    if Undo == 1 then
        reaper.Undo_BeginBlock()   
        reaper.Undo_EndBlock("Move selected items up "..HowMuchUp.." track",-1)
    else
        no_undo()
    end  
    reaper.UpdateArrange()

 
