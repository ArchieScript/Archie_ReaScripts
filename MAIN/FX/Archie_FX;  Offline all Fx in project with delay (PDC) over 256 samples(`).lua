--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    FX
   * Description: Offline all Fx in project with delay (PDC) over x samples
   * Author:      Archie
   * Version:     1.0
   * Описание:    Offline все Fx в проекте с задержкой (PDC) более x образцов
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    vax(Rmm) http://www.andivaxmastering.com/
   * Gave idea:   vax(Rmm) http://www.youtube.com/channel/UCfqzOtNcxtITNsBw0x-RiZw
   * Extension:   Reaper 5.984+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   v.1.0 [03.12.19]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local samples = 256  -- delay in samples
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context();
    
    
    local function Offline();
        reaper.Undo_BeginBlock();
        local str;
        for itr = 0, reaper.CountTracks(0) do;
        
            local Track;
            if itr == 0 then;
                Track = reaper.GetMasterTrack(0);
            else;
                Track = reaper.GetTrack(0,itr-1);
            end;
        
            for ifx = 1,reaper.TrackFX_GetCount(Track) do;
                local retval, buf = reaper.TrackFX_GetNamedConfigParm(Track,ifx-1,'pdc');
                if retval and tonumber(buf) and tonumber(buf) > (samples or 256) then;
                    local Offline = reaper.TrackFX_GetOffline(Track,ifx-1)and 1 or 0;
                    reaper.TrackFX_SetOffline(Track,ifx-1,true);
                    local FXGUID = reaper.TrackFX_GetFXGUID(Track,ifx-1);
                    str = (str or '')..FXGUID..Offline;
                end;
            end;
            
            for ifx = 1,reaper.TrackFX_GetRecCount(Track)do;
                local retval,buf = reaper.TrackFX_GetNamedConfigParm(Track,0x1000000+ifx-1,'pdc');
                if retval and tonumber(buf) and tonumber(buf) > (samples or 256) then; 
                    local Offline = reaper.TrackFX_GetOffline(Track,0x1000000+ifx-1)and 1 or 0;
                    reaper.TrackFX_SetOffline(Track,0x1000000+ifx-1,true);
                    local FXGUID = reaper.TrackFX_GetFXGUID(Track,0x1000000+ifx-1);
                    str = (str or '')..FXGUID..Offline;
                end;
            end;  
        end;
        reaper.SetProjExtState(0,'OFFLINEFX_PDC','FXGUID_STATE',str or '');
        reaper.SetToggleCommandState(sec,cmd,1);
        reaper.RefreshToolbar2(sec,cmd);
        reaper.Undo_EndBlock('Offline fx PDC',-1);
    end;
   
   
    
    
    local function Online();
        reaper.Undo_BeginBlock();
        local ret,str = reaper.GetProjExtState(0,'OFFLINEFX_PDC','FXGUID_STATE');
        local T = {};
        
        for var in str:gmatch('{.-}%d*') do;
            local GuidFx,OfflineFx = var:match('({.*})(%d*)');
            T[GuidFx] = tonumber(OfflineFx);
        end;
        
        local Track;
        for itr = 0, reaper.CountTracks(0) do;
        
            if itr == 0 then;
                Track = reaper.GetMasterTrack(0);
            else;
                Track = reaper.GetTrack(0,itr-1);
            end;
        
            for ifx = 1, reaper.TrackFX_GetCount(Track) do;
                local GUID = reaper.TrackFX_GetFXGUID(Track,ifx-1);
                if T[GUID] then;
                    reaper.TrackFX_SetOffline(Track,ifx-1,T[GUID]);
                end;
            end;
            
            for ifx = 1, reaper.TrackFX_GetCount(Track) do;
                local GUID = reaper.TrackFX_GetFXGUID(Track,0x1000000+ifx-1);
                if T[GUID] then;
                    reaper.TrackFX_SetOffline(Track,0x1000000+ifx-1,T[GUID]);
                end;
            end;
        end;
        
        reaper.SetProjExtState(0,'OFFLINEFX_PDC','FXGUID_STATE','');
        reaper.SetToggleCommandState(sec,cmd,0);
        reaper.RefreshToolbar2(sec,cmd);
        reaper.Undo_EndBlock('Online fx PDC',-1);
    end;
    
    
    
    
    
    local toggle = tonumber(reaper.GetExtState('ArchieTOGGLESTATEPDC','STATE'))or 0;
    if toggle == 0 then;
        Offline();
        reaper.SetExtState('ArchieTOGGLESTATEPDC','STATE',1,true);
    else;
        Online();
        reaper.SetExtState('ArchieTOGGLESTATEPDC','STATE',0,true);
    end;