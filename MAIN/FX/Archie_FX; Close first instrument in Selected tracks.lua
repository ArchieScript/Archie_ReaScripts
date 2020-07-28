--[[ 
   * Category:    FX 
   * Description: Close first instrument in Selected tracks 
   * Oписание:    Закрыть первый инструмент в выбранных дорожках 
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   * Donation:    http://money.yandex.ru/to/410018003906628 
   * Author:      Archie 
   * Version:     1.0 
   * customer:    ---   
   * gave idea:   borisuperful(Rmm/forum) 
--==========================================]] 
 
 
   
    --=========================================================================== 
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\ 
    --=========================================================================== 
     
     
       
    ----------------------------------------------------------------------------- 
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end 
    -----------------------------------------------------------------------------   
     
     
    
    local CountSeTrack = reaper.CountSelectedTracks( 0 )  
    if CountSeTrack == 0 then no_undo()return end 
      
    local x = 0 
    for i = 1,CountSeTrack do  
     
        local track = reaper.GetSelectedTrack(0, i - 1)  
        local instrument = reaper.TrackFX_GetInstrument( track )  
        local FXOpen = reaper.TrackFX_GetOpen( track, instrument ) 
        if instrument == -1 then FXOpen = false end 
         
        if FXOpen == true and x == 0 then  
            reaper.Undo_BeginBlock()    
        end 
        
        if FXOpen == true then  
            x = x + 1 
        end   
        
        reaper.TrackFX_SetOpen( track, instrument, 0 )   
        
    end  
     
    if x == 0 then no_undo() return end 
     
    reaper.Undo_EndBlock('Open'..' '..x..' '..'instrument',1) 
    
 