--[[
   * Category:    FX
   * Description: Open all VSTi in Selected tracks
   * Oписание:    Открыть все VSTi в выбранных дорожках
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
    
    
     
    ------------------------------------------------------------s-----------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------
   
   
    local CountSeTrack = reaper.CountSelectedTracks( 0 )
    if CountSeTrack == 0 then no_undo() return end
    
    local instrument , x = false, 0      
    
    for i = 1,CountSeTrack do
        
        local track = reaper.GetSelectedTrack(0, i - 1) 
        local FXCount = reaper.TrackFX_GetCount( track )
        
        for i2 = 1,FXCount do  
                                  
            local retval,buf = reaper.TrackFX_GetFXName(track, i2-1,"")
            if buf:match('^VSTi')then 
                instrument = true else instrument = false
            end
            
            if instrument == true then 
                reaper.TrackFX_Show( track, i2-1, 3 )
                x = x + 1
            end  
            
        end      
    end  
   
    if x == 0 then no_undo() return end
    
    reaper.Undo_BeginBlock() 
    reaper.Undo_EndBlock('Open'..' '..x..' '..'instrument',1)
    
    
    
