--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Midi Editor
   * Description: Set note ends to start of next note (legato) - All notes
   * Author:      Archie
   * Version:     1.0
   * Описание:    Установить конец ноты в начала следующей ноты (легато) - Все ноты
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    shuco(RMM)
   * Gave idea:   shuco(RMM)
   * Extension:   Reaper 6.2+ http://www.reaper.fm/
   * Changelog:   v.1.0 [10.01.2020]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local MIDIEditor_Act = reaper.MIDIEditor_GetActive();
    if not MIDIEditor_Act then no_undo()return end;
    
    
    -------------------
    local take = reaper.MIDIEditor_GetTake(MIDIEditor_Act);
    local item = reaper.GetMediaItemTake_Item(take);
    
    local item_pos = reaper.GetMediaItemInfo_Value(item,'D_POSITION');
    local item_len = reaper.GetMediaItemInfo_Value(item,'D_LENGTH');
    
    local Source = reaper.GetMediaItemTake_Source(take);
    local ret_len, lengthIsQN = reaper.GetMediaSourceLength(Source);
    if not lengthIsQN then no_undo()return end;
    local Source_len_Time = reaper.TimeMap_QNToTime(ret_len);
    
    local strtOffs = reaper.GetMediaItemTakeInfo_Value(take,"D_STARTOFFS");
    local playRate = reaper.GetMediaItemTakeInfo_Value(take, "D_PLAYRATE");
    local End_Src_Time = ((Source_len_Time - strtOffs)/playRate)+item_pos;
    
    if End_Src_Time > item_pos+item_len then End_Src_Time = item_pos+item_len end;
    local End_Src_PPQ = reaper.MIDI_GetPPQPosFromProjTime(take,End_Src_Time);
    -------------------
    
    -------------------
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    -------------------
    
    -------------------
    for i = ({reaper.MIDI_CountEvts(take)})[2]-1,0,-1 do;
        local retval,selected,muted,startppqpos,endppqpos,chan,pitch,vel = reaper.MIDI_GetNote(take,i);
        if startppqpos >= End_Src_PPQ-3 and endppqpos < End_Src_PPQ+3 then;
            reaper.MIDI_DeleteNote(take,i);
        elseif startppqpos < End_Src_PPQ-3 then;
            break;
        end;
    end;
    -------------------
    
    -------------------
    local t = {};
    local tSel = {};
    for i = 1,({reaper.MIDI_CountEvts(take)})[2] do;
        local retval,selected,muted,startppqpos,endppqpos,chan,pitch,vel = reaper.MIDI_GetNote(take,i-1);
        ---
        tSel[i-1] = selected;
        ---
        if not t[pitch] then;
            reaper.MIDI_InsertNote(take,true,1,End_Src_PPQ-1,End_Src_PPQ,1,pitch,1,true);
        end;
        t[pitch] = true;
    end;
    -------------------
    
    -------------------
    reaper.MIDIEditor_OnCommand(MIDIEditor_Act,40214);--Unselect all
    reaper.MIDIEditor_OnCommand(MIDIEditor_Act,40003);--Edit: Select all notes
    reaper.MIDIEditor_OnCommand(MIDIEditor_Act,40405);--Set note ends to start of next note (legato)
    -------------------
     
    -------------------
    for i = ({reaper.MIDI_CountEvts(take)})[2]-1,0,-1 do;
        local retval,selected,muted,startppqpos,endppqpos,chan,pitch,vel = reaper.MIDI_GetNote(take,i);
        if startppqpos >= End_Src_PPQ-3 and endppqpos < End_Src_PPQ+3 then;
            reaper.MIDI_DeleteNote(take,i);
        elseif endppqpos > End_Src_PPQ-3 and endppqpos < End_Src_PPQ+3 then;
            reaper.MIDI_SetNote(take,i,selected,muted,startppqpos,End_Src_PPQ,chan,pitch,vel,true);
        end;
    end;
    -------------------
    
    reaper.MIDIEditor_OnCommand(MIDIEditor_Act,40214);--Unselect all
    
    -------------------
    for i = 0, #tSel do;
        if tSel[i] == true then;
            local retval,selected,muted,startppqpos,endppqpos,chan,pitch,vel = reaper.MIDI_GetNote(take,i);
            reaper.MIDI_SetNote(take,i,tSel[i],muted,startppqpos,endppqpos,chan,pitch,vel,true);
        end;
    end;
    -------------------
    
    
    -------------------
    reaper.MIDI_Sort(take);
    -------------------
    
    -------------------
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("Set note ends to start of next note (legato) - All notes",-1);
    -------------------