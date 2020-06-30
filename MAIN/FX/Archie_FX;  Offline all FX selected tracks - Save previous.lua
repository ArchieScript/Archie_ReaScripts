--[[     NEW INSTANCES;
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    FX
   * Description: FX;  Offline all FX selected tracks - Save previous.lua
   * Author:      Archie
   * Version:     1.0
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.0+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.0 [300620]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    local BUTTON_STATE = 0; -- 0/1 подсветка кнопки
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.6",file,'')then;A=nil;return;end;return A;
    end; local Arc = MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    --=========================================
    
    
    
    local ProjExtState = ('OFFLINE ALL FX SELECTED TRACKS - SAVE OR RESTORE PREVIOUS');
    
    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);
    
    local CountSelTrack2 = reaper.CountSelectedTracks2(0,true);
    if CountSelTrack2 == 0 then no_undo()return end;
    
    
    -----
    local str_numb = '';
    for itr = 1,CountSelTrack2 do;
        local Track = reaper.GetSelectedTrack2(0,itr-1,true);
        local GUID = reaper.GetTrackGUID(Track);
        local ret,str = reaper.GetProjExtState(0,ProjExtState,GUID);
        if ret == 1 and str ~= '' then;
            local numb = math.floor(reaper.GetMediaTrackInfo_Value(Track,'IP_TRACKNUMBER')+0.5);
            str_numb = str_numb..numb..',';
        end;
    end;
    str_numb = str_numb:gsub(',$','');
    if str_numb ~= '' then;
        local MB = reaper.MB('Eng\nTracks "'..str_numb..'" already have a save, re-save them?\n\nRus:\nТреки "'..str_numb..'" уже имеют сохранение, пересохранить их ?','Woops '..str_numb,1);
        if MB == 2 then no_undo()return end; 
    end;
    -----
    
    
    local str;
    
    for itr = 1,CountSelTrack2 do;
        
        local Track = reaper.GetSelectedTrack2(0,itr-1,true);
        -----
        if Track then;
            local GUID = reaper.GetTrackGUID(Track);
            
            for ifx = 1,reaper.TrackFX_GetCount(Track) do; 
                local Offline = reaper.TrackFX_GetOffline(Track,ifx-1)and 1 or 0;
                
                if Offline == 0 then;
                    reaper.TrackFX_SetOffline(Track,ifx-1,1);
                end;
                
                local FxGUID = reaper.TrackFX_GetFXGUID(Track,ifx-1);
                str = (str or '')..FxGUID..Offline;
            end;
            
            
            for ifx = 1,reaper.TrackFX_GetRecCount(Track)do;
                local Offline = reaper.TrackFX_GetOffline(Track,0x1000000+ifx-1)and 1 or 0;
                if Offline == 0 then;
                    reaper.TrackFX_SetOffline(Track,0x1000000+ifx-1,1);
                end;
                local FxGUID = reaper.TrackFX_GetFXGUID(Track,0x1000000+ifx-1);
                local GUID = reaper.GetTrackGUID(Track);
                str = (str or '')..FxGUID..Offline;
            end;
            reaper.SetProjExtState(0,ProjExtState,GUID,str or '');
            ---------------------------------------------
        end;
    end;
    
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock('Offline all FX selected track Save previous',-1);
    
    
    if BUTTON_STATE == 1 then;
        reaper.defer(function();
            local function zxc();
                reaper.SetExtState(ProjExtState,'State',1,false);
                local scrPath,scrName = debug.getinfo(1,'S').source:match("^@(.+)[/\\](.+)");
                dofile(scrPath..'/Archie_FX;  Offline all FX selected tracks - Restore previous.lua');
            end;
            pcall(zxc);
        end);
    end;
    