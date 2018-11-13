--[[
   * Category:    Envelope
   * Description: Restore saved points'by time*'(slot 1**) 
   * Oписание:    Восстановление сохраненных точек"по времени*"(слот 1**)
                  * Подробнее в "Save selected points'by time'(slot 1)"
                  ** Чтобы изменить № слота,измените строку "local slot = (№ слота)" 
                     который нужен, и в скрипте Сохранение(Save selected
                                              points by time) сделать тоже самое
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    ---
   * gave idea:   ---
--==========================================]]    
    
    
    
    ---------------------------
    local slot = (1) -- № слота
    ---------------------------
    local RemoveSaveState = (0)
        --Удалить информацию о сохранении при восстановлении, = 1 Да, = 0 Нет
    --------------------------------------------------------------------------
    
    
    
    --===========================================================================
    --////////////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================
    
    
    
    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------
        
    
    if not tonumber(slot) then slot = 1 end
    if not tonumber(RemoveSaveState) then RemoveSaveState = 0 end
    
    local Envelope = reaper.GetSelectedEnvelope( 0 )
    if not Envelope then no_undo() return end
    
    
    
    local selX  = reaper.GetExtState('section_selX_InTimeԘ'..slot, 'key_SelX_InTimeԘ'..slot)  
    local timeX = reaper.GetExtState('section_timX_InTimeԘ'..slot, 'Key_TimX_InTimeԘ'..slot) 
    if selX == '' and timeX == '' then no_undo() return end

     
     
    reaper.Undo_BeginBlock() 
    
    
    local selT,timeT = {},{}
    local t
    for S in string.gmatch (selX, "[^&]+") do
        if not tonumber(t)then t = 0 end t = t + 1 
        if S == 'true'  then  S = true  end
        if S == 'false' then  S = false end
        selT[t] = S
    end
    
    
    local t = nil
    for S in string.gmatch (timeX, "[^&]+") do
        if not tonumber(t)then t = 0 end t = t + 1 
        S = tonumber(S)  
        timeT[t] = S 
    end



    local t = nil  
    local CountAutoItem = reaper.CountAutomationItems(Envelope)
    for i1 = -1,CountAutoItem -1  do  
       local CountPoint = reaper.CountEnvelopePointsEx(Envelope,i1)
       for i2 = 1,CountPoint do 
           local _,time,_,_,_,_ = reaper.GetEnvelopePointEx(Envelope,i1,i2-1)
           reaper.SetEnvelopePointEx(Envelope,i1,i2-1,nil,nil,nil,nil,false,nil)
           
            for iT = 0, #timeT  do
                if time == timeT[iT] then
                    reaper.SetEnvelopePointEx(Envelope,i1,i2-1,nil,nil,nil,nil,selT[iT],nil)
                end
            end    
       end
    end   
    
    
    if RemoveSaveState == 1 then
        reaper.DeleteExtState('section_selX_InTimeԘ'..slot, 'key_SelX_InTimeԘ'..slot, true )
        reaper.DeleteExtState('section_timX_InTimeԘ'..slot, 'Key_TimX_InTimeԘ'..slot, true )
    end
    
    reaper.Undo_EndBlock("Restore saved points'by time'( slot "..slot..' )',1)
    reaper.UpdateArrange()

