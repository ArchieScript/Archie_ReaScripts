-- NEW INSTANCE
--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Midi Editor
   * Description: Toggle Loop source item
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(***)
   * Gave idea:   Archie(***)
   * Changelog:   
   *              v.1.02 [13.01.2020]
   *                  + Button Backlight Monitoring
   
   *              v.1.0 [11.01.2020]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    -- NEW INSTANCE
    
    local MonitorButton = true; -- true/false   -- Мониторинг Подсветки Кнопки
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    ------------------------------------------------
    local midieditor = reaper.MIDIEditor_GetActive();
    if midieditor then;
        
        reaper.Undo_BeginBlock();
        local Und;
        local take = reaper.MIDIEditor_GetTake(midieditor);
        local item = reaper.GetMediaItemTake_Item(take);
        local loopSource = reaper.GetMediaItemInfo_Value(item,'B_LOOPSRC');
        reaper.SetMediaItemInfo_Value(item,'B_LOOPSRC',math.abs(loopSource-1));
        if math.abs(loopSource-1)==0 then Und='OFF'else Und='ON' end;
        
        reaper.Undo_EndBlock('Loop Source - '..Und,-1);
        
        reaper.UpdateArrange();
    else;
        reaper.defer(function()end);
    end;
    ------------------------------------------------
    
    
    
    
    
    
    
    
    --===============================================================
    ------------------------------------------------
    local ActiveOn,ActiveOff;
    local ActiveDoubleScr,stopDoubleScr;
    local _,extnameProj,sec,cmd,_,_,_ = reaper.get_action_context();
    
    local function loop();
        
        local midieditor = reaper.MIDIEditor_GetActive();
        if midieditor then;
        
            ----- stop Double Script -------
            if not ActiveDoubleScr then;
                stopDoubleScr = (tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr"))or 0)+1;
                reaper.SetExtState(extnameProj,"stopDoubleScr",stopDoubleScr,false);
                ActiveDoubleScr = true;
            end;
            
            local stopDoubleScr2 = tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr"));
            if stopDoubleScr2 > stopDoubleScr then  return  end;
            --------------------------------
        
            local take = reaper.MIDIEditor_GetTake(midieditor);
            local item = reaper.GetMediaItemTake_Item(take);
            local loopSource = reaper.GetMediaItemInfo_Value(item,'B_LOOPSRC');
            
            if loopSource == 0 then;
                if not ActiveOff then;
                    reaper.SetToggleCommandState(sec,cmd,0);
                    reaper.RefreshToolbar2(sec, cmd);
                    ActiveOn = nil;
                    ActiveOff = true;
                end;
            else;
                if not ActiveOn then;
                    reaper.SetToggleCommandState(sec,cmd,1);
                    reaper.RefreshToolbar2(sec, cmd);
                    ActiveOff = nil;
                    ActiveOn = true;
                end;
            end;
        end;   
        reaper.defer(loop);
    end;
    ------------------------------------------------
    
    
    if MonitorButton == true then;
        loop();
    end;
    --===============================================================
    
    
    
    
    