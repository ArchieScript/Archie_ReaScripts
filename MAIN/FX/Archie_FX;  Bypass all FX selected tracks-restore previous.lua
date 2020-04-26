--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    FX
   * Description: FX;  Bypass all FX selected tracks-restore previous.lua
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
    
    
    local ProjExtState = ('BYPASS ALL FX SELECTED TRACKS - SAVE OR RESTORE PREVIOUS');
    
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    
    for itr = 0,reaper.CountSelectedTracks(0)do;
        
        local Track;
        if itr == 0 then;
            local trM = reaper.GetMasterTrack(0);
            local selM = reaper.GetMediaTrackInfo_Value(trM,'I_SELECTED')==1;
            if selM then;
                Track = trM;
            end;
        else;
            Track = reaper.GetSelectedTrack(0,itr-1);
        end;
        
        if Track then;
            local GUID = reaper.GetTrackGUID(Track);
            local t = {};
            ---------------------------------------------
            local ret,str = reaper.GetProjExtState(0,ProjExtState,GUID);
            if ret == 1 and str ~= '' then;
                
                for var in str:gmatch('{.-}%d*') do;
                    local GuidFx,bypass = var:match('({.*})(%d*)');
                    t[GuidFx] = tonumber(bypass);
                end;
                
                for ifx = 1, reaper.TrackFX_GetCount(Track) do;
                    local GUID = reaper.TrackFX_GetFXGUID(Track,ifx-1);
                    if t[GUID] then;
                        reaper.TrackFX_SetEnabled(Track,ifx-1,t[GUID]);
                    end;
                end;
                
                for ifx = 1, reaper.TrackFX_GetCount(Track) do;
                    local GUID = reaper.TrackFX_GetFXGUID(Track,0x1000000+ifx-1);
                    if t[GUID] then;
                        reaper.TrackFX_SetEnabled(Track,0x1000000+ifx-1,t[GUID]);
                    end;
                end;
            end;
            ---------------------------------------------
        end;
    end;
    
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock('Restory Bypass all FX selected track',-1);
    
    
    