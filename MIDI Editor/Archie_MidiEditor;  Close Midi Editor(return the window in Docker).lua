--[[
   * Category:    MidiEditor
   * Description: Close Midi Editor(return the window in Docker)
   * Oписание:    Закрыть редактор Midi(вернуть окно в докер)
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
    
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context()
    local toggle_state = reaper.GetToggleCommandStateEx(sectionID, 40018)
    if toggle_state == 0 then                                        
	  reaper.MIDIEditor_OnCommand(MidiEditor,40018)--Options: Toggle window docking
    end
    ---
    reaper.MIDIEditor_OnCommand( MidiEditor, 40794 )--View: Toggle show MIDI editor windows

    
    reaper.Undo_BeginBlock()
    reaper.Undo_EndBlock( "Close Midi Editor(return the window in Docker)", 1 ) 
 



