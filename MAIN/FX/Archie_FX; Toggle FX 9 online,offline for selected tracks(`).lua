--[[
   * Category:    FX
   * Description: Toggle FX 9 online/offline for selected tracks
   * Oписание:    Переключение FX 9 онлайн/оффлайн для выбранных треков
   * GIF:         http://goo.gl/u9CMVE
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Author:      Archie
   * Version:     1.02
   * customer:    shibata(RMM)
   * gave idea:   shibata(RMM)
--======================================================================]]



    local FX = 9
                -- укажите № FX который нужно онлайн /оффлайн
                -- specify № of the FX you want online / offline
                ------------------------------------------------



    --===========================================================================
    --////////////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------


    if not tonumber(FX)then FX = 9 end

    local CountSelTr = reaper.CountSelectedTracks(0)
    if CountSelTr == 0 then no_undo() return end


    local LastTouchedTrack = reaper.GetLastTouchedTrack()
    local ActiveTrack, Set, undo = _,_,0


    for i = 1, CountSelTr do
       local sel_track = reaper.GetSelectedTrack( 0, i-1 )
       local CountFX = reaper.TrackFX_GetCount( sel_track )
       if CountFX >= FX then undo = 1
           if sel_track == LastTouchedTrack then
               ActiveTrack = LastTouchedTrack break
           end
       end
    end
    if undo ~= 1 then no_undo() return end


    if not ActiveTrack then
        for i = 1, CountSelTr do
           local sel_track = reaper.GetSelectedTrack( 0, i-1 )
           local CountFX = reaper.TrackFX_GetCount( sel_track )
           if CountFX >= FX then
               ActiveTrack = sel_track break
           end
        end
    end


    local GetOffline = reaper.TrackFX_GetOffline(ActiveTrack, FX-1 )
    if GetOffline == false then Set = 1 else Set = 0 end


    reaper.Undo_BeginBlock()

    for i = 1, CountSelTr do
        local sel_track = reaper.GetSelectedTrack( 0, i - 1 )
        reaper.TrackFX_SetOffline(sel_track, FX-1, Set )
    end

    if Set == 0 then Set = "inline" else Set = "Offline" end
    local name_script = "FX "..FX.." "..Set.."/ Toggle"

    reaper.Undo_EndBlock(name_script,1)















