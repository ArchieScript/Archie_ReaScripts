--[[
   * Category:    Track
   * Description: Select a track by name(abbreviated input)
   * Oписание:    Выберите треки по имени(сокращенный ввод)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    Supa75(RMM)
   * gave idea:   Supa75(RMM)
--=========================]]



    local Unselect_From_Previous = 2
                            -- = 2 Показать окно с запросом о снятии выделения с предыдущих треков
                            -- = 1 Не показывать окно с запросом и Снять выделение
                            -- = 0 Не показывать окно с запросом и Не снимать выделение,



    --===========================================================================
    --////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------




    local CountTr = reaper.CountTracks()
    if CountTr == 0 then no_undo() return end


    if not Unselect_From_Previous then Unselect_From_Previous = 2 end
    local retval, UserName = reaper.GetUserInputs
    ('Select track by name',1,'Enter the name of the track,extrawidth=50','name:')
    if retval == false then no_undo()return end
    if UserName == "ૐ" then no_undo()return end
    if string.gsub(UserName,"%s",""):len() == 0 then UserName = "" end
    if UserName == "" then UserName = "ૐ" end
    if not string.match(UserName,"%S")then no_undo() return end
    -----------------------------------------------------------


    local Undo
    for i = 1, CountTr do
        local track = reaper.GetTrack(0, i-1)
        local NameTrack,_ = reaper.GetTrackState(track)
        if NameTrack == "ૐ" then NameTrack = "ఋ" end
        if string.gsub(NameTrack,"%s",""):len() == 0 then NameTrack = "" end
        if NameTrack == "" then NameTrack = "ૐ" end
        if string.match(NameTrack,UserName) then

            if not StopUnselect then
                if Unselect_From_Previous == 2 then
                    if reaper.GetSelectedTrack(0,0)then
                        local Message = reaper.ShowMessageBox
                        ("Unselected All track ?","Select track by name",1)
                        if Message == 1 then Unselect_From_Previous = 1 end
                    end
                end
                ---
                if Unselect_From_Previous == 1 then
                    local tr = reaper.GetTrack(0, 0)
                    reaper.SetOnlyTrackSelected(tr)
                    reaper.SetTrackSelected(tr, 0)
                end
                local StopUnselect = 1
            end
            reaper.SetTrackSelected(track, 1)
            Undo = 1
        end
    end
    ---

    if Undo ~= 1 then
        no_undo()
    else
        reaper.Undo_BeginBlock()
        reaper.Undo_EndBlock("Select track by name", 1)
    end
