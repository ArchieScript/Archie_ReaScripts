--[[
   * Category:    Envelope
   * Description: Save selected points'by time*'(slot 1**) 
   * Oписание:    Сохранение выбранных точек'по времени*'(слот 1**)         
                  * Если сохранить и переместить точку – то восстановления не произойдет,
                    потому что восстановление работает по времени"точка при восстановлении
                    должна находится в той же позиции - что была при сохранении"
                  ** Чтобы изменить № слота,измените строку "local slot = (№ слота)" 
                       который нужен, и в скрипте восстановления
                         (Restore saved points'by time'(slot 1)) сделать тоже самое
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



    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------


    if not tonumber(slot) then slot = 1 end
    
    local Envelope = reaper.GetSelectedEnvelope( 0 )
    if not Envelope then no_undo() return end
    


    reaper.DeleteExtState('section_selX_InTimeԘ'..slot, 'key_SelX_InTimeԘ'..slot, true )
    reaper.DeleteExtState('section_timX_InTimeԘ'..slot, 'Key_TimX_InTimeԘ'..slot, true )



    reaper.Undo_BeginBlock() 
    

    local selX,timeX = '',''

    local CountAutoItem = reaper.CountAutomationItems(Envelope)
    for i1 = -1,CountAutoItem -1 do 
       local CountPoint =  reaper.CountEnvelopePointsEx(Envelope,i1)
       for i2 = 1,CountPoint do 
           local _,time,_,_,_,sel = reaper.GetEnvelopePointEx(Envelope,i1,i2-1)
            sel = tostring(sel)
            selX = selX..'&'..sel  
            timeX = timeX..'&'..time 
            reaper.SetExtState( 'section_selX_InTimeԘ'..slot, 'key_SelX_InTimeԘ'..slot, selX , false ) 
            reaper.SetExtState( 'section_timX_InTimeԘ'..slot, 'Key_TimX_InTimeԘ'..slot, timeX , false )                
      end    
    end 

    reaper.Undo_EndBlock("Save selected points'by time'( slot "..slot..' )',1)


   
   

