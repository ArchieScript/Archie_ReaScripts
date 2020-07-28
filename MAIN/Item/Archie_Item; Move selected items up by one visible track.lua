--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Item 
   * Description: Move selected items up by one visible track 
   * Author:      Archie 
   * Version:     1.0 
   * Описание:    Переместить выбранные элементы вверх на одну видимую дорожку 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000 
   * Customer:    Archie(---) 
   * Gave idea:   Archie(---) 
   * Extension:   Reaper 6.03+ http://www.reaper.fm/ 
   * Changelog:     
   *              v.1.0 [04.02.20] 
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
    local Undo; 
     
    for i = 1,CountSelItem do; 
        local SelItem = reaper.GetSelectedMediaItem(0,i-1); 
        local track = reaper.GetMediaItemTrack(SelItem); 
        local preHeightTr = reaper.GetMediaTrackInfo_Value(track,'I_TCPH'); 
        if preHeightTr > 0 then; 
            local numb = reaper.GetMediaTrackInfo_Value(track,"IP_TRACKNUMBER"); 
            local new_track = reaper.GetTrack(0,numb-1-HowMuchUp); 
            if new_track then; 
                local heightTr = reaper.GetMediaTrackInfo_Value(new_track,'I_TCPH'); 
                if heightTr <= 0 then; 
                    new_track = nil; 
                    for i2 = (numb-1-HowMuchUp),0,-1 do; 
                        local track = reaper.GetTrack(0,i2); 
                        local heightTr = reaper.GetMediaTrackInfo_Value(track,'I_TCPH'); 
                        if heightTr > 0 then; 
                            new_track = track; 
                            break; 
                        end; 
                    end; 
                end; 
                 
                if new_track then; 
                    reaper.MoveMediaItemToTrack(SelItem,new_track); 
                    if not Undo then; 
                        reaper.Undo_BeginBlock(); 
                        Undo = true; 
                    end; 
                end; 
            end; 
        else; 
            reaper.SetMediaItemInfo_Value(SelItem,'B_UISEL',0);    
        end; 
    end; 
     
     
    if Undo then; 
        reaper.Undo_EndBlock("Move selected items up by "..HowMuchUp.." visible track",-1);                        
    else; 
        no_undo(); 
    end; 
    reaper.UpdateArrange(); 