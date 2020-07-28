--[[ 
   * Category:    FX 
   * Description: Open first instrument in Selected tracks 
   * Oписание:    Открыть первый инструмент в выбранных дорожках 
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
    if CountSeTrack == 0 then no_undo() return end 
  
    local x = 0 
    for i = 1,CountSeTrack do  
  
        local track = reaper.GetSelectedTrack(0, i - 1)  
        local instrument = reaper.TrackFX_GetInstrument( track )  
        
        if instrument > -1 then   
            x = x + 1 
        end     
          
        reaper.TrackFX_Show( track, instrument, 3)  
         
    end  
      
    if x == 0 then no_undo() return end 
      
    reaper.Undo_BeginBlock()   
    reaper.Undo_EndBlock('Open'..' '..x..' '..'instrument',1) 
      
 