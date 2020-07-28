--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Track 
   * Description: Track; Monitoring track exclusive.lua 
   * Author:      Archie 
   * Version:     1.0 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   *              http://vk.com/reaarchie 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Maestro Sound(rmm) 
   * Gave idea:   Maestro Sound(rmm) 
   * Extension:   Reaper 6.10+ http://www.reaper.fm/ 
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php 
   * Changelog:    
   *              v.1.0 [040620] 
   *                  + initialе 
--]] 
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    ------------------------------------------------------- 
    local function no_undo()reaper.defer(function()end)end; 
    ------------------------------------------------------- 
     
     
    local FirstSelTrack = reaper.GetSelectedTrack(0,0); 
    if not FirstSelTrack then no_undo() return end; 
     
     
    for i = 1, reaper.CountTracks(0) do; 
        local track = reaper.GetTrack(0,i-1); 
        local mon = reaper.GetMediaTrackInfo_Value(track,'I_RECMON'); 
        local sel = reaper.GetMediaTrackInfo_Value(track,'I_SELECTED')==1; 
        if sel then; 
            if mon ~= 1 then; 
                if not UNDO then; 
                    reaper.Undo_BeginBlock(); 
                    reaper.PreventUIRefresh(1); 
                    UNDO = true; 
                end; 
                reaper.SetMediaTrackInfo_Value(track,'I_RECMON',1); 
            end; 
        else; 
            if mon ~= 0 then; 
                if not UNDO then; 
                    reaper.Undo_BeginBlock(); 
                    reaper.PreventUIRefresh(1); 
                    UNDO = true; 
                end; 
                reaper.SetMediaTrackInfo_Value(track,'I_RECMON',0); 
            end; 
        end; 
    end; 
     
     
    if UNDO then; 
        reaper.Undo_EndBlock('Monitoring track exclusive',-1); 
        reaper.PreventUIRefresh(-1); 
    else; 
        no_undo(); 
    end; 
     
     
     