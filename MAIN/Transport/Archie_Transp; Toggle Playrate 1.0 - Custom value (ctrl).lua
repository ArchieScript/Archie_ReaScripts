--[[ 
   * --- / New Instance / --- 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Transport 
   * Description: Toggle Playrate 1.0 - Custom value (ctrl) 
   * Author:      Archie 
   * Version:     1.01 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    smrz1(RMM) 
   * Gave idea:   smrz1(RMM) 
   * Extension:   Reaper 5.981+ http://www.reaper.fm/ 
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw 
   * Changelog:   v.1.01 [22.10.19] 
   *                  + initialе 
--]] 
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    ------------------------------------------------------- 
    local function no_undo()reaper.defer(function()end)end; 
    ------------------------------------------------------- 
     
     
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context(); 
    local section = filename:match(".+[/\\](.+)"); 
     
     
    local Mouse_State = reaper.JS_Mouse_GetState(127); 
    if Mouse_State&4 == 4 or 
        Mouse_State&8 == 8 or 
        Mouse_State&16 == 16 then; 
        local ret = tonumber(reaper.GetExtState(section,"PLAYRATE_CUSTOM_VALUE"))or ""; 
        local retval, retvals_csv = reaper.GetUserInputs("Toggle Playrate",1,"Enter custom value",ret); 
        retvals_csv = tonumber(retvals_csv); 
        if not retval then no_undo() return end; 
        if not retvals_csv then; 
            if reaper.HasExtState(section,"PLAYRATE_CUSTOM_VALUE")then; 
                reaper.DeleteExtState(section,"PLAYRATE_CUSTOM_VALUE",true); 
            end; 
        else; 
            reaper.SetExtState(section,"PLAYRATE_CUSTOM_VALUE",retvals_csv,true); 
        end; 
        no_undo() return; 
    end; 
     
     
     
    local ExtState = tonumber(reaper.GetExtState(section,"PLAYRATE_CUSTOM_VALUE")); 
     
    if not ExtState then; 
         
        local PlayRate = reaper.Master_GetPlayRate(0); 
        local ExtStateDef = tonumber(reaper.GetExtState(section,"PLAYRATE_CUSTOM_VALUE_DEF")); 
 
        if PlayRate == 1 and not ExtStateDef then ExtStateDef = 4 end; 
         
        if PlayRate ~= 1 and ExtStateDef and ExtStateDef ~= PlayRate then; 
            reaper.DeleteExtState(section,"PLAYRATE_CUSTOM_VALUE_DEF",true); 
            ExtStateDef = nil; 
        end;  
        if not ExtStateDef then ExtStateDef = PlayRate end; 
        reaper.SetExtState(section,"PLAYRATE_CUSTOM_VALUE_DEF",ExtStateDef,true); 
        ExtState = ExtStateDef;   
    end; 
     
     
    local PlayRate = reaper.Master_GetPlayRate(0); 
    --reaper.Undo_BeginBlock(); 
    if PlayRate == 1 then; 
         
        reaper.CSurf_OnPlayRateChange(ExtState); 
        --reaper.Undo_EndBlock("Set playrate to",-1); 
        if reaper.HasExtState(section,"PLAYRATE_CUSTOM_VALUE_DEF")then; 
            reaper.DeleteExtState(section,"PLAYRATE_CUSTOM_VALUE_DEF",true); 
        end; 
    else; 
         
        reaper.CSurf_OnPlayRateChange(1); 
        --reaper.Undo_EndBlock("Set playrate to 1.0",-1); 
    end; 
     
     
    local PlayRate2; 
     
    local function loop(); 
         
        local PlayRate = reaper.Master_GetPlayRate(0); 
        if PlayRate ~= PlayRate2 then; 
            PlayRate2 = PlayRate; 
             
            ----- stop Double Script ------- 
            if not ActiveDoubleScr then; 
                stopDoubleScr = (tonumber(reaper.GetExtState(section,"stopDoubleScr"))or 0)+1; 
                reaper.SetExtState(section,"stopDoubleScr",stopDoubleScr,false); 
                ActiveDoubleScr = true; 
            end; 
            local stopDoubleScr2 = tonumber(reaper.GetExtState(section,"stopDoubleScr")); 
            if stopDoubleScr2 > stopDoubleScr then return end; 
            -------------------------------- 
             
            local Toggle = reaper.GetToggleCommandStateEx(sectionID,cmdID); 
            if PlayRate == 1 then; 
                if Toggle ~= 0 then; 
                    reaper.SetToggleCommandState(sectionID,cmdID,0); 
                    reaper.RefreshToolbar(cmdID); 
                end; 
            else; 
                if Toggle ~= 1 then; 
                    reaper.SetToggleCommandState(sectionID,cmdID,1); 
                    reaper.RefreshToolbar(cmdID); 
                end; 
            end; 
        end; 
        reaper.defer(loop); 
    end; 
     
    loop(); 