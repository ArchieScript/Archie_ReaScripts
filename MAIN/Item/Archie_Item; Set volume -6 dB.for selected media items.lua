--[[
   * Category:    Item
   * Description: Set volume -6 dB.for selected media items
   * Oписание:    Установите громкость -6 дБ.для выбранных элементов мультимедиа
   * GIF:         https://clck.ru/EeuyB
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    AlexLazer(RMM Forum)
   * gave idea:   AlexLazer(RMM Forum)
--==================================]]



    local DB = (-6.0)
                  -- Установите громкость для выбранных элементов



    --===========================================================================
    --///////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local Count = reaper.CountSelectedMediaItems( 0 )
    if Count == 0 then no_undo() return end


    if not tonumber(DB) then DB = (-6)end
    if DB <= -150 then DB = -150 end
    if DB >= 24 then DB = 24 end
    ---
    if DB < 0 then
        DB = math.abs(DB)
    else
        DB = tonumber("-"..DB)
    end
    ---
    local db = (0.89075630252101^(DB*0.99522))

    local Undo
    for i = 1,Count do
       local item = reaper.GetSelectedMediaItem( 0, i-1 )
       local take = reaper.GetMediaItemTake( item, 0 )
       if not reaper.BR_IsTakeMidi(take) then
           reaper.SetMediaItemInfo_Value( item, 'D_VOL', db )
           Undo = 1
       end
    end

    if Undo ~= 1 then
        no_undo()
    else
        reaper.Undo_BeginBlock()
        reaper.Undo_EndBlock("Set volume -6 dB.for selected media items",1)
    end
    reaper.UpdateArrange()
