--[[ 
   * Category:    Various 
   * Description: Move cursor to previous end-start of selected item 
   * Author:      Archie 
   * Version:     1.0 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * Donation:    http://money.yandex.ru/to/410018003906628 
   * Customer:    HDVulcan(RMM) 
   * Gave idea:   HDVulcan(RMM) 
   * Changelog:    
   *              v.1.0 [30.10.2019] 
   *                  initialе 
--]] 
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    ------------------------------------------------------- 
    local function no_undo()reaper.defer(function()end)end; 
    ------------------------------------------------------- 
     
     
    local CountSelItems = reaper.CountSelectedMediaItems(0); 
    if CountSelItems == 0 then no_undo()return end; 
      
    local timeT = {}; 
     
    for i = 1,CountSelItems do; 
        local selItem = reaper.GetSelectedMediaItem(0,i-1); 
        local pos = reaper.GetMediaItemInfo_Value(selItem,"D_POSITION"); 
        local len = reaper.GetMediaItemInfo_Value(selItem,"D_LENGTH"); 
        table.insert(timeT,pos); 
        table.insert(timeT,pos+len); 
        table.sort(timeT); 
    end; 
     
    local editCursor = reaper.GetCursorPosition(); 
     
    for i = #timeT,1,-1 do; 
        if timeT[i] < editCursor then; 
            reaper.SetEditCurPos(timeT[i],true,false); 
            break; 
        end; 
    end; 
     
    no_undo(); 