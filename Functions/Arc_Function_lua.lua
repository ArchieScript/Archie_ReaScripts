--[[
   * Category:    Function
   * Description: Arc_Function_lua
   * Author:      Archie
   * Version:     1.1.3
   * AboutScript: Functions for use with some scripts Archie
   * О скрипте:   Функции для использования с некоторыми скриптами Archie
   * Provides:    [nomain].
   * ---------------------
   
   * Changelog:   
   *              + nido_undo()
   *              + Action()
   *              + RemoveStretchMarkersSavingTreatedWave_Render(Take);
   *              + SaveSelTracksGuidSlot(Slot);
   *              + RestoreSelTracksGuidSlot(Slot,reset);
   *              + GetPreventSpectralPeaksInTrack(Track)
   *              + SetPreventSpectralPeaksInTrack(Track,Perf);--[=[Perf = true;false]=]
   *              + CloseAllFxInAllItemsAndAllTake(chain,float);--true;false;
   *              + SetShow_HideTrackMCP(Track,show_hide--[=[0;1]=]);
   *              + CloseAllFxInAllTracks(chain, float)--true,false
   *              + CloseToolbarByNumber(ToolbarNumber--[=[1-16]=])--некорректно работает с top
   *              + GetMediaItemInfo_Value(item,parmname)/[D_END] 
   *              + Get_Format_ProjectGrid(divisionIn)
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



    --|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------no_undo()--------------------------------------------------------------
    --no_undo()
    function Arc_Module.No_Undo()end; 
    function Arc_Module.no_undo()
        reaper.defer(Arc_Module.No_Undo)
    end
    --Что бы в ундо не прописывалось "ReaScript:Run"
    --====End===============End===============End===============End===============End====



    -------------Action------------------------------------------------------------------
    function Arc_Module.Action(...)
       local Table = {...}
       for i = 1, #Table do
         reaper.Main_OnCommand(reaper.NamedCommandLookup(Table[i]),0)
       end
    end
    -- Выполняет действие, относящееся к разделу основное действие. 
    --====End===============End===============End===============End===============End====
    --|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||




    --------------RemoveStretchMarkersSavingTreatedWave_Render---------------------------
    function Arc_Module.RemoveStretchMarkersSavingTreatedWave_Render(Take);

        ----#0---------------------------------------------------------------------------
        if not Take then reaper.ReaScriptError("bad argument #1 to"..
            "'RemoveStretchMarkersSavingTreatedWave_Render' (Take expected)");
            return
        end;
        ---------------------------------------------------------------------------------

        ----#1---------------------------------------------------------------------------
        if not reaper.TakeIsMIDI(Take) then;
            if reaper.GetTakeNumStretchMarkers(Take) > 0 then;
            -----------------------------------------------------------------------------

                ----#2-------------------------------------------------------------------
                reaper.PreventUIRefresh(195638945);
                reaper.Undo_BeginBlock2(0);
                -------------------------------------------------------------------------

                ----#3---Save All Items--------------------------------------------------
                local Guid = {};
                for i = 1, reaper.CountSelectedMediaItems(0) do;
                    local sel_item = reaper.GetSelectedMediaItem(0,i-1);
                    Guid[i] = reaper.BR_GetMediaItemGUID(sel_item);
                end;
                -------------------------------------------------------------------------

                ----#4---Select item Take work-------------------------------------------
                reaper.SelectAllMediaItems(0,0);
                local item = reaper.GetMediaItemTake_Item(Take);
                reaper.SetMediaItemSelected(item,1);
                -------------------------------------------------------------------------

                ----#5---Disable and Prepare Envelope------------------------------------
                local Len = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
                local PlayRat = reaper.GetMediaItemTakeInfo_Value(Take,"D_PLAYRATE");
                local active,visible,armed,inLane,laneHeight,defaultShape,minValue,
                      maxValue,centerValue,typeS,faderScaling,EnvelopePresent = {};
                local CountTakeEnv = reaper.CountTakeEnvelopes(Take);
                if CountTakeEnv > 0 then;
                    EnvelopePresent = "Active";
                    ----
                    for i = 1,CountTakeEnv do;
                        local EnvTake = reaper.GetTakeEnvelope(Take,i-1);
                        local NotCreateStart,NotCreateEnd,valuestart,valueEnd = nil,nil,nil,nil;
                        ----
                        for i2 = 1,reaper.CountEnvelopePoints(EnvTake) do;
                            local time = select(2,reaper.GetEnvelopePoint(EnvTake,i2-1))/PlayRat;
                            if time == 0 then;
                                NotCreateStart = 1;
                            elseif time == Len then;
                                NotCreateEnd = 1;
                                break;
                            end;
                        end;
                        if not NotCreateStart then;
                            valuestart = select(2,reaper.Envelope_Evaluate(EnvTake,0,0,0));
                        end;
                        if not NotCreateEnd then;
                            valueEnd = select(2,reaper.Envelope_Evaluate(EnvTake,(Len*PlayRat),0,0));
                        end;
                        if valuestart then;
                            reaper.InsertEnvelopePoint(EnvTake,0,valuestart,0,0,0,true);
                        end;
                        if valueEnd then;
                            reaper.InsertEnvelopePoint(EnvTake,(Len*PlayRat),valueEnd,0,0,0,true);
                        end;
                        reaper.Envelope_SortPoints(EnvTake);
                        reaper.DeleteEnvelopePointRange(EnvTake,(-9^99),-0.0000001);
                        reaper.DeleteEnvelopePointRange(EnvTake,0.0000001,0.01);--!?
                        reaper.DeleteEnvelopePointRange(EnvTake,(Len*PlayRat)+0.0000001,9^99);
                        reaper.DeleteEnvelopePointRange(EnvTake,(Len*PlayRat)-0.01,(Len*PlayRat)-0.0000001);--!?
                        ----
                        local EnvAlloc = reaper.BR_EnvAlloc(EnvTake,false);
                        active[i],visible,armed,inLane,laneHeight,defaultShape,minValue,maxValue,
                        centerValue,typeS,faderScaling = reaper.BR_EnvGetProperties(EnvAlloc);     
                        reaper.BR_EnvSetProperties(EnvAlloc,false--[=[active]=],visible,armed,
                                               inLane,laneHeight,defaultShape,faderScaling);
                        reaper.BR_EnvFree(EnvAlloc,true);
                    end;
                end;
                -------------------------------------------------------------------------

                ----#6---Disable All Fx--------------------------------------------------
                local FX_Enabled = {};
                local CountFx = reaper.TakeFX_GetCount(Take);
                for i = 1,CountFx do;
                    FX_Enabled[i] = reaper.TakeFX_GetEnabled(Take,i-1);
                    reaper.TakeFX_SetEnabled(Take,i-1,0);
                end;
                -------------------------------------------------------------------------
                
                ----#7---Take properties Reset-------------------------------------------
                local Pich = reaper.GetMediaItemTakeInfo_Value(Take,"D_PITCH");
                reaper.SetMediaItemTakeInfo_Value(Take,"D_PITCH",0);
                local PreserPitch = reaper.GetMediaItemTakeInfo_Value(Take,"B_PPITCH");
                reaper.SetMediaItemTakeInfo_Value(Take,"B_PPITCH",0);
                local vol = reaper.GetMediaItemTakeInfo_Value(Take,"D_VOL");
                reaper.SetMediaItemTakeInfo_Value(Take,"D_VOL",1);
                local pan = reaper.GetMediaItemTakeInfo_Value(Take,"D_PAN");
                reaper.SetMediaItemTakeInfo_Value(Take,"D_PAN",0);
                local Chanmode = reaper.GetMediaItemTakeInfo_Value(Take,"I_CHANMODE");
                reaper.SetMediaItemTakeInfo_Value(Take,"I_CHANMODE",0);
                PichMode = reaper.GetMediaItemTakeInfo_Value(Take,"I_PITCHMODE");
                reaper.SetMediaItemTakeInfo_Value(Take,"I_PITCHMODE",-1);
                
                ----#8---Item Fx Tail Reset----------------------------------------------
                local itemfxtail = reaper.SNM_GetIntConfigVar("itemfxtail",0);
                reaper.SNM_SetIntConfigVar("itemfxtail",0);
                -------------------------------------------------------------------------
                
                ----#9---Render items to new take-------GetActiveTake--------------------
                Arc_Module.Action(41999);
                local Take_X = reaper.GetActiveTake(item);
                -------------------------------------------------------------------------
                
                ----#8---Item Fx Tail Restore--------------------------------------------
                reaper.SNM_SetIntConfigVar("itemfxtail",itemfxtail);
                -------------------------------------------------------------------------
                
                ----#10---Delete Take All Stretch Markers--------------------------------
                local NumStrMar = reaper.GetTakeNumStretchMarkers(Take);
                reaper.DeleteTakeStretchMarkers(Take, 0, NumStrMar);
                -------------------------------------------------------------------------
                
                ----#11---Reset play rate / Reset Offset---------------------------------
                reaper.SetMediaItemTakeInfo_Value(Take,"D_STARTOFFS",0);
                reaper.SetMediaItemTakeInfo_Value(Take,"D_PLAYRATE",1);
                local retval,section,start,length,fade,reverse = reaper.BR_GetMediaSourceProperties(Take_X);
                reaper.BR_SetMediaSourceProperties(Take,section,start,length,fade,reverse);
                -------------------------------------------------------------------------
                
                ----#5---Enable and Recover Envelope-------------------------------------
                if EnvelopePresent then;
                    for i = 1,CountTakeEnv do;
                        local EnvTake = reaper.GetTakeEnvelope(Take,i-1);
                        local retvalA, timeA,valueA,shapeA,tensionA,selectedA = nil,{},{},{},{},{};
                        for iA = 1,reaper.CountEnvelopePoints(EnvTake) do;
                           retvalA,timeA[iA],valueA[iA],shapeA[iA],tensionA[iA],selectedA[iA] = reaper.GetEnvelopePoint(EnvTake,iA-1);
                        end;
                        for iA = 1,reaper.CountEnvelopePoints(EnvTake) do;
                            reaper.SetEnvelopePoint(EnvTake,iA-1,timeA[iA]/PlayRat,valueA[iA],shapeA[iA],tensionA[iA],selectedA[iA],true);
                        end;
                        reaper.Envelope_SortPoints(EnvTake);
                        local EnvAlloc = reaper.BR_EnvAlloc(EnvTake,false);
                        local activ,visible,armed,inLane,laneHeight,Shape,minValue,maxValue,centerValue,
                                                types,faderScaling = reaper.BR_EnvGetProperties(EnvAlloc);
                        reaper.BR_EnvSetProperties(EnvAlloc,active[i],visible,armed,inLane,
                                                     laneHeight,Shape,faderScaling);
                        reaper.BR_EnvFree(EnvAlloc,true);
                    end;
                end;
                -------------------------------------------------------------------------
                
                ----#12---Change the file------------------------------------------------
                local Take_X_Source = reaper.GetMediaItemTake_Source(Take_X);
                local Filenamebuf = reaper.GetMediaSourceFileName(Take_X_Source,"");
                reaper.BR_SetTakeSourceFromFile(Take,Filenamebuf,true);
                -------------------------------------------------------------------------
                
                ----#7---Take properties Recover-----------------------------------------
                reaper.SetMediaItemTakeInfo_Value(Take,"D_PITCH",Pich);
                reaper.SetMediaItemTakeInfo_Value(Take,"B_PPITCH",PreserPitch);
                reaper.SetMediaItemTakeInfo_Value(Take,"D_VOL",vol);
                reaper.SetMediaItemTakeInfo_Value(Take,"D_PAN",pan);
                reaper.SetMediaItemTakeInfo_Value(Take,"I_CHANMODE",Chanmode);
                reaper.SetMediaItemTakeInfo_Value(Take,"I_PITCHMODE",PichMode);
                -------------------------------------------------------------------------

                ----13---Delete created Take -/-(Delete active take from items)----------
                Arc_Module.Action(40129);
                reaper.SetActiveTake(Take);
                -------------------------------------------------------------------------

                ----#6---Enable All Fx---------------------------------------------------
                for i = 1, #FX_Enabled do;
                    reaper.TakeFX_SetEnabled(Take,i-1,FX_Enabled[i]);
                end;
                -------------------------------------------------------------------------

                ----#3---Restore Select Media Items--------------------------------------
                reaper.SelectAllMediaItems(0,0);
                for i = 0, #Guid do; 
                    local item = reaper.BR_GetMediaItemByGUID(0,Guid[i]);
                    if item then;
                        reaper.SetMediaItemSelected(item,1);
                    end;
                end;
                -------------------------------------------------------------------------

                ---#2--------------------------------------------------------------------
                reaper.Undo_EndBlock2(0,"RemoveStretchMarkersSavingTreatedWave",-1);
                reaper.PreventUIRefresh(-195638945);
                -------------------------------------------------------------------------
                
            ----#1-----------------------------------------------------------------------
            end;
        end;
        ---
        ----#14----------------
        reaper.UpdateArrange();
    end;   -- Удалить Маркеры Растяжки, Сохраняя Обработанную Волну (Render)
    --====End===============End===============End===============End===============End====



    -------SaveSelTracksGuidSlot---------------------------------------------------------
    ------RestoreSelTracksGuidSlot-------------------------------------------------------
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
    --====End===============End===============End===============End===============End====



    ----------------GetPreventSpectralPeaksInTrack---------------------------------------
    function Arc_Module.GetPreventSpectralPeaksInTrack(Track)
        local _,str = reaper.GetTrackStateChunk(Track,"",false);
        local Perf = str:match('PERF (%d+)');
        if Perf == "4" then return true end
        return false
    end
    -- ПОЛУЧИТЬ ПРЕДОТВРАЩЕНИЕ СПЕКТРАЛЬНЫХ ПИКОВ В ТРЕКЕ
    --====End===============End===============End===============End===============End====



    ------SetPreventSpectralPeaksInTrack------[[Perf = true;false]]----------------------
    function Arc_Module.SetPreventSpectralPeaksInTrack(Track,Perf);
        if Perf == true then Perf = 4 end;
        if Perf == false then Perf = 0 end;
        local _,str = reaper.GetTrackStateChunk(Track,"",false);
        local str2 = str:gsub('PERF %d+',"PERF".." "..Perf);
        reaper.SetTrackStateChunk(Track,str2,false);
    end;
    -- УСТАНОВИТЬ ПРЕДОТВРАЩЕНИЕ СПЕКТРАЛЬНЫХ ПИКОВ В ТРЕКЕ
    --====End===============End===============End===============End===============End====



    -----------------CloseAllFxInAllItemsAndAllTake----true;false;-----------------------
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
    --====End===============End===============End===============End===============End====



    --------------SetShow_HideTrackMCP---------------------------------------------------
    function Arc_Module.SetShow_HideTrackMCP(Track,show_hide--[[0;1]]);
        local _,str = reaper.GetTrackStateChunk(Track,"",true);
        local SHOWINMIX = str:match('SHOWINMIX %d+');
        local str = string.gsub(str,SHOWINMIX, "SHOWINMIX"..' '..show_hide);
        reaper.SetTrackStateChunk(Track, str, true);
    end;
    -- Show Hide Track in Mixer (MCP)
    -- Показать Скрыть дорожку в микшере (MCP)
    --====End===============End===============End===============End===============End====



    ----------------- CloseAllFxInAllTracks ---------------------------------------------
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
    --====End===============End===============End===============End===============End====



    --------------- Несовместимо с верхним докером --------------------------------------
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
    --====End===============End===============End===============End===============End====


   
    --------------GetMediaItemInfo_Value-------------------------------------------------
    function Arc_Module.GetMediaItemInfo_Value(item, parmname)
        if parmname == "END" or parmname == "D_END" then return
            reaper.GetMediaItemInfo_Value(item,"D_POSITION")+
            reaper.GetMediaItemInfo_Value(item,"D_LENGTH")
        else
            return reaper.GetMediaItemInfo_Value(item,parmname) 
        end
    end 
    --====End===============End===============End===============End===============End====



    -----------Get_Format_ProjectGrid----------------------------------------------------
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
    --====End===============End===============End===============End===============End====



    --------invert_number----------------------------------------------------------------
    function Arc_Module.invert_number(X)
        local X = X - X * 2 
        return X
    end
	-- инвертировать число
    --====End===============End===============End===============End===============End====



    ----------------CountTrackSelectedMediaItems-----------------------------------------
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
    --====End===============End===============End===============End===============End====



    ---------------GetTrackSelectedMediaItems--------------------------------------------
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
    --====End===============End===============End===============End===============End====



    --===============
    return Arc_Module
    --===============
