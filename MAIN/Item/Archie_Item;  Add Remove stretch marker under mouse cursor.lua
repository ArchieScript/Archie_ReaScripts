--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Add Remove stretch marks under mouse cursor
   * Author:      Archie
   * Version:     1.02
   * Описание:    Добавить удалить маркеры растяжки под курсором мыши
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    AndiVax(Rmm)$
   * Gave idea:   AndiVax(Rmm)$
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.02 [19.10.19]
   *                  + No change
   
   *              v.1.01 [08.10.19]
   *                  + Insert extreme markers, if necessary
   *              v.1.0 [08.10.19]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    --------------------------------------------------------
    local function no_undo() reaper.defer(function()end)end;
    --------------------------------------------------------
    
    
    local x,y = reaper.GetMousePosition();
    local item,take = reaper.GetItemFromPoint(x,y,false);
    if not take or reaper.TakeIsMIDI(take)then no_undo() return end;
    reaper.BR_GetMouseCursorContext();
    local mousePos = reaper.BR_PositionAtMouseCursor(true);
    local posIt = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
    local lenIt= reaper.GetMediaItemInfo_Value(item, "D_LENGTH");
    local ratIt = reaper.GetMediaItemTakeInfo_Value(take,"D_PLAYRATE");
    local sm_mar = reaper.BR_GetMouseCursorContext_StretchMarker();
    
    reaper.Undo_BeginBlock();
    
    if sm_mar >= 0 then; 
        reaper.DeleteTakeStretchMarkers(take,sm_mar);
        reaper.Undo_EndBlock("Remove stretch marks under mouse cursor",-1);
    else;
        local idx = reaper.SetTakeStretchMarker(take,-1,(mousePos-posIt)*ratIt);
        if idx == 0 then;
            reaper.SetTakeStretchMarker(take,-1,0);
            idx = idx + 1;
        end;
         
        if idx == reaper.GetTakeNumStretchMarkers(take)-1 then;
            reaper.SetTakeStretchMarker(take,-1,lenIt*ratIt);
        end;
        
        reaper.Undo_EndBlock("Add stretch marker under mouse cursor",-1);
    end;
    reaper.UpdateArrange();