--[[              
   *              NEW INSTANCE (ReaScript task control)
   * 
   * Category:    Preferences
   * Description: Draw edges on peaks
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Preferences -> Peaks/Waveforms -> Name Script
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    smrz1[RMM]
   * Gave idea:   smrz1[RMM]
   * Extension:   Reaper 6.01+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [12122019]
   *                  +  initialе
--]] 
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    
    
    local ConfigVar = reaper.SNM_GetIntConfigVar("peaksedges",0);
    
    
    -- / Draw edges on peaks / --
    if ConfigVar&1 == 1 then;
        SetConfigVar = ConfigVar &~ (ConfigVar&1);
    else;
        SetConfigVar = ConfigVar | 1;
    end;
    
    reaper.SNM_SetIntConfigVar("peaksedges",SetConfigVar);
    -----------------------------------------------
    
    
    
    
    
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
        
        local ConfigVar = reaper.SNM_GetIntConfigVar("peaksedges",0)&1;
        
        if ConfigVar == 1 then;
            if not ActiveOff then;
                reaper.UpdateArrange()
                reaper.SetToggleCommandState(sec,cmd,1);
                reaper.RefreshToolbar2(sec, cmd);
                ActiveOn = nil;
                ActiveOff = true;
            end;
        else;
            if not ActiveOn then;
                reaper.UpdateArrange()
                reaper.SetToggleCommandState(sec,cmd,0);
                reaper.RefreshToolbar2(sec, cmd);
                ActiveOff = nil;
                ActiveOn = true;
            end;
        end;
        reaper.defer(loop);
    end;
    
    loop();
    no_undo();