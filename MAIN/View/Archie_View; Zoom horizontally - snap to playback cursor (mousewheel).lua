--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    View
   * Description: Zoom horizontally - snap to playback cursor (mousewheel)
   * Описание:    Увеличение по горизонтали - привязать к курсору воспроизведению (колесико мыши)
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    AndiVax(Rmm)
   * Gave idea:   AndiVax(Rmm)
   * Extension:   Reaper 5.981+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *             initialе
   *                + v.1.0 [20.10.19]
--]]
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local STOP_EDIT = 1;
                 -- = 0 Всегда привязывать к плей курсору
                 -- = 1 При стопе привязать к курсору редактирования
                 -- = 0 Always snap to play cursor
                 -- = 1 When stop snap to edit cursor
    
    
    local STEP = 500;
                    -- Step zoom
                    -- Шаг масштабирования
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    local function main();
    
        local MouseWheel = ({reaper.get_action_context()})[7];
        local window, segment, details = reaper.BR_GetMouseCursorContext();
        if window == "ruler" or window == "arrange" then;
            
            local PlayPosition = reaper.GetPlayPosition();
            if STOP_EDIT == 1 then;
                if reaper.GetPlayState()&1 == 0 then;
                    PlayPosition = reaper.GetCursorPosition();
                end;
            end;
            
            local start_time, end_time = reaper.GetSet_ArrangeView2(0,0,0,0);
            local Pix = reaper.GetHZoomLevel()*(end_time-start_time); -- длина выб.врем. в пикселях
            
            if MouseWheel < 0 then;
                zoomPixel = Pix + (STEP or 500);
            else;
                zoomPixel = Pix - (STEP or 500);
            end;
            
            local NewLength2 = (zoomPixel)/reaper.GetHZoomLevel(); --длина в.в. в сек пикселей
            if NewLength2 <= 0.0003 then NewLength2 = 0.0003 end;
            
            local start_timeNew = PlayPosition - NewLength2/2;
            local end_timeNew   = PlayPosition + NewLength2/2;
            
            reaper.GetSet_ArrangeView2(0,1,0,0,start_timeNew,end_timeNew);
            
        end;
    end;
    
    reaper.defer(main);