--[[      NEW INSTANCE !!!
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Save all track mute solo state slot 1
   * Author:      Archie
   * Version:     1.10
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.05+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              Arc_Function_lua v.2.8.1+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   
   *              v.1.0 [100620]
   *                  + ----
   
   *              v.1.0 [230320]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local SLOT = 1; -- 1..100
    
    local Buttonllumination = 1 -- 0/1 Подсветка кнопки
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
	

    
    
    --=========================================
    SLOT = tonumber(SLOT)or 1;
    if SLOT < 1 or SLOT > 100 then slot = 1 end;
    local extname = 'ARCHIE_TRACK_MUTE_SOLO_STATE_SLOT '..SLOT;
    --=========================================
    
    
    
    --=========================================
    reaper.SetProjExtState(0,extname,'','');
    
    local CountTrack = reaper.CountTracks(0);
    if CountTrack > 0 then;
        
        for i = 1,CountTrack do;
            local track = reaper.GetTrack(0,i-1);
            local guid = reaper.GetTrackGUID(track);
            local solo = math.floor((reaper.GetMediaTrackInfo_Value(track,'I_SOLO'))+.5);
            local mute = math.floor((reaper.GetMediaTrackInfo_Value(track,'B_MUTE'))+.5);
            reaper.SetProjExtState(0,extname,guid,mute..' '..solo);
        end;
        
        reaper.SetExtState(extname,'SaveState',1,false);
    else;    
        reaper.DeleteExtState(extname,'SaveState',false);
    end;
    --=========================================
    
    
    
    
    --=========================================
    local x;
    local function tmr(ckl);
        x=(x or 0)+1;
        if x>=ckl then x=0 return true end;return false;   
    end;
    --=========================================
    
    
    
    --=========================================
    if Buttonllumination ~= 1 then;
        Arc.no_undo();
    else;
        --===========================
        local _,FILE,sec,cmd,_,_,_ = reaper.get_action_context();
        local ActiveDoubleScr,stopDoubleScr;
         
        local function loop();
            local tm = tmr(15);
            if tm then;
                ----- stop Double Script -------
                if not ActiveDoubleScr then;
                    stopDoubleScr = (tonumber(reaper.GetExtState(extname,"stopDoubleScr"))or 0)+1;
                    reaper.SetExtState(extname,"stopDoubleScr",stopDoubleScr,false);
                    ActiveDoubleScr = true;
                end;
                
                local stopDoubleScr2 = tonumber(reaper.GetExtState(extname,"stopDoubleScr"));
                if stopDoubleScr2 > stopDoubleScr then return end;
                --------------------------------
                
                local but = tonumber(reaper.GetExtState(extname,'SaveState'))or 0;
                if but == 1 then;
                    if reaper.GetToggleCommandStateEx(sec,cmd)~=1 then;
                        reaper.SetToggleCommandState(sec,cmd,1);
                        reaper.RefreshToolbar2(sec,cmd);
                    end;
                else;
                    if reaper.GetToggleCommandStateEx(sec,cmd)~=0 then;
                        reaper.SetToggleCommandState(sec,cmd,0);
                        reaper.RefreshToolbar2(sec,cmd);
                    end;
                    return;
                end;
                --t=t+1
            end;
            reaper.defer(loop);
        end;
        reaper.defer(loop);
        
        reaper.defer(function()
            local ScrPath,ScrName = FILE:match('(.+)[/\\](.+)')
            Arc.GetSetTerminateAllInstancesOrStartNewOneKB_ini(1,516,ScrPath,ScrName);
        end);
        --===========================
    end;
    --===============================
    
  
  
  