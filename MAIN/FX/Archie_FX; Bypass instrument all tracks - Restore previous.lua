--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    FX 
   * Description: FX; Bypass instrument all tracks - Restore previous.lua 
   * Author:      Archie 
   * Version:     1.0 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Archie(---) 
   * Gave idea:   Archie(---) 
   * Extension:   Reaper 6.0+ http://www.reaper.fm/ 
   * Changelog:    
   *              v.1.0 [260420] 
   *                  + initialе 
--]] 
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    local ProjExtState = ('BYPASS INSTRUMENT ALL TRACKS-SAVE OR RESTORE PREVIOUS'); 
     
     
    local ret,str = reaper.GetProjExtState(0,ProjExtState,'FXGUID_STATE'); 
    if ret == 1 and str ~= '' then; 
         
        reaper.Undo_BeginBlock(); 
        reaper.PreventUIRefresh(1); 
         
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
         
        --reaper.SetProjExtState(0,ProjExtState,'FXGUID_STATE',''); 
        reaper.PreventUIRefresh(-1); 
        reaper.Undo_EndBlock('Restore Bypass instrument all tracks',-1);  
    end; 
     
     
     
     
     