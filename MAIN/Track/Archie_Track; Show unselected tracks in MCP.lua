--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Track 
   * Description: Track; Show unselected tracks in MCP.lua 
   * Author:      Archie 
   * Version:     1.0 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   *              http://vk.com/reaarchie 
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000 
   * Customer:    Archie(---) 
   * Gave idea:   Archie(---) 
   * Extension:   Reaper 6.05+ http://www.reaper.fm/ 
   * Changelog:    
   *              v.1.0 [120420] 
   *                  + initialе 
--]] 
  --====================================================================================== 
  --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
  --====================================================================================== 
   
   
    ------------------------------------------------------- 
    local function no_undo()reaper.defer(function()end)end; 
    ------------------------------------------------------- 
   
     
     
    local CountTracks = reaper.CountTracks(0); 
    if CountTracks == 0 then no_undo()return end; 
     
     
    for i = 1,CountTracks do; 
        local track = reaper.GetTrack(0,i-1); 
        local UnSel = reaper.GetMediaTrackInfo_Value(track,'I_SELECTED')==0; 
        if UnSel then; 
            local Visib = reaper.IsTrackVisible(track,true); 
            if not Visib then; 
                if not UNDO then; 
                    reaper.Undo_BeginBlock(); 
                    reaper.PreventUIRefresh(1); 
                    UNDO = true; 
                end; 
                reaper.SetMediaTrackInfo_Value(track,'B_SHOWINMIXER',1);   
            end; 
        end; 
    end; 
     
     
    if UNDO then; 
        reaper.TrackList_AdjustWindows(true); 
        reaper.PreventUIRefresh(-1); 
        reaper.Undo_EndBlock('Show unselected tracks in MCP',-1); 
    else; 
        no_undo(); 
    end; 
     
     
     
     