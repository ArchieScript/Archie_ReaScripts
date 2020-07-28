--[[               
   *              NEW INSTANCE (ReaScript task control) 
   *  
   * Category:    Preferences 
   * Description: Sample-level waveform (Smooth) 
   * Author:      Archie 
   * Version:     1.0 
   * AboutScript: Preferences -> Peaks/Waveforms -> Name Script 
   * О скрипте:   Образец-уровень сигнала (Гладкий) 
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
  
     
     
     
     
     
    local ConfigVar = reaper.SNM_GetIntConfigVar("sampleedges",0); 
    -- / Sample-level waveform (Smooth) / -- 
    if ConfigVar ~= 16 then; 
        reaper.SNM_SetIntConfigVar("sampleedges",16); 
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
         
        local ConfigVar = reaper.SNM_GetIntConfigVar("sampleedges",0); 
         
        if ConfigVar == 16 then; 
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
    no_undo(); 