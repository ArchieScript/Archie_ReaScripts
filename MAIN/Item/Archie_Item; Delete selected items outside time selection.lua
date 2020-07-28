--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Item 
   * Description: Delete selected items outside time selection 
   * Author:      Archie 
   * Version:     1.0 
   * Описание:    Удаление выбранных элементов вне времени выбора 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Archie(---) 
   * Gave idea:   Archie(---) 
   * Extension:   Reaper 6.03+ http://www.reaper.fm/ 
   * Changelog:    
   *              v.1.0 [10.02.20] 
   *                  + initialе 
--]] 
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
    ------------------------------------------------------- 
    local function no_undo()reaper.defer(function()end)end; 
    ------------------------------------------------------- 
     
     
    ------------------------------------------------------- 
    local function DeleteMediaItem(item); 
        if item then; 
            local tr = reaper.GetMediaItem_Track(item); 
            reaper.DeleteTrackMediaItem(tr,item); 
        end; 
    end; 
    ------------------------------------------------------- 
     
     
    local CountSelItem = reaper.CountSelectedMediaItems(0); 
    if CountSelItem == 0 then no_undo() return end; 
     
     
    local timeSelStart,timeSelEnd = reaper.GetSet_LoopTimeRange(0,0,0,0,0); -- В Аранже 
    if timeSelStart == timeSelEnd then no_undo() return end; 
     
    local Undo; 
     
    for i = CountSelItem-1,0,-1 do; 
         
        local SelItem = reaper.GetSelectedMediaItem(0,i); 
        local PosIt = reaper.GetMediaItemInfo_Value(SelItem,"D_POSITION"); 
        local LenIt = reaper.GetMediaItemInfo_Value(SelItem,"D_LENGTH"); 
        local EndIt = PosIt + LenIt; 
         
        if PosIt < timeSelEnd and EndIt > timeSelStart then; 
             
            if not Undo then reaper.Undo_BeginBlock()Undo=1 end; 
             
            if PosIt < timeSelEnd and EndIt > timeSelEnd then; 
                local Right = reaper.SplitMediaItem(SelItem,timeSelEnd); 
                if Right then 
                    DeleteMediaItem(Right); 
                end 
            end 
             
            if PosIt < timeSelStart and EndIt > timeSelStart then; 
                local Left = reaper.SplitMediaItem(SelItem,timeSelStart); 
                if Left then 
                    DeleteMediaItem(SelItem); 
                end 
            end; 
        else; 
            if not Undo then reaper.Undo_BeginBlock()Undo=1 end; 
            DeleteMediaItem(SelItem); 
        end; 
    end; 
     
     
    if Undo then; 
        reaper.Undo_EndBlock("Delete selected items outside time selection",-1); 
    else; 
        no_undo(); 
    end; 
    reaper.UpdateArrange(); 
     
     
     
     