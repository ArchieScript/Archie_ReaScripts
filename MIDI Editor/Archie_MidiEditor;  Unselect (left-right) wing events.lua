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
   *              [main=midi_editor] . > Archie_MidiEditor;  Unselect left wing events.lua
   *              [main=midi_editor] . > Archie_MidiEditor;  Unselect right wing events.lua
   * Changelog:   
   *              +  initialе / v.1.0 [12042019]
   
   
   -- Тест только на windows  /  Test only on windows.
   --=======================================================================================
   --    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
   (+) - required for installation      | (+) - обязательно для установки
   (-) - not necessary for installation | (-) - не обязательно для установки
   -----------------------------------------------------------------------------------------
   (+) Reaper v.5.967 +           --| http://www.reaper.fm/download.php                     
   (-) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                
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
    local ScriptName_1 = "Archie_MidiEditor;  Unselect left wing events.lua";
    local ScriptName_2 = "Archie_MidiEditor;  Unselect right wing events.lua";
    
    
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
    local retval,count_notes,ccs,sysex = reaper.MIDI_CountEvts(Take);
    if count_notes == 0 then --[[Arc.no_undo()]] return end;
    
    
    if ScriptName == ScriptName_2 then;
        for i = count_notes-1,0,-1 do;
            _,sel_,_,_,endppq_,_,_,_ = reaper.MIDI_GetNote(Take,i);
            if sel_ then;
                 break;
            end;
        end;
    elseif ScriptName == ScriptName_1 then;
        for i = 1, count_notes do;
            _,sel_,_,_startppq_,_,_,_,_ = reaper.MIDI_GetNote(Take,i-1);
            if sel_ then;
                 break;
            end;
        end;
    end;
    
    
    for i = count_notes-1,0,-1 do;
        local
        retval,sel,muted,startppq,endppq,chan,pitch,vel = reaper.MIDI_GetNote(Take,i);
        if sel then;
            if ScriptName == ScriptName_2 then;
                if endppq == endppq_ then;
                    reaper.MIDI_SetNote(Take,i,false--[[sel]],muted,startppq,endppq,chan,pitch,vel,false);
                end;
            elseif ScriptName == ScriptName_1 then;    
                if startppq == _startppq_ then;
                    reaper.MIDI_SetNote(Take,i,false--[[sel]],muted,startppq,endppq,chan,pitch,vel,false);
                end;
            end; 
        end;
    end;