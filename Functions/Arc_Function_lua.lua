--[[
   * Category:    Function
   * Description: Arc_Function_lua
   * Author:      Archie
   * Version:     1.1.1
   * AboutScript: Functions for use with some scripts Archie
   * О скрипте:   Функции для использования с некоторыми скриптами Archie
   * Provides:    [nomain].
   * ---------------------
   
   * Changelog:   + SaveSelTracksGuidSlot(Slot);
   *              + RestoreSelTracksGuidSlot(Slot,reset);
   *              + GetPreventSpectralPeaksInTrack(Track)
   *              + SetPreventSpectralPeaksInTrack(Track,Perf);--[=[Perf = true;false]=]
   *              + CloseAllFxInAllItemsAndAllTake(chain,float);--true;false;
   *              + SetShow_HideTrackMCP(Track,show_hide--[=[0;1]=]);
   *              + CloseAllFxInAllTracks(chain, float)--true,false
   *              + CloseToolbarByNumber(ToolbarNumber--[=[1-16]=])--некорректно работает с top
   *              + no_undo()
   *              + GetMediaItemInfo_Value(item,parmname)/[D_END] 
   *              + Get_Format_ProjectGrid(divisionIn)
   *              + Action(id)
   *              + invert_number(X)
   *              + CountTrackSelectedMediaItems(track)
   *              + GetTrackSelectedMediaItems(track,idx)
--======================================================]]



    --======================================================================================
    --///////////  FUNCTIONS  \\\\\\\\\\\\  FUNCTIONS  ////////////  FUNCTIONS  \\\\\\\\\\\\
    --======================================================================================




    --===================
    local Arc_Module = {}
    --===================



    --------------no_undo()-------------------------------------------------------------
    --no_undo()
    function Arc_Module.No_Undo()end; 
    function Arc_Module.no_undo()
        reaper.defer(Arc_Module.No_Undo)
    end
    --Что бы в ундо не прописывалось "ReaScript:Run"
    --==================================================================================



    -------SaveSelTracksGuidSlot--------------------------------------------------------
    ------RestoreSelTracksGuidSlot------------------------------------------------------
    function Arc_Module.SaveSelTracksGuidSlot(Slot);
        local t = {};
        _G[Slot] = t;
        for i = 1, reaper.CountSelectedTracks(0) do;
            local sel_tracks = reaper.GetSelectedTrack(0,i-1);
            t[i] = reaper.GetTrackGUID(sel_tracks);
        end;
    end;
    ---
    function Arc_Module.RestoreSelTracksGuidSlot(Slot,reset);
       local tr = reaper.GetTrack(0,0);
       reaper.SetOnlyTrackSelected(tr);
       reaper.SetTrackSelected(tr, 0);
       ---
       local t = _G[Slot];
       for i = 1, #t do;
           local track = reaper.BR_GetMediaTrackByGUID(0,t[i]);
           if track then;
               reaper.SetTrackSelected(track,1);
           end;
       end;
       if reset == 1 or reset == true then;
           _G[Slot] = nil;
       end;
    end;
    -- SaveSelTracksGuidSlot("Slot_1")
    -- RestoreSelTracksGuidSlot("Slot_1",true)
    -- SaveSelTracksGuidSlot("Slot_2")
    -- RestoreSelTracksGuidSlot("Slot_2",false)
    -- RestoreSelTracksGuidSlot("Slot_2",true)
    --==================================================================================



    ----------------GetPreventSpectralPeaksInTrack--------------------------------------
    function Arc_Module.GetPreventSpectralPeaksInTrack(Track)
        local _,str = reaper.GetTrackStateChunk(Track,"",false);
        local Perf = str:match('PERF (%d+)');
        if Perf == "4" then return true end
        return false
    end
    -- ПОЛУЧИТЬ ПРЕДОТВРАЩЕНИЕ СПЕКТРАЛЬНЫХ ПИКОВ В ТРЕКЕ
    --==================================================================================



    ------SetPreventSpectralPeaksInTrack------[[Perf = true;false]]---------------------
    function Arc_Module.SetPreventSpectralPeaksInTrack(Track,Perf);
        if Perf == true then Perf = 4 end;
        if Perf == false then Perf = 0 end;
        local _,str = reaper.GetTrackStateChunk(Track,"",false);
        local str2 = str:gsub('PERF %d+',"PERF".." "..Perf);
        reaper.SetTrackStateChunk(Track,str2,false);
    end;
    -- УСТАНОВИТЬ ПРЕДОТВРАЩЕНИЕ СПЕКТРАЛЬНЫХ ПИКОВ В ТРЕКЕ
    --==================================================================================



    -----------------CloseAllFxInAllItemsAndAllTake----true;false;----------------------
    function Arc_Module.CloseAllFxInAllItemsAndAllTake(chain,float);--true;false;
        local CountItem = reaper.CountMediaItems(0);
        if CountItem == 0 then Arc_Module.no_undo() return -1 end;
        for j = CountItem-1,0,-1 do;
            local Item = reaper.GetMediaItem(0,j);
            local CountTake = reaper.CountTakes(Item);
            for i = CountTake-1,0,-1 do;
                local Take = reaper.GetMediaItemTake(Item,i);
                local CountTakeFX = reaper.TakeFX_GetCount(Take);
                for ij = CountTakeFX-1,0,-1 do;
                   if chain == 1 or chain == true then;
                       reaper.TakeFX_Show(Take,ij,0);
                   end;
                   if float == 1 or float == true then;
                       reaper.TakeFX_Show(Take,ij,2);
                   end;
                end;
            end;
        end;
        return true
    end;
    -- Закрыть Все Fx Во Всех Элементах  И Во всех тейках
    -- Close All Fx In All Elements And In All Takes
    --==================================================================================



    --------------SetShow_HideTrackMCP--------------------------------------------------
    function Arc_Module.SetShow_HideTrackMCP(Track,show_hide--[[0;1]]);
        local _,str = reaper.GetTrackStateChunk(Track,"",true);
        local SHOWINMIX = str:match('SHOWINMIX %d+');
        local str = string.gsub(str,SHOWINMIX, "SHOWINMIX"..' '..show_hide);
        reaper.SetTrackStateChunk(Track, str, true);
    end;
    -- Show Hide Track in Mixer (MCP)
    -- Показать Скрыть дорожку в микшере (MCP)
    --==================================================================================



    ----------------- CloseAllFxInAllTracks --------------------------------------------
    function Arc_Module.CloseAllFxInAllTracks(chain, float)--true,false
        local CountTr = reaper.CountTracks(0)
        if CountTr == 0 then 
            reaper.ReaScriptError("No Tracks in project") 
            Arc_Module.no_undo() return
        end
        for i = 1, CountTr do
            local Track = reaper.GetTrack(0,i-1)
            local CountFx = reaper.TrackFX_GetCount(Track)
            for i2 = 1, CountFx do
                if chain == 1 or chain == true then 
                    reaper.TrackFX_Show(Track,i2-1,0)
                end
                if float == 1 or float == true then 
                    reaper.TrackFX_Show(Track,i2-1,2)
                end 
            end
        end
    end
    -- Закрыть Все Fx На Всех Дорожках
    --==================================================================================



    --------------- Несовместимо с верхним докером -------------------------------------
    function Arc_Module.CloseToolbarByNumber(ToolbarNumber--[[1-16]])
        local CloseToolbar_T = {[0]=41651,41679,41680,41681,41682,41683,41684,41685,
                               41686,41936,41937,41938,41939,41940,41941,41942,41943}
        local state = reaper.GetToggleCommandState(CloseToolbar_T[ToolbarNumber]) 
        if state == 1 then
            reaper.Main_OnCommand(CloseToolbar_T[ToolbarNumber],0)
        end
    end
    -- Закрыть Панель Инструментов По Номеру
    -- Несовместимо с верхним докером (top)
    --==================================================================================


   
    --------------GetMediaItemInfo_Value------------------------------------------------
    function Arc_Module.GetMediaItemInfo_Value(item, parmname)
        if parmname == "END" or parmname == "D_END" then return
            reaper.GetMediaItemInfo_Value(item,"D_POSITION")+
            reaper.GetMediaItemInfo_Value(item,"D_LENGTH")
        else
            return reaper.GetMediaItemInfo_Value(item,parmname) 
        end
    end 
    --==================================================================================



    -----------Get_Format_ProjectGrid---------------------------------------------------
    function Get_Format_ProjectGrid(divisionIn)
        local grid_div
        if divisionIn < 1 then
            grid_div = (1 / divisionIn)
            if math.fmod(grid_div,3) == 0 then
                grid_div = "1/"..string.format("%.0f",grid_div/1.5).."T"
            else
                grid_div = "1/"..string.format("%.0f",grid_div) 
            end
        else    
            grid_div = tonumber(string.format("%.0f",divisionIn)) 
        end    
        return grid_div
    end
    -- Форматирует значение сетки проекта в удобочитаемую форму
    --==================================================================================



    -------------Action-----------------------------------------------------------------
    function Arc_Module.Action(...)
       local Table = {...}
       for i = 1, #Table do
         reaper.Main_OnCommand(reaper.NamedCommandLookup(Table[i]),0)
       end
    end
    -- Выполняет действие, относящееся к разделу основное действие. 
    --==================================================================================



    --------invert_number---------------------------------------------------------------
    function Arc_Module.invert_number(X)
        local X = X - X * 2 
        return X
    end
	-- инвертировать число
    --==================================================================================



    ----------------CountTrackSelectedMediaItems----------------------------------------
    function Arc_Module.CountTrackSelectedMediaItems(track);
        local CountTrItems = reaper.CountTrackMediaItems(track);
        local count = 0;
        for i = 1,CountTrItems do;
            local Items =  reaper.GetTrackMediaItem(track,i-1);
            local sel = reaper.IsMediaItemSelected(Items);
            if sel then count = count + 1 end;
        end;
        return count;
    end;
    --Количество в треке Выбранных Элементов
    --==================================================================================



    ---------------GetTrackSelectedMediaItems-------------------------------------------
    function Arc_Module.GetTrackSelectedMediaItems(track,idx);
        local CountTrItems = reaper.CountTrackMediaItems(track);
        local count = -1;
        for i = 1,CountTrItems do;
            local Items = reaper.GetTrackMediaItem(track,i-1);
            local sel = reaper.IsMediaItemSelected(Items);
            if sel then count = count + 1 end;
            if count == idx then return Items end;
        end;
    end;
    -- Получить в треке Выбранный Элемент
    --==================================================================================



    --===============
    return Arc_Module
    --===============
