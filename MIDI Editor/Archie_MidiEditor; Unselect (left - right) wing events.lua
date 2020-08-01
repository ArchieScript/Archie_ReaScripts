--[[
   * Category:    MidiEditor
   * Description: Unselect (left-right*) wing events
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Unselect (left-right*) wing events
   * О скрипте:   Отменить выбор (слева-справа*) событий миди
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Antibio[RMM]
   * Gave idea:   Antibio[RMM]
   * Provides:    
   *              [nomain] .
   *              [main=midi_editor] . > Archie_MidiEditor; Unselect left wing events.lua
   *              [main=midi_editor] . > Archie_MidiEditor; Unselect right wing events.lua
   * Changelog:   
   *              +  initialе / v.1.0 [12042019]
   
   
   -- Тест только на windows  /  Test only on windows.
   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                     
   (+) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                
   (-) ReaPack v.1.2.2 +          --| http://reapack.com/repos                              
   (-) Arc_Function_lua v.2.3.2 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
   (-) reaper_js_ReaScriptAPI     --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
   (-) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                
   =======================================================================================]]
    
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    
    
    ---------------------------------------------------------------
    local function no_undo();reaper.defer(function()return end)end;
    ---------------------------------------------------------------
    
    

    local ScriptName   = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)");
    local ScriptName_1 = "Archie_MidiEditor; Unselect left wing events.lua";
    local ScriptName_2 = "Archie_MidiEditor; Unselect right wing events.lua";
    
    
    if ScriptName ~= ScriptName_1 and ScriptName ~= ScriptName_2 then;
            reaper.MB("Rus:\n\n"..
                      " * Неверное имя скрипта !\n * Имя скрипта должно быть одно из следующих \n"..
                      "    в зависимости от задачи. \n\n\n"..
                      "Eng:\n\n * Invalid script name ! \n"..
                      " * The script name must be one of the following \n"..
                      "    depending on the task.\n"..
                      "-------\n\n\n"..
                      "Script Name: / Имя скрипта:\n\n"..ScriptName_1.."\n\n"..ScriptName_2,"ERROR !",0);
            no_undo() return;
    end;
    
    
    local MidiEditor = reaper.MIDIEditor_GetActive();
    if not MidiEditor then Arc.no_undo() return end;
    
    
    local Take = reaper.MIDIEditor_GetTake(MidiEditor);
    local count = ({reaper.MIDI_CountEvts(Take)})[2];
    if count == 0 then no_undo() return end;
    
    reaper.MIDIEditor_LastFocused_OnCommand(40659,false);
    
    local FNG_Take = reaper.FNG_AllocMidiTake(Take);
    local FNG_CountNotes = reaper.FNG_CountMidiNotes(FNG_Take);
    if FNG_CountNotes == 0 then no_undo() return end;
    
    
    local FNG_Note,Note_Sel,Note_Pos;
    if ScriptName == ScriptName_2 then;
        for i = FNG_CountNotes-1,0,-1 do;
            FNG_Note = reaper.FNG_GetMidiNote(FNG_Take, i);
            
            Note_Sel = reaper.FNG_GetMidiNoteIntProperty( FNG_Note,"SELECTED"); 
            
            Note_Pos = reaper.FNG_GetMidiNoteIntProperty( FNG_Note,"POSITION");
            
            if Note_Sel == 1 then;
                break;
            end;
        end;
    elseif ScriptName == ScriptName_1 then;
        for i = 1, FNG_CountNotes do;
            FNG_Note = reaper.FNG_GetMidiNote(FNG_Take, i-1);
            
            Note_Sel = reaper.FNG_GetMidiNoteIntProperty( FNG_Note,"SELECTED"); 
            
            Note_Pos = reaper.FNG_GetMidiNoteIntProperty( FNG_Note,"POSITION");
            
            if Note_Sel == 1 then;
                break;
            end;
        end;
    end;
    
    
    if Note_Sel == 1 then;
        reaper.Undo_BeginBlock()
        
        for i = FNG_CountNotes-1,0,-1 do;
        
            local FNG_Note2 = reaper.FNG_GetMidiNote(FNG_Take, i);
            local Note_Sel2 = reaper.FNG_GetMidiNoteIntProperty(FNG_Note2,"SELECTED");  
            local Note_Pos2 = reaper.FNG_GetMidiNoteIntProperty(FNG_Note2,"POSITION");
            if Note_Pos == Note_Pos2 then;
                
                if Note_Sel2 == 1 then;
                    reaper.FNG_SetMidiNoteIntProperty(FNG_Note2,"SELECTED",0);
                end;  
            end;
        end;
        
        reaper.Undo_EndBlock(ScriptName:gsub("Archie_MidiEditor;  ",""),-1)
    end;
    
    reaper.FNG_FreeMidiTake(FNG_Take);