--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Envelope Take
   * Description: Insert four points in time selection and omit by -1 dB (Envelope take volume)
   * Author:      Archie
   * Version:     1.02
   * Описание:    Вставьте четыре точки в выбор времени и опустите на -1 дБ (огибающая громкости тейка)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    HDVulcan(RMM)$
   * Gave idea:   HDVulcan(RMM)$
   * Extension:   Reaper 5.984+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.02 [17.02.20]
   *                  + Continue work with remote time selection

   *              v.1.0 [11.11.19]
   *                  + initialе
--]]

    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local value_DB = -1    --      | значения дб для изменения
    local ret_Point_1 = 0  --      | отступ точка 1
    local ret_Point_2 = 0  --      | отступ точка 2
    local ret_Point_3 = 0  --      | отступ точка 3
    local ret_Point_4 = 0  --      | отступ точка 4
    local SHAPE_1 =   0    -- 0..5 | Point Shape точка 1
    local SHAPE_2 =   0    -- 0..5 | Point Shape точка 2
    local SHAPE_3 =   0    -- 0..5 | Point Shape точка 3
    local SHAPE_4 =   0    -- 0..5 | Point Shape точка 4
    local SELECTED_1 = 0   -- 1/0  | выделение точки 1
    local SELECTED_2 = 1   -- 1/0  | выделение точки 2
    local SELECTED_3 = 1   -- 1/0  | выделение точки 3
    local SELECTED_4 = 0   -- 1/0  | выделение точки 4
    local TakeALL = false  --false/true | пременить ко всем тейкам
    local OnSelectedTracks = false  --false/true | На Выделенных треках
    local UnLoop = false    --     | true/false   удалить выбор времени
    local ENV_SEl_F_TR = false --  | true/false; true Выделить первую созданную огибающую

    local SaveTimeSel = false; --работает только при UnLoop = true (v.1.02)

    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    local titleUndo = "Volume of selected items in time selection by -1 dB"


    --=====================================================
    local function no_undo()reaper.defer(function()end)end;
    --=====================================================


    --==================================================================
    local function InsertEnvelopePointTake_Arc(Env,time,point_indent,noDuplicate,value,shape,tension,selected,noSortIn,startTimeTakeProj);
        if type(startTimeTakeProj)~="boolean"then;error("#10 Expected Boolean received "..type(startTimeTakeProj),2)end;
        local Take = reaper.Envelope_GetParentTake(Env);
        if not Take then return false end;
        local playrate = reaper.GetMediaItemTakeInfo_Value(Take,"D_PLAYRATE");
        local item = reaper.GetMediaItemTake_Item(Take);
        local posItem = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
        local lenItem = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
        if startTimeTakeProj == true then;time = time-posItem;end;
        --if posItem > time or posItem + lenItem < time then return false end; --Что бы точка не добавлялась за пределами айтема

        if noDuplicate == true or noDuplicate == 1 then;
            for i = 1, reaper.CountEnvelopePoints(Env) do;
                local _,time0,_,_,_,_ = reaper.GetEnvelopePoint(Env,i-1);
                time0 = time0/playrate;
                if time0 >= (time-(point_indent/2)) and time0 <= (time+(point_indent/2)) then;
                    point = true; break;
                    --reaper.DeleteEnvelopePointRange(Env,(time0*playrate)-1e-009,(time0*playrate)+1e-009);
                end;
            end;
        end;

        if not point then;
            time = time*(playrate or 1);
            reaper.InsertEnvelopePoint(Env,time,value,shape,tension,selected,noSortIn);
            return true;
        end;
        point=nil; return false;
    end;
    --===========================================================


    --===========================================================
    local function showEnvVolumeTakeSWS(take,VIS,ACT);
        local T = {};
        local guid = reaper.BR_GetMediaItemTakeGUID(take);
        local item = reaper.GetMediaItemTake_Item(take);
        local _,chunk = reaper.GetItemStateChunk(item,"",false);
        chunk = chunk:reverse(chunk);
        chunk = chunk:gsub(">",">\n\n",1);
        chunk = chunk:reverse(chunk).."\n\n";
        chunk = chunk:gsub("\nTAKE%s-[SEL]-%s-\n","\n\n%0");
        for str in chunk:gmatch(".-\n\n")do;
            if str:match(guid:gsub("%p","%%%0"))then;
                if not str:match("<VOLENV")then;
                   str = str.."<VOLENV\nACT 1 -1\nVIS 1 1 1\nLANEHEIGHT 0 0\nARM 0\nDEFSHAPE 0 -1 -1\nPT 0 1 0\n>\n";
                end;
                str = str:gsub("ACT%s-%d","ACT "..(ACT or 0));--Active
                str = str:gsub("VIS%s-%d","VIS "..(VIS or 1));
            end;
            table.insert(T,str);
        end;
        chunk = table.concat(T);
        reaper.SetItemStateChunk(item,chunk,false);
    end;
    --===========================================================


    --===========================================================
    local SelTrEnv;
    local StartLoop, EndLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    local resTimeSel = 9^9;
    if StartLoop == EndLoop and (UnLoop ~= true or SaveTimeSel ~= true) then;
        no_undo() return;
    elseif StartLoop == EndLoop and UnLoop == true and SaveTimeSel == true then;
        local ExtState = reaper.GetExtState('HDVulcan_InsertFourPointsTake','TIMESEL');
        local StartL, EndL = ExtState:match('^(.-)&&&(.-)$');
        StartL = tonumber(StartL);
        EndL = tonumber(EndL);
        if StartL and EndL then;

            if StartLoop == resTimeSel and EndLoop == resTimeSel then;
                StartLoop = StartL;
                EndLoop = EndL;
            else;
                reaper.DeleteExtState('HDVulcan_InsertFourPointsTake','TIMESEL',false);
                no_undo() return;
            end;
        else;
            no_undo() return;
        end;
    end;

    local Point1 = StartLoop - math.abs(ret_Point_1);
    local Point2 = StartLoop + math.abs(ret_Point_2);
    local Point3 = EndLoop   - math.abs(ret_Point_3);
    local Point4 = EndLoop   + math.abs(ret_Point_4);

    if Point1 == StartLoop then Point1 = Point1-(1e-004)end;
    if Point4 == EndLoop   then Point4 = Point4+(1e-004)end;

    --if Point2 >= Point3 then Point2 = StartLoop end;
    --if Point3 <= Point2 then Point3 = EndLoop end;

    if Point2 >= Point3 or Point3 <= Point2 then;
        Point2 = StartLoop;
        Point3 = EndLoop;
    end;


    local CountSelIt = reaper.CountSelectedMediaItems(0);
    if CountSelIt == 0 then no_undo() return end;

    reaper.PreventUIRefresh(1);
    local undo;

    for it = 1,CountSelIt do;

        local item = reaper.GetSelectedMediaItem(0,it-1);
        local posItem = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
        local lenItem = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");

        -----
        if OnSelectedTracks == true then;
            local Tr = reaper.GetMediaItem_Track(item);
            local sel = reaper.GetMediaTrackInfo_Value(Tr,"I_SELECTED");
            if sel == 0 then;
                posItem = math.huge;
            end;
        end;
        -----

        if posItem < Point4-(1e-004) and posItem+lenItem > Point1+(1e-004) then;

            local CountTake = reaper.CountTakes(item);
            if TakeALL ~= true then CountTake = 1 end;

            for tk = 1,CountTake do;

                local take;
                if TakeALL == true then;
                    take = reaper.GetMediaItemTake(item,tk-1);
                else;
                    take = reaper.GetActiveTake(item);
                end;

                local TakeIsMIDI = reaper.TakeIsMIDI(take);
                if not TakeIsMIDI then;

                    if not undo then;
                        undo = true;
                        reaper.Undo_BeginBlock();
                    end;

                    local playrate = reaper.GetMediaItemTakeInfo_Value(take,"D_PLAYRATE");
                    showEnvVolumeTakeSWS(take,1,1);
                    local Env = reaper.GetTakeEnvelopeByName(take,"Volume");
                    ----
                    if ENV_SEl_F_TR == true and not SelTrEnv then;
                        SelTrEnv = Env;
                    end;
                    ----
                    local _,value,_,_,_ = reaper.Envelope_Evaluate(Env,(Point1-posItem)*playrate,0,0);
                    InsertEnvelopePointTake_Arc(Env,Point1,(1e-006),true,value,SHAPE_1,0,SELECTED_1,false,true);
                    local _,value,_,_,_ = reaper.Envelope_Evaluate(Env,(Point2-posItem)*playrate,0,0);
                    InsertEnvelopePointTake_Arc(Env,Point2,(1e-006),true,value,SHAPE_2,0,SELECTED_2,false,true);
                    local _,value,_,_,_ = reaper.Envelope_Evaluate(Env,(Point3-posItem)*playrate,0,0);
                    InsertEnvelopePointTake_Arc(Env,Point3,(1e-006),true,value,SHAPE_3,0,SELECTED_3,false,true);
                    local _,value,_,_,_ = reaper.Envelope_Evaluate(Env,(Point4-posItem)*playrate,0,0);
                    InsertEnvelopePointTake_Arc(Env,Point4,(1e-006),true,value,SHAPE_4,0,SELECTED_4,false,true);
                    ----
                    local CountEnvPoint = reaper.CountEnvelopePoints(Env);
                    for pnt = 1,CountEnvPoint do;
                        local retval,time,value,shape,tension,selected = reaper.GetEnvelopePoint(Env,pnt-1);
                        local timex = (time/playrate)+posItem;
                        if timex >= Point2-0.00000001  and timex <= Point3+0.00000001 then;

                            local ScalingM = reaper.GetEnvelopeScalingMode(Env);
                            local value = reaper.ScaleFromEnvelopeMode(ScalingM,value)
                            local DB = 20 * math.log(value, 10)+value_DB;
                            if DB < -140 then DB = -140 end;
                            if DB > 6 then DB = 6 end;
                            local val = 10^(DB/20);
                            local val = reaper.ScaleToEnvelopeMode(ScalingM,val);

                            reaper.SetEnvelopePoint(Env,pnt-1,time,val,shape,tension,selected,false);
                        end;
                    end;
                end;
            end;
        end;
    end;

    if SelTrEnv then;
        reaper.SetCursorContext(2,SelTrEnv);
    end;

    if undo then;
        if UnLoop == true then;

             if SaveTimeSel == true then;
                 local StartLoop, EndLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
                 if StartLoop~=EndLoop then;
                     reaper.SetExtState('HDVulcan_InsertFourPointsTake','TIMESEL',StartLoop..'&&&'..EndLoop,false);
                 end;
             end;

             reaper.GetSet_LoopTimeRange(1,0,resTimeSel,resTimeSel,0);
         end
        reaper.Undo_EndBlock(titleUndo or "",-1);
    else;
        no_undo();
    end;
    reaper.PreventUIRefresh(-1);
    reaper.UpdateArrange();













