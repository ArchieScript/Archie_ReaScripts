--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Various 
   * Description: Var; Save time selection when record - Copy selected items after recording In place 
   * Author:      Archie 
   * Version:     1.0 
   * Описание:    Сохранить время выбора при записи - Копировать выбранные элементы после записи на месте 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    odinzavseh(Rmm) 
   * Gave idea:   odinzavseh(Rmm) 
   * Extension:   Reaper 6.03+ http://www.reaper.fm/ 
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php 
   * Changelog:    
   *              v.1.0 [19.02.20] 
   *                  + initialе 
--]] 
    --====================================================================================== 
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\ 
    --====================================================================================== 
     
     
    -- ПРИ ПОЯВЛЕНИИ ОКНА (REASCRIPT TASK CONTROL)  
    -- ДЛЯ КОРРЕКТНОЙ РАБОТЫ СКРИПТА СТАВИМ ГАЛКУ  
    -- (REMEMBER MY ANSWER FOR THIS SCRIPT)  
    -- НАЖИМАЕМ 'NEW INSTANCE' 
    ------------------------- 
    --WHEN THE WINDOW APPEARS (REASCRIPT TASK CONTROL) 
    --FOR THE CORRECT OPERATION OF THE SCRIPT,  
    --PUT A CHECK MARK (REMEMBER MY ANSWER FOR THIS SCRIPT),  
    --CLICK 'NEW INSTANCE' 
    ------------------------- 
     
     
    --[[ 
    Во время записи выставляем выбор времени и запускаем скрипт и так хоть 
    сколько раз, все выборы времени запомнятся. После записи, когда нажали 
    на стоп, выделяем любой айтем и запускаем скрипт и скрипт скопирует этот  
    выделенный айтем по сохраненным выборам времени. 
    --]] 
     
    local New_Items_Selected = false; -- true/false 
      
    local Previous_Items_Selected = false; -- true/false 
     
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
    ------------------------------------------------------- 
    local function no_undo()reaper.defer(function()end)end; 
    ------------------------------------------------------- 
     
     
    local function deleteDuplicatesValueInTable(tbl); 
        local X, res = {},{}; 
        for _,v in ipairs(tbl) do; 
            if (not X[v]) then; 
                res[#res+1] = v; 
                X[v] = true; 
            end; 
        end; 
        return res; 
    end; 
     
     
     
    local PlayState = reaper.GetPlayStateEx(0); 
    if PlayState&4~=0 then; 
     
        if PlayState&2==0 then; 
        ---- 
            local timeSelStart,timeSelEnd = reaper.GetSet_LoopTimeRange(0,0,0,0,0); -- В Аранже 
            if timeSelStart~=timeSelEnd then; 
                --- 
                local CLEAN = tonumber(reaper.GetExtState('ARC_RECARjMTIhME','CLEAN'))or 0; 
                if CLEAN == 0 then; 
                    reaper.DeleteExtState('ARC_RECARjMTIhME','TIME_SEL',false); 
                    reaper.SetExtState('ARC_RECARjMTIhME','CLEAN',1,false); 
                end; 
                 
                --- 
                local Ext = reaper.GetExtState('ARC_RECARjMTIhME','TIME_SEL'); 
                local str = Ext..'{'..timeSelStart..'&&&'..timeSelEnd..'}'; 
                reaper.SetExtState('ARC_RECARjMTIhME','TIME_SEL',str,false); 
                --- 
                local x, y = reaper.GetMousePosition(); 
                local tmSStt= tonumber(string.format("%.2f", timeSelStart)); 
                local tmSEnd = tonumber(string.format("%.2f", timeSelEnd)); 
                local tip = 'Save Time: \n'..tmSStt..' - '..tmSEnd; 
                reaper.TrackCtl_SetToolTip(tip,x+20,y-40,true); 
                --- 
            end; 
        ---- 
        end; 
         
    else; 
         
        local Ext = reaper.GetExtState('ARC_RECARjMTIhME','TIME_SEL'); 
        if Ext == '' then no_undo() return end; 
         
        local t={}; 
        for var in string.gmatch(Ext,"{.-}") do; 
            t[#t+1]=var; 
        end; 
        t = deleteDuplicatesValueInTable(t); 
         
        local CountSelItem = reaper.CountSelectedMediaItems(0); 
        if CountSelItem == 0 then no_undo() return end; 
         
        --------- 
        --------- 
         
        reaper.Undo_BeginBlock(); 
        reaper.PreventUIRefresh(1); 
         
         
        local itemNewT={}; 
        for i = 1,#t do; 
         
            local timeSelStart,timeSelEnd = t[i]:match('{(.+)&&&(.+)}'); 
            timeSelStart=tonumber(timeSelStart); 
            timeSelEnd=tonumber(timeSelEnd); 
            --------- 
             
            for i = CountSelItem-1,0,-1 do; 
                local itemSel = reaper.GetSelectedMediaItem(0,i); 
                local posIt = reaper.GetMediaItemInfo_Value(itemSel,'D_POSITION'); 
                local lenIt = reaper.GetMediaItemInfo_Value(itemSel,'D_LENGTH'); 
                if posIt+lenIt>timeSelStart and posIt<timeSelEnd then; 
                    local _, itChunk = reaper.GetItemStateChunk(itemSel,'',false); 
                    itChunk = itChunk:gsub('POOLEDEVTS {.-}','POOLEDEVTS '..reaper.genGuid());  
                    local track = reaper.GetMediaItem_Track(itemSel); 
                    local itemNew = reaper.AddMediaItemToTrack(track); 
                    reaper.SetItemStateChunk(itemNew,itChunk,false); 
                    itemNewT[#itemNewT+1]=itemNew; 
                    --- 
                    local Edges,EdgLen; 
                    if posIt<timeSelStart then Edges=timeSelStart else Edges=posIt end; 
                    if posIt+lenIt>timeSelEnd then EdgLen=timeSelEnd else EdgLen=posIt+lenIt end; 
                    reaper.BR_SetItemEdges(itemNew,Edges,EdgLen); 
                    --- 
                    reaper.SetMediaItemInfo_Value(itemNew,'B_UISEL',0); 
                    --- 
                    reaper.SetMediaItemInfo_Value(itemNew,'I_CUSTOMCOLOR',0x0037FF7A|0x1000000); 
                    --- 
                end; 
            end; 
        end; 
        --------- 
          
        if Previous_Items_Selected ~= true then; 
            reaper.SelectAllMediaItems(0,0); 
        end; 
          
        if New_Items_Selected == true then; 
            for i = 1,#itemNewT do; 
                reaper.SetMediaItemInfo_Value(itemNewT[i],'B_UISEL',1); 
            end; 
        end; 
         
        reaper.PreventUIRefresh(-1); 
        reaper.Undo_EndBlock('Copy take to saved positions',-1); 
        --------- 
        ---------   
    end; 
    reaper.UpdateArrange(); 
     
     
    local function loop(); 
        local PlayState = reaper.GetPlayStateEx(0)&4; 
        if PlayState~=4 then; 
            reaper.DeleteExtState('ARC_RECARjMTIhME','CLEAN',false); 
            return; 
        end; 
        reaper.defer(loop); 
    end; 
    reaper.defer(loop); 
     
     