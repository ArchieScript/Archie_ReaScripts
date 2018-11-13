--[[
   * Category:    MIDIEditor
   * Description: Open a floating instrument, appropriate MIDI editor
   * Oписание:    Открыть плавающий инструмент, соответствующий MIDI-редактору
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    ---
   * gave idea:   ---
--========================================================]] 


 
     --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================


	
    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------
    
    

    local MidiEditor = reaper.MIDIEditor_GetActive()
    if not MidiEditor then no_undo() return end
    
    local Take = reaper.MIDIEditor_GetTake(MidiEditor)
    if not Take then no_undo() return end
    
    local Take_Track = reaper.GetMediaItemTake_Track(Take)
    
    local FirstInstrument = reaper.TrackFX_GetInstrument(Take_Track)
    if FirstInstrument >= 0 then 
         reaper.TrackFX_Show(Take_Track, FirstInstrument, 3) 
    end  
      
      
      
   
     
      
 
