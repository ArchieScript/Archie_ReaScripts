--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Fx
   * Description: Toggle Bypass Fx by name in tracks by name(Template)
   * Author:      Archie
   * Version:     1.03
   * Описание:    Байпас Fx по имени в треках по имени (Шаблон)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Дима Горелик(Rmm)
   * Gave idea:   Дима Горелик(Rmm)
   * Extension:   Reaper 6.03+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.02/1.03 [020620]
   *                  + MASTER TRACK
   
   *              v.1.0 [07.02.20]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    local NAME_TRACK = 'drums;track2;track8'
                  --    Введите имена треков через точку с запятой
                  -- =  'drums;track2;track8' 
                  -- = '' - треки без имени
                  --     если нужно добавить треки без имени и с именем то в начало строки добавить точку с запятой
                  -- = ';drums;track2;track8'
    
    
    local NAME_FX = 'Nexu;EQ;eos' -- Введите часть имени Fx через точку с запятой без префикса 'Vst:/Vsti:'
    
    
    local MASTER_TRACK = false;
                    -- = true  включить мастер трек
                    -- = false выключить мастер трек
                    -- Если нужен только мастер трек,то установить NAME_TRACK = nil
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_ubdo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    ---------------------------------------------------------
    local function SC(x)return string.gsub(x,'%p','%%%0')end;
    ---------------------------------------------------------
    
    local 
    NT = {};
    for S in string.gmatch(NAME_FX..';',"(.-);") do;
        NT[#NT+1]=S:upper();
    end;
    
    local 
    TrNameT = {};
    if NAME_TRACK and NAME_TRACK ~= 'nil' then;
        for S in string.gmatch(NAME_TRACK..';',"(.-);") do;
            TrNameT[#TrNameT+1]=S:upper();
        end;
    end;
    
    
    local strU;
    
    local GetEnabled, SetEnabled;
    
    local Undo;
    
    
    --( MASTER ---------------------------
    if MASTER_TRACK == true then;
        
        local masterTrack = reaper.GetMasterTrack(0);
        local FX_Count = reaper.TrackFX_GetCount(masterTrack);
        for ifx = 1, FX_Count do;
            local _, nameFx = reaper.TrackFX_GetFXName(masterTrack,ifx-1,'');
            nameFx = nameFx:upper();
            for inm = 1, #NT do;
                if nameFx:match(SC(NT[inm])) then;
                    if not GetEnabled then;
                        GetEnabled = reaper.TrackFX_GetEnabled(masterTrack,ifx-1);
                        if GetEnabled then SetEnabled = false else SetEnabled = true GetEnabled = true end;
                    end;
                    
                    if not Undo then;
                        reaper.Undo_BeginBlock();
                        reaper.PreventUIRefresh(1);
                        Undo = true;
                    end;
                    
                    reaper.TrackFX_SetEnabled(masterTrack,ifx-1,SetEnabled);
                    
                    if SetEnabled == true then strU = "Unbypass Fx" else strU = "Bypass Fx" end;
                    break;
                end;
            end;
        end;
    end;
    -- MASTER )---------------------------
    
    
    --( TRACK ---------------------------
    if #TrNameT > 0 then;
    
        local CountTrack = reaper.CountTracks(0);
        
        for i = 1,CountTrack do;
            local Track = reaper.GetTrack(0,i-1);
            local retval,stringNeedBig = reaper.GetSetMediaTrackInfo_String(Track,'P_NAME','',0);
            stringNeedBig = stringNeedBig:upper();
            for iTr = 1,#TrNameT do;
                
                if type(TrNameT[iTr])=='string' --[[and #TrNameT[iTr]:gsub('%s','')>0]] and stringNeedBig == TrNameT[iTr] then;
                    local FX_Count = reaper.TrackFX_GetCount(Track);
                    for ifx = 1, FX_Count do;
                        
                        local _, nameFx = reaper.TrackFX_GetFXName(Track,ifx-1,'');
                        nameFx = nameFx:upper();
                        for inm = 1, #NT do;
                            if nameFx:match(SC(NT[inm])) then;
                                if not GetEnabled then;
                                    GetEnabled = reaper.TrackFX_GetEnabled(Track,ifx-1);
                                    if GetEnabled then SetEnabled = false else SetEnabled = true GetEnabled = true end;
                                end;
                                
                                if not Undo then;
                                    reaper.Undo_BeginBlock();
                                    reaper.PreventUIRefresh(1);
                                    Undo = true;
                                end;
                                
                                reaper.TrackFX_SetEnabled(Track,ifx-1,SetEnabled);
                                
                                if SetEnabled == true then strU = "Unbypass Fx" else strU = "Bypass Fx" end;
                                break;
                            end;
                        end;
                    end;
                end;
            end;
        end;
    end;
    -- TRACK )---------------------------
    
    
    if Undo then;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock(strU,-1);
    else;
        no_ubdo();
    end;
    