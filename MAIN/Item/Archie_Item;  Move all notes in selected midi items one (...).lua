--[[
   * Category:    Item
   * Description: Move all notes in selected midi items one (...)
   * Author:      Archie
   * Version:     1.0
   * AboutScript: ---
   * О скрипте:   переместить все ноты в выбранных midi элементах на один (...)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Krikets(Rmm/forum) 
   * Gave idea:   Krikets(Rmm/forum)
   * Provides:    
   *              [main] . > Archie_Item;  Move all notes in selected midi items one octave down.lua
   *              [main] . > Archie_Item;  Move all notes in selected midi items one octave up.lua
   *              [main] . > Archie_Item;  Move all notes in selected midi items one semitone down.lua
   *              [main] . > Archie_Item;  Move all notes in selected midi items one semitone up.lua
   * Changelog:   
   *              v.1.0[27.07.19]
   *                  + initialе

    -- Тест только на windows  /  Test only on windows.
    --=======================================================================================
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
    (+) - required for installation      | (+) - обязательно для установки
    (-) - not necessary for installation | (-) - не обязательно для установки
    -----------------------------------------------------------------------------------------
    (+) Reaper v.5.981 +            --| http://www.reaper.fm/download.php
    (-) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php
    (-) ReaPack v.1.2.2 +           --| http://reapack.com/repos
    (-) Arc_Function_lua v.2.4.4 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]] 



    --=========================================================================================
    --/////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\\\
    --=========================================================================================



    ------------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end;
    ------------------------------------------------------------------------------
    
    
    local ScrName = {
                     "Archie_Item;  Move all notes in selected midi items one octave down.lua",
                     "Archie_Item;  Move all notes in selected midi items one octave up.lua",
                     "Archie_Item;  Move all notes in selected midi items one semitone down.lua",
                     "Archie_Item;  Move all notes in selected midi items one semitone up.lua"
                    };
    
    
    local nameScript = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)");
    if     nameScript == ScrName[1] then semitone = -12;
    elseif nameScript == ScrName[2] then semitone =  12;
    elseif nameScript == ScrName[3] then semitone =  -1;    
    elseif nameScript == ScrName[4] then semitone =   1;
    end;
    
    
    if not semitone then;
        reaper.MB(
                  "Rus:\n\nНеверное Имя Скрипта!\nИмя скрипта должно быть одно из следующих **\n\n\n\n"..
                  "Eng:\n\nInvalid Script Name!\nThe script name must be one of the following **\n\n\n\n**\n"..
                  table.concat(ScrName,"\n")
                  ,"ERROR",0);
        no_undo() return;
    end;
    
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo() return end;
    
    
    local retval   = {};
    local sel      = {};
    local mute     = {};
    local startppq = {};
    local endppq   = {};
    local chan     = {};
    local pitch    = {};
    local vel      = {};
    local Undo_BegBlock;
    
    

    for i = 1,CountSelItem do;
        local SelItem = reaper.GetSelectedMediaItem(0,i-1);
        local ActiveTake = reaper.GetActiveTake(SelItem);
        local midiTake = reaper.TakeIsMIDI(ActiveTake);
        if midiTake then;
            
            local ret,notecnt,ccevtcnt,textsyxevtcnt = reaper.MIDI_CountEvts(ActiveTake);
            for i2 = notecnt-1,0,-1 do;
                local _,_,_,_,_,_,Pitch,_ = reaper.MIDI_GetNote(ActiveTake,i2);
                if semitone > 0 then;
                    if Pitch > 127-semitone then goto END_LOOP_goto end;
                else;
                    if Pitch < math.abs(semitone)then goto END_LOOP_goto end;
                end;
            end;
            
            for i3 = notecnt-1,0,-1 do;
               retval  [i3],
               sel     [i3],
               mute    [i3],
               startppq[i3],
               endppq  [i3],
               chan    [i3],
               pitch   [i3],
               vel     [i3] = reaper.MIDI_GetNote(ActiveTake,i3);
               reaper.MIDI_DeleteNote(ActiveTake,i3);
            end;
            
            for i3 = notecnt-1,0,-1 do;
                reaper.MIDI_InsertNote(ActiveTake,
                                       sel     [i3],
                                       mute    [i3],
                                       startppq[i3],
                                       endppq  [i3],
                                       chan    [i3],
                                       pitch   [i3]+semitone,
                                       vel     [i3],
                                              true);
            end;
            reaper.MIDI_Sort(ActiveTake);
            if not Undo_BegBlock then;
                reaper.Undo_BeginBlock();
                Undo_BegBlock = true;
            end;
        end;
        ::END_LOOP_goto::;
    end;
    
    reaper.UpdateArrange();
    
    if Undo_BegBlock then;
        reaper.Undo_EndBlock(nameScript:match(".-Archie_Item;%s-(.+)%.lua"),-1);
    else;
        no_undo();
    end;