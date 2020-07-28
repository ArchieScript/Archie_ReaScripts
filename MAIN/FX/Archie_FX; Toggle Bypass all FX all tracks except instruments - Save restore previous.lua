--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    FX
   * Description: FX; Toggle Bypass all FX all tracks except instruments - Save restore previous.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.0+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.0 [250420]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    
    local function Tip(fmt);
        local x,y = reaper.GetMousePosition();
        reaper.TrackCtl_SetToolTip(fmt,x+10,y-30,false);
    end;
    
    
    local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context();
    local ProjExtState = ('Toggle Bypass all FX all tracks except instruments - save restore previous'):upper();
    
    
    local function Bypass();
        reaper.Undo_BeginBlock();
        reaper.PreventUIRefresh(1);
        local str;
        ---------
        for itr = 0, reaper.CountTracks(0) do;
            
            local Track;
            if itr == 0 then;
                Track = reaper.GetMasterTrack(0);
            else;
                Track = reaper.GetTrack(0,itr-1);
            end;
            
            ---------------------------------------------
            local Instrument = reaper.TrackFX_GetInstrument(Track);
            for ifx = 1,reaper.TrackFX_GetCount(Track) do;
                if ifx-1 ~= Instrument then;
                    local bypass = reaper.TrackFX_GetEnabled(Track,ifx-1)and 1 or 0;
                    if bypass == 1 then;
                        reaper.TrackFX_SetEnabled(Track,ifx-1,false);
                    end;
                    
                    local FxGUID = reaper.TrackFX_GetFXGUID(Track,ifx-1);
                    str = (str or '')..FxGUID..bypass; 
                end;
            end;
            
            
            for ifx = 1,reaper.TrackFX_GetRecCount(Track)do;
                local bypass = reaper.TrackFX_GetEnabled(Track,0x1000000+ifx-1)and 1 or 0;
                if bypass == 1 then;
                    reaper.TrackFX_SetEnabled(Track,0x1000000+ifx-1,false);
                end;
                
                local FxGUID = reaper.TrackFX_GetFXGUID(Track,0x1000000+ifx-1);
                str = (str or '')..FxGUID..bypass;  
            end;
        end;
        -------------
        reaper.SetProjExtState(0,ProjExtState,'FXGUID_STATE',str or '');
        reaper.SetToggleCommandState(sec,cmd,1);
        reaper.RefreshToolbar2(sec,cmd);
        -------------
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Toggle Bypass all FX Except Instruments save previous',-1);    
    end;
    
    
    
    
    
    
    
    local function UnBypass();
        reaper.Undo_BeginBlock();
        local ret,str = reaper.GetProjExtState(0,ProjExtState,'FXGUID_STATE');
        local T = {};
        
        for var in str:gmatch('{.-}%d*') do;
            local GuidFx,bypass = var:match('({.*})(%d*)');
            T[GuidFx] = tonumber(bypass);
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
                    reaper.TrackFX_SetEnabled(Track,ifx-1,T[GUID]);
                end;
            end;
            
            for ifx = 1, reaper.TrackFX_GetCount(Track) do;
                local GUID = reaper.TrackFX_GetFXGUID(Track,0x1000000+ifx-1);
                if T[GUID] then;
                    reaper.TrackFX_SetEnabled(Track,0x1000000+ifx-1,T[GUID]);
                end;
            end;
        end;
        
        reaper.SetProjExtState(0,ProjExtState,'FXGUID_STATE','');
        reaper.SetToggleCommandState(sec,cmd,0);
        reaper.RefreshToolbar2(sec,cmd);
        reaper.Undo_EndBlock('Toggle Restory Bypass all FX Except Instruments',-1);
    end;
    
    
    
    
    local toggle = tonumber(reaper.GetExtState(ProjExtState,'STATE'))or 0;
    if toggle == 0 then;
        Tip('BUPASS FX');
        Bypass();
        reaper.SetExtState(ProjExtState,'STATE',1,true);
    else;
        Tip('RESTORE FX');
        UnBypass();
        reaper.SetExtState(ProjExtState,'STATE',0,true);
    end;