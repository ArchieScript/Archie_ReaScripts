--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Paste solo mute state selected track.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    ---(Rmm)
   * Gave idea:   Vax(Rmm)
   * Extension:   Reaper 6.14+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.0 [011020]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    --[[
    Archie_Track; Cut solo mute state selected track.lua
    Archie_Track; Copy solo mute state selected track.lua
    Archie_Track; Paste solo mute state selected track.lua
    --]]
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    local section = 'COPY PASTE SOLO MUTE STATE SELECTED TRACK';
    
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo()return end;
    
    
    local HasExt = reaper.HasExtState(section,'key');
    local ExtState = reaper.GetExtState(section,'key');
    if ExtState == '' or not HasExt then no_undo()return end;
    
    local t = {};
    for var in string.gmatch(ExtState,"{(.-)}") do;
        solo,mute = var:match('(.+)&(.+)');
        t[#t+1] = {};
        t[#t].solo = solo;
        t[#t].mute = mute;
    end;
    
    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();
    
    
    for i = 1,CountSelTrack do;
        local SelTrack = reaper.GetSelectedTrack(0,i-1);
        
        if not t[i]then t[i]=t[#t]end;
        
        reaper.SetMediaTrackInfo_Value(SelTrack,'I_SOLO',t[i].solo);
        reaper.SetMediaTrackInfo_Value(SelTrack,'B_MUTE',t[i].mute);
    end;
    
    reaper.Undo_EndBlock('Paste Solo mute',-1);
    reaper.PreventUIRefresh(-1);
    
    
    --Если скопировать два, а всавлять в пять, то второй вставится в 3,4,5
    
    
    
    