--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Track
   * Description: Track; Toggle Rec Arm exclusive(`).lua
   * Author:      Archie
   * Version:     1.03
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * DONATION:    http://paypal.me/ReaArchie?locale.x=ru_RU
   * Customer:    AlexLazer(rmm)$
   * Gave idea:   AlexLazer(rmm)$
   * Extension:   Reaper 6.10+ http://www.reaper.fm/
   *              SWS v.2.12.0 http://www.sws-extension.org/index.php
   * Changelog:
   *              v.1.0 [040620]
   *                  + initialе
--]]
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================


    local SEL_TRACK_MON = -1
                     -- = -1 -- Игнорировать мониторинг на выделенном треке;
                     -- =  0 -- Выключить мониторинг на выделенном треке;
                     -- =  1 -- Включить мониторинг на выделенном треке;


    local UNSEL_TRACK_MON = -1
                       -- = Игнорировать мониторинг на невыделенных треках;
                       -- = 0 Выключить мониторинг на невыделенных треках;
                       -- = 1 Включить мониторинг на невыделенных треках;


    local OFF_AUTO_REC_ARM = 1
                        -- = 0 Не отключать авто rec arm на не выделенных треках
                        -- = 1 Отключить авто rec arm на всех не выделенных треках


    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================


    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------



    --=========================================
    local function GetSetArmTrackState(set,track,state);
        if not set or set == 0 then;
            return reaper.GetMediaTrackInfo_Value(track,"I_RECARM");
        else;
            local _,TrackChunk = reaper.GetTrackStateChunk(track,'',false);
            local bracket,ret = 0,nil;
            for var in string.gmatch(TrackChunk..'\n',".-\n") do;
                if var:match('^%s-%S')=='<'or var:match('^%s-%S')=='>'then;
                    bracket = bracket+1;
                end;
                ret = tonumber(var:match('^%s-LOCK%s+(%d*).-$'));
                if ret or (bracket >= 2) then break end;
            end;
            if ret and ret >= 1 then;
                local x,t,arg1,arg2 = 0,{},nil,nil;
                for var in string.gmatch(TrackChunk..'\n',".-\n") do;
                    if not arg1 and not arg2 then;
                        arg1,arg2 = var:match('^%s-(REC%s+)(%d*).-$');
                        if arg1 and arg2 then;
                            var = var:gsub(arg1..arg2,arg1..state);
                        end;
                    end;
                    x=x+1;t[x]=var;
                end;
                reaper.SetTrackStateChunk(track,table.concat(t),false);
            else;
                reaper.SetMediaTrackInfo_Value(track,"I_RECARM",state);
            end;
        end;
    end;
    --=========================================


    --=========================================
    local function Set_Auto_RecArm_State(track,state);
        local REC,t,idx = nil,{},0;
        local _,TrackChunk = reaper.GetTrackStateChunk(track,'',false);
        for var in string.gmatch(TrackChunk..'\n',".-\n") do;
            if var:match('^%s-AUTO_RECARM')then;
                local arg1,arg2 = var:match('^%s-(AUTO_RECARM%s+)(%d*).-$');
                if arg1 and arg2 then;
                    var = var:gsub(arg1..arg2,arg1..state);
                end;
            else;
                if REC and state == 1 then;
                    var = 'AUTO_RECARM '..state..'\n'..var;
                end;
            end;
            if REC then REC = nil end;
            if var:match('^%s-REC%s+%d+')then;
                REC = true;
            end;
            idx = idx + 1;
            t[idx] = var
        end;
        if table.concat(t)~=TrackChunk..'\n' then;
            reaper.SetTrackStateChunk(track,table.concat(t),false);
        end;
    end;
    --=========================================




    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then no_undo() return end;


    local arm_new = 0;
    for i = 1,CountSelTrack do;
        local track_sel = reaper.GetSelectedTrack(0,i-1);
        local arm = reaper.GetMediaTrackInfo_Value(track_sel,'I_RECARM');
        if arm == 0 then;
            arm_new = 1;
            break;
        end;
    end;

    reaper.Undo_BeginBlock();
    reaper.PreventUIRefresh(1);

    for i = 1, reaper.CountTracks(0) do;
        local Track = reaper.GetTrack(0,i-1);
        local sel = reaper.GetMediaTrackInfo_Value(Track,'I_SELECTED')==1;
        if sel then;
            reaper.SetMediaTrackInfo_Value(Track,'I_RECARM',arm_new);
            if SEL_TRACK_MON == 0 then;
                reaper.SetMediaTrackInfo_Value(Track,'I_RECMON',0);
            elseif SEL_TRACK_MON == 1 then;
                reaper.SetMediaTrackInfo_Value(Track,'I_RECMON',1);
            end;
        else;
            GetSetArmTrackState(1,Track,0);
            if UNSEL_TRACK_MON == 0 then;
                reaper.SetMediaTrackInfo_Value(Track,'I_RECMON',0);
            elseif UNSEL_TRACK_MON == 1 then;
                reaper.SetMediaTrackInfo_Value(Track,'I_RECMON',1);
            end;

            if OFF_AUTO_REC_ARM == 1 then;
                Set_Auto_RecArm_State(Track,0);
            end;
        end;
    end;

    local Title;
    if arm_new == 1 then;
        Title = 'Arm exclusive';
    else;
        Title = 'UnArm exclusive';
    end;

    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock(Title,-1);


