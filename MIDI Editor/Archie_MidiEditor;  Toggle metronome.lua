--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Midi Editor
   * Description: Toggle metronome
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.01+ http://www.reaper.fm/
   * Changelog:   v.1.0 [27.01.20]
   *                  + initialе
--]] 

    --КОГДА ПОЯВИТСЯ ОКНО "REASCRIPT TASK CONTROL" НАЖМИТЕ КНОПКУ "NEW INSTANCE"
    -- WHEN APPEARS WINDOW "REASCRIPT TASK CONTROL" CLICK "NEW INSTANCE"
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    local MIDIEditor = reaper.MIDIEditor_GetActive();
    if MIDIEditor then;
        reaper.Undo_BeginBlock();
        reaper.Main_OnCommandEx(40364,0,0);--Options: Toggle metronome
        
        local Undo;
        local Tog = reaper.GetToggleCommandStateEx(0,40364);
        if Tog == 1 then Undo = 'Enable'else Undo = 'Disable' end;
        
        reaper.Undo_EndBlock('Metronome '..Undo,8);
    end;
    
    
    
    
    
    
    local ActiveOn,ActiveOff;
    local ActiveDoubleScr,stopDoubleScr;
    local _,extnameProj,sec,cmd,_,_,_ = reaper.get_action_context();
    
    local function loop();
        
        ----- stop Double Script -------
        if not ActiveDoubleScr then;
            stopDoubleScr = (tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr"))or 0)+1;
            reaper.SetExtState(extnameProj,"stopDoubleScr",stopDoubleScr,false);
            ActiveDoubleScr = true;
        end;
        
        local stopDoubleScr2 = tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr"));
        if stopDoubleScr2 > stopDoubleScr then  return  end;
        --------------------------------
        
        local Tog = reaper.GetToggleCommandStateEx(0,40364);
        
        if Tog == 1 then;
            if not ActiveOff then;
                reaper.SetToggleCommandState(sec,cmd,1);
                reaper.RefreshToolbar2(sec, cmd);
                ActiveOn = nil;
                ActiveOff = true;
            end;
        else;
            if not ActiveOn then;
                reaper.SetToggleCommandState(sec,cmd,0);
                reaper.RefreshToolbar2(sec, cmd);
                ActiveOff = nil;
                ActiveOn = true;
            end;
        end;
        reaper.defer(loop);
    end;
    
    loop();