--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    MidiEditor
   * Description: MidiEditor; Set selected notes velocity to(n).lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Provides:    
   *              [nomain] .
   *              [main] . > Archie_MidiEditor; Set selected notes velocity to 0.lua
   *              [main] . > Archie_MidiEditor; Set selected notes velocity to 10.lua
   *              [main] . > Archie_MidiEditor; Set selected notes velocity to 20.lua
   *              [main] . > Archie_MidiEditor; Set selected notes velocity to 30.lua
   *              [main] . > Archie_MidiEditor; Set selected notes velocity to 40.lua
   *              [main] . > Archie_MidiEditor; Set selected notes velocity to 50.lua
   *              [main] . > Archie_MidiEditor; Set selected notes velocity to 60.lua
   *              [main] . > Archie_MidiEditor; Set selected notes velocity to 70.lua
   *              [main] . > Archie_MidiEditor; Set selected notes velocity to 80.lua
   *              [main] . > Archie_MidiEditor; Set selected notes velocity to 90.lua
   *              [main] . > Archie_MidiEditor; Set selected notes velocity to 100.lua
   *              [main] . > Archie_MidiEditor; Set selected notes velocity to 110.lua
   *              [main] . > Archie_MidiEditor; Set selected notes velocity to 120.lua
   *              [main] . > Archie_MidiEditor; Set selected notes velocity to 127.lua
   * Extension:   
   *              Reaper 6.07+ http://www.reaper.fm/
   *              ReaPack v.1.2.2 +  http://reapack.com/repos
   * Changelog:   
   *              v.1.0 [030420]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
     
    ---------------------------------------------------------------
    local scriptPath,scriptName = debug.getinfo(1,'S').source:match("^@(.+)[/\\](.+)");
    local VELOCITY = tonumber(scriptName:match("^.-(%d+)%s-.lua"));
    if not VELOCITY or VELOCITY > 127 then VELOCITY = 127 end;
    ---------------------------------------------------------------
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------


    local midieditor = reaper.MIDIEditor_GetActive();
    if not midieditor then no_undo()return end;

    local UNDO;
    local take = reaper.MIDIEditor_GetTake(midieditor);
    local _,notecnt,_,_ = reaper.MIDI_CountEvts(take);
    for i = 1,notecnt do;
        local retval,sel,mut,startppqpos,endppqpos,chan,pitch,vel = reaper.MIDI_GetNote(take,i-1);
        if sel == true and vel ~= VELOCITY then;
            if not UNDO then;
                reaper.Undo_BeginBlock();
                reaper.PreventUIRefresh(1);
                UNDO = true;
            end;
            reaper.MIDI_SetNote(take,i-1,sel,mut,startppqpos,endppqpos,chan,pitch,VELOCITY,true); 
        end;
    end;
    reaper.MIDI_Sort(take);
    
    if UNDO then;
        reaper.Undo_EndBlock('Set selected notes velocity to '..VELOCITY,-1);
        reaper.PreventUIRefresh(-1);
    else;
        no_undo();
    end;
    
    reaper.UpdateArrange();