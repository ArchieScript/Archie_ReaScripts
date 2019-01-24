--[[
   * Category:    Markers
   * Description: Save template regions in slot "X"
   * Oписание:    Сохранить шаблон регионов в слот "X"
   * GIF:         http://clck.ru/ENiiR
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    ---
   * gave idea:   ---
--========================================================]]


 
    local MaxSlot = 100 --  Максимальное количество слотов можно менять
                        --  от 0 до бесконечности,
                        --  в скрипте восстановления
                        --  выставить такие-же значения 

                        --  The maximum number of slots can be changed 
                        --  from 0 to infinity, in the recovery script
                        --  set the same values
                        -----------------------------------------------
    local Slot = 0 -- 0 равен - Показать окно для ввода слота, 
                   -- в противном случае впишите номер слота 
                   -- в скрипте восстановления так-же впиcать номер слота 
                   -- и окно появляться не будет
                                     -----------
                   -- 0 is equal - Show the window for entering the slot,
                   -- otherwise enter the number of the slot
                   -- in the recovery script, also enter the number of the slot
                   -- and the window will not appear
                   -----------------------------------------------
                   
    -- Чтобы удалить(сбросить) все сохраненные слоты, введите в окне ввода слота слово "Reset"
    -- To delete(reset) all of the saved slots, enter in the input box to slot the word "Reset"
    ------------------------------------------------------------------------------------------- 
        
    
    
    --===========================================================================
    --////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================
    
    
    
    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    if not Slot then Slot = 0 end
    if not MaxSlot then MaxSlot = 100 end
    
    local _, _, num_regions = reaper.CountProjectMarkers( 0 ) 
    if num_regions == 0 then
        ER = "ОТСУТСТВУЮТ РЕГИОНЫ В ПРОЕКТЕ! \n\n"
           .."NO REGIONS IN THE PROJECT!"
        reaper.MB(ER,"ERROR !",0) return
    end

    if Slot == 0 then
        local retval,value_csv = reaper.GetUserInputs
                               ( "Save template regions in slot"
                               , 1
                               , "Specify number slot".."  < 0 - "..MaxSlot.." >"
                               , "№ Slot"
                               )
        if retval == false then no_undo() return end
        Slot = value_csv
    end   
 
    local j,g
    for var in string.gmatch (Slot,"[^%s]") do  -- пробел
        if not j then j = "" end
        j = j..var --все кроме пробел
    end
    
    
    if j == "Reset" or j == "reset" then
        for i = 0,MaxSlot do
            reaper.DeleteExtState( "sectionß***", "keyß***"..i, true)
            reaper.DeleteExtState( "sectionßß**", "keyßß**"..i, true)
            reaper.DeleteExtState( "sectionßßß*", "keyßßß*"..i, true)
            reaper.DeleteExtState( "sectionßßßß", "keyßßßß"..i, true)
            reaper.DeleteExtState( "section.ß.ß", "key.ß.ß"..i, true)
        end  
        do no_undo() return end
    end
    
    
    if not j then no_undo() return end
 
    Slot = tonumber(j) 
     
    if not tonumber(Slot)then Slot = -1 end   
    if Slot >= 0 and Slot <= MaxSlot then
        g = 0
    end
    if not g then
        local ERROR = "Не верные значения! \n"
              .."Введите номер слота от 1 до"..MaxSlot.." \n"
              .."\n"
              .."Invalid values! \n"
              .."Enter a slot number between 1 and"..MaxSlot.."\n"
      
        local MB = reaper.MB(ERROR,"ERROR !",1)
        if MB == 1 then 
            local ScriptPath = select(2,reaper.get_action_context())
            dofile(ScriptPath)
        end
        do no_undo() return end
    end
    --==========================
   
    
    
    reaper.DeleteExtState( "sectionß***", "keyß***"..Slot, true)
    reaper.DeleteExtState( "sectionßß**", "keyßß**"..Slot, true)
    reaper.DeleteExtState( "sectionßßß*", "keyßßß*"..Slot, true)
    reaper.DeleteExtState( "sectionßßßß", "keyßßßß"..Slot, true)
    reaper.DeleteExtState( "section.ß.ß", "key.ß.ß"..Slot, true) 
     
    
    local _, _, num_regions = reaper.CountProjectMarkers( 0 )
    if num_regions == 0 then no_undo() return end
    
    
    reaper.Undo_BeginBlock()
        
    local PosReg,EndReg,NameReg,ColReg = '','','',''
    
    for i = 1, num_regions do
    
        local retval,isrgn,pos,rgnend,name,markrgnindexnumber,color = reaper.EnumProjectMarkers3( 0, i-1 )
         
        if name == "" or name == " " then name = "!empty!" end
        
        PosReg  = PosReg  ..'&'.. pos
        EndReg  = EndReg  ..'&'.. rgnend
        NameReg = NameReg ..'&'.. name
        ColReg  = ColReg  ..'&'.. color
    
    end
    
    
    reaper.SetExtState( "sectionß***", "keyß***"..Slot, PosReg ,true)
    reaper.SetExtState( "sectionßß**", "keyßß**"..Slot, EndReg ,true)
    reaper.SetExtState( "sectionßßß*", "keyßßß*"..Slot, NameReg,true)
    reaper.SetExtState( "sectionßßßß", "keyßßßß"..Slot, ColReg ,true)
    reaper.SetExtState( "section.ß.ß", "key.ß.ß"..Slot, 0      ,true)
    
    
    
    reaper.Undo_EndBlock("Save template regions in slot", -1 )
    reaper.UpdateTimeline()
     
