--[[
   * ВАЖНО:
   * ПРИ ПЕРВОМ ЗАПУСКЕ СКРИПТА ПОЯВИТСЯ ОКНО {Reascript task control:
   * ДЛЯ КОРЕКТНОЙ РАБОТЫ СКРИПТА СТАВИМ ГАЛКУ
   * Remember my answer for this script} НАЖИМАЕМ Terminale instances
   * http://clck.ru/Dqnkm
   * -------
   * Category:    Track
   * Description: Auto open VSTi in selected tracks and close in the rest
   * Oписание:    Автоматически открыть VSTi в выбранных дорожках,закрыть в остальных
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    elektrozz (Rmm/forum)
   * gave idea:   elektrozz (Rmm/forum)
--====================================]]



    local Fx_search = "VSTi:"
                    -- = "VSTi:" Откроет только VSTi: Инструмент
                    -- = "VST:" Откроет только VST: эффект
                    -- = "VST" Откроет все  VST эффекты
                    -- Или введите Часть имени плагина
                    -- например:Fx_search = "Часть имени плагина"
                                           ----------------------
                    -- = "VSTi:" will only Open VSTi: Tool
                    -- = "VST:" will Open only VST: effect
                    -- = "VST" Opens all VST effects
                    -- Or enter part of the plugin name
                    -- example:Fx_search = "part of the name of the plugin"
                    ------------*-------------------------------------------



    local AlwaysClose = 1
                     -- = 0 Не закрывать автоматически все открытые "Fx_search"
                     -- = 1 Автоматически закрыть все открытые "Fx_search"
                                                      ------------------
                     -- = 0 Do not automatically close all open "Fx_search"
                     -- = 1 Automatically close all open "Fx_search"
                     -----------------------------------------



    local OpenOneOrAllVSTi = 0
                        -- = 0 Открыть только первый "Fx_search" в треке
                        -- = 1 Открыть все VSTi в треке
                                                -------
                        -- = 0 Open only the first "Fx_search" in the track
                        -- = 1 Open all "Fx_search" in the track
                        -----------------------------------------


    local CloseVSTi = 1
                 -- = 1 закрыть все "Fx_search" при выключении скрипта
                 -- = 0 не закрыть все "Fx_search" при выключении скрипта
                                                     ---------------------
                 -- = 1 close all "Fx_search" when the script is turned off
                 -- = 0 do not close all "Fx_search" when you turn off the script
                 ----------------------------------------------------------------


    local Open = 3
                -- = 1 Показать-Открыть "Fx_search" в цепи(в списке)
                -- = 3 Показать-Открыть "Fx_search" плавающий
                                                -------------
                -- = 1 Show-Open the "Fx_search" in a chain(list)
                -- = 3 View to Open the "Fx_search" floating
                --------------------------------------------


    local Close = 4
                -- = 0 Закрыть    только в цепи(в списке)
                -- = 2 Закрыть "Fx_search" только плавающий
                -- = 4 Закрыть "Fx_search" ВСЕ
                              -----------------
                -- = 0 Close   only in the chain (in the list)
                -- = 2 Close "Fx_search" only floating
                -- = 4 Close "Fx_search" ALL




    --===========================================================================
    --////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------


    if not Fx_search then Fx_search = "VSTi:" end

    local Guid1,Guid2,resetGuid,Guid_x = {},{},{},{}


    local function main(Open,Close)

        local focus = reaper.GetCursorContext2(false)
        if focus == 0 then

            for i = 1,reaper.CountTracks(0) do
                local track = reaper.GetTrack(0,i-1)
                local sel = reaper.GetMediaTrackInfo_Value(track,'I_SELECTED')
                if sel == 1 then resetGuid[i] = 1 end
                Guid1[i] = reaper.GetTrackGUID(track)
                local FX_GetCount = reaper.TrackFX_GetCount(track)
                for i2 = 1, FX_GetCount do
                    local _, buf = reaper.TrackFX_GetFXName(track,i2-1,'')
                    if buf:match(Fx_search)then
                        if sel == 0 then
                        -------
                            if AlwaysClose ~= 0 then
                                for i3 = 1, FX_GetCount do
                                    local _, buf = reaper.TrackFX_GetFXName(track, i3-1, '')
                                    if buf:match(Fx_search)then
                                        ---
                                        if Close ~= 4 then
                                            reaper.TrackFX_Show(track, i3-1, Close)---))
                                        else
                                            reaper.TrackFX_SetOpen(track, i3-1, 0)----))
                                        end
                                        ---
                                    end
                                end
                            end
                        -------
                        else
                            local GetOpen = reaper.TrackFX_GetOpen(track,i2-1)
                            if GetOpen == false then
                                if Guid1[i] ~= Guid2[i] then
                                    if OpenOneOrAllVSTi ~= 1 then
                                        reaper.TrackFX_Show(track, i2-1, Open)-----((( 1 / 3
                                        ---
                                        if Open ~= 1 then
                                            for i4 = i2, FX_GetCount do
                                                local _, buf = reaper.TrackFX_GetFXName(track,i4,'')
                                                if buf:match(Fx_search)then
                                                    ---
                                                    if Close ~= 4 then
                                                        reaper.TrackFX_Show(track, i4, Close)---))
                                                    else
                                                        reaper.TrackFX_SetOpen(track, i4, 0)----))
                                                    end
                                                    ---
                                                end
                                            end
                                        end
                                        ---
                                    else
                                        for i5 = 1, FX_GetCount do
                                            local _, buf = reaper.TrackFX_GetFXName(track,i5-1,'')
                                            if buf:match(Fx_search)then
                                                reaper.TrackFX_Show(track,i5-1,Open)----((
                                            end
                                        end
                                    end
                                end
                            end
                            Guid2[i] = reaper.GetTrackGUID(track)
                            break
                        end
                    end
                end
                if resetGuid[i] ~= 1 then Guid2[i] = nil end
                resetGuid[i] = 0
            end
        elseif focus >= 1 then
            for j = 1,reaper.CountTracks(0)do Guid2[j] = nil end
        end
    end
    ---



    local function SetToggleButtonOnOff(numb)
        local _,_,sec,cmd,_,_,_ = reaper.get_action_context()
        reaper.SetToggleCommandState( sec, cmd, numb )
        reaper.RefreshToolbar2( sec, cmd )
    end
    ---



    local function exit()
        SetToggleButtonOnOff(0)
        if CloseVSTi == 1 then
            for i = 1,reaper.CountTracks(0) do
                local track = reaper.GetTrack(0,i-1)
                if track then
                    local FX_GetCount = reaper.TrackFX_GetCount(track)
                    for i2 = 1, FX_GetCount do
                        local _, buf = reaper.TrackFX_GetFXName(track,i2-1,'')
                        if buf:match(Fx_search)then
                            reaper.TrackFX_SetOpen(track,i2-1,0)
                            ---
                            if Close ~= 4 then
                                reaper.TrackFX_Show(track, i2-1, Close)---))
                            else
                                reaper.TrackFX_SetOpen(track,i2-1, 0)----))
                            end
                            ---
                        end
                    end
                end
            end
        end
        local name_script = "OFF Auto open"..Fx_search
        reaper.Undo_BeginBlock()
        reaper.Undo_EndBlock(name_script,1)
    end
    ---



    if reaper.CountTracks(0)== 0 then no_undo() return end



    if AlwaysClose ~= 0 and AlwaysClose ~= 1 then AlwaysClose = 1 end
    if OpenOneOrAllVSTi ~= 0 and OpenOneOrAllVSTi ~= 1 then OpenOneOrAllVSTi = 0 end
    if CloseVSTi ~= 0 and CloseVSTi ~= 1 then CloseVSTi = 1 end
    if Open ~= 1 and Open ~= 3 then Open = 3 end
    if Close ~= 0 and Close ~= 2 and Close ~= 4 then Close = 4 end



    local function loop()
        main(Open,Close)
        reaper.defer(loop)
    end


    SetToggleButtonOnOff(1)
    local name_script = "ON Auto open"..Fx_search
    reaper.Undo_BeginBlock()
    reaper.Undo_EndBlock(name_script,1)
    loop()
    reaper.atexit(exit)




