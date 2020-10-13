--[[
   * Category:    MidiEditor
   * Description: MidiEditor; Activate previous MIDI item - Select only this item - Set cursor to start items.lua
   * GIF:         http://avatars.mds.yandex.net/get-pdb/2974644/2a2d99b2-96f8-4271-9104-ecc8eb6653a5/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.04
   * customer:    BRG(rmm)
   * gave idea:   BRG(rmm)
--====================================]]
    
    
	--[[
    --(1.03-------------------------------------------------------------------
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    local  midieditor = reaper.MIDIEditor_GetActive();
    if not midieditor then no_undo()return end;
    
    local take = reaper.MIDIEditor_GetTake(midieditor);
    if not take then no_undo()return end;
    
    local item = reaper.GetMediaItemTake_Item(take);
    if not item then no_undo()return end;
    
    ---
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    ---
    
    for i = 1,math.huge do;
        local me = reaper.MIDIEditor_GetActive();
        if me then;
            reaper.MIDIEditor_OnCommand(me,2);
        else;break;
        end;
    end;
    
    reaper.SelectAllMediaItems(0,0);
    reaper.SetMediaItemInfo_Value(item,'B_UISEL',1);
    
    reaper.Main_OnCommand(40153,0)--Item: Open in built-in MIDI editor (set default behavior in preferences)
    
    ----
    local  midieditor = reaper.MIDIEditor_GetActive();
    if not midieditor then no_undo()return end;
    reaper.MIDIEditor_OnCommand(midieditor,40834);--Activate previous MIDI item
    local take = reaper.MIDIEditor_GetTake(midieditor);
    if take then;
        local item = reaper.GetMediaItemTake_Item(take);
        if take then;
            reaper.SelectAllMediaItems(0,0);
            local pos = reaper.GetMediaItemInfo_Value(item,'D_POSITION');
            reaper.SetEditCurPos(pos,true,false);
            reaper.SetMediaItemInfo_Value(item,'B_UISEL',1);
            reaper.Main_OnCommand(40153,0)--Item: Open in built-in MIDI editor (set default behavior in preferences)
            --reaper.MIDIEditor_OnCommand(midieditor,40466);--View: Zoom to content
        end;
    end;
    
    reaper.PreventUIRefresh(-1);
    local title = 'Activate next MIDI item - Select only this item - Set cursor to start items.lua'
    reaper.Undo_EndBlock(title,-1);
    reaper.UpdateArrange(); 
    --1.03)-------------------------------------------------------------------
    --]]
    
    
    
    
    -------------------------------------------------------------------------
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    local midieditor = reaper.MIDIEditor_GetActive();
    if not midieditor then no_undo()return end;
    
    reaper.Undo_BeginBlock();
    
    reaper.MIDIEditor_OnCommand(midieditor,40834);--Activate previous MIDI item
    local take = reaper.MIDIEditor_GetTake(midieditor);
    if take then;   
        local item = reaper.GetMediaItemTake_Item(take);
        reaper.SelectAllMediaItems(0,0);
        local pos = reaper.GetMediaItemInfo_Value(item,'D_POSITION');
        reaper.SetEditCurPos(pos,true,false);
        reaper.SetMediaItemInfo_Value(item,'B_UISEL',1);
        reaper.Main_OnCommand(40153,0)--Item: Open in built-in MIDI editor (set default behavior in preferences)
        -- reaper.MIDIEditor_OnCommand(midieditor,40466);--View: Zoom to content
    end;
    local title = 'Activate previous MIDI item - Select only this item - Set cursor to start items.lua'
    reaper.Undo_EndBlock(title,-1);
    reaper.UpdateArrange();
    -------------------------------------------------------------------------
	
	
	
	