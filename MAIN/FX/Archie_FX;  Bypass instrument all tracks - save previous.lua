--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    FX
   * Description: Bypass instrument all tracks - save previous
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.0+ http://www.reaper.fm/
   * Changelog:   v.1.0 [15.01.20]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    
    --======================================================================
    local value,ScriptWay,sec,cmd,mod,res,val = reaper.get_action_context();
    --======================================================================
    
    
    --=========================================================
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
            if Instrument >= 0 then;
                local Enabled = reaper.TrackFX_GetEnabled(Track,Instrument)and 1 or 0;
                if Enabled == 1 then;
                    reaper.TrackFX_SetEnabled(Track,Instrument,false);
                end;
                
                local FxGUID = reaper.TrackFX_GetFXGUID(Track,Instrument);
                
                str = (str or '')..FxGUID..Enabled;  
            end;
        end;
        -------------
        reaper.SetProjExtState(0,'ArchieBypass_INSTRUMENT_SavePrevExceptInstruments','FXGUID_STATE',str or '');
        reaper.SetToggleCommandState(sec,cmd,1);
        reaper.RefreshToolbar2(sec,cmd);
        -------------
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Bypass instrument all tracks - save previous',-1);    
    end;
    --=========================================================
    
    
    
    
    
    --=========================================================
    local function UnBypass();
        reaper.Undo_BeginBlock();
        local ret,str = reaper.GetProjExtState(0,'ArchieBypass_INSTRUMENT_SavePrevExceptInstruments','FXGUID_STATE');
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
        end;
        
        reaper.SetProjExtState(0,'ArchieBypass_INSTRUMENT_SavePrevExceptInstruments','FXGUID_STATE','');
        reaper.SetToggleCommandState(sec,cmd,0);
        reaper.RefreshToolbar2(sec,cmd);
        reaper.Undo_EndBlock('Restory Bypass instrument all tracks',-1);
    end;
    --=========================================================
    
    
    
    
    
    
    --=========================================================
    local toggle = tonumber(reaper.GetExtState('ARCHIE_TOGGLESTATE_BYPASS_INSTRUMENT_allTrack','STATE'))or 0;
    if toggle == 0 then;
         Bypass();
         reaper.SetExtState('ARCHIE_TOGGLESTATE_BYPASS_INSTRUMENT_allTrack','STATE',1,true);
    else;
         UnBypass();
         reaper.SetExtState('ARCHIE_TOGGLESTATE_BYPASS_INSTRUMENT_allTrack','STATE',0,true);
    end;
    --=========================================================
    
    
    
    