--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Render
   * Description: Render multi-track to a stereo track in certain channels
   * Author:      Archie
   * Version:     1.02
   * Описание:    Рендер мульти-трека в стерео-трек на определенных каналах
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Дима Горелик(Rmm)$
   * Gave idea:   Дима Горелик(Rmm)$
   * Extension:   Reaper 6.0+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   *              reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   * Changelog:   
   *              v.1.02 [29.01.20]
   *                  + Fixed: Path MacOs
   
   *              v.1.0 [20.01.20]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================    
    
    
    local Chanell = -1 -- Установить каналы для рендера
                                -- 1 = 1-2;  2 = 2-3; 3 = 3-4; 5 = 5-6 etc.
                                -- -1 показать окно для ввода
        
    
    local MODE = 3
            -- = 0 Post-Fader
            -- = 3 Pre-Fader
            -- = 1 Pre-FX / Pre-Fader
    
    
    --------
    
    
    local Render_Name = '$track-$day$month$year2-$hour-$minute'
        -- Взять имя с окна рендера      = 0
        -- Показать окно для ввода имени = 1
        -- Взять имя из буфера обмена    = 2
        -- или впишите Имя               = '-stem-'  Имя может содержать спец знаки, 
        --                                           такие как '$track', 
        --                                           смотрите окно рендера - 'Wildcards'
        --------------------------------------------------------------------------------
    
    
    
    local Render_Directory = 'XXRPP/Render-stem'
            -- путь может быть относительным путем   = '-stem-'
            -- или впишите полный путь   = 'C:/Users/...'
            -- Взять путь с окна рендера = -1
            -- Путь .rpp файла           = "XXRPP"
            -- Или продолжите путь       = "XXRPP/My Render/MULTI"
            ------------------------------------------------------
    
    
    
    local TailOnOff =  0
                 -- = -1 настройки из окна рендера (Tail)
                 -- =  0 отключить хвост (Tail)
                 -- =  1 включить хвост (Tail) / Необходимо установить TailTime ms
                 -----------------------------------------------------------------
          
    
    local TailTime = 1000 -- Длина хвоста, должен быть включен TailOnOff = 1
                -- = n ms
                -- = < 0 (-1)  длина хвоста соответствует выбору времени
          --------------------------------------------------------------
    
    
    local SampleRate = 0 -- = 0 default-сэмплрейт проекта или установите в виде = 44100 или 48000 и т.д.
          ----------------------------------------------------------------------------------------------
          
    
    
    local OutputFormat = 0
                    -- = 0 Wave
                    -- = 1 AIFF
                    -- = 2 FLAC
                    -- = 3 MP3
                    -- = 4 WavPack
                    --------------
          
          
    local bit = 24
        -- Wave
        --    = 8  |  8 bit PCM 
        --    = 16 | 16 bit PCM 
        --    = 24 | 24 bit PCM 
        --    = 32 | 32 bit FP 
        --    = 64 | 64 bit FP 
        --    =  4 |  4 bit IMA ADPCM 
        --    =  2 |  2 bit adpcm
        -- AIFF 
        --    =  8 |  8 bit PCM 
        --    = 16 | 16 bit PCM 
        --    = 24 | 24 bit PCM 
        --    = 32 | 32 bit PCM
        -- FLAC
        --    = 24 | 24 bit
        --    = 23 | 23/24 bit
        --    = 22 | 22/24 bit
        --    = 21 | 21/24 bit
        --    = 20 | 20/24 bit
        --    = 19 | 19/24 bit
        --    = 18 | 18/24 bit
        --    = 17 | 17/24 bit
        --    = 16 | 16 bit
        -- MP3
        --    =  0 | Maximum bitrate/quality
        -- WavPack
        --    =  0 |    16 bit
        --    =  1 |    24 bit
        --    =  2 |    32 bit integer
        --    =  3 |    32 bit FP
        --    =  4 | 23/24 bit
        --    =  5 | 22/24 bit
        --    =  6 | 21/24 bit
        --    =  7 | 20/24 bit
        --    =  8 | 19/24 bit
        --    =  9 | 18/24 bit
        --    = 10 | 17/24 bit
        --    = 11 |    32 bit FP - 144db floor
        --    = 12 |    32 bit FP - 120db floor
        --    = 13 |    32 bit FP - 96db floor
        --------------------------------------
    
    
    local AddRendFileInProj = 1
                         -- = 0  Не добавлять отрендеренные файлы в проект 
                         -- = 1  Добавить отрендеренные файлы в проект
                         ---------------------------------------------
    
    
    
    local Render_Speed = 0
                    -- = 0  Full-speed Offline
                    -- = 1  1x Offline
                    -- = 2  Online Render
                    -- = 3  Offline Render (Idle)
                    -- = 4  1x Offline Render (ldle)
                    --------------------------------
    
    
    
    local ResampleMode = 8
                    -- = 0  Medium (64pt Sinc)
                    -- = 1  Low (Linear Interpolation) 
                    -- = 2  Lowest (Point Sampling)
                    -- = 3  Good (192pt Sinc)
                    -- = 4  Better (384pt Sinc)
                    -- = 5  Fast (IIR + Linear Interpolation)
                    -- = 6  Fast (lliRx2 + Linear Interpolation)
                    -- = 7  Fast (16pt Sinc)
                    -- = 8  HQ (512pt Sinc)
                    -- = 9  Extreme HQ (768pt HQ Sinc)
                    ----------------------------------
    
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================   
    
                       
    
    ----------------------------------------------------------------------
    ---------------------------------------------------------------
    ------------------------------------------------------
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    ----------------------------------------
    ----------------------------------------
    local function If_Equals_Or(x,...);
        for _,v in pairs{...} do;
            if v == x then return true end;
        end;
        return false;
    end;
    ----------------------------------------
    ----------------------------------------
    
    
    ----------------------------------------
    ----------------------------------------
    -- encoding
    local b='ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'
    function enc(data);
        return ((data:gsub('.', function(x) 
            local r,b='',x:byte()
            for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
            return r;
        end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
            if (#x < 6) then return '' end
            local c=0
            for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
            return b:sub(c+1,c+1)
        end)..({ '', '==', '=' })[#data%3+1])
    end;
    ----------------------------------------
    ----------------------------------------
    
    
    -----------
    if not tonumber(Chanell) or Chanell > 64 then Chanell = 1 end;
    if Chanell < 0 then;
        local retval,retvals_csv = reaper.GetUserInputs('Render multi-track to a stereo track in certain channels',1, 'Inter chanell: 1-2 or 3-4 or.. etc.','1-2');
        if not retval then no_undo()return end;
        retvals_csv = tonumber(string.match(retvals_csv,'^%d+'));
        if not retvals_csv then no_undo()return end;
        if retvals_csv > 64 or retvals_csv < 0 then retvals_csv = 1 end;
        Chanell = retvals_csv;
    end;
    -----------
    
    
    --===========================================================================
    local function Render();
        ----------------------------------------------------------------
        -- MODE: 0 = Post-Fader; 3 = Pre-Fader; 1 = Pre-FX (Pre-Fader?)
        -- Chanell: 1=1-2;2=2-3;3=3-4;5=5-6 etc.
        local function trackSend(Track,Chanell,MODE);
            local numb = reaper.GetMediaTrackInfo_Value(Track,'IP_TRACKNUMBER');
            retval, stringNeedBig = reaper.GetSetMediaTrackInfo_String(Track,'P_NAME','',0);
            reaper.InsertTrackAtIndex(numb-1,false);
            local Track2 = reaper.GetTrack(0,numb-1);
            reaper.GetSetMediaTrackInfo_String(Track2,'P_NAME',stringNeedBig,1);
            reaper.SetMediaTrackInfo_Value(Track2,'D_VOL',1);
            reaper.CreateTrackSend(Track,Track2);
            if not Chanell then Chanell = 1 end;
            local Chan = tonumber((string.match(Chanell,'%d+')));
            if not Chan then Chan = 1 end;
            reaper.SetTrackSendInfo_Value(Track2,-1,0,"I_SRCCHAN",Chan-1);
            reaper.SetTrackSendInfo_Value(Track2,-1,0,"I_DSTCHAN",0);
            if MODE~=0 and MODE~=1 and MODE~=3 then MODE=3 end;
            reaper.SetTrackSendInfo_Value(Track2,-1,0,"I_SENDMODE",MODE);
            reaper.SetTrackSendInfo_Value(Track2,-1,0,"D_VOL",1);
            reaper.SetTrackSendInfo_Value(Track2,-1,0,"I_MIDIFLAGS",0);
            return Track2,Chan;
        end;
        ----------------------------------------------------------------
        
        local SelTr = {};
        local Send_T = {};
        local CountSelTrack = reaper.CountSelectedTracks(0);
        if CountSelTrack > 0 then;
           
            reaper.Undo_BeginBlock();
            reaper.PreventUIRefresh(1);
             
            for i = CountSelTrack-1,0,-1 do;
                local selTrack = reaper.GetSelectedTrack(0,i);
                if selTrack then;
                    
                    Send_T[#Send_T+1],Chan = trackSend(selTrack,Chanell,MODE);
                    SelTr[#SelTr+1] = selTrack
                end;
            end;
            
            if #Send_T > 0 then;
                reaper.SetOnlyTrackSelected(Send_T[1]);
                for i = 1, #Send_T do;
                    reaper.SetMediaTrackInfo_Value(Send_T[i],'I_SELECTED',1);
                end;
                    
                    if AddRendFileInProj == 1 then;
                        reaper.SelectAllMediaItems(0,0);
                    end;
                    
                    reaper.Main_OnCommand(42230,0);--проект рендер,самые последние настройки
            
                for i = 1, #Send_T do;
                    reaper.DeleteTrack(Send_T[i]);
                end;
                
                
                if AddRendFileInProj == 1 then;
                    -- / Move / --
                    for i = 1, #SelTr do;
                        local Track = reaper.GetTrack(0,reaper.CountTracks(0)-1);
                        local numb = reaper.GetMediaTrackInfo_Value(SelTr[i],'IP_TRACKNUMBER');
                        reaper.SetMediaTrackInfo_Value(Track,'I_SELECTED',1);
                        reaper.ReorderSelectedTracks(numb-1, 0 )
                        reaper.SetMediaTrackInfo_Value(Track,'I_SELECTED',0);
                        -- do return  end;
                    end;
                    --------------
                    
                    
                    -- / Sel tr / --
                    for i = 1, reaper.CountSelectedMediaItems(0) do;
                        local item = reaper.GetSelectedMediaItem(0,i-1);
                        local tr = reaper.GetMediaItemTrack(item);
                        reaper.SetMediaTrackInfo_Value(tr,'I_SELECTED',1);
                    end;
                    ----------------
                end;
                
            end;
           
            reaper.PreventUIRefresh(-1);
            reaper.Undo_EndBlock("Render stem from "..Chan..'-'..Chan+1 .." chanell",-1);   
        end;
    end;
    --===========================================================================
    
    
    
    
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then reaper.MB("No Track Selected!","Render Error",0)no_undo() return end;
    
    
    
    -------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------
    -- / Save render / ------------------------------------------------------------------------
    local S = {};
    S.RENDER_SETTINGS    = reaper.GetSetProjectInfo       (0,"RENDER_SETTINGS"    ,0,0);--Sourse
    S.RENDER_BOUNDSFLAG  = reaper.GetSetProjectInfo       (0,"RENDER_BOUNDSFLAG"  ,0,0);--Bounds
    S.RENDER_TAILFLAG    = reaper.GetSetProjectInfo       (0,"RENDER_TAILFLAG"    ,0,0);--Tail
    S.RENDER_TAILMS      = reaper.GetSetProjectInfo       (0,"RENDER_TAILMS"      ,0,0);--Tail ms
    S.RENDER_SRATE       = reaper.GetSetProjectInfo       (0,"RENDER_SRATE"       ,0,0);--Sample rate
    S.RENDER_CHANNELS    = reaper.GetSetProjectInfo       (0,"RENDER_CHANNELS"    ,0,0);--channels
    S.RENDER_SPEED       = reaper.SNM_GetIntConfigVar     (  "projrenderlimit"      ,0);--speed
    S.RENDER_RESAMPLE    = reaper.SNM_GetIntConfigVar     (  "projrenderresample"   ,0);--resample
    S._, S.RENDER_FORMAT = reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT"      ,0,0);--render_format
    S.RENDER_ADDTOPROJ   = reaper.GetSetProjectInfo       (0,"RENDER_ADDTOPROJ"   ,0,0);--add rendered files to project
    S.SILENTLY_iNCREMENT = reaper.SNM_GetIntConfigVar     (  "renderclosewhendone"  ,0);--Silently increment filenames to avoid overwriting 1 of / 17 on
    S._, S.RENDER_FILE   = reaper.GetSetProjectInfo_String(0,"RENDER_FILE"        ,0,0); -- render directory
    S._, S.RENDER_NAME   = reaper.GetSetProjectInfo_String(0,"RENDER_PATTERN",""    ,0);-- Render Name
    -------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------
    
    
    
    
    -------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------
    -- / Подготовить рендер / -----------------------------------------------------------------
    
    
    -- / Render Name / -----------------------
    if Render_Name == 1 then;
        local retval, NameFile = reaper.GetUserInputs("Name File",1,"Name File,extrawidth=150","-Stem-");
        if not retval then no_undo() return end;
        reaper.GetSetProjectInfo_String(0,"RENDER_PATTERN",NameFile,true);
    elseif Render_Name == 2 then;
        local NameFile = reaper.CF_GetClipboard(''):sub(0,50);
        if #NameFile:gsub('%s','')==0 then NameFile = '' end;
        reaper.GetSetProjectInfo_String(0,"RENDER_PATTERN",NameFile,true);
    elseif Render_Name ~= 0 then;
        if type(Render_Name)~='string'then Render_Name=''end;
        reaper.GetSetProjectInfo_String(0,"RENDER_PATTERN",Render_Name,true);
    end;
    ------------------------------------------
    
    
    
    
    -- / render directory / ------------------
    if Render_Directory ~= -1 then;
        if type(Render_Directory)~='string' then Render_Directory=''end;
        local projfn = ({reaper.EnumProjects(-1,"")})[2]:match("(.+)[/\\]")or "";
        Render_Directory = (Render_Directory:gsub("^XXRPP",projfn):gsub("\\","/"):gsub("/$",""))or"";
        reaper.GetSetProjectInfo_String(0,"RENDER_FILE",Render_Directory,1);
    end;
    ------------------------------------------
    
    
    
    
    -- / Sourse / ------------------------------------
    reaper.GetSetProjectInfo(0,"RENDER_SETTINGS",3,1);
    --------------------------------------------------
    
    
    
    -- / Bounds / ----------------------------
    local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
    --if OffTimeSelection == true then startLoop = endLoop end;
    if startLoop == endLoop then;
        reaper.GetSetProjectInfo(0,"RENDER_BOUNDSFLAG",1,1);
    else;
        reaper.GetSetProjectInfo(0,"RENDER_BOUNDSFLAG",2,1);
    end;
    ------------------------------------------
    
    
    
    -- / Tail / ------------------------------
    if TailOnOff == 0 then;
        reaper.GetSetProjectInfo(0,"RENDER_TAILFLAG",(S.RENDER_TAILFLAG&~4),1);
    elseif TailOnOff == 1 then;
        reaper.GetSetProjectInfo(0,"RENDER_TAILFLAG",(S.RENDER_TAILFLAG |4),1);
        if not tonumber(TailTime)then TailTime = 0 end;
        local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
        if TailTime < 0 then TailTime = (endLoop-startLoop)*1000 end;
        reaper.GetSetProjectInfo(0,"RENDER_TAILMS",TailTime,1);
    end;
    ------------------------------------------
    
    
    
    -- / Sample rate / -----------------------
    reaper.GetSetProjectInfo(0,"RENDER_SRATE",tonumber(SampleRate) or 0,1);--Sample rate --0 default
    ------------------------------------------
    
    
    -- / channels / --------------------------
    channelsRend = 2;
    reaper.GetSetProjectInfo  (0,"RENDER_CHANNELS",channelsRend or 2,1);-- 1 mono/ 2 stereo 
    ------------------------------------------
    
    
    
    -- / Format | bit / ----------------------
    if not If_Equals_Or(OutputFormat,0,1,2,3,4)then OutputFormat = 0 end;
    local render_format;
    if OutputFormat == 0 then; -- wave
        if not If_Equals_Or(bit,8,16,24,32,64,4,2) then bit = 16 end;
        render_format = string.char(101,118,97,119,bit,0,0);
    elseif OutputFormat == 1 then; -- AIFF
        if not If_Equals_Or(bit,8,16,24,32) then bit = 16 end;
        render_format = string.char(102,102,105,97,bit,0,0);
    elseif OutputFormat == 2 then; -- FLAC
        if not If_Equals_Or(bit,16,17,18,19,20,21,22,23,24) then bit = 24 end;
        render_format = string.char(99,97,108,102,bit,0,0,0,5,0,0,0);
    elseif OutputFormat == 3 then; -- MP3  
        render_format = string.char(108,51,112,109,64,1,0,0,0,0,0,0,10,0,0,0,
                                    255,255,255,255,4,0,0,0,64,1,0,0,0,0,0,0);
    elseif OutputFormat == 4 then; -- WavPack
        if not If_Equals_Or(bit,0,1,2,3,4,5,6,7,8,9,10,11,12,13) then bit = 1 end;
        render_format = string.char(107,112,118,119,0,0,0,0,bit,0,0,0,0,0,0,0,0,0,0,0);
    end;
    render_format = enc(render_format);
    
    reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT",render_format,1);
    ------------------------------------------
    
    
    
    -- / add rendered files to project / -----
    if not If_Equals_Or(AddRendFileInProj,0,1)then AddRendFileInProj = 1 end;
    reaper.GetSetProjectInfo(0,"RENDER_ADDTOPROJ",AddRendFileInProj,1);
    ------------------------------------------
    
    
    -- / speed  '1x Offline' / ---------------
    if not If_Equals_Or(Render_Speed,0,1,2,3,4)then Render_Speed = 0 end;
    reaper.SNM_SetIntConfigVar("projrenderlimit",Render_Speed);
    ------------------------------------------
    
    
    -- / resample / --------------------------
    if not If_Equals_Or(ResampleMode,0,1,2,3,4,5,6,7,8,9)then ResampleMode = 0 end;
    reaper.SNM_SetIntConfigVar("projrenderresample",ResampleMode);
    ------------------------------------------
    
    
    -- / Silently increment filenames to avoid overwriting / --
    reaper.SNM_SetIntConfigVar("renderclosewhendone",17);-- 17 on
    ------------------------------------------
    
    
    local Localize = reaper.JS_Localize("Render to File","common");
    local Window_Find = reaper.JS_Window_Find(Localize,true);
    if Window_Find then;
        reaper.JS_Window_Destroy(Window_Find);
        reaper.Main_OnCommand(40015,0);--Render project to disk... 
    end;
    --ConfigVar В самый конец и перезагрузить окно
    -------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------
    
    
    -------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------
    -- / рендер / -----------------------------------------------------------------------------
    
    Render();
    
    -------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------
    
    
    
    -------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------
    -- / Restore render / ---------------------------------------------------------------------
    reaper.GetSetProjectInfo(0,"RENDER_SETTINGS"      ,S.RENDER_SETTINGS  ,1);
    reaper.GetSetProjectInfo(0,"RENDER_BOUNDSFLAG"    ,S.RENDER_BOUNDSFLAG,1);
    reaper.GetSetProjectInfo(0,"RENDER_TAILFLAG"      ,S.RENDER_TAILFLAG  ,1);
    reaper.GetSetProjectInfo(0,"RENDER_TAILMS"        ,S.RENDER_TAILMS    ,1);
    reaper.GetSetProjectInfo(0,"RENDER_SRATE"         ,S.RENDER_SRATE     ,1);
    reaper.GetSetProjectInfo(0,"RENDER_CHANNELS"      ,S.RENDER_CHANNELS  ,1);
    reaper.GetSetProjectInfo(0,"RENDER_ADDTOPROJ"     ,S.RENDER_ADDTOPROJ ,1);
    ---
    reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT" ,S.RENDER_FORMAT    ,1);
    reaper.GetSetProjectInfo_String(0,"RENDER_FILE"   ,S.RENDER_FILE      ,1);
    reaper.GetSetProjectInfo_String(0,"RENDER_PATTERN",S.RENDER_NAME      ,1);
    ---
    reaper.SNM_SetIntConfigVar("projrenderlimit"      ,S.RENDER_SPEED       );
    reaper.SNM_SetIntConfigVar("projrenderresample"   ,S.RENDER_RESAMPLE    );
    reaper.SNM_SetIntConfigVar("renderclosewhendone"  ,S.SILENTLY_iNCREMENT );
    -------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------
    -------------------------------------------------------------------------------------------
    -----
    local Localize = reaper.JS_Localize("Render to File","common");
    local Window_Find = reaper.JS_Window_Find(Localize,true);
    if Window_Find then;
        reaper.JS_Window_Destroy(Window_Find);
        reaper.Main_OnCommand(40015,0);--Render project to disk...
    end;
    -----
    -------------------------------------------------------------------------------------------
    no_undo();