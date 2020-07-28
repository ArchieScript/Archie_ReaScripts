--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    FX
   * Description: FX; Bypass instrument selected tracks - Save previous.lua
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


    local ProjExtState = ('BYPASS INSTRUMENTS SELECT TRACKS-SAVE OR RESTORE PREVIOUS');

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
        -----
        if Track then;
            local GUID = reaper.GetTrackGUID(Track);
            -----------------
            local Instrument = reaper.TrackFX_GetInstrument(Track);
            if Instrument >= 0 then;
                local Enabled = reaper.TrackFX_GetEnabled(Track,Instrument)and 1 or 0;
                if Enabled == 1 then;
                    reaper.TrackFX_SetEnabled(Track,Instrument,false);
                end;

                local FxGUID = reaper.TrackFX_GetFXGUID(Track,Instrument);
                str = (str or '')..FxGUID..Enabled;
            end;
            reaper.SetProjExtState(0,ProjExtState,GUID,str or '');
            ---------------------------------------------
        end;
    end;

    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock('Bypass instrument select tracks-save previous',-1);


