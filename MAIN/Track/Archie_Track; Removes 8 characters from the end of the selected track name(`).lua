--[[
   * Category:    Track
   * Description: Removes 8 characters from the end of the selected track name
   * Oписание:    Убирает с конца имени выделенных треков 8 символов (русс / 2)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    Supa75 (Rmm/forum)
   * gave idea:   Supa75 (Rmm/forum)
--====================================]]



    local CountEndRemove = 8
      --Введите значение, сколько символов нужно удалить с конца имени веделенных треков



    --===========================================================================
    --////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local CountSelTrack = reaper.CountSelectedTracks(0)
    if CountSelTrack == 0 then no_undo()return end
    if not CountEndRemove then CountEndRemove = 1 end
    for i = CountSelTrack-1,0,-1 do
        local SelTrack = reaper.GetSelectedTrack(0,i)
        local _,name = reaper.GetSetMediaTrackInfo_String(SelTrack,"P_NAME","",0)
        if name ~= "" then
            local len = string.len(name)
            if len >= CountEndRemove then
                local name = string.match(string.reverse(name),".+",CountEndRemove+1)
                if not name then name = "" end
                local name = string.reverse(name)
                reaper.GetSetMediaTrackInfo_String( SelTrack, "P_NAME", name, 1 )
            end
        end
    end
	no_undo()