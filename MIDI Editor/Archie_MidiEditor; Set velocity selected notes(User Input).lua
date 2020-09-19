--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    MidiEditor
   * Description: MidiEditor; Set velocity selected notes(User Input).lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Supa75(---)
   * Gave idea:   Supa75(---)
   * Extension:   
   *              Reaper 6.14+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.0 [190820]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then A.no_undo()return;end;return A;
    end;local Arc=MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    local ArcFileIni = reaper.GetResourcePath():gsub('\\','/')..'/reaper-Archie.ini';
    --=========================================
    
     
    local midieditor = reaper.MIDIEditor_GetActive();
    if not midieditor then no_undo()return end;
    
    
    local prevVel;
    local t = {};
    
    local take = reaper.MIDIEditor_GetTake(midieditor);
    local _,notecnt,_,_ = reaper.MIDI_CountEvts(take);
    for i = 1,notecnt do;
        local retval,sel,mut,startppqpos,endppqpos,chan,pitch,vel = reaper.MIDI_GetNote(take,i-1);
        if sel == true and not prevVel then prevVel = vel end;
        
        if sel == true then;
            t[i]={};
            t[i][1]=sel;
            t[i][2]=mut;
            t[i][3]=startppqpos;
            t[i][4]=endppqpos;
            t[i][5]=chan;
            t[i][6]=pitch;
            t[i][7]=vel;
        end;
    end;
    
    
    if not prevVel then no_undo()return end;
     
    local retval,retvals_csv = reaper.GetUserInputs('Set velocity selected notes',1,'New velocity (0 - 127):',prevVel);
    
    if not retval then no_undo()return end;
    
    retvals_csv = tonumber(retvals_csv);
    
    if not retvals_csv then no_undo()return end;
    
    retvals_csv = math.abs(retvals_csv);
    
    if retvals_csv > 127 then retvals_csv = 127 end;
    
    
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    
    for key,val in pairs(t)do;
        reaper.MIDI_SetNote(take,key-1,t[key][1],t[key][2],t[key][3],t[key][4],t[key][5],t[key][6],retvals_csv,true);
    end;
    
    reaper.MIDI_Sort(take);
    
    reaper.Undo_EndBlock('Set velocity selected notes',-1);
    reaper.PreventUIRefresh(-1);
    reaper.UpdateArrange();
    
    