--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Render 
   * Description: Render track into one new track (Pre Fx & wave 24 bit & HQ(512pt Sinc) & Full-speed Offline ) 
   * >>>          (COPY) >>> Render stems Template(`) 
   * Author:      Archie 
   * Version:     2.0 
   * Описание:    Шаблон Рендера треков 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Extension:   Reaper 5.984+ http://www.reaper.fm/ 
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php 
   *              reaper_js_ReaScriptAPI Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw 
   * Changelog:    
   *              --- 
    
   *              v.1.12 [090620] 
   *                  + Capture SEND (Render in one track) 
   *              v.1.11 [090620] 
   *                  + fixed bug 
   *              v.1.04 [240320] 
   *                  + Path from the project settings 
   *              v.1.03 [07.02.20] 
   *                  + Fixed bug: No signal when render in single track when route is disabled  
   *              v.1.02 [29.01.20] 
   *                  + Fixed: Path MacOs 
--]] 
    --====================================================================================== 
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\ 
    --======================================================================================     
     
     
     
     
     
    local TailOnOff =  0 
                 -- = -1 настройки из окна рендера (Tail) 
                 -- =  0 отключить хвост (Tail) 
                 -- =  1 включить хвост (Tail) / Необходимо установить TailTime ms 
                 ----------------------------------------------------------------- 
           
     
    local TailTime = 1000 -- ms / Длина хвоста, должен быть включен TailOnOff = 1 
          ----------------------------------------------------------------------- 
           
     
    local Render_Directory = -2 
            -- путь может быть пустым              -|= '' 
            -- или относительным путем             -|= '-stem-' 
            -- или впишите полный путь             -|= 'C:/Users/...' 
            -- Взять путь с окна рендера           -|= -1 
            -- Взять путь из окна настроек проекта -|= -2 
            -- Путь .rpp файла                     -|= "XXRPP" 
            -- Или продолжите путь                 -|= "XXRPP/My Render/MULTI" 
            ------------------------------------------------------ 
           
     
    local Render_Name = '$track-$day$month$year2-$hour-$minute' 
        -- Взять имя с окна рендера      = 0 
        -- Показать окно для ввода имени = 1 
        -- или впишите Имя               = '-stem-'  Имя может содержать спец знаки,  
        --                                           такие как '$track',  
        --                                           смотрите окно рендера - 'Wildcards' 
        -------------------------------------------------------------------------------- 
           
     
    local channelsRend = 2  -- Рендер в =1 моно / =2 стерео /=4/=6/=8 и т.д. 
          ------------------------------------------------------------------ 
           
     
    local monoInMono =  1 
                  -- = -1  'моно в моно, мульти в мульти' Взависимости от галок из окна рендера 
                  -- =  0  'моно в моно, мульти в мульти' Отключить 
                  -- =  1  'моно в моно, мульти в мульти' Включить 
                  ------------------------------------------------ 
           
     
    local RenderViaMaster = 0 
                       -- = 0 Рендер Трек (только трек) 
                       -- = 1 Рендер Трек Через Мастер 
                      -------------------------------- 
                       
    
     local OffTimeSelection = false 
                       -- = true Отключить Выбор времени  
                       --        (рендерить только длину всего проекта) 
                       -- = false Включить Выбор времени  
                       --         (рендерить по выбору времени если установлено,  
                       --          иначе  длину всего проекта) 
                       -- = -1 Рендерить только по выбору времени или показать запрос 
                       -------------------------------------------------------------- 
     
     
     
    local SampleRate  = 0 -- = 0 default-сэмплрейт проекта или установите в виде = 44100 или 48000 и т.д. 
          ---------------------------------------------------------------------------------------------- 
           
           
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
           
           
    local PrePan = false 
              -- = true  Перед панорамой / PrePan 
              -- = false После панорамы  / PostPan 
              ------------------------------------- 
           
           
    local PreFade = false 
               -- = true  Перед фейдером / PreFade 
               -- = false После фейдера / PostFade 
               ----------------------------------- 
     
     
    local PreFx = true 
             -- = true  Перед Эффектами / PreFx 
             -- = false После Эффектов  / PostFx 
             ----------------------------------- 
     
     
    local NewTrack_RendINOne = 0 
                          -- = 0 Рендер выделенный трек в ОДИН новый трек 
                          -- = 1 Рендер каждый выделенный трек в новый Трек 
                          ------------------------------------------------- 
     
     
    local MasterRender = false 
                    -- = true  Если выбран мастер трек, то рендерить только  
                    --         мастер трек, иначе выделенные треки 
                    -- = false рендерить только выделенные треки, 
                    --         не обращая внимания на мастер трек 
                    --------------------------------------------- 
                        
     
     
    local IGNORE_SEND = true 
             -- = true  Если с трека отправлены посылы,то игнорировать их (Рендер в один трек) 
             -- = false Если с трека отправлены посылы,то Захватить их в новый файл (Рендер в один трек) 
             -- = -1    Если с трека отправлены посылы,то Показать запрос о выборе (Рендер в один трек) 
     
     
     
    local RenInOneTrMOVE = 0  
                      -- = 0 Создать трек НАД первым выделенным (Рендер в один трек) 
                      -- = 1 Создать трек ПОД первым выделенным  (Рендер в один трек) 
                      -- = 2 Создать трек в самом верху  (Рендер в один трек) 
                      -- = 3 Создать трек в самом низу  (Рендер в один трек) 
                      ------------------------------------------------------ 
           
           
    local RenTrInTrMOVE = 0  
                     -- = 0 Создать треки НАД выделенными (Рендер трек в трек) 
                     -- = 1 Создать треки ПОД выделенными (Рендер трек в трек) 
                     -- = 2 Создать треки в самом верху   (Рендер трек в трек) 
                     -- = 3 Создать треки в самом низу    (Рендер трек в трек) 
                     --------------------------------------------------------- 
       
       
    local RenMastTrMOVE = 0  
                     -- = 0 Создать трек в самом низу (Рендер Мастер в трек) 
                     -- = 1 Создать трек в самом верху (Рендер Мастер в трек) 
                     -------------------------------------------------------- 
           
           
    local MutePreTrack = true 
                    -- = true  Замьютировать отрендеренные (предыдущие) треки 
                    -- = false Не мьютировать отрендеренные (предыдущие) треки 
                    ---------------------------------------------------------- 
       
       
    local SelPreTrack = false 
                   -- = true  -- Не снимать выделения с предыдущих (отрендеренных) треков 
                   -- = false -- Снять выделения с предыдущих (отрендеренных) треков 
                   ----------------------------------------------------------------- 
       
       
    local SelPostTrack = true 
                    -- = true    Выделить новые треки 
                    -- = false   Не выделять новые треки 
                    ------------------------------------ 
                     
                     
    local RemovePreTrack = false 
                      -- = true   Удалить предыдущие (отрендеренные) треки 
                      -- = false  Не удалять предыдущие (отрендеренные) треки 
                      ------------------------------------------------------- 
                       
                       
    local AddRendFileInProj = 1 
                         -- = 0  Не добавлять отрендеренные файлы в проект  
                         --      (в этом режиме неработают некоторые настройки выше,мьют,удалить и т.д.) 
                         -- = 1  Добавить отрендеренные файлы в проект 
                         --------------------------------------------- 
                    
           
    local TITLE = "Render track into one new track ((Pre Fx & wave 24 bit & HQ(512pt Sinc) & Full-speed Offline )"  
             -- = "Строка истории отмены, если хотите изменить" 
             -------------------------------------------------- 
     
     
     
     
     
    ---- / Secondary output format / --------------------------------- 
    local OutputFormat2 = -1; 
                    -- = -1 Off 
                    -- =  0 Wave 
                    -- =  1 AIFF 
                    -- =  2 FLAC 
                    -- =  3 MP3 
                    -- =  4 WavPack 
                    --------------- 
           
           
    local bit2 = 0; 
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
    ------------------------------------------------------------------  
       
     
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
     
    ------------------------------------------------------- 
    local function no_undo()reaper.defer(function()end)end; 
    ------------------------------------------------------- 
     
     
     
    ---------------------------------------- 
    ---------------------------------------- 
    if OffTimeSelection == -1 then; 
        local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0); 
        if startLoop == endLoop then; 
            local MB = reaper.MB('Rus:\nНет выбора времени\nРендерить длину всего проекта ? - ОК\n\n'.. 
                           'Eng:\nNo time selection\nRender length of entire project ? - OK' 
                           ,'Woops',1); 
            if MB == 1 then; 
                OffTimeSelection = true; 
            else; 
                no_undo()return; 
            end; 
        else; 
            OffTimeSelection = false; 
        end; 
    end; 
    ---------------------------------------- 
    ---------------------------------------- 
     
     
     
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
     
     
    ---------------------------------------- 
    ---------------------------------------- 
    local function RenderSelectedTrackToNewTrack(); 
         
        local CountSelTrack = reaper.CountSelectedTracks(0); 
        if CountSelTrack > 0 then; 
             
            reaper.PreventUIRefresh(1); 
            reaper.Undo_BeginBlock(); 
             
            ---- 
            local SV = {}; 
            for i = 1,CountSelTrack do; 
                SV[i] = {}; 
                SV[i].SelTr = reaper.GetSelectedTrack(0,i-1); 
                 
                if PreFade == true then; 
                    SV[i].VolTr = reaper.GetMediaTrackInfo_Value(SV[i].SelTr,"D_VOL"); 
                    reaper.SetMediaTrackInfo_Value(SV[i].SelTr,"D_VOL",1); 
                end; 
                 
                if PrePan == true then; 
                    SV[i].PanTr = reaper.GetMediaTrackInfo_Value(SV[i].SelTr,"D_PAN"); 
                    reaper.SetMediaTrackInfo_Value(SV[i].SelTr,"D_PAN",0); 
                end; 
                 
                if PreFx == true then; 
                    local CountFX = reaper.TrackFX_GetCount(SV[i].SelTr); 
                    local Instrument = reaper.TrackFX_GetInstrument(SV[i].SelTr); 
                    SV[i].FxEnabled = {}; 
                     
                    for ifx = 1,CountFX do; 
                        SV[i].FxEnabled[ifx] = reaper.TrackFX_GetEnabled(SV[i].SelTr,ifx-1); 
                        if ifx-1 ~= Instrument then; 
                            reaper.TrackFX_SetEnabled(SV[i].SelTr,ifx-1,false); 
                        end; 
                    end; 
                end; 
            end; 
            ---- 
             
            ---- 
            local SelItT = {}; 
            local CountSelItem = reaper.CountSelectedMediaItems(0); 
            local CountItem = reaper.CountMediaItems(0); 
            for i = 1, CountSelItem do; 
                SelItT[i] = reaper.GetSelectedMediaItem(0,i-1); 
            end; 
              
            local CountTrackPreRend = reaper.CountTracks(0); 
            reaper.Main_OnCommand(42230,0);--проект рендер,самые последние настройки 
            local CountTrackPostRend = reaper.CountTracks(0); 
            if CountTrackPreRend ~= CountTrackPostRend then; 
                reaper.Main_OnCommand(40297,0); -- Track: Unselect all tracks 
                if CountItem ~= reaper.CountMediaItems(0) then; 
                    for i = 1,#SelItT do; 
                        reaper.SetMediaItemSelected(SelItT[i],0); 
                    end; 
                end; 
            end; 
            ---- 
             
            ---- 
            local ST = {}; 
            local x; 
            for i = #SV,1,-1 do; 
             
                if PreFade == true then; 
                    reaper.SetMediaTrackInfo_Value(SV[i].SelTr,"D_VOL",SV[i].VolTr); 
                end; 
                 
                if PrePan == true then; 
                    reaper.SetMediaTrackInfo_Value(SV[i].SelTr,"D_PAN",SV[i].PanTr); 
                end; 
                 
                if PreFx == true then; 
                    for ifx = 1,#SV[i].FxEnabled do; 
                        local Enabled = reaper.TrackFX_GetEnabled(SV[i].SelTr,ifx-1); 
                        if Enabled ~= SV[i].FxEnabled[ifx] then; 
                            reaper.TrackFX_SetEnabled(SV[i].SelTr,ifx-1,SV[i].FxEnabled[ifx]); 
                        end; 
                    end; 
                end; 
                 
                
                if(CountTrackPostRend-CountTrackPreRend)==#SV then; 
                    if RenTrInTrMOVE == 0 then Reorder = 0 else Reorder = 2 end; 
                    --переместить-- 
                    x = (x or 1); 
                    local lastTr = reaper.GetTrack(0,CountTrackPostRend-x); 
                    reaper.SetOnlyTrackSelected(lastTr); 
                    --- 
                    if RenderViaMaster == 1 then; 
                        local _,nmTr = reaper.GetSetMediaTrackInfo_String(lastTr,'P_NAME',0,0); 
                        reaper.GetSetMediaTrackInfo_String(lastTr,'P_NAME','Mast - '..nmTr,1); 
                    end; 
                    --- 
                    if RenTrInTrMOVE == 0 then; 
                        local numb = reaper.GetMediaTrackInfo_Value(SV[i].SelTr,"IP_TRACKNUMBER"); 
                        reaper.ReorderSelectedTracks(numb-1,Reorder); 
                    elseif RenTrInTrMOVE == 1 then; 
                        local numb = reaper.GetMediaTrackInfo_Value(SV[i].SelTr,"IP_TRACKNUMBER"); 
                        reaper.ReorderSelectedTracks(numb,Reorder); 
                    elseif RenTrInTrMOVE == 2 then; 
                        reaper.ReorderSelectedTracks(0,Reorder); 
                    elseif not If_Equals_Or(RenTrInTrMOVE,0,1,2) then; 
                        x = (x+1); 
                    end; 
                    --иначе самый низ-- 
                    table.insert(ST,lastTr); 
                end; 
                 
                if CountTrackPreRend ~= CountTrackPostRend then; 
                    if MutePreTrack == true then; 
                        reaper.SetMediaTrackInfo_Value(SV[i].SelTr,"B_MUTE",1); 
                    end; 
                end; 
            end; 
            ---- 
             
            reaper.Main_OnCommand(40297,0); -- Track: Unselect all tracks 
             
            if SelPreTrack == true or CountTrackPreRend == CountTrackPostRend then; 
                for i = 1, #SV do; 
                    reaper.SetMediaTrackInfo_Value(SV[i].SelTr,"I_SELECTED",1); 
                end; 
            end; 
             
            --- 
            if RemovePreTrack == true then; 
                if(CountTrackPostRend-CountTrackPreRend)==#SV then; 
                    if SelPreTrack ~= true then; 
                        for i = 1, #SV do; 
                            reaper.SetMediaTrackInfo_Value(SV[i].SelTr,"I_SELECTED",1); 
                        end; 
                    end; 
                    reaper.Main_OnCommand(40005,0);--Track: Remove tracks 
                end; 
            end; 
            --- 
             
            if SelPostTrack == true then; 
                for i = 1,#ST do; 
                    reaper.SetMediaTrackInfo_Value(ST[i],"I_SELECTED",1); 
                end; 
            end; 
             
            if TITLE and #TITLE:gsub("%s*","") == 0 then TITLE = nil end; 
            reaper.Undo_EndBlock(TITLE or "Render Selected Track To New Track",-1); 
            reaper.PreventUIRefresh(-1); 
        end; 
    end; 
    ---------------------------------------- 
    ---------------------------------------- 
     
     
    ---------------------------------------- 
    ---------------------------------------- 
    local function RenderSelectedTrackOneNewTrack(); 
        local nameTrck; 
        local CountSelTrack = reaper.CountSelectedTracks(0); 
        if CountSelTrack > 0 then; 
            ---- 
            reaper.PreventUIRefresh(1); 
            reaper.Undo_BeginBlock(); 
                 
             
            --------------- 
            local SOLO; 
            for i = 1, CountSelTrack do; 
                local trackSel = reaper.GetSelectedTrack(0,i-1); 
                local solo = reaper.GetMediaTrackInfo_Value(trackSel,"I_SOLO"); 
                if solo > 0 then; 
                    SOLO = true; 
                end; 
                if IGNORE_SEND ~= true and not SEND then; 
                    local NumSends = reaper.GetTrackNumSends(trackSel,0); 
                    if NumSends > 0 then; 
                        SEND = true; 
                    end; 
                elseif IGNORE_SEND == true and SOLO == true then; 
                    break; 
                end; 
                if SOLO==true and SEND==true then break end; 
            end; 
            ---- 
            if IGNORE_SEND == -1 and SEND == true then; 
                local MB = reaper.MB('Rus:\nС выделенных треков существуют посылы, Захватить их в новый файл ? - ОК\n\n'.. 
                                     'Eng:\nSelected tracks have send. Capture them in a new file? - OK','SEND >>>',1); 
                if MB ~= 1 then; SEND = false; end; 
            end; 
            --------------- 
             
             
            local NoSelT = {}; 
            local SelT   = {}; 
             
            local CountTrack = reaper.CountTracks(0); 
            for i = 1, CountTrack do; 
                 
                local Track = reaper.GetTrack(0,i-1); 
                local sel = reaper.GetMediaTrackInfo_Value(Track,"I_SELECTED"); 
                if sel == 0 then; 
                    NoSelT[#NoSelT+1] = {}; 
                    NoSelT[#NoSelT].Track = Track; 
                    NoSelT[#NoSelT].solo = reaper.GetMediaTrackInfo_Value(Track,"I_SOLO"); 
                    if NoSelT[#NoSelT].solo ~= 0 then; 
                        reaper.SetMediaTrackInfo_Value(Track,"I_SOLO",0); 
                    end; 
                else; 
                    --- 
                    if not nameTrck then; 
                        nameTrck = ({reaper.GetSetMediaTrackInfo_String(Track,'P_NAME',0,0)})[2]; 
                        if nameTrck == "" then nameTrck = nil end; 
                    end; 
                    --- 
                    SelT[#SelT+1] = {}; 
                    SelT[#SelT].Track = Track; 
                    SelT[#SelT].solo = reaper.GetMediaTrackInfo_Value(Track,"I_SOLO"); 
                    local mute = reaper.GetMediaTrackInfo_Value(Track,"B_MUTE"); 
                     
                     
                    if SEND == true then; 
                        if mute == 0 and not SOLO and SelT[#SelT].solo ~= 2 then; 
                            reaper.SetMediaTrackInfo_Value(Track,"I_SOLO",2); 
                        elseif SelT[#SelT].solo > 0 and SelT[#SelT].solo ~= 2 then; 
                            reaper.SetMediaTrackInfo_Value(Track,"I_SOLO",2); 
                        end; 
                    else; 
                        if mute == 0 and not SOLO and SelT[#SelT].solo ~= 1 then; 
                            reaper.SetMediaTrackInfo_Value(Track,"I_SOLO",1); 
                        elseif SelT[#SelT].solo > 0 and SelT[#SelT].solo ~= 1 then; 
                            reaper.SetMediaTrackInfo_Value(Track,"I_SOLO",1); 
                        end; 
                    end; 
                     
                     
                    local SOLO = reaper.GetMediaTrackInfo_Value(Track,"I_SOLO"); 
                    if SOLO ~= 0 then SelT[1].RSOLO = true end; 
                    --- 
                    if PreFade == true then; 
                        SelT[#SelT].VolTr = reaper.GetMediaTrackInfo_Value(Track,"D_VOL"); 
                        reaper.SetMediaTrackInfo_Value(Track,"D_VOL",1); 
                    end; 
                    if PrePan == true then; 
                        SelT[#SelT].PanTr = reaper.GetMediaTrackInfo_Value(Track,"D_PAN"); 
                        reaper.SetMediaTrackInfo_Value(Track,"D_PAN",0); 
                    end; 
                    if PreFx == true then; 
                        local CountFX = reaper.TrackFX_GetCount(Track); 
                        local Instrument = reaper.TrackFX_GetInstrument(Track); 
                        SelT[#SelT].FxEnabled = {}; 
                         
                        for ifx = 1,CountFX do; 
                            SelT[#SelT].FxEnabled[ifx] = reaper.TrackFX_GetEnabled(Track,ifx-1); 
                            if ifx-1 ~= Instrument then; 
                                reaper.TrackFX_SetEnabled(Track,ifx-1,false); 
                            end; 
                        end; 
                    end; 
                end; 
            end; 
             
             
             
             
             
            if type(SelT[1])~= 'table' then SelT[1] = {} end; 
            if SelT[1].RSOLO ~= true then SelT[1].RSOLO = false end; 
             
             
            local SelItT = {}; 
            local CountSelItem = reaper.CountSelectedMediaItems(0); 
            local CountItem = reaper.CountMediaItems(0); 
            for i = 1, CountSelItem do; 
                SelItT[i] = reaper.GetSelectedMediaItem(0,i-1); 
            end; 
             
             
            local CountTrackPreRend = reaper.CountTracks(0); 
            reaper.InsertTrackAtIndex(0,false); 
            local Track = reaper.GetTrack(0,0); 
            --- 
            reaper.GetSetMediaTrackInfo_String(Track,'P_NAME',nameTrck or '',1); 
            --- 
            -- 
            if SelT[1].RSOLO ~= true then; 
                reaper.SetMediaTrackInfo_Value(Track,"B_MUTE",1); 
            end; 
            -- 
            reaper.SetMediaTrackInfo_Value(Track,"D_VOL",1); 
            reaper.SetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH",1); 
            --- 
            --- 
            for iSnd = 1,reaper.CountSelectedTracks(0) do; 
                local TrSnd = reaper.GetSelectedTrack(0,iSnd-1); 
                local mastSnd = reaper.GetMediaTrackInfo_Value(TrSnd,'B_MAINSEND'); 
                if mastSnd == 0 then; 
                    reaper.SetMediaTrackInfo_Value(TrSnd,'B_MAINSEND',1); 
                end; 
            end 
            --- 
            --- 
            reaper.SetOnlyTrackSelected(Track); 
            local LPreTrack = reaper.GetTrack(0,reaper.CountTracks(0)-1); 
            reaper.Main_OnCommand(42230,0);--проект рендер,самые последние настройки 
            local LPostTrack = reaper.GetTrack(0,reaper.CountTracks(0)-1); 
            reaper.SetMediaTrackInfo_Value(Track,"I_FOLDERDEPTH",0); 
            reaper.DeleteTrack(Track); 
            local CountTrackPostRend = reaper.CountTracks(0); 
            --переместить-- 
            if LPreTrack ~= LPostTrack then; 
                if RenInOneTrMOVE == 0 then Reorder = 0 else Reorder = 2 end; 
                reaper.SetOnlyTrackSelected(LPostTrack); 
                if not SelT[1].Track then SelT[1].Track = LPostTrack end;  
                --- 
                if RenderViaMaster == 1 then; 
                 local _,nmTr = reaper.GetSetMediaTrackInfo_String(LPostTrack,'P_NAME',0,0); 
                 reaper.GetSetMediaTrackInfo_String(LPostTrack,'P_NAME','Mast - '..nmTr,1); 
                end; 
                --- 
                if RenInOneTrMOVE == 0 then; 
                    local numb = reaper.GetMediaTrackInfo_Value(SelT[1].Track,"IP_TRACKNUMBER"); 
                    reaper.ReorderSelectedTracks(numb-1,Reorder); 
                elseif RenInOneTrMOVE == 1 then; 
                    local numb = reaper.GetMediaTrackInfo_Value(SelT[1].Track,"IP_TRACKNUMBER"); 
                    reaper.ReorderSelectedTracks(numb,Reorder); 
                elseif RenInOneTrMOVE == 2 then; 
                    reaper.ReorderSelectedTracks(0,Reorder); 
                end; 
                --иначе самый низ-- 
            end; 
            --------------- 
            if CountTrackPostRend == CountTrackPreRend then; 
                for i = 1, #SelT do; 
                    if i == 1 then; 
                        reaper.SetOnlyTrackSelected(SelT[i].Track); 
                    else; 
                        reaper.SetMediaTrackInfo_Value(SelT[i].Track,"I_SELECTED",1); 
                    end; 
                end; 
            else; 
                if CountItem ~= reaper.CountMediaItems(0) then; 
                    for i = 1,#SelItT do; 
                        reaper.SetMediaItemSelected(SelItT[i],0); 
                    end; 
                end; 
            end; 
             
             
            for i = 1, #NoSelT do; 
                reaper.SetMediaTrackInfo_Value(NoSelT[i].Track,"I_SOLO",NoSelT[i].solo); 
            end; 
             
            reaper.Main_OnCommand(40297,0); -- Track: Unselect all tracks 
             
            for i = 1, #SelT do; 
                reaper.SetMediaTrackInfo_Value(SelT[i].Track,"I_SOLO",SelT[i].solo); 
                 
                if PreFade == true then; 
                    reaper.SetMediaTrackInfo_Value(SelT[i].Track,"D_VOL",SelT[i].VolTr); 
                end; 
                 
                if PrePan == true then; 
                    reaper.SetMediaTrackInfo_Value(SelT[i].Track,"D_PAN",SelT[i].PanTr); 
                end; 
                 
                if PreFx == true then; 
                    for ifx = 1,#SelT[i].FxEnabled do; 
                        local Enabled = reaper.TrackFX_GetEnabled(SelT[i].Track,ifx-1); 
                        if Enabled ~= SelT[i].FxEnabled[ifx] then; 
                            reaper.TrackFX_SetEnabled(SelT[i].Track,ifx-1,SelT[i].FxEnabled[ifx]); 
                        end; 
                    end; 
                end; 
                --- 
                if CountTrackPostRend ~= CountTrackPreRend then; 
                    if MutePreTrack == true then; 
                        reaper.SetMediaTrackInfo_Value(SelT[i].Track,"B_MUTE",1); 
                    end;                     
                end; 
            end; 
             
             
            --- 
            if SelPreTrack == true or CountTrackPostRend == CountTrackPreRend then; 
                for i = 1, #SelT do; 
                    reaper.SetMediaTrackInfo_Value(SelT[i].Track,"I_SELECTED",1); 
                end; 
            end; 
             
            if RemovePreTrack == true then; 
                if CountTrackPostRend ~= CountTrackPreRend then; 
                    if SelPreTrack ~= true then; 
                        for i = 1, #SelT do; 
                            reaper.SetMediaTrackInfo_Value(SelT[i].Track,"I_SELECTED",1); 
                        end; 
                    end; 
                    reaper.Main_OnCommand(40005,0);--Track: Remove tracks 
                end; 
            end; 
            --- 
             
            if SelPostTrack == true then; 
                if CountTrackPostRend ~= CountTrackPreRend and LPostTrack then; 
                    reaper.SetMediaTrackInfo_Value(LPostTrack,"I_SELECTED",1); 
                end;   
            end; 
            ---  
             
            if TITLE and #TITLE:gsub("%s*","") == 0 then TITLE = nil end; 
            reaper.Undo_EndBlock(TITLE or "Render Selected Track Into One New Track",-1); 
            reaper.PreventUIRefresh(-1); 
        end; 
    end; 
    ---------------------------------------- 
    ---------------------------------------- 
     
     
    ---------------------------------------- 
    ---------------------------------------- 
    local function Render_Master_Tr(); 
        reaper.PreventUIRefresh(1); 
        reaper.Undo_BeginBlock(); 
         
        local LastPostTrack; 
        local SelTr = {}; 
        local CountSelTrack = reaper.CountSelectedTracks(0); 
        for i = 1, CountSelTrack do; 
            SelTr[i] = reaper.GetSelectedTrack(0,i-1); 
        end; 
             
        local CountTrackPreRend = reaper.CountTracks(0); 
        reaper.Main_OnCommand(42230,0);--проект рендер,самые последние настройки 
        local CountTrackPostRend = reaper.CountTracks(0); 
         
        if CountTrackPostRend ~= CountTrackPreRend then; 
            LastPostTrack = reaper.GetTrack(0,reaper.CountTracks(0)-1); 
         
            reaper.Main_OnCommand(40297,0); -- Track: Unselect all tracks 
             
            if LastPostTrack then; 
                reaper.SetOnlyTrackSelected(LastPostTrack); 
                if RenMastTrMOVE == 1 then;   
                    reaper.ReorderSelectedTracks(0,2); 
                end; 
                 
                if SelPostTrack ~= true then; 
                    reaper.SetMediaTrackInfo_Value(LastPostTrack,"I_SELECTED",0); 
                end;  
            end; 
        end; 
         
        if SelPreTrack == true then; 
            for i = 1, #SelTr do; 
                reaper.SetMediaTrackInfo_Value(SelTr[i],"I_SELECTED",1); 
            end; 
            local MasterTrack = reaper.GetMasterTrack(0); 
            reaper.SetMediaTrackInfo_Value(MasterTrack,"I_SELECTED",1); 
        end; 
     
        if TITLE and #TITLE:gsub("%s*","") == 0 then TITLE = nil end; 
        reaper.Undo_EndBlock(TITLE or "Render Master Track",-1); 
        reaper.PreventUIRefresh(-1); 
    end; 
    ---------------------------------------- 
    ---------------------------------------- 
     
     
    ---------------------------------------- 
    ---------------------------------------- 
     
     
    ------------------------------------------------------------------------------------------- 
    -------------------------------------------------------------------------------------------     
    if not reaper.JS_Window_Find then; 
        reaper.MB("Extension not installed - reaper_js_ReaScriptAPI!","Render Error",0); 
        no_undo() return; 
    end; 
     
     
    local RENDER_MASTER; 
    if MasterRender == true then; 
        local MasterTrack = reaper.GetMasterTrack(0); 
        local selMaster = reaper.GetMediaTrackInfo_Value(MasterTrack,"I_SELECTED"); 
        if selMaster == 1 then RENDER_MASTER = true end; 
    end; 
     
     
    if RENDER_MASTER ~= true then; 
        local CountSelTrack = reaper.CountSelectedTracks(0); 
        if CountSelTrack == 0 then reaper.MB("No Track Selected!","Render Error",0)no_undo() return end; 
    end; 
    ------------------------------------------------------------------------------------------- 
    ------------------------------------------------------------------------------------------- 
     
     
     
    ------------------------------------------------------------------------------------------- 
    ------------------------------------------------------------------------------------------- 
    -- / Save render / ------------------------------------------------------------------------ 
    local S = {}; 
    S.RENDER_SETTINGS      = reaper.GetSetProjectInfo       (0,"RENDER_SETTINGS"    ,0,0);--Sourse 
    S.RENDER_BOUNDSFLAG    = reaper.GetSetProjectInfo       (0,"RENDER_BOUNDSFLAG"  ,0,0);--Bounds 
    S.RENDER_TAILFLAG      = reaper.GetSetProjectInfo       (0,"RENDER_TAILFLAG"    ,0,0);--Tail 
    S.RENDER_TAILMS        = reaper.GetSetProjectInfo       (0,"RENDER_TAILMS"      ,0,0);--Tail ms 
    S.RENDER_SRATE         = reaper.GetSetProjectInfo       (0,"RENDER_SRATE"       ,0,0);--Sample rate 
    S.RENDER_CHANNELS      = reaper.GetSetProjectInfo       (0,"RENDER_CHANNELS"    ,0,0);--channels 
    S.RENDER_SPEED         = reaper.SNM_GetIntConfigVar     (  "projrenderlimit"      ,0);--speed 
    S.RENDER_RESAMPLE      = reaper.SNM_GetIntConfigVar     (  "projrenderresample"   ,0);--resample 
    S._, S.RENDER_FORMAT   = reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT"      ,0,0);--render_format 
    S._2, S.RENDER_FORMAT2 = reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT2"     ,0,0);--render_format2 
    S.RENDER_ADDTOPROJ     = reaper.GetSetProjectInfo       (0,"RENDER_ADDTOPROJ"   ,0,0);--add rendered files to project 
    S.SILENTLY_iNCREMENT   = reaper.SNM_GetIntConfigVar     (  "renderclosewhendone"  ,0);--Silently increment filenames to avoid overwriting 1 of / 17 on 
    S._, S.RENDER_FILE     = reaper.GetSetProjectInfo_String(0,"RENDER_FILE"        ,0,0); -- render directory 
    S._, S.RENDER_NAME     = reaper.GetSetProjectInfo_String(0,"RENDER_PATTERN",""    ,0);-- Render Name 
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
        if Render_Directory == -2 then; 
            Render_Directory = reaper.GetProjectPath(''); 
        end; 
         
        if type(Render_Directory)~='string' then Render_Directory=''end; 
        local projfn = ({reaper.EnumProjects(-1,"")})[2]:match("(.+)[/\\]")or ""; 
        Render_Directory = (Render_Directory:gsub("^XXRPP",projfn):gsub("\\","/"):gsub("/$",""))or"";  
        reaper.GetSetProjectInfo_String(0,"RENDER_FILE",Render_Directory,1); 
    end; 
    ------------------------------------------ 
     
     
    -- / Sourse / --------------------------- 
    local Srs; 
    if RenderViaMaster == 1 then Srs = 128 else Srs = 3 end; 
    if RENDER_MASTER == true then Srs = 0 end; 
    if not If_Equals_Or(monoInMono,-1,0,1)then monoInMono = -1 end; 
    --- 
    if monoInMono == -1 then; 
        local Sourse = (((S.RENDER_SETTINGS&4)+(S.RENDER_SETTINGS&16))+Srs); 
        reaper.GetSetProjectInfo(0,"RENDER_SETTINGS",Sourse,1); 
    elseif monoInMono == 0 then; 
        reaper.GetSetProjectInfo(0,"RENDER_SETTINGS",Srs,1); 
    elseif monoInMono == 1 then; 
        reaper.GetSetProjectInfo(0,"RENDER_SETTINGS",20 + Srs,1); 
    end; 
    ------------------------------------------ 
     
     
    -- / Bounds / ---------------------------- 
    local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0); 
    if OffTimeSelection == true then startLoop = endLoop end; 
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
        if TailTime < 0 then TailTime = (endLoop-startLoop)*1000 end; 
        reaper.GetSetProjectInfo(0,"RENDER_TAILMS",TailTime,1); 
    end; 
    ------------------------------------------ 
    
     
    -- / Sample rate / ----------------------- 
    reaper.GetSetProjectInfo(0,"RENDER_SRATE",tonumber(SampleRate) or 0,1);--Sample rate --0 default 
    ------------------------------------------ 
     
     
    -- / channels / -------------------------- 
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
     
     
     
    -- / Format_2 | bit / -- /Experimental/--- 
    if not If_Equals_Or(OutputFormat2,0,1,2,3,4)then OutputFormat2 = -1 end; 
    if OutputFormat2 == -1 then; 
        reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT2",'',1); 
    else; 
         
        local render_format; 
        if OutputFormat2 == 0 then; -- wave 
            if not If_Equals_Or(bit2,8,16,24,32,64,4,2) then bit2 = 16 end; 
            render_format = string.char(101,118,97,119,bit2,0,0); 
        elseif OutputFormat2 == 1 then; -- AIFF 
            if not If_Equals_Or(bit2,8,16,24,32) then bit2 = 16 end; 
            render_format = string.char(102,102,105,97,bit2,0,0); 
        elseif OutputFormat2 == 2 then; -- FLAC 
            if not If_Equals_Or(bit2,16,17,18,19,20,21,22,23,24) then bit2 = 24 end; 
            render_format = string.char(99,97,108,102,bit2,0,0,0,5,0,0,0); 
        elseif OutputFormat2 == 3 then; -- MP3   
            render_format = string.char(108,51,112,109,64,1,0,0,0,0,0,0,10,0,0,0, 
                                        255,255,255,255,4,0,0,0,64,1,0,0,0,0,0,0); 
        elseif OutputFormat2 == 4 then; -- WavPack 
            if not If_Equals_Or(bit2,0,1,2,3,4,5,6,7,8,9,10,11,12,13) then bit2 = 1 end; 
            render_format = string.char(107,112,118,119,0,0,0,0,bit2,0,0,0,0,0,0,0,0,0,0,0); 
        end; 
        render_format = enc(render_format); 
         
        reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT2",render_format,1); 
    end; 
    ------------------------------------------ 
     
     
     
     
     
    -- / add rendered files to project / ----- 
    if not If_Equals_Or(AddRendFileInProj,0,1)then AddRendFileInProj = 1 end; 
    reaper.GetSetProjectInfo(0,"RENDER_ADDTOPROJ",AddRendFileInProj,1); 
    ------------------------------------------ 
     
     
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
    ---- 
    --if AddRendFileInProj == 0 and RENDER_MASTER ~= true then NewTrack_RendINOne = 1 end;-- (-v.1.04) 
     
    if RENDER_MASTER == true then; 
        Render_Master_Tr(); 
    else; 
        ---- 
        if NewTrack_RendINOne == 0 then; 
            RenderSelectedTrackOneNewTrack(); -- трек в один трек 
        elseif NewTrack_RendINOne == 1 then; 
            RenderSelectedTrackToNewTrack(); --трек в трек 
        end; 
        ---- 
    end; 
    ---- 
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
    reaper.GetSetProjectInfo_String(0,"RENDER_FORMAT2",S.RENDER_FORMAT2   ,1); 
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