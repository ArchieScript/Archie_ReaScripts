--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Copy solo mute state selected track.lua
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
    
    local t = {};
    
    for i = 1,CountSelTrack do;
        local SelTrack = reaper.GetSelectedTrack(0,i-1);
        local solo = reaper.GetMediaTrackInfo_Value(SelTrack,'I_SOLO');
        local mute = reaper.GetMediaTrackInfo_Value(SelTrack,'B_MUTE');
        t[#t+1] = '{'..solo..'&'..mute..'}';
    end;
    
    local value = table.concat(t);
    
    reaper.SetExtState(section,'key',value,false);
    
    
    