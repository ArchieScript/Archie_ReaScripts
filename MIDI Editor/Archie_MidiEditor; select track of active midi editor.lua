--[[
   * Category:    MidiEditor
   * Description: MidiEditor; select track of active midi editor.lua
   * Oписание:    выберите трек активного midi editor
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.02
   * Customer:    BRG(Rmm)
   * Gave idea:   BRG(Rmm)
--====================================]]



    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    local MidiEditor = reaper.MIDIEditor_GetActive();
    if not MidiEditor then no_undo() return end 
    
    local take = reaper.MIDIEditor_GetTake(MidiEditor);
    if take then;
	   track = reaper.GetMediaItemTake_Track(take);
	   reaper.SetOnlyTrackSelected(track);
	   reaper.defer(function()reaper.SetMixerScroll(track)end);
    end;
    
    reaper.Main_OnCommand(40913,0);--Vertical scroll selected tracks into view
    
    no_undo();
    
    
    