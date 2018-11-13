--[[
   * Category:    Markers
   * Description: Restore template regions from slot "X"
   * Oписание:    Восстановить шаблон регионов из слота "X"
   * GIF:         http://clck.ru/ENiiR
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    ---
   * gave idea:   ---
--=================================================]]
 
 
 
    local MaxSlot = 100 --  Максимальное количество слотов можно менять
                        --  от 0 до бесконечности,
                        --  в скрипте сохранения
                        --  выставить такие-же значения 
                                             ----------
                        --  The maximum number of slots can be changed 
                        --  from 0 to infinity, in the conservation of script
                        --  set the same values
                        -----------------------------------------------
                        
    local Slot = 0 -- 0 равен - Показать окно для ввода слота, 
                   -- в противном случае впишите номер слота 
                   -- в скрипте сохранения так-же впиcать номер слота 
                   -- и окно появляться не будет
                                     -----------
                   -- 0 is equal - Show the window for entering the slot,
                   -- otherwise enter the number of the slot
                   -- in the conservation of script, also enter the number of the slot
                   -- and the window will not appear
                   -----------------------------------------------
                     
    local RemoveExistingRegion = 0           
                    -- RemoveExistingRegion = true 
                    -- Удалить перед восстановлением все
                    -- существующие регионы из проекта.  
                    -- RemoveExistingRegion = false     
                    -- Не удалить перед восстановлением все
                    -- существующие регионы из проекта. 
                    -- RemoveExistingRegion = 0 
                    -- показывать окно с запросом.
                    
                    -- RemoveExistingRegion = true 
                    -- Remove before restoring all 
                    -- Existing regions from the project.
                    -- RemoveExistingRegion = false     
                    -- Do not remove before restoring all 
                    -- Existing regions from the project.
                    -- RemoveExistingRegion = 0 
                    -- show a window with a query. 
                    -----------------------------------
                    
    local RemoveSaveState = 0
        --Удалить информацию о сохранении текущего пресета
             -- при восстановлении, = 1 Да, = 0 Нет
    -----------------------------------------------               
    
    -- Чтобы зачистить все сохраненные слоты, введите в окне ввода слота слово "Reset"
    -- To clear all saved slots, enter the word in the slot input window "Reset"
    ----------------------------------------------------------------------------
    
    
    
    
    --======================================================================================
    --////////////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------    
    
    
    
    if not tonumber(RemoveSaveState) then RemoveSaveState = 0 end
    if not Slot then Slot = 0 end
    if not MaxSlot then MaxSlot = 100 end
    if not RemoveExistingRegion then RemoveExistingRegion = false end
    
    
    
    do local Check
      for i = 1, MaxSlot do
          Check = reaper.GetExtState( "sectionß***", "keyß***"..i)
          if Check ~= "" then break end
      end 
      if Check == "" then 
          local text = "Нет сохраненных слотов !\n\n"
              .. "No saved slots !"
          reaper.MB(text,"ERROR !",0)  
          do no_undo() return end  
      end
    end
    
 
    if Slot == 0 then
        local retval,value_csv = reaper.GetUserInputs
                               ( "Restore template regions in slot"
                               , 1
                               , "Specify number slot".."  < 0 - "..MaxSlot.." >"
                               , "№ Slot"
                               )
        if retval == false then no_undo() return end
        Slot = value_csv
    end   
    
    local j,g
    for var in string.gmatch (Slot,"[^%s]") do  -- пробела
        if not j then j = "" end
        j = j..var    --все кроме пробела
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
    ---===================================
    
    
    
    local PosReg  = reaper.GetExtState( "sectionß***", "keyß***"..Slot)
    local EndReg  = reaper.GetExtState( "sectionßß**", "keyßß**"..Slot)
    local NameReg = reaper.GetExtState( "sectionßßß*", "keyßßß*"..Slot)
    local ColReg  = reaper.GetExtState( "sectionßßßß", "keyßßßß"..Slot)
    local one     = reaper.GetExtState( "section.ß.ß", "key.ß.ß"..Slot)
    ---
    if not one or one == "" then one = 0 end
    reaper.DeleteExtState( "section.ß.ß", "key.ß.ß"..Slot, true)
    reaper.SetExtState( "section.ß.ß", "key.ß.ß"..Slot, one+1  ,true)
    local one = reaper.GetExtState( "section.ß.ß", "key.ß.ß"..Slot)
    ----
     
    if PosReg  == '' and 
       EndReg  == '' and 
       NameReg == '' and 
       NameReg == '' then 
       
       local ExistingSlots = ""
       for i = 1, MaxSlot do
           local PosReg = reaper.GetExtState( "sectionß***", "keyß***"..i)
           if PosReg ~= "" then ExistingSlots = ExistingSlots .. i .. " , " end
       end 
       if ExistingSlots ~= "" then 
           ExistingSlots = "Сохраненные слоты: \nSaved slots: \n\n"..ExistingSlots 
           ExistingSlots = ExistingSlots:match(".+ [^,]+") 
       end
 
       local ERROR = "Отсутствует сохраненный слот \n"
                  .. "Ввести другой ? \n"
                  .. " \n"
                  .. "No saved slot \n"
                  .. "Enter another ? \n"
                  .. "--------------------\n\n"
            
           local MB = reaper.MB(ERROR..ExistingSlots,"ERROR !",1)
           if MB == 1 then 
                local ScriptPath = select(2,reaper.get_action_context())
               dofile(ScriptPath)
           end
           do no_undo() return end
    end  
    
    
    
    
    reaper.Undo_BeginBlock()
    
    if RemoveExistingRegion == 0 then  
        local text = "Удалить существующие регионы ? \n\n"
             .."Delete existing regions?"
        local MB = reaper.MB(text,"ERROR !",4)
        if MB == 6 then RemoveExistingRegion = true end
        if MB == 7 then RemoveExistingRegion = false end
    end
    
    if RemoveExistingRegion == true then  
        local _, _, num_regions = reaper.CountProjectMarkers( 0 )
        if num_regions > 0 then  
            for i = 1,1000000 do
                reaper.DeleteProjectMarker( 0,i,1)
                local _, _, Count = reaper.CountProjectMarkers( 0 ) 
                if Count == 0 then break end
            end
        end 
    end    
     
    local PosRegT,EndRegT,NameRegT,ColRegT,forloop = {},{},{},{},0
    
    for var in string.gmatch( PosReg , "[^&]+") do
        PosRegT[#PosRegT+1] = var   
    end
    
    for var in string.gmatch( EndReg , "[^&]+") do
        EndRegT[#EndRegT+1] = var
    end
    
    for var in string.gmatch( NameReg , "[^&]+") do
        NameRegT[#NameRegT+1] = var..string.rep(" ",one)         
    end
    
    for var in string.gmatch( ColReg , "[^&]+") do
        ColRegT[#ColRegT+1] = var
    end
    ---  

    for i = 1,#PosRegT do   
        if NameRegT[i]:match("!empty!") then NameRegT[i] = ""..string.rep(" ",one) end            
        reaper.AddProjectMarker2(0,true,PosRegT[i],EndRegT[i],NameRegT[i],1,ColRegT[i])
    end    
    ---
    
    local _, _, num_regions = reaper.CountProjectMarkers( 0 )
    if num_regions > 0 then  
        for i = 1,num_regions do
            local retval,isrgn,pos,rgnend,name,markrgnindexnumber = reaper.EnumProjectMarkers( i-1 )
            local name = name:match(".+[^%s]+") -- минус пробел в конце
            if not name then name = "" end
            reaper.SetProjectMarker( markrgnindexnumber, isrgn, pos, rgnend, name )
        end
    end
    ---
    
    if RemoveSaveState == 1 then
        reaper.DeleteExtState( "sectionß***", "keyß***"..Slot, true)
        reaper.DeleteExtState( "sectionßß**", "keyßß**"..Slot, true)
        reaper.DeleteExtState( "sectionßßß*", "keyßßß*"..Slot, true)
        reaper.DeleteExtState( "sectionßßßß", "keyßßßß"..Slot, true)
        reaper.DeleteExtState( "section.ß.ß", "key.ß.ß"..Slot, true)
    end
    
    reaper.Undo_EndBlock("Restore template regions from slot", -1 )
    reaper.UpdateTimeline()
