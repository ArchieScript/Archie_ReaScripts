--[[
   * Category:    Track
   * Description: Appends to the name of the selected track "_ARCHIVE"
   * Author:      Archie
   * Version:     1.03
   * AboutScript: Appends to the name of the selected track "_ARCHIVE"
   *              NOTE THE SETTINGS BELOW
   * О скрипте:   Дописывает к имени выделенного трека "_ARCHIVE"
   *              ОБРАТИТЕ ВНИМАНИЕ НА НАСТРОЙКИ НИЖЕ   
   * GIF:         http://clck.ru/Eexrt
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Supa75 (Rmm/forum)
   * Gave idea:   Supa75 (Rmm/forum)
   * Changelog:   + добавлена регулируемая настройка при недописывание в конце / v.1.03[04122218]
   *              + added adjustable setting when overwriting at the end / v.1.03[04122218]
   *              +! fixed bug with non-selection / v.1.02
   *              +! исправлена ошибка с невыделением / v.1.02
   *              + GIF     / v.1.01 
   *              + initialе / v.1.0 
--============================================================================================|
----------------SYSTEM REQUIREMENTS:-------/-------СИСТЕМНЫЕ ТРЕБОВАНИЯ:----------------------|
   + Reaper v.5.962 -----------| http://www.reaper.fm/download.php -------|(and above |и выше)|
   - SWS v.2.9.7 --------------| http://www.sws-extension.org/index.php --|(and above |и выше)|
   - ReaPack v.1.2.2 ----------| http://reapack.com/repos ----------------|(and above |и выше)|
   - Arc_Function_lua v.1.1.6 -| Repository - Archie-ReaScripts  http://clck.ru/EjERc |и выше)|
   - reaper_js_ReaScriptAPI64 -| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr |и выше)|
                                                                 http://clck.ru/Eo5Lw |и выше)|
--===========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    local AddToNameOfTrack = "_ARCHIVE"
               -- ВВЕДИТЕ ЗНАЧЕНИЕ КОТОРОЕ НУЖНО ДОПИСАТЬ К ИМЕНИ ВЫДЕЛЕННОГО ТРЕКА
                                                         ---------------------------
               -- ENTER THE VALUE YOU WANT TO APPEND TO THE NAME OF THE SELECTED TRACK
               -----------------------------------------------------------------------

    local DoNotAddToTrackNameIfEnd = "ARCHIVE"
               -- ВВЕДИТЕ ТО ЗНАЧЕНИЕ,ПРИ СОДЕРЖАНИИ КОТОРОГО В КОНЦЕ ИМЕНИ ТРЕКА,
               --                              НЕ БУДЕТ ДОБАВЛЯТЬСЯ К ИМЕНИ ТРЕКА
                                               --------------------------------------
               -- ENTER THE VALUE IN THE CONTENT OF WHICH IS AT THE END OF THE TRACK NAME,
               --                                   WILL BE ADDED TO THE NAME OF THE TRACK
               ---------------------------------------------------------------------------



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================   
               


    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local CountSelTrack = reaper.CountSelectedTracks(0)  
    if CountSelTrack == 0 then no_undo()return end

    if not AddToNameOfTrack then AddToNameOfTrack = "" end
    
    local DoNotAddToTrackNameIfEnd_X = DoNotAddToTrackNameIfEnd:gsub(" ","")
    
    for i = CountSelTrack-1,0,-1 do
        local SelTrack = reaper.GetSelectedTrack( 0, i )
        local _,name = reaper.GetSetMediaTrackInfo_String(SelTrack,"P_NAME","",0)
        local name_X = name:gsub(" ","")
        if not name_X:match(DoNotAddToTrackNameIfEnd_X)then
            reaper.GetSetMediaTrackInfo_String(SelTrack,"P_NAME",name..AddToNameOfTrack,1)
        end
    end
    no_undo()