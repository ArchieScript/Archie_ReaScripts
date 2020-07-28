--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Set selected tracks virtual MIDI keyboard to n channels
   * Author:      Archie
   * Version:     1.0
   * Описание:    ---
   * GIF:         http://avatars.mds.yandex.net/get-pdb/2374077/fdf757be-16e4-415b-bc44-3c7a8e55b931/s1200
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Nordum(Rmm)
   * Gave idea:   Nordum(Rmm)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   * Provides:    
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to all channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 1 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 2 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 3 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 4 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 5 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 6 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 7 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 8 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 9 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 10 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 11 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 12 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 13 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 14 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 15 channels.lua
   *              [main] . > Archie_Track;  Set selected tracks virtual MIDI keyboard to 16 channels.lua
   * Changelog:   v.1.0 [19.09.19]
   *                  + initialе
--]]
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    -------------------------------------------------------
	local NUMB_CHANNELS; -- 0 all or 1-16
    local scrName = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)");
    local scrName2 = tonumber(scrName:match("^.-(%S+)%s-channels%.lua$"))or 0;
    if scrName2 < 1 or scrName2 > 16 then NUMB_CHANNELS = 0 else NUMB_CHANNELS = scrName2 end;
    -------------------------------------------------------
    
    
    -------------------------------------------------------
    function Unpack_I_RECINPUT_midi(value);
        if value&4096 == 4096 then;
            local isMIDI = (value & 63);
            if isMIDI < 32 then return isMIDI,0 else return isMIDI-32,1 end;
        end;
    end;
    -------------------------------------------------------
    
    
    -------------------------------------------------------
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;
    
    local Undo;
    for t = 1,CountSelTrack do;
        local trackSel = reaper.GetSelectedTrack(0,t-1);
        local recInput = reaper.GetMediaTrackInfo_Value(trackSel,"I_RECINPUT");
        local chan,val = Unpack_I_RECINPUT_midi(recInput);
        if val ~= 0 or chan ~= NUMB_CHANNELS then;
            reaper.SetMediaTrackInfo_Value(trackSel,"I_RECINPUT",4096+(62<<5)+NUMB_CHANNELS);
            if not Undo then reaper.Undo_BeginBlock()Undo = true end;
        end; 
    end;
    
    if Undo then;
        if NUMB_CHANNELS == 0 then NUMB_CHANNELS = "all" end;
        reaper.Undo_EndBlock("Set selected tracks virtual MIDI keyboard to ".. NUMB_CHANNELS .." channels",-1);
    else;
        no_undo();
    end;
    -------------------------------------------------------