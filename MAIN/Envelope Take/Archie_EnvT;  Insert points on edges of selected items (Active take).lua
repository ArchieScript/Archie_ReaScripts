--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Envelope Take
   * Description: EnvT;  Insert points on edges of selected items (Active take).lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Martin111(Rmm)
   * Gave idea:   Martin111(Rmm)
   * Extension:   Reaper 6.12+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [110720]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
     
    
    local CountSelIt = reaper.CountSelectedMediaItems(0);
    if CountSelIt == 0 then no_undo() return end;
    
    reaper.PreventUIRefresh(1);
    
    for it = 1,CountSelIt do;
        local item = reaper.GetSelectedMediaItem(0,it-1);
        ----
        local Take = reaper.GetActiveTake(item);
        local pos = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
        local len = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
        local rate = reaper.GetMediaItemTakeInfo_Value(Take,'D_PLAYRATE');
        ----
        local CountTakeEnv = reaper.CountTakeEnvelopes(Take);
        for i2 = 1,CountTakeEnv do;
            local TakeEnv = reaper.GetTakeEnvelope(Take,i2-1);
            ---
            local firstPoint1 = reaper.GetEnvelopePointByTime(TakeEnv,0);
            local firstPoint2 = reaper.GetEnvelopePointByTime(TakeEnv,0.000000001);
            ----
            if firstPoint1 == firstPoint2 then;
                if not UNDO then;reaper.Undo_BeginBlock();UNDO = true;end;
                local retval,value,dVdS,ddVdS,dddVdS = reaper.Envelope_Evaluate(TakeEnv,0,0,0);
                reaper.InsertEnvelopePoint(TakeEnv,0,value,0,0,1,false);
            end;
            ----
            len = len*rate;
            lastPoint1 = reaper.GetEnvelopePointByTime(TakeEnv,len);
            lastPoint2 = reaper.GetEnvelopePointByTime(TakeEnv,len-0.01);
            ----
            if lastPoint1 == lastPoint2 then;
                if not UNDO then;reaper.Undo_BeginBlock();UNDO = true;end;
                local retval,value,dVdS,ddVdS,dddVdS = reaper.Envelope_Evaluate(TakeEnv,len,0,0);
                reaper.InsertEnvelopePoint(TakeEnv,len,value,0,0,1,false);
            end;
        end;
    end;
    
    reaper.PreventUIRefresh(-1);
    if UNDO then;
        reaper.Undo_EndBlock('Insert points on edges of selected items (Active take)',-1)
    else;
        no_undo();
    end;
    
    
    
    