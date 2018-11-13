--[[
   * Category:    Track
   * Description: Selects tracks that have "_ARCHIVE" in their name"
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Selects tracks that have "_ARCHIVE" in their name"
   * О скрипте:   Выделить треки, у которых в названии есть "_ARCHIVE"
   * GIF:         http://clck.ru/Eeye5
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Supa75 (Rmm/forum)
   * Gave idea:   Supa75 (Rmm/forum)
   * Changelog:   +! fixed bug with non-selection / v.1.02
   *              +! исправлена ошибка с невыделением / v.1.02
   *              + GIF     / v.1.01 
   *              + initialе / v.1.0 
--==============================================================
SYSTEM  REQUIREMENTS:  Reaper v.5.96 |  SWS v.2.9.7  (and above)
СИСТЕМНЫЕ ТРЕБОВАНИЯ:  Reaper v.5.96 |  SWS v.2.9.7     (и выше)
--============================================================]]



    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================

 

    
    
    local EndOfTrackContains = "_ARCHIVE"
                   -- Введите значение при содержании которого в имени выделится трек
    
  
  
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------
    
    
    
    local CountTrack = reaper.CountTracks( 0 )     
    if CountTrack == 0 then no_undo()return end
    
    if not EndOfTrackContains then EndOfTrackContains = "{$[(*)]*[}{(*)]$}" end
    for i = 1,CountTrack do
        local Track = reaper.GetTrack( 0, i-1 )
        local retval, buf = reaper.GetTrackName( Track, "" )
        if buf:match(EndOfTrackContains)then
            reaper.SetTrackSelected(Track,1)
        end 
    end 
    no_undo()