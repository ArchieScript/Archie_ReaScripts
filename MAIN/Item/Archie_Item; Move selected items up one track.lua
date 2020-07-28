--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Item 
   * Description: Move selected items up one track 
   * Author:      Archie 
   * Version:     1.02 
   * Описание:    Переместить выбранные элементы на одну дорожку вверх  
   * GIF:         http://clck.ru/Eddx2 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000 
   * Customer:    Maestro Sound(Rmm) 
   * Gave idea:   Maestro Sound(Rmm) 
   * Extension:   Reaper 5.981+ http://www.reaper.fm/ 
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php 
   * Changelog:    
   *              v.1.02 [04.02.20] 
   *                  !+ Improved performance 
    
   *              v.1.0 [13.11.18] 
   *                  + initialе 
--]]    
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --======================================================================================  
     
     
      
    ------------------------------------------------------- 
    local function no_undo()reaper.defer(function()end)end; 
    ------------------------------------------------------- 
     
    local HowMuchUp = 1; 
     
    local CountSelItem = reaper.CountSelectedMediaItems(0); 
    if CountSelItem == 0 then no_undo() return end; 
     
    HowMuchUp = math.abs(tonumber(HowMuchUp)or 1); 
     
    for i = 1,CountSelItem do; 
        local SelItem = reaper.GetSelectedMediaItem(0,i-1); 
        local track = reaper.GetMediaItemTrack(SelItem); 
        local numb = reaper.GetMediaTrackInfo_Value(track, "IP_TRACKNUMBER"); 
        local new_track = reaper.GetTrack(0,numb-1-HowMuchUp) 
        if new_track then; 
            reaper.MoveMediaItemToTrack(SelItem,new_track); 
            if not Undo then; 
                reaper.Undo_BeginBlock(); 
                Undo = true; 
            end; 
        end; 
    end; 
     
     
    if Undo then; 
        reaper.Undo_EndBlock("Move selected items up "..HowMuchUp.." track",-1); 
    else; 
        no_undo(); 
    end; 
    reaper.UpdateArrange(); 