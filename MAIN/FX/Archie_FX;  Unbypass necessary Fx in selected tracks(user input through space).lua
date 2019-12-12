--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Fx
   * Description: Unbypass necessary Fx in selected tracks(user input through  space)
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    vax(Rmm)
   * Gave idea:   vax(Rmm)
   * Changelog:   v.1.0 [12.12.19]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    
    -------------------------------------------------------
    local function no_ubdo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    ----------------------------------------------------------------------------------------
    local function retT(X)local x for key, val in pairs(X) do x=(x or 0)+1 end return x end;
    ----------------------------------------------------------------------------------------
    
    
    
    local retval, str = reaper.GetUserInputs("Bypass fx in selected tracks by number",1,"number fx by comma,extrawidth=150","");
    if not retval or #str:gsub("%s","")==0 then no_ubdo()return end;
    
    
    local
    T = {};
    for S in string.gmatch(str,"%d+") do;
        if tonumber(S) then;
           T[tonumber(S)]=tonumber(S);
        end;
    end;
    
    
    if retT(T) == 0 then no_ubdo()return end;
    
    
    local 
    CountSelTrack = reaper.CountSelectedTracks(0);
    local Undo;
    local UndoT = {};
    for i = 1,CountSelTrack do;
        local SelTrack = reaper.GetSelectedTrack(0,i-1);  
        local FX_Count = reaper.TrackFX_GetCount(SelTrack);
        for ifx = 1,FX_Count do;
            
            if T[ifx] then;
            
                if not Undo then;
                    reaper.Undo_BeginBlock();
                    reaper.PreventUIRefresh(1);
                    Undo = true;
                end;
                
                UndoT[#UndoT+1] = ifx;
                reaper.TrackFX_SetEnabled(SelTrack,ifx-1,true);
            end;
        end;
    end;
    
    
    
    local UndoT2 = {};
    local Not;
    for i = 1,#UndoT do;
        for i2 = 1,#UndoT2 do;
            if UndoT2[i2] == UndoT[i]then;
               Not = true;
            end;
        end;   
        if not Not then;
            UndoT2[#UndoT2+1]=UndoT[i];
        end;    
    end;
    
    
    local strU = table.concat(UndoT2,",");
    
    
    
    if Undo then;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock("Unbypass "..strU.." Fx",-1);
    else;
        no_ubdo();
    end;