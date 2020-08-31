--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    FX
   * Description: FX; Offline all FX all tracks - Save previous.lua
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.0+ http://www.reaper.fm/
   * Changelog:
   *              v.1.0 [310820]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    local CountTrack = reaper.CountTracks(0);
    --if CountTrack > 0 then;

        local ProjExtState = ('OFFLINE ALL FX ALL TRACKS-SAVE OR RESTORE PREVIOUS');

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
            for ifx = 1,reaper.TrackFX_GetCount(Track) do;
                
                local Offline = reaper.TrackFX_GetOffline(Track,ifx-1)and 1 or 0;
                
                if Offline == 0 then;
                    reaper.TrackFX_SetOffline(Track,ifx-1,true);
                end;

                local FxGUID = reaper.TrackFX_GetFXGUID(Track,ifx-1);
                str = (str or '')..FxGUID..Offline;
            end;
            
            
            for ifx = 1,reaper.TrackFX_GetRecCount(Track)do;
                local Offline = reaper.TrackFX_GetOffline(Track,0x1000000+ifx-1)and 1 or 0;
                
                
                if Offline == 0 then;
                    reaper.TrackFX_SetOffline(Track,0x1000000+ifx-1,true);
                end;

                local FxGUID = reaper.TrackFX_GetFXGUID(Track,0x1000000+ifx-1);
                str = (str or '')..FxGUID..Offline;
            end;
        end;
        -------------
        reaper.SetProjExtState(0,ProjExtState,'FXGUID_STATE',str or '');
        -------------
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock('Offline all FX all track save previous',-1);
    --end;

