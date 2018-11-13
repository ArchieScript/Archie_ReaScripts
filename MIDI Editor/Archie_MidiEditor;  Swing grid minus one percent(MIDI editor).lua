--[[
   * Category:    Midi
   * Description: Swing grid minus one percent(MIDI editor)
   * Oписание:    качание сетки минус один процент(миди редактор)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    Maestro Sound(RMM Forum)
   * gave idea:   Maestro Sound(RMM Forum)
--=================================================]]



    local SWING = ( -1 )
                -- Установить процент качания от -200 до +200
                -- To set the percentage of swing from -200 to +200
                ---------------------------------------------------
  
    local SwingMidiOnOff = (0)
                      -- SwingMidiOnOff = 0 - скрипт сработает только в том случае,
                          -- если в миди редакторе включено качания
                                                       -----------
                      -- SwingMidiOnOff = 1 - скрипт сработает в любом случае,
                        --не обращая внимания на индикатор качания в миди редакторе
                        -----------------------------------------------------------
                     -- SwingMidiOnOff = 0 - the script will work only if,
                        -- if swing is enabled in MIDI editor
                                                      -----------
                     -- SwingMidiOnOff = 1 - the script will work in any case,
                        -- ignoring the swing indicator in the MIDI editor
                                --http://prnt.sc/kupnup
                       -----------------------------------------------------------   
    
    

    --===========================================================================
    --////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
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
    if not tonumber(SWING)then no_undo() return end
    if not tonumber(SwingMidiOnOff)then SwingMidiOnOff = 0 end
    
    
    if SwingMidiOnOff ~= 1 then
        if reaper.GetToggleCommandStateEx(32060,41006)== 0 then
            no_undo() return
        end
    end
   
    if SWING < -200 or SWING > 200 then SWING = 1 end
    local MidiSwing = GetSetMIDIEditorGridSwing(0,MIDIActive,nil)
   
    if MidiSwing <= -1.0 then MidiSwing = -1 end
    if MidiSwing >=  1.0 then MidiSwing =  1 end
 

    GetSetMIDIEditorGridSwing(1,MIDIActive,MidiSwing+SWING/100)
    local MidiSwing = GetSetMIDIEditorGridSwing(0,MIDIActive,nil)

    local plus
    if SWING > 0  then SWING = "+"..SWING end
    local MidiSwing = tonumber(string.format('%.2f',MidiSwing))
    if MidiSwing > 0 then plus = "+" else plus = "" end
    local Undo = MidiSwing *100 .."%  / MidiSwing ".. SWING .." /"
    reaper.Undo_BeginBlock()
    reaper.Undo_EndBlock(plus..Undo,1)