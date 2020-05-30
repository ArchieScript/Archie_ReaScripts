--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track;  Visible only selected tracks and their children - restore back.lua
   * Author:      Archie
   * Version:     1.02
   * О скрипте:   Видны только выделенные треки и их потомки-восстановить обратно
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Shico(Rmm)
   * Gave idea:   Shico(Rmm)
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.0 [310520]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    local IGNORE_COLLAPSE = true; --true / false
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    local function no_undo()reaper.defer(function()end)end;
    -----------------------------
    local UNDO_65498798343;
    local function UNDO(set);
        if not UNDO_65498798343 and set == 1 then;
            reaper.Undo_BeginBlock();
            reaper.PreventUIRefresh(1);
            UNDO_65498798343 = true;
            return UNDO_65498798343;
        end;
        return UNDO_65498798343;
    end;
    -----------------------------
    local function SetToggleButtonOnOff(numb);
        local _,_,sec,cmd,_,_,_ = reaper.get_action_context();
        reaper.SetToggleCommandState(sec,cmd,numb or 0);
        reaper.RefreshToolbar2(sec,cmd);
    end;
    -----------------------------
    
    
    local ProjExtState = 'ARCHIE_VISIBLE_ONLY_SELECTED_TRACKS_AND_THEIR_CHILDREN_RESTORE_BACK';
    local retval,key,value = reaper.EnumProjExtState(0,ProjExtState,0);
    if retval then;
    --------------------
        for i = 1, math.huge do;
            local retval,key,value = reaper.EnumProjExtState(0,ProjExtState,i-1);
            if retval then;
                local track = reaper.BR_GetMediaTrackByGUID(0,key);
                if track then;
                    local hideX,visibTcpX,visibMcpX,collapseX = value:match("(.*)&&&(.*)&&&(.*)&&&(.*)");
                    if tonumber(hideX)and tonumber(hideX)==1  then;
                        local visibTcp = reaper.GetMediaTrackInfo_Value(track,"B_SHOWINTCP");
                        local visibMcp = reaper.GetMediaTrackInfo_Value(track,"B_SHOWINMIXER");
                        if visibTcp == 0 or visibMcp == 0 then;
                            if tonumber(visibTcpX) then;
                                if tonumber(visibTcpX)~=tonumber(visibTcp) then;
                                    UNDO(1);
                                    reaper.SetMediaTrackInfo_Value(track,"B_SHOWINTCP",visibTcpX);
                                end;
                            end;
                            if tonumber(visibMcpX) then;
                                if tonumber(visibMcpX)~=tonumber(visibMcp) then;
                                    UNDO(1);
                                    reaper.SetMediaTrackInfo_Value(track,"B_SHOWINMIXER",visibMcpX);
                                end;
                            end;
                        end;
                    end;
                    ----
                    if tonumber(collapseX)then;
                        local folder = reaper.GetMediaTrackInfo_Value(track,"I_FOLDERDEPTH")==1;
                        if folder then;
                            local collapse = reaper.GetMediaTrackInfo_Value(track,"I_FOLDERCOMPACT");
                            if tonumber(collapseX)>0 and tonumber(collapseX)~=tonumber(collapse)then;
                                UNDO(1);
                                reaper.SetMediaTrackInfo_Value(track,"I_FOLDERCOMPACT",collapseX);
                            end;
                        end;
                    end;
                end;
            else;
                reaper.SetProjExtState(0,ProjExtState,"","");
                break;
            end;
        end;
        ----
        if UNDO(0)then;
            reaper.Undo_EndBlock('Restore visible track',-1);
            reaper.PreventUIRefresh(-1);
            reaper.TrackList_AdjustWindows(false);
            reaper.Main_OnCommand(40913,0);--Vertical scroll selected tracks
        else;
            reaper.Main_OnCommand(40913,0);--Vertical scroll selected tracks
            no_undo();
        end;
        SetToggleButtonOnOff(0);
        --------------------
    else;
        --------------------
        local CountTrack = reaper.CountTracks(0);
        local CountSelTrack = reaper.CountSelectedTracks(0);
        if CountTrack == 0 or CountSelTrack == 0 then no_undo()return end;
        local height;
        for i = CountSelTrack-1,0,-1 do;
            local trackSel = reaper.GetSelectedTrack(0,i);
            local visibTcp = reaper.GetMediaTrackInfo_Value(trackSel,"B_SHOWINTCP");
            local visibMcp = reaper.GetMediaTrackInfo_Value(trackSel,"B_SHOWINMIXER");
            if IGNORE_COLLAPSE == true then;
                height = reaper.GetMediaTrackInfo_Value(trackSel,"I_WNDH");
            end;
            height = height or 1000000;
            if (visibTcp == 0 and visibMcp == 0)or height < 5 then;
                reaper.SetMediaTrackInfo_Value(trackSel,"I_SELECTED",0);
            end;
        end;
        local CountSelTrack = reaper.CountSelectedTracks(0);
        if CountSelTrack == 0 then no_undo()return end;
        -------
        local Depth,Depth_On,Hide;
        for i = 1, CountTrack do;
            local track = reaper.GetTrack(0,i-1);
            local visibTcp = reaper.GetMediaTrackInfo_Value(track,"B_SHOWINTCP");
            local visibMcp = reaper.GetMediaTrackInfo_Value(track,"B_SHOWINMIXER");
            local folder = reaper.GetMediaTrackInfo_Value(track,"I_FOLDERDEPTH")==1;
            local collapse;
            if folder then;
                collapse = reaper.GetMediaTrackInfo_Value(track,"I_FOLDERCOMPACT");
            end;
            local guid = reaper.GetTrackGUID(track);
            local valSetProj = visibTcp..'&&&'..visibMcp..'&&&'..(collapse or '');
            ----------
            local sel = reaper.GetMediaTrackInfo_Value(track,"I_SELECTED")>0;
            
            if Depth_On then;
                local Depth2 = reaper.GetTrackDepth(track);
                if Depth2 <= Depth then Depth = nil Depth_On = nil end;
            end; 
            
            if sel and folder and not Depth then;
                Depth = reaper.GetTrackDepth(track);
            end;
            
            if Depth then Depth_On = Depth end;
            
            if not sel and not Depth and (visibTcp~=0 or visibMcp~=0) then;
                UNDO(1);
                reaper.SetMediaTrackInfo_Value(track,"B_SHOWINTCP",0);
                reaper.SetMediaTrackInfo_Value(track,"B_SHOWINMIXER",0);
                Hide = 1;
            elseif folder and collapse > 0 then;
                UNDO(1);
                reaper.SetMediaTrackInfo_Value(track,"I_FOLDERCOMPACT",0);
            end;
            
            valSetProj = (Hide or '')..'&&&'..valSetProj;
            Hide = nil;
            reaper.SetProjExtState(0,ProjExtState,guid,valSetProj);
        end;
        ----
        if UNDO(0)then;
            reaper.Undo_EndBlock('Visible only selected tracks and their children',-1);
            reaper.PreventUIRefresh(-1);
            reaper.TrackList_AdjustWindows(false);
            reaper.Main_OnCommand(40913,0);--Vertical scroll selected tracks
            SetToggleButtonOnOff(1);
        else;
            reaper.SetProjExtState(0,ProjExtState,"","");
            no_undo();
        end;
        --------------------
    end;
    
    
    
    