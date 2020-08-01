--[[
   * Category:    Midi
   * Description: swing grid disable and reset(MIDI editor)
   * Oписание:    отключить и сбросить сетку качания(MIDI editor)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    Maestro Sound(RMM Forum)
   * gave idea:   Maestro Sound(RMM Forum)
--=================================================]]
    
    
    
    local straight = (1)
                     -- straight = 0 - Всегда устанавливать значение "straight"
                     -- straight = 1 - Установить значение "straight" 
                              -- только если активен "Swing"
                     --------------------------------------
                     
    
	
     --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================


   
    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------
    
    
 
    local function GetSetMIDIEditorGridSwing(isSet,MidiEditor,swingIn)
        local take = reaper.MIDIEditor_GetTake(MidiEditor)
        if tonumber(swingIn) and isSet == 1 then  
            reaper.PreventUIRefresh(951753) 
            local _,grid,swingOnOff,swing = reaper.GetSetProjectGrid(0,0)
            reaper.MIDIEditor_OnCommand( MidiEditor,41006)
            local MidiGrid = select(1,reaper.MIDI_GetGrid(take))
            reaper.GetSetProjectGrid(0,1,nil,1,nil) 
            local ToggleDivOn = reaper.GetToggleCommandState(42010)
            if ToggleDivOn == 0 then 
                reaper.Main_OnCommand(42010,0)
            end  --Grid: Use the same grid division in arrange view and MIDI editor 
            reaper.GetSetProjectGrid(0,1,nil,nil,swingIn)
            if ToggleDivOn ~= 1 then
                reaper.Main_OnCommand(42010,0)
                reaper.SetMIDIEditorGrid( 0, MidiGrid/4)
                reaper.GetSetProjectGrid(0,1,grid,swingOnOff,swing)  
            else
                reaper.GetSetProjectGrid(0,1,nil,swingOnOff,nil)
            end
            reaper.PreventUIRefresh(-951753)
        end    
        reaper.MIDIEditor_OnCommand( MidiEditor,41006)---
        local MidiGrid,MidiSwing,noteLen = reaper.MIDI_GetGrid(take)
        return MidiSwing --,MidiGrid,noteLen  
    end
    ---    
    
    
   
    
    local MIDIActive = reaper.MIDIEditor_GetActive()
    if not MIDIActive then no_undo() return end
    
    reaper.PreventUIRefresh(1)
    
    if reaper.GetToggleCommandStateEx(32060,41003)==1 then x = 41003 end
    if reaper.GetToggleCommandStateEx(32060,41004)==1 then x = 41004 end
    if reaper.GetToggleCommandStateEx(32060,41005)==1 then x = 41005 end
    if reaper.GetToggleCommandStateEx(32060,41006)==1 then x = 41006 end
    
    GetSetMIDIEditorGridSwing(1,MIDIActive,0)
    
    if straight ~= 1 then  
        reaper.MIDIEditor_OnCommand( MIDIActive,41003)
    else   
        if x ~= 41006 then 
            reaper.MIDIEditor_OnCommand( MIDIActive,x)
        else
            reaper.MIDIEditor_OnCommand( MIDIActive,41003)    
        end   
    end    
    
    reaper.PreventUIRefresh(-1)
    reaper.Undo_BeginBlock()
    reaper.Undo_EndBlock("0.0%/ Swing RESET and OFF/MidiEditor",0)   