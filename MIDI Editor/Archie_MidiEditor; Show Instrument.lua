--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Midi Editor
   * Description: Show Instrument
   * Author:      Archie
   * Version:     1.0
   * Описание:    Показать инструмент
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Darek(Rmm)
   * Gave idea:   Darek(Rmm)
   * Extension:   Reaper 6.02+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.0 [09.01.2020]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    local MidiEditor = reaper.MIDIEditor_GetActive();
    if not MidiEditor then no_undo() return end;
    
    
    local Take = reaper.MIDIEditor_GetTake(MidiEditor);
    if not Take then no_undo() return end;
    
    
    local Item = reaper.GetMediaItemTake_Item(Take);
    if not Item then no_undo() return end;
    
    local Track = reaper.GetMediaItemTrack(Item);
    
    local Instrument = reaper.TrackFX_GetInstrument(Track);
    if Instrument < 0 then no_undo() return end;
    
    
    reaper.Undo_BeginBlock();
    
    reaper.TrackFX_SetOpen(Track,Instrument,true);
    
    reaper.Undo_EndBlock("Show Instrument",-1);
    