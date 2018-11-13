--[[
   * Category:    Track
   * Description: Appends to the name of the selected track "_ARCHIVE"
   * Author:      Archie
   * Version:     1.02
   * AboutScript: Appends to the name of the selected track "_ARCHIVE"
   * О скрипте:   Дописывает к имени выделенного трека "_ARCHIVE"
   * GIF:         http://clck.ru/Eexrt
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
    
    
    
    local AddToNameOfTrack = "_ARCHIVE"
               -- Введите значение которое нужно дописать к имени выделенного трека



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================   
               


    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local CountSelTrack = reaper.CountSelectedTracks( 0 )  
    if CountSelTrack == 0 then no_undo()return end

    if not AddToNameOfTrack then AddToNameOfTrack = "" end
    for i = CountSelTrack-1,0,-1 do
        local SelTrack = reaper.GetSelectedTrack( 0, i )
        local _,name = reaper.GetSetMediaTrackInfo_String(SelTrack,"P_NAME","",0)
        if not name:match(AddToNameOfTrack)then
            reaper.GetSetMediaTrackInfo_String(SelTrack,"P_NAME",name..AddToNameOfTrack,1)
        end
    end
    no_undo()