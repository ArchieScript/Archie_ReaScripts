--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Add Remove stretch marker to nearest grid under mouse cursor
   * Author:      Archie
   * Version:     1.03
   * Описание:    Добавить удалить маркер растяжки к ближайшей сетки под курсором мыши
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    AndiVax(Rmm)$
   * Gave idea:   AndiVax(Rmm)$
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.03 [22.10.19]
   *                  + Added ability to add marker to selected items

   *              v.1.02 [19.10.19]
   *                  + No change
   *              v.1.0 [08.10.19]
   *                  + initialе
--]]

    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local ADD_MAR_SEL_ITEM = false;
                        -- = true;  Add marker to selected items
                        --          Добавить маркер в выбранные элементы
                        -- = false; Not add marker to selected items
                        --          Не добавлять маркер в выбранные элементы


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================


    --------------------------------------------------------
    local function no_undo() reaper.defer(function()end)end;
    --------------------------------------------------------



    local function GetPreviousGrid(time);
        for i = 1,math.huge do;
            local val = reaper.SnapToGrid(0,time);
            if val <= time then return val end;
            time = time-0.001;
        end;
    end;


    local function GetNextGrid(time);
        for i = 1,math.huge do;
            local val = reaper.SnapToGrid(0,time);
            if val >= time then return val end;
            time = time+0.001;
        end;
    end;


    local x,y = reaper.GetMousePosition();
    local item,take = reaper.GetItemFromPoint(x,y,false);
    if not take or reaper.TakeIsMIDI(take)then no_undo() return end;
    reaper.BR_GetMouseCursorContext();
    local mousePos = reaper.BR_PositionAtMouseCursor(true);
    local PreviousGrid = GetPreviousGrid(mousePos);
    local NextGrid = GetNextGrid(mousePos);
    local newPos;
    if math.abs(mousePos-PreviousGrid ) < math.abs(mousePos-NextGrid)then;
        newPos = PreviousGrid else newPos = NextGrid;
    end;
    local posIt = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
    local lenIt= reaper.GetMediaItemInfo_Value(item, "D_LENGTH");
    local ratIt = reaper.GetMediaItemTakeInfo_Value(take,"D_PLAYRATE");
    local sm_mar = reaper.BR_GetMouseCursorContext_StretchMarker();
    if sm_mar < 0 then;
        for i = 1, reaper.GetTakeNumStretchMarkers(take)do;
            local retval, pos, srcpos = reaper.GetTakeStretchMarker(take,i-1);
            if (pos/ratIt)+posIt == newPos then sm_mar = i-1 end;
        end;
    end;
    reaper.Undo_BeginBlock();

    -----
    local Undo;
    local itemX = item;
    local takeX = take;
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if ADD_MAR_SEL_ITEM ~= true or sm_mar >= 0 then CountSelItem = 0 end;

    for i = 0,CountSelItem do;
        if i > 0 then;
            item = reaper.GetSelectedMediaItem(0,i-1);
            take = reaper.GetActiveTake(item);
            if itemX == item and takeX == take then;
                item = nil;
                take = nil;
            end;
        end;
        if item and take then;
            -----
            local posIt = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
            local lenIt= reaper.GetMediaItemInfo_Value(item, "D_LENGTH");
            local ratIt = reaper.GetMediaItemTakeInfo_Value(take,"D_PLAYRATE");
            if posIt < mousePos and posIt+lenIt > mousePos then;
            -----

                if sm_mar >= 0 then;
                    reaper.DeleteTakeStretchMarkers(take,sm_mar);
                    Undo = "Remove stretch marker to nearest grid under mouse cursor";
                else;
                    local idx = reaper.SetTakeStretchMarker(take,-1,(newPos-posIt)*ratIt);

                    if idx == 0 then;
                        reaper.SetTakeStretchMarker(take,-1,0);
                        idx = idx + 1;
                    end;

                    if idx == reaper.GetTakeNumStretchMarkers(take)-1 then;
                        reaper.SetTakeStretchMarker(take,-1,lenIt*ratIt);
                    end;

                    Undo = "Add stretch marker to nearest grid under mouse cursor";
                end;
            end;
        end;
    end;
    reaper.Undo_EndBlock(Undo,-1);
    reaper.UpdateArrange();

