--[[
   * Category:    MidiEditor
   * Description: Close Midi Editor
   * Oписание:    Закрыть редактор Midi
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    ---
   * gave idea:   ---
--====================================]]



    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------
    
    
    
    local MidiEditor = reaper.MIDIEditor_GetActive()
    if not MidiEditor then no_undo() return end 
	   
    reaper.MIDIEditor_OnCommand( MidiEditor, 40794 )--View: Toggle show MIDI editor windows
    
    reaper.Undo_BeginBlock()
    reaper.Undo_EndBlock( "Close Midi Editor", 1 ) 


 
    
    
    

