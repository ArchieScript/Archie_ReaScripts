--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Envelope
   * Description: Env; Set value from under mouse to selected points active envelope.lua
   * Author:      Archie
   * Version:     1.0
   * AboutScript: ---
   * О скрипте:   ---
   * GIF:         http://avatars.mds.yandex.net/get-pdb/2492526/85240391-ecd7-497a-82e2-27bad9b82b0b/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    J T(Rmm)
   * Gave idea:   J T(Rmm)
   * Extension:   Reaper 6.14+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [260820]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    -------------------------------------------------------
    local function Convert_Env_ValueInValueAndInPercent_SWS(envelope,valPoint,PerVal);
        local _,_,_,_,_,_,min,max,_,_,faderS = reaper.BR_EnvGetProperties(reaper.BR_EnvAlloc(envelope,true));
        reaper.BR_EnvFree(reaper.BR_EnvAlloc(envelope,true),true);
        local interval = (max - min);
        if PerVal == 0 then return (valPoint-min)/interval*100;
        elseif PerVal == 1 then return (valPoint/100)*interval + min;
        end;
    end;
    -------------------------------------------------------
    
    
    
    --Copy-------------------------------------------------
    local x,y = reaper.GetMousePosition();
    local window,segment,details = reaper.BR_GetMouseCursorContext();
    local EnvUnderMouse,takeEnvelope = reaper.BR_GetMouseCursorContext_Envelope();
    if not EnvUnderMouse then;
        reaper.TrackCtl_SetToolTip('No Envelope Under Mouse',x,y-30,false);
        no_undo()return;
    end;
    
    local CurCont_Pos = reaper.BR_GetMouseCursorContext_Position();
    
    local pos = 0;
    
    if takeEnvelope then;
        local item,take = reaper.GetItemFromPoint(x,y,false);
        if not item or not take then no_undo()return end;
        ----
        local pos = reaper.GetMediaItemInfo_Value(item,'D_POSITION');
        local rate = reaper.GetMediaItemTakeInfo_Value(take,'D_PLAYRATE');
        CurCont_Pos = (CurCont_Pos-pos)*rate;
    end;
    ----
    
    local retval,value,_,_,_ = reaper.Envelope_Evaluate(EnvUnderMouse,CurCont_Pos,0,0);
    
    local ValueInValue = Convert_Env_ValueInValueAndInPercent_SWS(EnvUnderMouse,value,0);
    
    --reaper.TrackCtl_SetToolTip('Copy Envelope Value',x,y-30,false);
    -------------------------------------------------------
    
    
    --Paste------------------------------------------------
    local Env = reaper.GetSelectedEnvelope(0);
    --local Env = EnvUnderMouse;
    
    if not Env or (tonumber(Env) and Env <= 0) then;
        reaper.TrackCtl_SetToolTip('Not Selected Envelope for paste',x,y-30,false);
        no_undo()return; 
    end;
    
    local ValueInValue2 = Convert_Env_ValueInValueAndInPercent_SWS(Env,ValueInValue,1);
    
    
    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();
    
    
    local CountAutoItems = reaper.CountAutomationItems(Env);
    for i = 0, CountAutoItems do;
    
        local CountEnvPoints = reaper.CountEnvelopePointsEx(Env,i-1);
        
        for i2 = 1,CountEnvPoints do;
            
            local retval,time,value,shape,tension,selected = reaper.GetEnvelopePointEx(Env,i-1,i2-1);
            if selected == true then;
                reaper.SetEnvelopePointEx(Env,i-1,i2-1,time,ValueInValue2,shape,tension,selected,true);
            end;
        end;
        reaper.Envelope_SortPointsEx(Env,i-1);
    end;
    
    
    reaper.Undo_EndBlock('Set value from under mouse to selected points active envelope',-1);
    reaper.PreventUIRefresh(-1);
    --reaper.UpdateArrange();
    
    reaper.TrackCtl_SetToolTip('-----\nDone\n-----',x,y-30,false);
    -------------------------------------------------------
    
    
    
    
    