--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Various
   * Description: Var;  Pre-reverb(`).lua
   * Author:      Archie
   * Version:     1.04
   * Описание:    Предварительная реверберация
   * GIF:         Пошаговое выполнение скрипта (как скрипт делает пре ревер)
   *              http://avatars.mds.yandex.net/get-pdb/2745165/83870370-824b-4932-a4c6-a4aa6fa4fc5e/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Extension:   Reaper 6.01+ http://www.reaper.fm/
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php
   * Changelog:   
   *              v.1.04 [110520]
   *                  + The script was converted to a template
   *                  + ----
   *                  + Скрипт переделан в шаблон
   
   *              v.1.03 [100520]
   *                  + Ability to save the track template in a subdirectory
   *                  + -----
   *                  + Возможность сохранения шаблона трека в подкаталоге
   *              v.1.02 [11.04.20]
   *                  + Possibility of arithmetic operations in the input field
   *                  + Cleaning up intermediate files in a directory
   *                  + Fixed bug when working with multiple items at the same time
   *                  + automatic channel detection
   *                  + -----
   *                  + Возможность арифметических действий в поле ввода
   *                  + Зачистка от промежуточных файлов в директории
   *                  + Исправлена ошибка при работе с несколькими элементами одновременно
   *                  + автоопределение каналов
   *              v.1.0 [11.12.19]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    local Tail_Rever = true;
                 --  = true  | показать окно для ввода времени хвоста
                 --  = false | хвост по размеру выбора времени
                 --  = 1.50..| или введите время в сек
    
    
    -------------------------------------------------------------------
    -- В шаблоне этот параметр не менять  (Archie_Var;  Pre-reverb(`).lua)
    -- Do not change this parameter in the template (Archie_Var;  Pre-reverb(`).lua)
    local NameTemplates = [[$ArchiePreVerb$]];  -- Имя шаблона(Необходимо при дублировании скрипта для другого ревера)
    -------------------------------------------------------------------
    
    
    local PathTemplates = [[]]; -- Путь шаблона, без файла (Необязятельно). Например: PathTemplates = [[c:\bla\bla\bla]];
    
    
    
    local PreFxTrack = false;
                  -- = true  Перед эффектами на треке
                  -- = false После эффектов на треке
    
    
    
    local Channel = 4;
               -- = 1 mono         / Track: Render selected area of tracks to mono post-fader stem tracks (and mute originals)
               -- = 2 stereo       / Track: Render selected area of tracks to stereo post-fader stem tracks (and mute originals)
               -- = 3 multichannel / Track: Render selected area of tracks to multichannel post-fader stem tracks (and mute originals)
               -- = 4 Определи автоматически / Detect it automatically
    
    
    local snapToGrid = true;
                  -- = true  | Ровнять по ближайшей сетке
                  -- = false | Не ровнять по сетке, рендерить четко по времени (Tail_Rever) 
    
    
    local FADEIN  = true;
              --  = true  | on fade in
              --  = false | off fade in
    
    
    local FADEOUT = true;
             --  = true  |  on fade out
             --  = false | off fade out
    
    
    local IN_SHAPE  = 0;  -- 0..6, 0=linear, -1 default
    local OUT_SHAPE = 2;  -- 0..6, 0=linear, -1 default
    
    
    
    local Pre_Vol_Track = true;
                     -- = true  | Перед громкостью на треке
                     -- = false | После громкости на треке
    
    
    local Pre_Pan_Track = true;
                     -- = true  | Перед панорамой на треке
                     -- = false | После панорамой на треке
    
    
    local Remove_Time_Silection = true;
                             -- = true  | Удалить выбор времени
                             -- = false | Не удалять выбор времени
    
    
    local Name_Track = 'Pre Reverb';
                  -- = 'Имя трека'
    
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    local function PreReverbRun();
        
        
        --------------------------------------------------------------
        local function EnumerateAllDirectoriesAndSubdirectories(path);
            local T = {};
            path = path:gsub('\\','/');
            for i = 0,math.huge do;
                local Subdirectories = reaper.EnumerateSubdirectories(path,i);
                if Subdirectories then;
                    T[#T+1] = path..'/'..Subdirectories;
                else;
                    break;
                end;
            end;
            ::REPEAT::;
            local X = #T;
            for i = 1,#T do;
                for i2 = 0,math.huge do;
                    local Subdirectories = reaper.EnumerateSubdirectories(T[i],i2);
                    if Subdirectories then;
                        local SKIP = nil;
                        for i3 = 1,#T do;
                            if T[i3]==T[i]..'/'..Subdirectories then SKIP = true break end;    
                        end;
                        if not SKIP then;
                            T[#T+1] = T[i]..'/'..Subdirectories;
                        end;
                    else;
                        break;
                    end;
                end;
            end;
            if #T ~= X then goto REPEAT end;
            table.insert(T,1,path);
            return T;
        end;
        --------------------------------------------------------------
        
        
        
        
        --==================================================================================================================
        if type(NameTemplates)~="string" or #NameTemplates:gsub("%s","")==0 then NameTemplates = "ArchiePreVerb" end;
        
        local file = io.open(PathTemplates..'/'..NameTemplates..'.RTrackTemplate');
        if not file then;
            local ResPath = reaper.GetExtState('ARCHIE_VAR_PRE-REVERB_LUA','Path - '..NameTemplates);
            file = io.open(ResPath..'/'..NameTemplates..'.RTrackTemplate');
            if not file then;
                ResPath = reaper.GetResourcePath()..'/TrackTemplates';
                file = io.open(ResPath..'/'..NameTemplates..'.RTrackTemplate');
                if not file then;
                    local Subdir = EnumerateAllDirectoriesAndSubdirectories(ResPath);
                    for i = 1,#Subdir do;
                        for i2 = 1,math.huge do;
                            local Files = reaper.EnumerateFiles(Subdir[i],i2-1);
                            if Files then;
                                local FilesX = Files:upper();
                                if FilesX == (NameTemplates..".RTrackTemplate"):upper()then;
                                    file = io.open(Subdir[i]..'/'..Files);
                                    if file then;
                                        reaper.SetExtState('ARCHIE_VAR_PRE-REVERB_LUA','Path - '..NameTemplates,Subdir[i],true);
                                        break;
                                    end;
                                end;
                            else;
                                break;
                            end;
                        end;
                    end;
                end;
            end;
        end;
        ----
        local strTemplate;
        if not file then;
            local MB =
            reaper.MB("Eng:\n\nThe script did not find a track template named '"..NameTemplates.."' \n"..
                      "Save a track template with a customized reverb named '"..NameTemplates.."' - Cancel\nDelete this script - Ok\n\n\n"..
                      "Rus:\n\nСкрипт не нашел шаблон трека с именем '"..NameTemplates.."' \n"..
                      "Сохраните шаблон трека с настроенным ревербератором с именем '"..NameTemplates.."' - отмена\nУдалить данный скрипт - Ok"
                      ,"Woops - (Track Templates)",1);
            --[ v1.04
            if MB==1 then;
                local _,filename,_,_,_,_,_ = reaper.get_action_context();
                os.remove (filename);
                reaper.AddRemoveReaScript(false,0,filename,true);
            end;
            --]]
            no_undo() return;
        else;
            strTemplate = file:read("a");
            file:close();
        end;
        --==================================================================================================================
        
        
        
        --=====================================================
        local CountSelItem = reaper.CountSelectedMediaItems(0);
        if CountSelItem == 0 then;
            reaper.MB("No selected items !\n\nНет выбранных элементов !","Woops",0);
            no_undo()return;
        end;
        --=====================================================
        
        
        
        --=====================================================
        local startLoop, endLoop = reaper.GetSet_LoopTimeRange(0,0,0,0,0);
        if startLoop == endLoop then;
            reaper.MB("No time selection !\n\nНет выбора времени !","Woops",0);
            no_undo() return;
        end;
        --=====================================================
        
        
        
        --=====================================================
        local SelItemT = {};
        local selInTimeSel;
        for i = 1,CountSelItem do;
            local SelItem = reaper.GetSelectedMediaItem(0,i-1);
            local posIt = reaper.GetMediaItemInfo_Value(SelItem,"D_POSITION");
            local lenIt = reaper.GetMediaItemInfo_Value(SelItem,"D_LENGTH");
            if posIt < endLoop and posIt+lenIt > startLoop then;
                selInTimeSel = true;
                SelItemT[#SelItemT+1]=SelItem;
            end;
        end;
        
        if not selInTimeSel then;
            reaper.MB("No items in time selection !\n\nНет элементов в выборе времени !","Woops",0);
            no_undo() return;
        end;
        --=====================================================
        
        
        
        --=====================================================
        if not tonumber(Tail_Rever) and Tail_Rever ~= true then Tail_Rever = false end;
        if Tail_Rever == true then;
            --local val = tonumber(({reaper.GetProjExtState(0,"ArchiePreReverbScRiPt","valueTailSec")})[2])or(endLoop-startLoop);
            local val = tonumber(string.format("%.4f", endLoop-startLoop));--v.1.02
            local retval,retvals_csv = reaper.GetUserInputs("Pre Verb",1,"Value in sec. (0 = time selection),extrawidth=60",val);
            if not retval then no_undo() return end;
            if retvals_csv:match('^[%+%-%*%/]')then;--v.1.02
                retvals_csv = val..retvals_csv--v.1.02
            end;--v.1.02
            retvals_csv = retvals_csv:gsub('[,;]','.');--v.1.02
            local _,retvals_csv = pcall(load('return '..retvals_csv));--v.1.02
            retvals_csv = tonumber(retvals_csv);
            if not retvals_csv or retvals_csv <= 0 then;
                retvals_csv = (endLoop-startLoop);
            end;
            --reaper.SetProjExtState(0,"ArchiePreReverbScRiPt","valueTailSec",retvals_csv);
            Tail_Rever=retvals_csv;
        elseif not Tail_Rever or Tail_Rever <= 0 then;
            Tail_Rever = (endLoop-startLoop);
        end;
        --=====================================================
        
        
        
        --=====================================================
        if startLoop - Tail_Rever < 0 then;
            reaper.MB("The tail does not fit, there is too little space at the beginning !\n\nХвост не помещается, слишком мало место в начале !","Woops !!!",0);
            no_undo() return;
        end;
        --=====================================================
        
        
        
        --=========================
        reaper.Undo_BeginBlock();
        reaper.PreventUIRefresh(1);
        --=========================
        
        
        
        --=====================================================
        local ShowStatusWindow = reaper.SNM_GetIntConfigVar("showpeaksbuild",0);
        if ShowStatusWindow == 1 then;
            reaper.SNM_SetIntConfigVar("showpeaksbuild",0);
        end;
        --=====================================================
        
        
        
        --=====================================================
        ---(v.1.02
        if Channel == 4 then;
            local retChan = -1;
            local ChanSrc; 
            for i = 1, #SelItemT do;
                local take = reaper.GetActiveTake(SelItemT[i]);
                local isMidi = reaper.TakeIsMIDI(take);
                if not isMidi then;
                    local source = reaper.GetMediaItemTake_Source(take);
                    source = reaper.GetMediaSourceParent(source)or source;
                    ChanSrc = reaper.GetMediaSourceNumChannels(source);
                    local chan = reaper.GetMediaItemTakeInfo_Value(take,"I_CHANMODE");
                    if chan == 1 then ChanSrc = 2 end;
                    if chan > 1 and chan < 5 then ChanSrc = 1 end;
                else;
                    ChanSrc = 2;
                end;
                if ChanSrc > retChan then retChan = ChanSrc end;
                if retChan > 2 then break end;
            end;   
            if retChan <= 0 then retChan = 2 end;
            Channel = retChan;
            if Channel < 1 then Channel = 1 end;
            if Channel > 3 then Channel = 3 end;
        end;
        --- v.1.02)
        --=====================================================
        
        
        
        --=====================================================
        reaper.Main_OnCommand(40297,0);-- Unselect all tracks
        
        for i = 1,#SelItemT do;
            local Track = reaper.GetMediaItem_Track(SelItemT[i]);
            reaper.SetMediaTrackInfo_Value(Track,"I_SELECTED",1);
        end;
        --=====================================================
        
        
        
        --=====================================================
        -- / Save Mute Vol Pan Fx tr / -- 
        local CountSelTrack = reaper.CountSelectedTracks(0);
        local STrT = {};
        for i = 1,CountSelTrack do;
            STrT[i] = {};
            STrT[i].SelTrack = reaper.GetSelectedTrack(0,i-1);
            STrT[i].Mute = reaper.GetMediaTrackInfo_Value(STrT[i].SelTrack,"B_MUTE");
            STrT[i].Solo = reaper.GetMediaTrackInfo_Value(STrT[i].SelTrack,"I_SOLO");
            -----
            if Pre_Vol_Track == true then;
                STrT[i].vol = reaper.GetMediaTrackInfo_Value(STrT[i].SelTrack,"D_VOL");
                reaper.SetMediaTrackInfo_Value(STrT[i].SelTrack,"D_VOL",1);
            end;
            if Pre_Pan_Track == true then;
                STrT[i].pan = reaper.GetMediaTrackInfo_Value(STrT[i].SelTrack,"D_PAN"); 
                reaper.SetMediaTrackInfo_Value(STrT[i].SelTrack,"D_PAN",0);
            end;
            -----
            if PreFxTrack == true then;
                local CountFX = reaper.TrackFX_GetCount(STrT[i].SelTrack);
                local Instrument = reaper.TrackFX_GetInstrument(STrT[i].SelTrack);
                STrT[i].FxEnabled = {};
                
                for ifx = 1,CountFX do;
                    STrT[i].FxEnabled[ifx] = reaper.TrackFX_GetEnabled(STrT[i].SelTrack,ifx-1);
                    if ifx-1 ~= Instrument then;
                        reaper.TrackFX_SetEnabled(STrT[i].SelTrack,ifx-1,false);
                    end;
                end;
            end;
        end;
        --=====================================================
        
        
        
        --=====================================================
        if Channel~=1 and Channel~=2 and Channel~=3 then Channel=2 end;
        local ChanT = {41718,41716,41717};
        reaper.Main_OnCommand(ChanT[Channel],0);--render
        reaper.SelectAllMediaItems(0,0);
        --=====================================================
        
        
        
        --=====================================================
        local SelTrack = reaper.GetSelectedTrack(0,0);
        local numb = reaper.GetMediaTrackInfo_Value(SelTrack,"IP_TRACKNUMBER");
        reaper.InsertTrackAtIndex(numb-1,false);
        local TrackPreVerb = reaper.GetTrack(0,numb-1);
        reaper.SetTrackStateChunk(TrackPreVerb,strTemplate,false);
        reaper.SetMediaTrackInfo_Value(TrackPreVerb,"D_VOL",1);
        reaper.SetMediaTrackInfo_Value(TrackPreVerb,"D_PAN",0);
        --=====================================================
        
        
        
        --=====================================================
        local CountTrItems = reaper.CountTrackMediaItems(TrackPreVerb);
        for i = 1,CountTrItems do;
            local item = reaper.GetTrackMediaItem(TrackPreVerb,i-1);
            reaper.DeleteTrackMediaItem(TrackPreVerb,item);
        end; 
        --=====================================================
        
        
        
        --=====================================================
        local CountTrackEnvelopes = reaper.CountTrackEnvelopes(TrackPreVerb);
        for ienv = 1, CountTrackEnvelopes do;
            local TrackEnv = reaper.GetTrackEnvelope(TrackPreVerb,ienv-1);
            local retval,str = reaper.GetEnvelopeStateChunk(TrackEnv,"",false);
            if str:match("ACT%s-(%d+)")~='0'then;
                 str = str:gsub("ACT%s-%d+","ACT 0");
                 reaper.SetEnvelopeStateChunk(TrackEnv,str,false);
             end;
         end;
        --=====================================================
        
        
        
        --=====================================================
        for i = reaper.CountSelectedTracks(0)-1,0,-1 do;
            local SelTrack = reaper.GetSelectedTrack(0,i);
            local CountTrItems = reaper.CountTrackMediaItems(SelTrack);
            for ii = CountTrItems-1,0,-1 do;
                local item = reaper.GetTrackMediaItem(SelTrack,ii);
                reaper.MoveMediaItemToTrack(item,TrackPreVerb);
            end;
        end;
        reaper.Main_OnCommand(40005,0);--Track: Remove tracks
        --=====================================================
        
        
        
        --=====================================================
        reaper.SelectAllMediaItems(0,0);
        local remfileT = {};
        local CountTrItems = reaper.CountTrackMediaItems(TrackPreVerb);
        for i = 1,CountTrItems do;
            local item = reaper.GetTrackMediaItem(TrackPreVerb,i-1);
            reaper.SetMediaItemInfo_Value(item,"B_UISEL",1);
            ---(v.1.02
            local take = reaper.GetActiveTake(item);
            local source = reaper.GetMediaItemTake_Source(take);
            local source = reaper.GetMediaSourceParent(source)or source;
            local filenamebuf = reaper.GetMediaSourceFileName(source,'');
            if type(filenamebuf)=='string'and filenamebuf ~= '' then;
                remfileT[#remfileT+1] = filenamebuf;
            end;
            ---v.1.02)
        end;
        ---(v.1.02
        reaper.Main_OnCommand(40919,0); -- Set item mix behavior to always mix
        ---v.1.02)
        reaper.Main_OnCommand(41051,0); -- Toggle take reverse
        --=====================================================
        
        
        
        --=====================================================
        local Tail;
        if snapToGrid == true then;
            Tail = reaper.SnapToGrid(0,endLoop+Tail_Rever);
            if Tail == endLoop then;
                Tail = endLoop+Tail_Rever;
            end;
        else;
            Tail = endLoop+Tail_Rever;
        end;
        reaper.GetSet_LoopTimeRange(1,0,startLoop,Tail,0);
        --=====================================================
        
        
        
        --=====================================================
        if type(Name_Track)~='string'or #Name_Track:gsub('[%s.,;"]','')==0 then Name_Track='Pre Reverb'end;
        reaper.SetOnlyTrackSelected(TrackPreVerb);
        reaper.GetSetMediaTrackInfo_String(TrackPreVerb,"P_NAME",Name_Track,1);
        reaper.Main_OnCommand(ChanT[Channel],0);--render
        local TrackPreVerbReady = reaper.GetSelectedTrack(0,0);
        reaper.GetSetMediaTrackInfo_String(TrackPreVerbReady,"P_NAME",Name_Track,1);
        
        reaper.SetOnlyTrackSelected(TrackPreVerb);
        reaper.Main_OnCommand(40005,0);--Track: Remove tracks
        reaper.SetOnlyTrackSelected(TrackPreVerbReady);
        
        reaper.GetSet_LoopTimeRange(1,0,startLoop,endLoop,0);
        
        local CountTrItems = reaper.CountTrackMediaItems(TrackPreVerbReady);
        for i = 1,CountTrItems do;
            local item = reaper.GetTrackMediaItem(TrackPreVerbReady,i-1);
            local pos = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
            local len = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
            if pos+len ~= Tail then;
                reaper.SetMediaItemInfo_Value(item,"D_LENGTH",Tail-pos);
                len = Tail-pos;
            end;
            reaper.SetMediaItemInfo_Value(item,"D_POSITION",pos-((pos+len)-endLoop));
            reaper.SetMediaItemInfo_Value(item,"B_UISEL",1);
            ---(v.1.02
            local tk = reaper.GetActiveTake(item);
            reaper.GetSetMediaItemTakeInfo_String(tk,'P_NAME',Name_Track,1); 
            ---v.1.02)
        end;
        reaper.Main_OnCommand(41051,0); -- Toggle take reverse
        --=====================================================
        
        
        
        --=====================================================
        for i = 1,#STrT do;
            reaper.SetMediaTrackInfo_Value(STrT[i].SelTrack,"B_MUTE",STrT[i].Mute);
            reaper.SetMediaTrackInfo_Value(STrT[i].SelTrack,"I_SOLO",STrT[i].Solo);
            
            if Pre_Vol_Track == true then;
                reaper.SetMediaTrackInfo_Value(STrT[i].SelTrack,"D_VOL",STrT[i].vol);
            end;
            if Pre_Pan_Track == true then;
                reaper.SetMediaTrackInfo_Value(STrT[i].SelTrack,"D_PAN",STrT[i].pan);
            end;
            
            if PreFxTrack == true then;
                for ifx = 1, #STrT[i].FxEnabled do;
                    reaper.TrackFX_SetEnabled(STrT[i].SelTrack,ifx-1,STrT[i].FxEnabled[ifx]);
                end;
            end;
        end;
        --=====================================================
        
        
        
        --=====================================================
        -- / fade in out / --
        if FADEIN == true or FADEOUT == true then;
            local CountSelItem = reaper.CountSelectedMediaItems(0);
            for i = 1,CountSelItem do;
                local SelItem = reaper.GetSelectedMediaItem(0,i-1);
                if FADEIN == true then;
                    if tonumber(IN_SHAPE) and IN_SHAPE >= 0 and IN_SHAPE <= 6 then;
                        reaper.SetMediaItemInfo_Value(SelItem,"C_FADEINSHAPE",IN_SHAPE);
                    end;
                    reaper.SetMediaItemInfo_Value(SelItem,"D_FADEINLEN",Tail-endLoop);
                end;
                
                if FADEOUT == true then;
                    if tonumber(OUT_SHAPE)and OUT_SHAPE >= 0 and OUT_SHAPE <= 6 then;
                        reaper.SetMediaItemInfo_Value(SelItem,"C_FADEOUTSHAPE",OUT_SHAPE);
                    end;
                    reaper.SetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN",endLoop-startLoop);
                end;
            end;
        end;
        --=====================================================
        
        
        
        --=====================================================
        if ShowStatusWindow == 1 then;
            reaper.defer(function()reaper.SNM_SetIntConfigVar("showpeaksbuild",1)end);
        end;
        --=====================================================
        
        
        
        --=====================================================
        if Remove_Time_Silection == true then;
            reaper.GetSet_LoopTimeRange(1,0,0,0,0);
        end;
        --=====================================================
        
        
        ---(v.1.02---------------------------
        reaper.defer(function();
                     for i = 1,#remfileT do;
                         os.remove(remfileT[i]);
                     end;end);
        ---v.1.02)---------------------------
        
        
        --=========================
        reaper.Undo_EndBlock("Pre-reverb",-1);
        reaper.PreventUIRefresh(-1);
        reaper.UpdateArrange();
        --=========================
        
    end;
    --RUN = PreReverbRun();
    -----------------------------------------------------------------
    -----------------------------------------------------------------
    -----------------------------------------------------------------
    -----------------------------------------------------------------
    -----------------------------------------------------------------
    -----------------------------------------------------------------
    
    
    
    local function msgGui(msg);
        gfx.init("Help",580,350,0,50,50);
        local function def();
            gfx.x,gfx.y = 10,5;
            gfx.gradrect(0,0,gfx.w,gfx.h,.2,.2,.2,1);
            gfx.setfont(1,"Arial",20,0);
            gfx.drawstr(msg);
            if gfx.getchar()<0 then return end;
            reaper.defer(def);
        end;
        reaper.defer(def);
    end;
    
    
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context();
    local filePath = filename:match('(.+)[/\\].+');
    local file = io.open(filename);
    if not file then return end;
    local strScr = file:read("a");
    file:close();
    
    
    ::rest::;
    local retval,retvals_csv = reaper.GetUserInputs("Archie Pre Verb",1,"Enter Tag (>= 3 symbol),extrawidth=100",'ArchiePreVerb');
    if not retval then no_undo() return end;
    retvals_csv = (retvals_csv:match('%w+')or'');
    if #retvals_csv:gsub('%s','')<3 then goto rest end;
    
    
    local Var;
    local NmeTemp;
    local t = {};
    for S in string.gmatch(strScr..'\n',".-\n") do;
        
        if S:match('%s-local%s+NameTemplates%s-%=%s-%[%[%$.-%$%]%]')and not NmeTemp then;
            Var = S:gsub('NameTemplates%s-%=%s-%[%[%$.-%$%]%]','NameTemplates = [['..retvals_csv..']]');
            if Var ~= S then S = Var Var = true end;
            NmeTemp = true;
        end;
        
        if S:match('%s-%-%-%s-RUN%s-%=%s-PreReverbRun%s-%(.-%)')then;
            S = "    RUN = PreReverbRun();\n\n\n\n\n\n\n\n\n\n";
        end;
        
        table.insert(t,S);
        
        if S:match('%s-RUN%s-%=%s-PreReverbRun%s-%(.-%).-')then;
            break;
        end;
    end;
    
    if Var ~= true then no_undo() return end;
    
    
    local NewScript = filePath..'/Archie_Var;  Pre-reverb('..retvals_csv..').lua';
    file = io.open(NewScript,'w');
    local wrt = file:write(table.concat(t));
    file:close();
    if type(wrt)~='userdata'then no_undo() return end;
    
    reaper.AddRemoveReaScript(true,0,NewScript,true);
    
    local scr = NewScript:match('.+[/\\](.+)');
    
    msgGui(
    'Скрипт успешно создан\nИщите в экшен листе\n'..scr..'\nСохраните трек темплейт с настроенным ревербератором с именем\n'..retvals_csv..'\n\nИмя скрипта скопировано в буфер обмена\n\n\n\n'..
    'Script was successfully created\nSearch in the action list\n'..scr..'\nSave the track template with the reverb set up with the name\n'..retvals_csv..'\n\nScript name is copied to the clipboard');
    reaper.CF_SetClipboard(scr);
    
    
    