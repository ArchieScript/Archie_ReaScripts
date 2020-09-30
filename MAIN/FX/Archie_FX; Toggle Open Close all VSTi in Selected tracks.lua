--[[
   * Category:    FX
   * Description: FX; Toggle Open Close all VSTi in Selected tracks.lua
   * Oписание:    Открыть все VSTi в выбранных дорожках
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Author:      Archie
   * Version:     1.0
   * customer:    ---
   * gave idea:   YuriOl(Rmm/forum)
--==========================================]]



    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    ------------------------------------------------------------s-----------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------


    local CountSeTrack = reaper.CountSelectedTracks( 0 )
    if CountSeTrack == 0 then no_undo() return end

    local instrument , x = false, 0
    
    title = 'Open'
    --------------------------
    local OpenClose;
    for i = 1,CountSeTrack do;
        local track = reaper.GetSelectedTrack(0, i - 1)
        local FXCount = reaper.TrackFX_GetCount( track )
        for i2 = 1,FXCount do

            local retval,buf = reaper.TrackFX_GetFXName(track, i2-1,"")
            if buf:match('^VSTi')then
                instrument = true else instrument = false
            end

            if instrument == true then
                
                local GetOpen = reaper.TrackFX_GetOpen(track,i2-1);
                if GetOpen then OpenClose = 2 title = 'Close' break end;
            end
        end 
    end;
    OpenClose = OpenClose or 3
    --------------------------
    
    
    reaper.Undo_BeginBlock();
    
    for i = 1,CountSeTrack do

        local track = reaper.GetSelectedTrack(0, i - 1)
        local FXCount = reaper.TrackFX_GetCount( track )

        for i2 = 1,FXCount do

            local retval,buf = reaper.TrackFX_GetFXName(track, i2-1,"")
            if buf:match('^VSTi')then
                instrument = true else instrument = false
            end

            if instrument == true then
                if OpenClose == 3 then;
                    reaper.TrackFX_Show( track, i2-1,OpenClose);
                elseif OpenClose == 2 then;
                    reaper.TrackFX_Show( track, i2-1,OpenClose);
                    reaper.TrackFX_Show( track, i2-1,0);
                end;
                x = x + 1
            end
        end
    end
    ----
    
    reaper.Undo_EndBlock(title..' '..'all Vsti in selected track',1)

