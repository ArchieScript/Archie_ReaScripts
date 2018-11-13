 --[[
   * ВАЖНО:  IMPORTANTLY:
   * ПРИ ПЕРВОМ ЗАПУСКЕ СКРИПТА ПОЯВИТСЯ ОКНО {Reascript task control}:
   * ДЛЯ КОРРЕКТНОЙ РАБОТЫ СКРИПТА СТАВИМ ГАЛКУ
   * {Remember my answer for this script} НАЖИМАЕМ New instance 
     -------
   * Category:    Item
   * Description: Select first or next item from cursor position(full description inside)
                  Select first or next item from cursor position in first selected
                  track with selected item or from first item,Selected track
                  optionally, move the item to the cursor
   * Oписание:    Выбрать первый или следующий элемент от позиции курсора в первом
                  выбранном треке с выбранным элементом или от первого элемента,
                  Выбрать трек, по желанию переместить элемент к курсору
   * GIF:         http://goo.gl/zVcwMg
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.01
   * customer:    HDVulcan(RMM_Forum)   
   * gave idea:   HDVulcan(RMM_Forum)  
   * changelog:   + Added double undo on request HDVulcan / v.1.1 
                  + Добавлена двойная отмена по просьбе HDVulcan / v.1.1               
--=====================================================================]]


   
   
    local Sel_Track_On_Off = (1)
                          --[[ Возможность Выделять Трек, После Применения Скрипта:
                             "1" = | ON  |  Вместе с выделенным итемом выделяется также и текущий трек.
                             "2" = | OFF |  Вместе с выделенным итемом не происходит выделения текущего трека.]]
                             --=================================================================================
        
    local BlockFirstItem = (true)
                        --[[   Возможность Блокировки Ранее Выделенного айтема:(Когда курсор на начале айтема)
                             "true"  = Блокировать ранее выделенный айтем.
                             "false" = Не блокировать ранее выделенный айтем.]]
                             --===============================================

    local MoveItem = (0)
                        --[[   Возможность Подтягивать Выделенный айтем:
                             "0" = Не подтягивать выделенный айтем к позиции курсора;
                             "1" = Подтягивать выделенный айтем к позиции курсора.]]
                             --=====================================================
            
    local SequenceSelect = (0)
                       --[[    Курсор Стоит на Начале Нескольких айтемов:
                           "0" = Если нет выделенных айтемов,сначала выделится верхний айтем, далее следующий на треке.
                               Если есть выделенные айтемы,то сразу выделится следующий на треке.
                           "1" = Если нет выделенных айтемов,сначала выделится верхний айтем, далее следующий на треке.
                               Если есть выделенные айтемы,кроме верхнего,то выделится сначала верхний айтем и затем следующий на треке.
                           "2" = Если нет выделенных айтемов, сначала выделится нижний айтем, далее верхний и затем следющий на треке.   
                               Если есть выделенные айтемы,кроме верхнего,то выделится сначала верхний айтем и затем следующий на треке.]]       
                               --=======================================================================================================
     
     local Double_Undo = (0)
                     -- Создать две точки отмены 
                     -- При первом нажатии на отмену не снимать выделение с только что выделенного айтема
                     -- = 0  | OFF |
                     -- = 1  | ON  |
                     -- Работает только с включенным MoveItem [ MoveItem = (1) ]
                     --=========================================================
                     
                     
     

    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================
    
    
    
        
    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local function GetFirstSelItemInFirstSelTrackOrJustFirstSelItem()
        local Sel_item, It_track, sel, Get, x
        for i = 1, reaper.CountSelectedMediaItems( 0 ) do
            Sel_item = reaper.GetSelectedMediaItem(0, i - 1)
            It_track = reaper.GetMediaItem_Track( Sel_item )
            sel = reaper.IsTrackSelected( It_track )
            if sel == true then
                Get = reaper.GetSelectedMediaItem(0, i - 1);x = 1;break
            end
        end
        if not x then Get = reaper.GetSelectedMediaItem(0, 0)end
        return Get
    end
    --========================================================



    local WorkingItem = GetFirstSelItemInFirstSelTrackOrJustFirstSelItem()
    local Track
    if WorkingItem then
        Track = reaper.GetMediaItem_Track( WorkingItem )
    else
        Track = reaper.GetSelectedTrack( 0, 0 )
    end
    if not Track then no_undo() return end
    --====================================
    

    reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock()
    --======================


    if Track then
        if Sel_Track_On_Off == 1 then
            reaper.SetOnlyTrackSelected( Track )
            --reaper.SetMediaTrackInfo_Value( Track, 'I_SELECTED', 0 )--*
            --reaper.SetMediaTrackInfo_Value( Track, 'I_SELECTED', 1 )--*
            --* Что б трек стал последний тронутый активируй две строки
        end
    end
    --=============================================
    

    local Cur = reaper.GetCursorPosition()
    local CountTrItem = reaper.CountTrackMediaItems( Track )
    local BackwardShift,initial
    ---------------------------
    for i = 1, CountTrItem do
        local Tr_item = reaper.GetTrackMediaItem( Track, i - 1 )
        local pos = reaper.GetMediaItemInfo_Value( Tr_item, 'D_POSITION' )
        local IsItemSel = reaper.IsMediaItemSelected( Tr_item )
        -------------------------------------------------------
        if Cur >= pos and Cur <= pos+0.0000001 then BackwardShift = pos end
        -------------------------------------------------------------------
        if pos == Cur then
            for i2 = 1, CountTrItem do
            --------------------------
                local Tr_item2 = reaper.GetTrackMediaItem( Track, i2 - 1 )
                local pos2 = reaper.GetMediaItemInfo_Value( Tr_item2, 'D_POSITION' )
                local IsItemSel = reaper.IsMediaItemSelected( Tr_item2 )
                -------------------------------------------------------
                if SequenceSelect == 0 then
                    --0=_Первый(верхний) и Следующий/Следующий
                    if pos2 == Cur and IsItemSel == true then
                        Tr_item = Tr_item2
                        break
                    else
                        if pos2 == Cur and IsItemSel == false then
                            Tr_item = Tr_item2
                        end
                    end
                else
                    if SequenceSelect == 1 or SequenceSelect == 2 then
                        --1=_Первый(верхний)и Следующий/Первый(верхний)и Следующий
                        --2=_последний(нижний)Первый(верхний)и Следующий/Первый(верхний)и Следующий
                        if pos2 == Cur and IsItemSel == true then
                            first = 0
                        end
                        if pos2 == Cur and first == 0 then
                            Tr_item = Tr_item2
                        end
                        if SequenceSelect == 1 then
                            if pos2 == Cur and not first then Tr_item = Tr_item2 end
                        end
                    end
                end
                ----------------------------
                if pos2 > Cur then break end
            end
        end
        ------------------------------------------------------
        local IsItemSel = reaper.IsMediaItemSelected( Tr_item)
        --====================================================
        
        
        if pos == Cur and IsItemSel == false then
            reaper.SelectAllMediaItems( 0, 0 )
            reaper.SetMediaItemSelected( Tr_item, 1 )
            initial = 1
            break
            ----------------------------------------
        else
            if pos == Cur and IsItemSel == true then
                if BlockFirstItem == true then
                    reaper.SetEditCurPos( pos + 0.0000001, true, true )
                end
            end
            ------------------------------------------------------------
        end
        --============================================================
        
        if pos > Cur then
        -----------------
            if SequenceSelect == 0 or SequenceSelect == 1 then  
                local posX,x = _,0
                for i2 = 1, CountTrItem do 
                    local Tr_it = reaper.GetTrackMediaItem( Track, i2 - 1 ) 
                    local posN = reaper.GetMediaItemInfo_Value( Tr_it, 'D_POSITION' )
                    if posN > Cur then
                        x = (x + 1)
                        if posN == posX then
                            Tr_item = Tr_it
                        else
                            if posN ~= posX and x > 1 then
                                break  
                            end
                        end
                        posX = posN 
                    end
                end
            end  
            --===============================
            
            reaper.SelectAllMediaItems( 0, 0 )
            reaper.SetMediaItemSelected( Tr_item, 1 )
            ----------------------------------------
            if MoveItem == 1 then
                if Double_Undo == 1 then
                    reaper.Undo_EndBlock(" [ Selected item ] / Select next item from cursor position",-1)
                    reaper.Undo_BeginBlock()
                end
                if BackwardShift then
                    ------------------
                    reaper.SetMediaItemPosition( Tr_item, BackwardShift, true )
                else
                    reaper.SetMediaItemPosition( Tr_item, Cur, true )
                end    
            end 
            break
        end    
    end
    --====================================================
    
    if not BackwardShift then BackwardShift = 0 end
    -------------------------------------------------
    local function Loop() 
        local Sel_item = reaper.GetSelectedMediaItem(0, 0)
        local Curs = reaper.GetCursorPosition()
        if Curs ~= BackwardShift+0.0000001 then return end
        if not Sel_item then   
            if BackwardShift == (Curs-0.0000001) then 
                reaper.SetEditCurPos(BackwardShift, true, true )
            end            
            return
        end  
        reaper.defer(Loop)
    end
   --===================
    if not initial then
        Loop() 
    end
    ---


    reaper.UpdateArrange()
    reaper.Undo_EndBlock( [[Select next item from cursor position
                                  in first selected track with selected
                                      item or from first item,
                                                  Selected track ]], -1)
    reaper.PreventUIRefresh(-1)----------------------------------------