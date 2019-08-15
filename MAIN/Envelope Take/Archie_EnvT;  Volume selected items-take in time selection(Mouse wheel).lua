--[[
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Envelope Take
   * Description: Volume selected items-take in time selection(Mouse wheel)
   * Author:      Archie
   * Version:     1.02
   * AboutScript: ---
   * О скрипте:   ---
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Supa75 - (Rmm)
   * Gave idea:   AlexLazer / Maestro Sound / Supa75 - (Rmm)
   * Changelog:   
   *              v.1.02 [16.08.09]
   *                  + Envelope Reset with Inactive Envelope
   
   *              v.1.0 [15.08.09]
   *                  + initialе

    -- Тест только на windows  /  Test only on windows.
    --=======================================================================================
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:         
    (+) - required for installation      | (+) - обязательно для установки
    (-) - not necessary for installation | (-) - не обязательно для установки
    -----------------------------------------------------------------------------------------
    (+) Reaper v.5.981 +            --| http://www.reaper.fm/download.php
    (+) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php
    (-) ReaPack v.1.2.2 +           --| http://reapack.com/repos
    (-) Arc_Function_lua v.2.4.4 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc  
    (-) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw    
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6
    =======================================================================================]] 
    
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local VOLUME_DB = 0.5;
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    
    local function ClearDuplicatePointsEnvelopeByTime(Env,autoitem_idx,time1,time2);
        local id1,id2;
        local Take = reaper.Envelope_GetParentTake(Env);local item;
        if Take then;item = reaper.GetMediaItemTake_Item(Take);end;
        local posItem  = tonumber(({pcall(reaper.GetMediaItemInfo_Value,    item,"D_POSITION")})[2])or 0;
        local playrate = tonumber(({pcall(reaper.GetMediaItemTakeInfo_Value,Take,"D_PLAYRATE")})[2])or 1;
        local Remove = true;
        local ii = 0;
        for i = 1, math.huge do;
            if autoitem_idx >= 0 then;
                for i = 1, reaper.CountEnvelopePointsEx(Env,autoitem_idx,0) do; 
                    local _,time,value,_,_,_ = reaper.GetEnvelopePointEx(Env,autoitem_idx,i-1);
                    if not id1 then if time >= time1-1e-006 then id1 = i-1 end end;
                    if time <= time2+1e-006 then id2 = i-1 else break end;
                end;
            else;
                id1 = reaper.GetEnvelopePointByTimeEx(Env,autoitem_idx,(time1-posItem+1e-006)*playrate);
                id2 = reaper.GetEnvelopePointByTimeEx(Env,autoitem_idx,(time2-posItem+1e-006)*playrate); 
            end;
            if id1 < 0 then id1 = 0 end;
            if id2 < 1 or id1 == id2 then return false end;
            if not Remove then ii = ii+1 end;
            if ii == 3 then break end;
            Remove = nil;
            local value_T = {};
            local time_T = {};
            ------------------
            for i = id2-ii,id1,-1 do;
                local _,time,value,_,_,_ = reaper.GetEnvelopePointEx(Env,autoitem_idx,i);
                value_T[#value_T+1]=value;
                time_T[#time_T+1]=time;
                if #value_T == 3 then;
                    if value_T[1] == value_T[2] and time_T[1] ~= time_T[2] then;
                        if value_T[1] == value_T[3] and time_T[2] ~= time_T[3] then; 
                            reaper.DeleteEnvelopePointRangeEx(Env,autoitem_idx,time_T[2]-1e-009,time_T[2]+1e-009);
                            Remove = true;
                            ii = 0;
                            break;
                        end;
                    end;
                    time_T = {};
                    value_T = {};
                end;
            end;
            ------------------
        end;
    end;
    
    
    
    -------------------------------------------------------
    local function InsertEnvelopePointTake_Arc(Env,time,point_indent,noDuplicate,value,shape,tension,selected,noSortIn,startTimeTakeProj);
        local Take = reaper.Envelope_GetParentTake(Env);
        if not Take then return false end;
        local playrate = reaper.GetMediaItemTakeInfo_Value(Take,"D_PLAYRATE");
        local item = reaper.GetMediaItemTake_Item(Take);
        local posItem = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
        local lenItem = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
        if startTimeTakeProj == 1 or startTimeTakeProj == true then;
            time = time-posItem;
        end;
        --if posItem > time or posItem + lenItem < time then return false end; --Что бы точка не добавлялась за пределами айтема
        if noDuplicate == true or noDuplicate == 1 then;
            for i = 1, reaper.CountEnvelopePoints(Env) do;
                local _,time0,_,_,_,_ = reaper.GetEnvelopePoint(Env,i-1);
                time0 = time0/playrate;
                if time0 >= (time-(point_indent/2)) and time0 <= (time+(point_indent/2)) then;
                    --point = true; break;
                    reaper.DeleteEnvelopePointRange(Env,(time0*playrate)-1e-009,(time0*playrate)+1e-009);
                end;
            end;
        end;
        if not point then;
            time = time*(playrate or 1);
            reaper.InsertEnvelopePoint(Env,time,value,shape,tension,selected,noSortIn);
            return true;
        end;
        point = nil; return false;
    end;
    
    
    local function GetInfoEnvelopePointByTimeOrPrev(Env,time,startTimeTakeProj);
        --startTimeTakeProj = true - proj, false - take;
        local Take = reaper.Envelope_GetParentTake(Env);local item;
        if Take then;item = reaper.GetMediaItemTake_Item(Take);end;
        local posItem  = tonumber(({pcall(reaper.GetMediaItemInfo_Value,    item,"D_POSITION")})[2])or 0;
        local playrate = tonumber(({pcall(reaper.GetMediaItemTakeInfo_Value,Take,"D_PLAYRATE")})[2])or 1;
        if not startTimeTakeProj or startTimeTakeProj == 0 then posItem = 0 end;
        local idx = reaper.GetEnvelopePointByTime(Env,(time-posItem)*playrate); 
        local retval,time,value,shape,tension,selected = reaper.GetEnvelopePoint(Env,idx);
        return (time/playrate+posItem),(value),(shape),(tension),(selected);
    end;
    
    
    local function GetEnvelopeValueByTime(Env,time,startTimeTakeProj);
        --startTimeTakeProj = true - proj, false - take;
        local Take = reaper.Envelope_GetParentTake(Env);local item;
        if Take then;item = reaper.GetMediaItemTake_Item(Take);end;
        local posItem  = tonumber(({pcall(reaper.GetMediaItemInfo_Value,    item,"D_POSITION")})[2])or 0;
        local playrate = tonumber(({pcall(reaper.GetMediaItemTakeInfo_Value,Take,"D_PLAYRATE")})[2])or 1;
        local samplerate = tonumber(reaper.format_timestr_pos(1,"",4));
        if not startTimeTakeProj or startTimeTakeProj == 0 then posItem = 0 end;
        local _,value = reaper.Envelope_Evaluate(Env,(time-posItem)*playrate,samplerate,1);
        return(value);
    end;
    
    
    local function DeleteEnvelopePointRange_Arc(Env, time_start, time_end, startTimeTakeProj);
        --startTimeTakeProj = true - proj, false - take;
        local Take = reaper.Envelope_GetParentTake(Env);local item;
        if Take then;item = reaper.GetMediaItemTake_Item(Take);end;
        local posItem  = tonumber(({pcall(reaper.GetMediaItemInfo_Value,    item,"D_POSITION")})[2])or 0;
        local playrate = tonumber(({pcall(reaper.GetMediaItemTakeInfo_Value,Take,"D_PLAYRATE")})[2])or 1;
        if not startTimeTakeProj or startTimeTakeProj == 0 then posItem = 0 end;
        return reaper.DeleteEnvelopePointRange(Env,(time_start-posItem)*playrate,(time_end-posItem)*playrate); 
    end;
    
    
    local function GetEnvelopePointInfo(Env,idx,startTimeTakeProj);
        --startTimeTakeProj = true - proj, false - take;
        local Take = reaper.Envelope_GetParentTake(Env);local item;
        if Take then;item = reaper.GetMediaItemTake_Item(Take);end;
        local posItem  = tonumber(({pcall(reaper.GetMediaItemInfo_Value,    item,"D_POSITION")})[2])or 0;
        local playrate = tonumber(({pcall(reaper.GetMediaItemTakeInfo_Value,Take,"D_PLAYRATE")})[2])or 1;
        if not startTimeTakeProj or startTimeTakeProj == 0 then posItem = 0 end;
        local retval, time, value, shape, tension, selected = reaper.GetEnvelopePoint(Env,idx);
        return retval, time/playrate+posItem, value, shape, tension, selected; 
    end;
    
    
    local function SetEnvelopePointInfo(Env,idx,time,value,shape,tension,selected,noSortIn, startTimeTakeProj);
        --startTimeTakeProj = (time) true - proj, false - take;
        local Take = reaper.Envelope_GetParentTake(Env);local item;
        if Take then;item = reaper.GetMediaItemTake_Item(Take);end;
        local posItem  = tonumber(({pcall(reaper.GetMediaItemInfo_Value,    item,"D_POSITION")})[2])or 0;
        local playrate = tonumber(({pcall(reaper.GetMediaItemTakeInfo_Value,Take,"D_PLAYRATE")})[2])or 1;
        if not startTimeTakeProj or startTimeTakeProj == 0 then posItem = 0 end;
        return reaper.SetEnvelopePoint(Env,idx,(time-posItem)*playrate,value,shape,tension,selected,noSortIn);
    end;
    -------------------------------------------------------
    
    
    
    if tonumber(VOLUME_DB)then;
        if VOLUME_DB <= 0 or VOLUME_DB > 10 then VOLUME_DB = 1 end;
    else;
        VOLUME_DB = 1;
    end;
    local MouseWheel = ({reaper.get_action_context()})[7];
    if MouseWheel < 0 then;
        VOLUME_DB = (VOLUME_DB-VOLUME_DB*2);
    end;
    if MouseWheel == 0 then no_undo()return end;
    
    
    local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    if startLoop == endLoop then no_undo()return end;
    
    
    
    local CountSelItem = reaper.CountSelectedMediaItems(0);
    if CountSelItem == 0 then no_undo()return end;
    
    local undo;
    for loopIt = 1, CountSelItem do;
        local item = reaper.GetSelectedMediaItem(0,loopIt-1);
        local take = reaper.GetActiveTake(item);
        local takeMIDI = reaper.TakeIsMIDI(take);
        if not takeMIDI then;
            local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
        
            -----
            local pos = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
            local len = reaper.GetMediaItemInfo_Value(item, "D_LENGTH");
            if(pos>=endLoop)or(pos+len<=startLoop)then goto END_LOOP end;
            if pos > startLoop then startLoop = pos end;
            if pos+len < endLoop then endLoop = pos+len end;
            
                    
            if not undo then;
                reaper.PreventUIRefresh(1);
                reaper.Undo_BeginBlock();
                undo = true;
            end;
            
             
            local Env = reaper.GetTakeEnvelopeByName(take,"Volume");
            if not Env then;
                local sel_item = {};
                for i=1,reaper.CountSelectedMediaItems(0)do;sel_item[i]=reaper.GetSelectedMediaItem(0,i-1);end;
                reaper.SelectAllMediaItems(0,0);reaper.SetMediaItemSelected(item,1);
                reaper.Main_OnCommand(40693,0);--take volume envelope
                Env = reaper.GetTakeEnvelopeByName(take,"Volume");
                local time,val,shape,tension,selected = GetInfoEnvelopePointByTimeOrPrev(Env,len, false);
                InsertEnvelopePointTake_Arc(Env,len,0,true, val,shape,tension,false,false, false);
                reaper.Main_OnCommand(40693,0);--take volume envelope
                reaper.SelectAllMediaItems(0,0);
                for i=1,#sel_item do;reaper.SetMediaItemSelected(sel_item[i],1);end;
            end;
            
            
            local ResetEnvelope;
            local Alloc_env = reaper.BR_EnvAlloc(Env,false);
            local active,visible,armed,inLane,laneHeight,defaultShape,minValue,maxValue,centerValue,Type,faderScaling=reaper.BR_EnvGetProperties(Alloc_env);
            local max_DB = math.floor((20*math.log(maxValue,10))+0.5)--1;
            if not active then;
                reaper.BR_EnvSetProperties(Alloc_env,true,visible,armed,inLane,laneHeight,defaultShape,faderScaling);
                ResetEnvelope = true;--v1.02
            end; reaper.BR_EnvFree(Alloc_env,true);
            
            if ResetEnvelope then;--v1.02
                DeleteEnvelopePointRange_Arc(Env,0,reaper.GetProjectLength(0),true);--v1.02
            end;--v1.02
            
            
            ClearDuplicatePointsEnvelopeByTime(Env,-1,startLoop,endLoop);
            
            
            local PointT_4 = {startLoop-0.00050, startLoop, endLoop, endLoop+0.00050};
            
            
            local value = GetEnvelopeValueByTime(Env, PointT_4[1], true);
            local time,_,shape,tension,selected = GetInfoEnvelopePointByTimeOrPrev(Env,PointT_4[1], true);
            InsertEnvelopePointTake_Arc(Env, PointT_4[1],1e-007, true, value, shape, tension, false, false, true);
            
            local value = GetEnvelopeValueByTime(Env, PointT_4[2], true);
            local time,_,shape,tension,selected = GetInfoEnvelopePointByTimeOrPrev(Env,PointT_4[2], true);
            InsertEnvelopePointTake_Arc(Env, PointT_4[2],1e-007, true, value, shape, tension, false, false, true);
            
            DeleteEnvelopePointRange_Arc(Env, PointT_4[1]+1e-007, PointT_4[2]-1e-007, true);
            
            
            local value = GetEnvelopeValueByTime(Env, PointT_4[3], true);
            local time,_,shape,tension,selected = GetInfoEnvelopePointByTimeOrPrev(Env,PointT_4[3], true);
            InsertEnvelopePointTake_Arc(Env, PointT_4[3],1e-007, true, value, shape, tension, false, false, true);
            
            local value = GetEnvelopeValueByTime(Env, PointT_4[4], true);
            local time,_,shape,tension,selected = GetInfoEnvelopePointByTimeOrPrev(Env,PointT_4[4], true);
            InsertEnvelopePointTake_Arc(Env, PointT_4[4],1e-007, true, value, shape, tension, false, false, true);
            
            DeleteEnvelopePointRange_Arc(Env, PointT_4[3]+1e-007, PointT_4[4]-1e-007, true);
            
            
            
            local ScalingMode = reaper.GetEnvelopeScalingMode(Env);
             
            for i = 1, reaper.CountEnvelopePoints(Env) do;
                
                local retval, time, value, shape, tension, selected = GetEnvelopePointInfo(Env,i-1,true);
                if time >= startLoop and time <= endLoop then;
                    
                    if ScalingMode == 1 then;
                        value = reaper.ScaleFromEnvelopeMode(ScalingMode,value);
                    end;
                    
                    local DB = 20 * math.log(value, 10);
                    if DB < -150 then DB = -150 end;
                    local DbNew = DB + VOLUME_DB;
                    if DbNew >= max_DB then DbNew = max_DB end;
                    local val_dB = 10^(DbNew/20);
                    local value = val_dB;
                    
                    if ScalingMode == 1 then;
                          value = reaper.ScaleToEnvelopeMode(ScalingMode,value);
                    end;
                    
                    SetEnvelopePointInfo(Env,i-1,time,value,shape,tension,selected,false, true);  
                end;
            end;
            ::END_LOOP::;
        end;
    end;
    
    if undo then;
        if VOLUME_DB >= 0 then VOLUME_DB = "+"..VOLUME_DB end;
        reaper.Undo_EndBlock(VOLUME_DB.."db-Volume sel take in time selection",-1);
        reaper.PreventUIRefresh(-1);
    else;
        no_undo();
    end;
    reaper.UpdateArrange();