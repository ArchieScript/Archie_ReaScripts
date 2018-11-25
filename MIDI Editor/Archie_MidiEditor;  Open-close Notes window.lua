--[[
   * Category:    MidiEditor
   * Description: Open-close Notes window
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Open-close Notes window
   * О скрипте:   Открыть-закрыть окно заметок
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Martin111(Rmm/forum)
   * Gave idea:   Martin111(Rmm/forum)
   * Changelog:   +  initialе / v.1.0
--===========================================================]]



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local ActiveMIDIEditor = reaper.MIDIEditor_GetActive()
    if not ActiveMIDIEditor then no_undo() return end


    local command_id = reaper.NamedCommandLookup("_S&M_SHOW_NOTES_VIEW")
    reaper.Main_OnCommand(command_id,0)
    no_undo()