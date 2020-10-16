--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Go to previous track - track solo in solo exclusive(skip minimized folders).lua
   * Author:      Archie
   * Version:     1.03
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    Vax(Rmm)
   * Gave idea:   Vax(Rmm)
   * Extension:   Reaper 6.14+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.03 [171120]
   *                  + solo lock track (vax)
   
   *              v.1.0 [011020]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    local function SetSoloTrack(track,val);
        local retval,str = reaper.GetTrackStateChunk(track,'',false);
        local str2 = str:gsub('MUTESOLO%s+%d+%s+%d+',function(s)return(s:match('MUTESOLO%s+%d+')..' '..val)end);
        if str~=str2 then;
            reaper.SetTrackStateChunk(track,str2,false);
        end;
    end;



    local LastTouchedTrack = reaper.GetLastTouchedTrack()or reaper.GetTrack(0,reaper.CountTracks(0)-1);
    if LastTouchedTrack then;
        
        reaper.PreventUIRefresh(1);
        reaper.Undo_BeginBlock();

        --reaper.Main_OnCommand(40286,0);
        -----------------
        reaper.SetOnlyTrackSelected(LastTouchedTrack);
        
        local dof = 
        reaper.GetResourcePath():gsub('\\','/')..
        '/Scripts/Archie-ReaScripts/MAIN/Track/'..
        'Archie_Track; Select previous tracks(skip minimized folders)(`).lua';
        dofile(dof); 
        -----------------
        
        local NewTrack = reaper.GetLastTouchedTrack();
        local Solo = reaper.GetMediaTrackInfo_Value(LastTouchedTrack,"I_SOLO");
        if Solo ~= 0 then;
            --reaper.SetMediaTrackInfo_Value(NewTrack,"I_SOLO",1);
            SetSoloTrack(NewTrack,1);
            for i = 1, reaper.CountTracks(0) do;
                local Track = reaper.GetTrack(0,i-1);
                if Track ~= NewTrack then;
                    local Solo = reaper.GetMediaTrackInfo_Value(Track,"I_SOLO");
                    if Solo ~= 0 then;
                        --reaper.SetMediaTrackInfo_Value(Track,"I_SOLO",0);
                        SetSoloTrack(Track,0);
                    end;
                end;
            end;
        end;
        
        -----(---
        local Context = reaper.GetCursorContext();
        if Context ~= 0 then;
            reaper.SetCursorContext(0,nil);
        end;
        -----)---
        
        local title = 'Go to previous track - track solo in solo exclusive(skip minimized folders)';
        reaper.Undo_EndBlock('Go to next track - track solo in solo exclusive',-1);
        reaper.PreventUIRefresh(-1);
    end;
    
    
    
    