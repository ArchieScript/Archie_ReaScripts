--[[ 
   * Category:    Item 
   * Description: Split (selected) item(s) under mouse cursor (select left) 
   * Author:      Archie 
   * Version:     1.11
   * AboutScript: Split selected item(s) under mouse cursor and all selected items  
                            in this position or item under mouse cursor(select left) 
                            PLEASE NOTE THE SETTINGS BELOW 
   * О скрипте:   Разделить выбранный элемент(ы) под курсором мыши и все выбранные 
                      элементы в этой позиции или элемент под курсором мыши (выбрать слева) 
                      ОБРАТИТЕ ВНИМАНИЯ НА НАСТРОЙКИ НИЖЕ 
   * GIF:         http://clck.ru/EexGi 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   * Donation:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Supa75(RMM Forum) 
   * Gave idea:   Supa75(RMM Forum) 
   * Changelog:    
   *              + REMOVE ITEM (LEFT / RIGHT) /  v.1.09 
    
   *              +!Fixed bugs Empty Item /  v.1.08 
   *              +! Fixed bugs when cutting at the point of zero / v.1.06 
   *              + Added ability to smart deselect previous items / v. 1. 05 
   *              + Added ability to select, deselect previous items / v. 1. 05 
   *              + Added the Smart Split / v.1.04 
   *              +! Fixed bugs with highlighting on last grid tick marks / v.1.03 
   *              + added the ability to control crossfade and overlap / v.1.02 
   *              + Added the ability to regulate fade-in / fade - out in the cut / v.1.01       
   *              +! Устранены ошибки при разрезании в точке нуля / v.1.06 
   *              + Добавлена возможность умного снятия выделения с предыдущих айтемов / v.1.05 
   *              + Добавлена возможность выбора снятия выделения с предыдущих айтемов / v.1.05 
   *              + Добавлено умное разрезание / v.1.04 
   *              +! Устранены ошибки с выделением на последних делениях сетки / v.1.03 
   *              + добавлена возможность регулирования перекрестным затуханием с перекрытием / v.1.02                  
   *              + Добавлена возможность регулирования усилением затуханием при разрезе / v.1.01                                      
--=============================================================================================]] 
 
 
 
 
    --====================================================================================== 
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\ 
    --====================================================================================== 
 
 
 
    local SmartSplit = 1 -- |= 1 ВКЛ|; |= 0 ВЫКЛ|; |= 1 ON|; |= 0 OFF|; 
             -- ЕСЛИ = 1 ТО, 
                  -- ЕСЛИ КУРСОР ПОД ВЫДЕЛЕННЫМ АЙТЕМОМ,  
                  -- ТО РАЗРЕЖЕТСЯ АЙТЕМ ПОД КУРСОРОМ И ВСЕ ВЫДЕЛЕННЫЕ АЙТЕМЫ В ЭТОЙ ПОЗИЦИИ 
                  -- ЕСЛИ КУРСОР НЕ ПОД ВЫДЕЛЕННЫМ АЙТЕМОМ, ТО РАЗРЕЖЕТСЯ ТОЛЬКО АЙТЕМ ПОД КУРСОРОМ 
                  --------------------------------------------------------------------------------- 
             -- IF = 1 THEN 
                  -- IF A CURSOR UNDER A SELECTED ITEM, THAT THE ITEM UNDER THE CURSOR AND ALL  
                  -- THE SELECTED ITEM IN THIS POSITION WILL BE CLEARED 
                  -- IF A CURSOR IS UNDEFINED BY AN ITEM, THEN ONLY AN ITEM UNDER A CURSOR WILL BE CLEARED 
                  --====================================================================================== 
 
 
    local Unselect_Smart = 1  -- |= 1 ВКЛ|; |= 0 ВЫКЛ|; |= 1 ON|; |= 0 OFF|; 
                 -- ЕСЛИ = 1 ТО, 
                      -- ЕСЛИ КУРСОР ПОД ВЫДЕЛЕННЫМ АЙТЕМОМ, ТО  
                      --      ВЫДЕЛЕНИЕ СНИМЕТСЯ СО ВСЕХ ПРЕДЫДУЩИХ АЙТЕМОВ 
                      -- ЕСЛИ КУРСОР НЕ ПОД ВЫДЕЛЕННЫМ АЙТЕМОМ, ТО ВЫДЕЛЕНИЕ  
                      --           НЕ БУДЕТ СНИМЕТСЯ СО ВСЕХ ПРЕДЫДУЩИХ АЙТЕМОВ 
                      -- НЕ РАБОТАЕТ, ЕСЛИ ВЫКЛЮЧЕН "SmartSplit = 0" 
                      --------------------------------------------------------- 
                      -- IF THE CURSOR UNDER THE SELECTED ITEM,   
                      --     SELECTED WILL BE REMOVED FROM ALL PREVIOUS ITEMS 
                      -- IF THE CURSOR UNDER THE SELECTED ITEM, THE SELECTED  
                      --        WILL NOT WITHDRAW FROM ALL THE PREVIOUS ITEMS 
                      --  DOES NOT WORK IF DISABLED "SmartSplit = 0" 
                      --===================================================== 
 
 
    local Unselect_All_Rest_Items = 1 
                                -- = 0 |- НЕ СНИМАТЬ ВЫДЕЛЕНИЯ СО ВСЕХ ПРЕДЫДУЩИХ АЙТЕМОВ 
                                -- = 1 |- СНЯТЬ ВЫДЕЛЕНИЯ СО ВСЕХ ПРЕДЫДУЩИХ АЙТЕМОВ 
                                -- НЕ РАБОТАЕТ, ЕСЛИ ВКЛЮЧЕН "Unselect_Smart = 1" 
                                ------------------------------------------------- 
                                -- = 0 |- DON'T UNSELECT ALL PREVIOUS ITEMS 
                                -- = 1 |- UNSELECT ALL PREVIOUS ITEMS 
                                --  DOES NOT WORK IF ENABLED "Unselect_Smart = 1" 
                                --=============================================== 
 
 
    local MIDI_item = 1 -- ЕСЛИ КУРСОР ПОД МИДИ АЙТЕМОМ, ТО ЕСЛИ 
                -- MIDI_item = 0  |- БУДЕТ РЕЗАТЬ ЧЕТКО ПОД МЫШКОЙ 
                -- MIDI_item = 1  |- БУДЕТ РЕЗАТЬ ПО БЛИЖАЙШЕМУ АКТИВНОМУ ДЕЛЕНИЮ СЕТКИ 
                ----------------------------------------------------------------------- 
                        -- IF THE CURSOR IS UNDER THE MIDI ITEM, THEN IF 
                -- MIDI_item = 0  | - WILL BE CUT CLEARLY UNDER THE ARM 
                -- MIDI_item = 1  | - WILL CUT BY THE CLOSEST ACTIVE GRID DIVISION 
                --================================================================ 
 
 
    local SnapGrid = 1 
                -- SnapGrid = -1  |- БУДЕТ РЕЗАТЬ ПО БЛИЖАЙШЕМУ ПЕРЕСЕЧЕНИЮ НУЛЯ В АЙТЕМАХ 
                --                          РАБОТАЕТ ТОЛЬКО, ЕСЛИ АЙТЕМ ПОД МЫШКОЙ ВЫДЕЛЕН 
                -- SnapGrid =  0  |- БУДЕТ РЕЗАТЬ ЧЕТКО ПОД МЫШКОЙ 
                -- SnapGrid =  1  |- БУДЕТ РЕЗАТЬ ПО БЛИЖАЙШЕМУ АКТИВНОМУ ДЕЛЕНИЮ СЕТКИ 
                ----------------------------------------------------------------------- 
                -- SnapGrid = -1  |- WILL CUT AT THE NEAREST ZERO CROSSING IN THE ITEM 
                --                       ONLY WORKS IF ITEM UNDER MOUSE IS HIGHLIGHTED 
                -- SnapGrid =  0  |- WILL BE CUT CLEARLY UNDER THE ARM 
                -- SnapGrid =  1  |- WILL CUT BY THE NEAREST ACTIVE GRID DIVISION 
                --=============================================================== 
 
 
    local Fade_In_Fade_Out = -1 
                        -- = -1 | OFF |- УСИЛЕНИЕ ЗАТУХАНИЕ УСТАНАВЛИВАЕТСЯ В ЗАВИСИМОСТИ ОТ НАСТРОЕК РИПЕРА 
                        -- =  0 | ON  |- РЕЗАТЬ БЕЗ - УСИЛЕНИЕ / ЗАТУХАНИЕ 
                        -- =    | ON  |- ИНАЧЕ УСТАНОВИТЕ УСИЛЕНИЕ ЗАТУХАНИЕ В СЕКУНДАХ(МИЛЛИСЕКУНДАХ/ 0.010) 
                    -- ЧТО БЫ ЭТО РАБОТАЛО "Overlap_Cross_Fade" ДОЛЖЕН БЫТЬ РАВЕН МИНУС ОДНОМУ ( Overlap_Cross_Fade = -1 ) 
                    -- ИНАЧЕ БУДЕТ РАБОТАТЬ "Overlap_Cross_Fade" 
                    ------------------------------------------------------------------------------------------------------ 
                        -- = -1 | OFF |- FADE-IN / FADE-OUT SET DEPENDING ON REAPER SETTINGS 
                        -- =  0 | ON  |- CUT WITHOUT FADE-IN / FADE-OUT 
                        -- =    | ON  |- OTHERWISE  ESTABLISH FADE-IN / FADE-OUT IN SECONDS(MILLISECONDS/ 0.010) 
                    -- WHAT WOULD IT WORK "Overlap_Cross_Fade" MUST BE EQUAL TO MINUS ONE ( Overlap_Cross_Fade = -1 ) 
                    -- OTHERWISE WILL WORK "Overlap_Cross_Fade" 
                    --=============================================================================================== 
 
 
    local Overlap_Cross_Fade = -1 
                      -- = -1 | OFF |- ПЕРЕКРЕСТНОЕ ЗАТУХАНИЕ С ПЕРЕКРЫТИЕМ УСТАНАВЛИВАЕТСЯ В ЗАВИСИМОСТИ ОТ НАСТРОЕК РИПЕРА 
                      -- =  0 | ON  |- РЕЗАТЬ БЕЗ ПЕРЕКРЕСТНОГО ЗАТУХАНИЯ И БЕЗ ПЕРЕКРЫТИЯ 
                      -- =    | ON  |- ИНАЧЕ УСТАНОВИТЕ ПЕРЕКРЕСТНОЕ ЗАТУХАНИЕ С ПЕРЕКРЫТИЕМ В СЕКУНДАХ(МИЛЛИСЕКУНДАХ/ 0.010) 
                  -- ЕСЛИ "Overlap_Cross_Fade" БОЛЬШЕ МИНУС ОДНОГО |ON|, ТО "Fade_In_Fade_Out" РАВЕН МИНУС ОДИН |OFF| 
                  --------------------------------------------------------------------------------------------------- 
                      -- = -1 | OFF |- OVERLAP AND CROSSFADE INSTALLED DEPENDING ON REAPER SETTINGS 
                      -- =  0 | ON  |- CUT WITHOUT OVERLAP AND CROSSFADE 
                      -- =    | ON  |- ELSE INSTALL OVERLAP AND CROSSFADE IN SECONDS (MILLISECONDS/ 0.010) 
                  -- IF "Overlap_Cross_Fade" MORE MINUS ONE |ON|, "Fade_In_Fade_Out" is EQUAL to MINUS ONE |OFF| 
                  --============================================================================================ 
 
 
    local Selected = 1 
               -- Selected = 0 | СКРИПТ СРАБОТАЕТ НА ЛЮБОМ ЭЛЕМЕНТЕ 
               -- Selected = 1 | СКРИПТ СРАБОТАЕТ ТОЛЬКО НА ВЫДЕЛЕННОМ ЭЛЕМЕНТЕ 
               -- НЕ РАБОТАЕТ ЕСЛИ "SmartSplit = 1" 
               ---------------------------------------------------------------- 
               -- Selected = 0 | SCRIPT WILL WORK ON ANY ELEMENT 
               -- Selected = 1 | THE SCRIPT WILL ONLY WORK ON THE SELECTED ITEM 
               -- DOESN'T WORK IF "SmartSplit = 1" 
               --============================================================== 
     
     
    local REMOVE_ITEM = 0; 
                  -- =  0; NOT REMOVE ITEM 
                  -- = -1; REMOVE LEFT ITEM 
                  -- =  1; REMOVE RIGHT ITEM 
                  --======================== 
     
 
 
 
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
 
 
 
 
 
    ------------------------------------------------------------------------------ 
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end; 
    ------------------------------------------------------------------------------ 
 
 
 
    if Unselect_Smart ~= 0 and SmartSplit == 0 then Unselect_Smart = 0 end; 
    if Unselect_Smart ~= 0 then Unselect_Smart = 1 end; 
    if Unselect_All_Rest_Items ~= 0 then Unselect_All_Rest_Items = 1 end; 
    if SmartSplit ~= 0 and SmartSplit ~= -1 then SmartSplit = 1 end; 
    if not tonumber(Fade_In_Fade_Out)   or Fade_In_Fade_Out   < 0 then Fade_In_Fade_Out   = -1 end; 
    if not tonumber(Overlap_Cross_Fade) or Overlap_Cross_Fade < 0 then Overlap_Cross_Fade = -1 end; 
    if not tonumber(SnapGrid ) then  SnapGrid  = 1 end; 
    if not tonumber(Selected ) then  Selected  = 1 end; 
    if not tonumber(MIDI_item) then  MIDI_item = 1 end; 
    --================================================; 
 
 
 
    local function Save_Selected_Items(); 
        sel_item = {}; 
        for i = 1, reaper.CountSelectedMediaItems(0) do; 
            sel_item[i] = reaper.GetSelectedMediaItem(0,i-1); 
        end; 
    end; 
    ---; 
 
 
    local function Restore_Selected_Items(); 
        reaper.SelectAllMediaItems(0,0); 
        for i = 1, #sel_item do; 
            reaper.SetMediaItemSelected(sel_item[i],1); 
        end; 
    end; 
    ---; 
 
 
 
    -----------// Fade-In / Fade-Out \\-------------- 
    ----------// Overlap / Cross-Fade \\------------- 
 
 
    local Length_Item,Val_Fade_In_Out,splitauto; 
                  
    if Overlap_Cross_Fade >= 0 then; 
        Val_Fade_In_Out = Overlap_Cross_Fade; 
        Length_Item = Overlap_Cross_Fade; 
        Fade_In_Fade_Out = -1 
    else; 
        Val_Fade_In_Out = Fade_In_Fade_Out; 
        Length_Item = 0 
    end; 
    ---; 
 
 
    local function Set_fadeInOut_OverlapCrossFade(item, parmname, Val_Fade_In_Out, Length_Item); 
        if Fade_In_Fade_Out >= 0 or Overlap_Cross_Fade >= 0 then; 
            if Length_Item > 0 then; 
                local Length = reaper.GetMediaItemInfo_Value(item, "D_LENGTH"); 
                reaper.SetMediaItemLength(item, (Length + Length_Item), true); 
            end 
            reaper.SetMediaItemInfo_Value(item, parmname, Val_Fade_In_Out); 
        end; 
    end; 
    --====================================================================; 
 
 
 
 
 
    local function Split_item_sel_left(item,Pos,Val_Fade_In_Out, Length_Item,Unselected_rest); 
        local tr,Split = reaper.GetMediaItemTrack(item); 
        local TrackNumber = reaper.GetMediaTrackInfo_Value(tr, "IP_TRACKNUMBER"); 
        local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION"); 
        local len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH"); 
        if pos < Pos and len + pos >= Pos then; 
            Split = reaper.SplitMediaItem(item, Pos); 
            if Split then; 
                if Unselected_rest == 1 then; 
                    for i = reaper.CountTrackMediaItems(tr)-1,0,-1 do; 
                        local it = reaper.GetTrackMediaItem(tr, i); 
                        reaper.SetMediaItemInfo_Value(it, "B_UISEL",0); 
                    end; 
                end; 
                reaper.SetMediaItemInfo_Value(item, "B_UISEL",1); 
                reaper.SetMediaItemInfo_Value(Split, "B_UISEL",0); 
                Set_fadeInOut_OverlapCrossFade(Split, "D_FADEINLEN" , Val_Fade_In_Out, 0); 
                Set_fadeInOut_OverlapCrossFade(item , "D_FADEOUTLEN", Val_Fade_In_Out, Length_Item); 
                ---- 
                if REMOVE_ITEM == 1 then; 
                    reaper.DeleteTrackMediaItem(tr,Split); 
                    Split = item; 
                elseif REMOVE_ITEM == -1 then; 
                    reaper.DeleteTrackMediaItem(tr,item); 
                    item = Split; 
                end; 
                ---- 
            end; 
        end; 
        return TrackNumber,Split,item; 
    end; 
    --===============================; 
 
 
 
    if SmartSplit == 1 then Selected = 0 end; 
 
    local window, segment, details = reaper.BR_GetMouseCursorContext(); 
    local item = reaper.BR_GetMouseCursorContext_Item(); 
    if item then; 
        if Selected > 0 then; 
            sel = reaper.GetMediaItemInfo_Value( item, "B_UISEL"); 
        end; 
    end; 
    if not item or sel == 0 then no_undo()return end; 
    --==============================================; 
 
 
 
 
    local take = reaper.GetActiveTake(item); 
    --- 
    local TakeIsMIDI; 
    if item and not take then; 
        TakeIsMIDI = true; 
    else; 
        TakeIsMIDI = reaper.TakeIsMIDI,take; 
    end; 
    --- 
    if TakeIsMIDI == true then; 
        if MIDI_item <= 0 then; 
            SnapGrid = 0; 
        else; 
            SnapGrid = 1; 
        end; 
    end; 
    --==================; 
 
 
 
 
    -------------------------------------------------------------- 
    --[[ Чтобы отмена не снимала выделение с треков при включенном 
        (опции/настройки/общие/настройки отмены действий/трек) 
 
        To cancel does not deselect tracks when enabled  
          (options/preference/general/undo settings/track) --]] 
 
    reaper.Undo_BeginBlock();reaper.Undo_EndBlock("",-1); 
    ----------------------------------------------------; 
 
 
 
 
    local name_script = "Split selected item under mouse cursor and" 
               .."all selected items in this position(select left)" 
    reaper.Undo_BeginBlock(); 
    --======================; 
 
 
 
    local Pos = reaper.BR_PositionAtMouseCursor(true); 
    if SnapGrid > 0 then; 
        Pos = reaper.SnapToGrid(0,Pos); 
    elseif SnapGrid == -1  then; 
        reaper.PreventUIRefresh(1); 
        Save_Selected_Items(); 
        reaper.SelectAllMediaItems(0,0); 
        reaper.SetMediaItemSelected(item,1)  
        local CurPos = reaper.GetCursorPosition(); 
        reaper.SetEditCurPos(Pos,0,0); 
        reaper.Main_OnCommand(41995, 0); 
        --Move edit cursor to nearest zero crossing in items 
        Pos = reaper.GetCursorPosition(); 
        reaper.SetEditCurPos(CurPos,0,0); 
        Restore_Selected_Items(); 
        reaper.PreventUIRefresh(-1); 
    end; 
    --=============================; 
 
 
 
 
    if Val_Fade_In_Out >= 0 then; 
        splitauto = reaper.SNM_GetIntConfigVar("splitautoxfade",0); 
        reaper.SNM_SetIntConfigVar("splitautoxfade",10);-- 10 No All; 2,3,11-Yes/(1-2);(2-3);(все-11)) 
    end; 
    ---; 
 
 
 
    if SmartSplit == 1 then; 
        local selected = reaper.GetMediaItemInfo_Value(item, "B_UISEL"); 
        if selected == 0 then; 
            OnSmart = 1; 
        end; 
    end; 
 
 
    if Unselect_Smart == 1 then; 
        if OnSmart == 1 then; 
            Unselect_All_Rest_Items = 0 
        else 
            Unselect_All_Rest_Items = 1 
        end; 
    end; 
 
    local TrackNumber,Split,item = Split_item_sel_left(item,Pos,Val_Fade_In_Out, Length_Item,Unselect_All_Rest_Items); 
 
    if Split then; 
     
        if OnSmart == 1 then; 
            if Unselect_All_Rest_Items == 1 then; 
                reaper.SelectAllMediaItems(0,0); 
            end; 
            reaper.SetMediaItemInfo_Value(item,"B_UISEL",1); 
            reaper.SetMediaItemInfo_Value(Split,"B_UISEL",0); 
        else; 
            local countTrack = reaper.CountTracks(0); 
            for i = 1,countTrack do; 
                local track = reaper.GetTrack(0, i-1); 
                local TrNumb =  reaper.GetMediaTrackInfo_Value( track, "IP_TRACKNUMBER"); 
                if TrNumb ~= TrackNumber then; 
                    local CountTrItems = reaper.CountTrackMediaItems(track); 
                    for i2 = 1,CountTrItems do; 
                        local item = reaper.GetTrackMediaItem(track, i2-1); 
                        local pos = reaper.GetMediaItemInfo_Value(item, "D_POSITION"); 
                        local len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH"); 
                        if pos <= Pos and len + pos >= Pos then; 
                            if reaper.GetMediaItemInfo_Value( item, "B_UISEL")== 1 then; 
                                Split_item_sel_left (item,Pos,Val_Fade_In_Out, Length_Item,Unselect_All_Rest_Items); 
                                break; 
                            end; 
                        else; 
                            if Unselect_All_Rest_Items == 1 then; 
                                reaper.SetMediaItemInfo_Value( item,"B_UISEL",0); 
                            end; 
                        end; 
                    end; 
                end; 
            end; 
        end; 
     
    end; 
    ---; 
 
 
 
    if splitauto then; 
        reaper.SNM_SetIntConfigVar("splitautoxfade",splitauto); 
    end; 
    ----------------------------------------------------------; 
 
    reaper.Undo_EndBlock(name_script,-1); 
    reaper.UpdateArrange(); 
    ----------------------; 