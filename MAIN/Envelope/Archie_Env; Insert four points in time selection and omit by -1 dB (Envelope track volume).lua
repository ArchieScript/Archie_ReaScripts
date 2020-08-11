--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Envelope
   * Description: Insert four points in time selection and omit by -1 dB (Envelope track volume)
   * Author:      Archie
   * Version:     1.04
   * Описание:    Вставьте четыре точки в выбор времени и опустите на -1 дБ (огибающая громкости трека)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    HDVulcan(RMM)$
   * Gave idea:   HDVulcan(RMM)$
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.03 [23.02.20]
   *                  + Remove dependency on selected items.
   *                    Now the script works only on selected tracks.

   *              v.1.02 [17.02.20]
   *                  + Continue work with remote time selection
   *              v.1.0 [11.11.19]
   *                  + initialе
--]]

     --======================================================================================
     --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
     --======================================================================================



     local value_DB      =    -1; --      | значения дб для изменения
     local Envelope      =     0; --      | 0 = volume  / 1 = volumePreFX
     local ret_Point_1   =     0; --      | отступ точка 1
     local ret_Point_2   =     0; --      | отступ точка 2
     local ret_Point_3   =     0; --      | отступ точка 3
     local ret_Point_4   =     0; --      | отступ точка 4
     local SHAPE_1       =     0; -- 0..5 | Point Shape точка 1
     local SHAPE_2       =     0; -- 0..5 | Point Shape точка 2
     local SHAPE_3       =     0; -- 0..5 | Point Shape точка 3
     local SHAPE_4       =     0; -- 0..5 | Point Shape точка 4
     local SELECTED_1    =     0; -- 1/0  | выделение точки 1
     local SELECTED_2    =     1; -- 1/0  | выделение точки 2
     local SELECTED_3    =     1; -- 1/0  | выделение точки 3
     local SELECTED_4    =     0; -- 1/0  | выделение точки 4
     local UnLoop        = false; --      | true/false
     local ENV_SEl_F_TR  =  true; --      | true/false Выделить первый созданный трек автоматизации  / оставить выделения на предыдущем треке автоматизации
     local SaveTimeSel   = false; --      | true/false  работает только при UnLoop = true (v.1.02+)



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================


    --=====================================================
    local function no_undo()reaper.defer(function()end)end;
    --=====================================================

    local titleUndo = "Track envelope volume in time selection and item selection by -1 dB"

    --===========================================================
    local function InsertEnvelopePointTrack_Arc(Env,autoitem_idx,time,point_indent,noDuplicate,value,shape,tension,selected,noSortIn,startTimeTakeProj)
        if type(startTimeTakeProj)~="boolean"then;error("#11 Expected Boolean received "..type(startTimeTakeProj),2)end;
        local Track = reaper.Envelope_GetParentTrack(Env);
        if not Track then return false end;

        if autoitem_idx >= 0 then;
            local posAutoIt = reaper.GetSetAutomationItemInfo(Env,autoitem_idx,"D_POSITION",0,0);
            local lenAutoIt = reaper.GetSetAutomationItemInfo(Env,autoitem_idx,"D_LENGTH",0,0);
            if not startTimeTakeProj then;time = time+posAutoIt;end;
            if (time < posAutoIt) or (time > posAutoIt+lenAutoIt) then return false end;
        end;

        if noDuplicate == true or noDuplicate == 1 then;
            for i = 1, reaper.CountEnvelopePointsEx(Env,autoitem_idx) do;
                local _,time0,_,_,_,_ = reaper.GetEnvelopePointEx(Env,autoitem_idx,i-1);
                if time0 >= (time-(point_indent/2)) and time0 <= (time+(point_indent/2)) then;
                    point = true; break;
                    --reaper.DeleteEnvelopePointRange(Env,(time0*playrate)-1e-009,(time0*playrate)+1e-009);
                end;
            end;
        end;

        if not point then;
            reaper.InsertEnvelopePointEx(Env,autoitem_idx,time,value,shape,tension,selected,noSortIn);
            return true;
        end;
        point=nil; return false;
    end;
    --===========================================================



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

    local EnvChun;
    if Envelope == 1 then Envelope=41865 EnvChun="<VOLENV" else Envelope = 41866 EnvChun="<VOLENV2" end;

    local SelTrEnv;
    if ENV_SEl_F_TR ~= true then;
        SelTrEnv = reaper.GetSelectedTrackEnvelope(0);
    end;


    local Point1 = StartLoop - math.abs(ret_Point_1);
    local Point2 = StartLoop + math.abs(ret_Point_2);
    local Point3 = EndLoop   - math.abs(ret_Point_3);
    local Point4 = EndLoop   + math.abs(ret_Point_4);

    if Point1 == StartLoop then Point1 = Point1-(1e-004)end;
    if Point4 == EndLoop   then Point4 = Point4+(1e-004)end;

    if Point2 >= Point3 or Point3 <= Point2 then;
        Point2 = StartLoop;
        Point3 = EndLoop;
    end;


    local STrT = {};
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;
    for t = 1,CountSelTrack do;
        table.insert(STrT,reaper.GetSelectedTrack(0,t-1));
    end;


    reaper.PreventUIRefresh(1);
    local undo;


    for t = 1,#STrT do;

        if not undo then;
            undo = true;
            reaper.Undo_BeginBlock();
        end;

        reaper.SetOnlyTrackSelected(STrT[t]);
        reaper.SetMediaTrackInfo_Value(STrT[t],"I_SELECTED",1);
        reaper.Main_OnCommand(Envelope,0);


        if ENV_SEl_F_TR == true and not SelTrEnv then;
            SelTrEnv = reaper.GetSelectedTrackEnvelope(0);
        end;

        local Env = reaper.GetTrackEnvelopeByChunkName(STrT[t],EnvChun);

        local _,value,_,_,_ = reaper.Envelope_Evaluate(Env,Point1,0,0);
        InsertEnvelopePointTrack_Arc(Env,-1,Point1,(1e-006),true,value,SHAPE_1,0,SELECTED_1,false,true);

        local _,value,_,_,_ = reaper.Envelope_Evaluate(Env,Point2,0,0);
        InsertEnvelopePointTrack_Arc(Env,-1,Point2,(1e-006),true,value,SHAPE_2,0,SELECTED_2,false,true);

        local _,value,_,_,_ = reaper.Envelope_Evaluate(Env,Point3,0,0);
        InsertEnvelopePointTrack_Arc(Env,-1,Point3,(1e-006),true,value,SHAPE_3,0,SELECTED_3,false,true);

        local _,value,_,_,_ = reaper.Envelope_Evaluate(Env,Point4,0,0);
        InsertEnvelopePointTrack_Arc(Env,-1,Point4,(1e-006),true,value,SHAPE_4,0,SELECTED_4,false,true);

        local CountEnvPoint = reaper.CountEnvelopePoints(Env);
        for pnt = 1,CountEnvPoint do;

            local retval,time,value,shape,tension,selected = reaper.GetEnvelopePoint(Env,pnt-1);
            if time >= Point2-0.00000001  and time <= Point3+0.00000001 then;

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


    local Track = reaper.GetSelectedTrack(0,0);
    if Track then;
        reaper.SetOnlyTrackSelected(Track);
        reaper.SetMediaTrackInfo_Value(Track,"I_SELECTED",0);
    end;
    for tb = 1,#STrT do;
        reaper.SetMediaTrackInfo_Value(STrT[tb],"I_SELECTED",1);
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

        end;
        reaper.Undo_EndBlock(titleUndo or "",-1);
    else;
        no_undo();
    end;

    reaper.PreventUIRefresh(-1);
    reaper.UpdateArrange();

	
	

