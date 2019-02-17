--[[
   * Category:    Function
   * Description: Arc_Function_lua
   * Author:      Archie
   * Version:     2.2.6
   * AboutScript: Functions for use with some scripts Archie
   * О скрипте:   Функции для использования с некоторыми скриптами Archie
   * Provides:    [nomain].
   * ----------------------
   
   * Changelog:   
   *              + no_undo();
   *              + Action();
   *              + SaveSoloMuteSelStateAllTracksGuidSlot(Slot);
   *              + RestoreSoloMuteSelStateAllTracksGuidSlot(Slot,clean);--clean = true или 1 - чтобы зачистить
   *              + js_API = js_ReaScriptAPI(); -- true / false
   *              + SWS = SWS_API(); -- true / false
   *              + If_Equals(EqualsToThat,...);
   *              + SetCollapseFolderMCP(track,clickable,is_show);
   *              + Path,Name = GetPathAndNameSourceMediaFile_Take(take);
   *              + ValueFromMaxRepsIn_Table(array, min_max); 
   *              + randomOfVal(...);
   *              + SetToggleButtonOnOff(numb); 0 or 1
   *              + _ = HelpWindow_WithOptionNotToShow(Text,Header,but,reset);
   *              + HelpWindowWhenReRunning(BottonText,but,reset);
   *              + DeleteMediaItem(item);
   *              + GetSampleNumberPosValue(take,SkipNumberOfSamplesPerChannel,FeelVolumeOfItem);
   *              + SetMediaItemLeftTrim2(position,item);
   *              + Save_Selected_Items_GuidSlot(Slot);
   *              + Restore_Selected_Items_GuidSlot(Slot,clean);--clean = true или 1 - чтобы зачистить
   *              + SaveSoloMuteStateAllTracksGuidSlot(Slot);
   *              + RestoreSoloMuteStateAllTracksGuidSlot(Slot,clean);--clean = true или 1 - чтобы зачистить
   *              + SaveMuteStateAllItemsGuidSlot(Slot);
   *              + RestoreMuteStateAllItemsGuidSlot(Slot,clean);--clean = true или 1 - чтобы зачистить
   *              + PosFirstIt,EndLastIt = GetPositionOfFirstItemAndEndOfLast();
   *              + PosFirstIt,EndLastIt = GetPositionOfFirstSelectedItemAndEndOfLast();
   *              + RemoveStretchMarkersSavingTreatedWave_Render(Take);
   *              + SaveSelTracksGuidSlot(Slot);
   *              + RestoreSelTracksGuidSlot(Slot,clean);
   *              + GetPreventSpectralPeaksInTrack(Track);
   *              + SetPreventSpectralPeaksInTrack(Track,Perf);--[=[Perf = true;false]=]
   *              + CloseAllFxInAllItemsAndAllTake(chain,float);--true;false;
   *              + SetShow_HideTrackMCP(Track,show_hide--[=[0;1]=]);
   *              + CloseAllFxInAllTracks(chain, float);--true,false
   *              + CloseToolbarByNumber(ToolbarNumber--[=[1-16]=]);--некорректно работает с top
   *              + GetMediaItemInfo_Value(item,parmname);/[D_END] 
   *              + Get_Format_ProjectGrid(divisionIn);
   *              + invert_number(X);
   *              + CountTrackSelectedMediaItems(track);
   *              + GetTrackSelectedMediaItems(track,idx);
--=======================================================]]




    --========================
    local Arc_Module = {};--==
    local VersionMod = "2.2.6"
    --========================



    --################################ http://НЕ_ЗАБУДЬ_ОБНОВИТЬ #############################################################
    --########################################################################################################################
    ------------- http://НЕ_ЗАБУДЬ_ОБНОВИТЬ ---------------------------------------------                                --###
    -------НЕ ЗАБУДЬ ОБНОВИТЬ--------НЕ ЗАБУДЬ ОБНОВИТЬ--------НЕ ЗАБУДЬ ОБНОВИТЬ--------                                --###
    function Arc_Module.VersionArc_Function_lua(version,ScriptPath,ScriptName);                                          --###
        local ver_fun = VersionMod  --<<<--НЕ ЗАБУДЬ ОБНОВИТЬ <<< "VersionMod" <<<                                       --###
        local v = ver_fun:gsub("%D", "");                                                                                --###
        if v < version:gsub("%D", "") then;                                                                              --###
            reaper.ClearConsole();                                                                                       --###
            reaper.ShowConsoleMsg('Eng:\n'..                                                                             --###
            --[[----------------]]'   The file "Arc_Function_lua" is not relevant, Obsolete.\n'..                        --###
            --[[----------------]]'   Download the Arc_Function_lua file at this URL.\n'..                               --###
            --[[----------------]]'   https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/'..            --###
            --[[----------------]]'ArchieScript/Archie_ReaScripts/blob/master/Functions/Arc_Function_lua.lua\n'..        --###
            --[[----------------]]'   And put it along the way\n'..'   '..ScriptPath..'/'..ScriptName..'\n'..            --###
            --[[----------------]]'   --------------------------------------------------------------------------------'..--###
            --[[----------------]]'-----------------------------------------------------------------------------------'..--###
            --[[----------------]]'--------------------------------------------------------------------------\nRus:\n'.. --###
            --[[----------------]]'   Файл "Arc_Function_lua" не актуален,Устарел.\n'..                                  --###
            --[[----------------]]'   Скачайте файл "Arc_Function_lua" по этому URL\n'..                                 --###
            --[[----------------]]'   https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/'..            --###
            --[[----------------]]'ArchieScript/Archie_ReaScripts/blob/master/Functions/Arc_Function_lua.lua\n'..        --###
            --[[----------------]]'   И положите его по пути\n'..'   '..ScriptPath..'/'..ScriptName);return false        --###
        end return true -----------------------------------------------------------------------------                    --###
    end    ---Сообщить об устаревшей версии----------------------------------------------------                          --###
    --====End===============End===============End===============End===============End====                                --###
    --########################################################################################################################
    --########################################################################################################################




    --=================================================================================================
    --                                                                                               --
    --          #########  ##     ##  ## ####      #####     ##       ##    #####    # #####    ##   --
    --         #########  ##     ##  ########    #######    ##       ##   ##   ##   ########   ##    --
    --        ##         ##     ##  ##     ##  ##     ##   ##           ##     ##  ##     ##  ##     --
    --       ##         ##     ##  ##     ##  ##         #####     ##  ##     ##  ##     ##  ##      --
    --      #########  ##     ##  ##     ##  ##          ##       ##  ##     ##  ##     ##  ##       --
    --     #########  ##     ##  ##     ##  ##     ##   ##   ##  ##  ##     ##  ##     ##            --
    --    ##          #######   ##     ##   #######     #####   ##   ##   ##   ##     ##  ##         --
    --   ##           #####    ##     ##    #####       ###    ##    #####    ##     ##  ##          --
    --                                                                                               --
    --=================================================================================================





    --|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||
    --------------no_undo()--------------------------------------------------------------
    --no_undo()
    function Arc_Module.No_Undo()end; 
    function Arc_Module.no_undo()--<<<
        reaper.defer(Arc_Module.No_Undo);
    end;
    --Что бы в ундо не прописывалось "ReaScript:Run"
    --====End===============End===============End===============End===============End====



    -------------Action------------------------------------------------------------------
    function Arc_Module.Action(...);
       local Table = {...};
       for i = 1, #Table do;
         reaper.Main_OnCommand(reaper.NamedCommandLookup(Table[i]),0);
       end;
    end;
    -- Выполняет действие, относящееся к разделу основное действие. 
    --====End===============End===============End===============End===============End====
    --|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||






    --226-----SaveSoloMuteSelStateAllTracksGuidSlot()------------------------------------
    -------------------------------RestoreSoloMuteSelStateAllTracksGuidSlot()------------
    function Arc_Module.SaveSoloMuteSelStateAllTracksGuidSlot(Slot);
        local CountTracks = reaper.CountTracks(0);
        if CountTracks == 0 then return false end;
        local t = {};_G['SavSolMutSelTrSlot_'..Slot] = t;
        for i = 1, CountTracks do;
            local track = reaper.GetTrack(0, i - 1);
            t[i] = reaper.GetTrackGUID(track)..'{'..
            reaper.GetMediaTrackInfo_Value(track,'B_MUTE')..'}{'..
            reaper.GetMediaTrackInfo_Value(track,'I_SOLO')..'}{'..
            reaper.GetMediaTrackInfo_Value(track,'I_SELECTED')..'}';
        end;
        return true;
    end;
    -------------------------------------------------------------------------
    function Arc_Module.RestoreSoloMuteSelStateAllTracksGuidSlot(Slot,clean);
        local t = _G['SavSolMutSelTrSlot_'..Slot];
        if t then;
            for i = 1, #t do;
                local guin,mute,solo,sel = string.match (t[i],'({.+}){(.+)}{(.+)}{(.+)}');
                local track = reaper.BR_GetMediaTrackByGUID(0,guin);
                reaper.SetMediaTrackInfo_Value(track, 'B_MUTE'    , mute);
                reaper.SetMediaTrackInfo_Value(track, 'I_SOLO'    , solo);
                reaper.SetMediaTrackInfo_Value(track, 'I_SELECTED', sel );
            end;
            if clean == 1 or clean == true then;
                _G['SavSolMutSelTrSlot_'..Slot] = nil;
                t = nil;
            end;
        end;    
    end;
    -- Save Restore Solo Mute Sel State All Tracks, Slots
    -- Сохранить Восстановить 'Выделения, Соло, Mute' Состояние Всех Дорожек, Слоты
    -- clean = true или 1 - зачистить сохраненную информацию за собой
    --====End===============End===============End===============End===============End==== 






    --225---------- js_ReaScriptAPI(); --------------------------------------------------
    function Arc_Module.js_ReaScriptAPI(boolean);
        if not reaper.JS_Mouse_GetState then;
            if boolean == true then;
                local MB = reaper.MB(
                "ENG:\n"..
                "* There is no file reaper_js_ReaScriptAPI...!\n"..
                "* Script requires an extension 'reaper_js_ReaScriptAPI'.\n"..
                "* Install repository 'ReaTeam Extensions'.\n\n".. 
                "    Go to website ReaPack - OK. \n\n"..
                "RUS:\n"..
                "* Отсутствует файл reaper_js_ReaScriptAPI...!\n"..
                "* Для работы скрипта требуется расширение 'reaper_js_ReaScriptAPI'.\n"..
                "* Установите репозиторий 'ReaTeam Extensions'\n\n"..
                "    Перейти на сайт ReaPack - OK. \n"
                ,"Error.",1);
                if MB == 1 then;
                    local OS = reaper.GetOS();
                    if OS == "OSX32" or OS == "OSX64" then;
                        os.execute("open https://reapack.com/repos");
                    else
                        os.execute("start https://reapack.com/repos");
                    end;
                end;
            end;
            local function Undo()end;reaper.defer(Undo);
            return false;
        end;
        return true;
    end;
    -- Проверяет, Установлено ли расширение 'reaper_js_ReaScriptAPI. 
    -- Если установлено вернет true, в противном случае false и предупреждения.
    -- boolean true - показать окно с предупреждением,
    -- boolean false - не показать окно с предупреждением.
    --====End===============End===============End===============End===============End====
    --|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||






    --225--------- SWS_API(); -----------------------------------------------------------
    function Arc_Module.SWS_API(boolean);
        if not reaper.BR_GetMediaItemGUID then;
            if boolean == true then;
                local MB = reaper.MB(
                "ENG:\n"..
                "    Missing extension 'SWS'!\n"..
                "    Script requires an extension SWS.\n"..
                "    Install extension 'SWS'. \n\n"..
                "    Go to website SWS - OK   \n\n"..
                "RUS:\n"..
                "    Отсутствует расширение 'SWS'!\n"..
                "    Для работы сценария требуется расширение 'SWS'\n"..
                "    Установите расширение 'SWS'. \n\n"..
                "    Перейти на сайт SWS - OK \n"
               ,"Error.",1);
               if MB == 1 then;
                   local OS = reaper.GetOS();
                   if OS == "OSX32" or OS == "OSX64" then;
                       os.execute("open ".."http://www.sws-extension.org/index.php");
                   else
                       os.execute("start ".."http://www.sws-extension.org/index.php");
                   end;
               end;
           end;
           local function Undo()end;reaper.defer(Undo);
           return false;
        end;
        return true;
    end;
    -- Проверяет, Установлено ли расширение 'SWS'. 
    -- Если установлено вернет true, в противном случае false и предупреждения.
    -- boolean true - показать окно с предупреждением,
    -- boolean false - не показать окно с предупреждением.
    --====End===============End===============End===============End===============End====
    --|||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||||






    ---218----------- If_Equals(EqualsToThat,...);---------------------------------------
    function Arc_Module.If_Equals(EqualsToThat,...);
        for _,v in ipairs {...} do;
            if v == EqualsToThat then return true end;
        end;
        return false;
    end;
    -- сократить условие
    --====End===============End===============End===============End===============End====






    --219---------- SetCollapseFolderMCP(track,clickable,is_show); ----------------------
    function Arc_Module.SetCollapseFolderMCP(track,clickable,is_show);
        if clickable == 0 or clickable == 1 then;
            if clickable == 0 then clickable = 1 else clickable = 0 end;
            if reaper.GetToggleCommandState(41154)== clickable then reaper.Main_OnCommand(41154,-1)end;
        end;
        local _,tr_chunk = reaper.GetTrackStateChunk(track,'',true);
        local BUSCOMP_var1 = tr_chunk:match('BUSCOMP (%d+)');
        if is_show ~= 1 then is_show = 0 end;
        local tr_chunk_out = tr_chunk:gsub('BUSCOMP '..BUSCOMP_var1..' %d+', 'BUSCOMP '..BUSCOMP_var1..' '..is_show);
        reaper.SetTrackStateChunk(track, tr_chunk_out,true);
    end;
    -- Collapsed / Uncollapsed Track MCP
    -- Свернуть / Развернуть Трек в Mикшере
    -- clickable = 0 кликабельный значок для папок скрыть:
    -- clickable = 1 кликабельный значок для папок показать:  иначе = -1;
    -- is_show = 1 - скрыть; is_show = 0 показать:
    --====End===============End===============End===============End===============End==== 






    --216---------- GetPathAndNameSourceMediaFile_Take(take); ---------------------------
    function Arc_Module.GetPathAndNameSourceMediaFile_Take(take);
        local guidStringTAKE = reaper.BR_GetMediaItemTakeGUID(take);
        local item = reaper.GetMediaItemTake_Item(take);
        local retval, str = reaper.GetItemStateChunk(item,"",false);
        local T = {};
        for ChunkTake in string.gmatch(str, '.->') do;
            T[#T+1] = ChunkTake;
        end;
        for i = 1, #T do;
            for guid,pach in string.gmatch(T[i],'[^IGUID]GUID ({.-}).-FILE (".-")') do;
                if guid == guidStringTAKE and pach then;
                    local Path,Name = string.match (pach, "(.+)[\\/](.+)");
                    Path =string.gsub(Path,'"',"");
                    Name =string.gsub(Name,'"',"");
                    return Path,Name;
                end;
                guid,pach = nil,nil;
            end;
        end;
        return false,false;
    end;
    -- ПОЛУЧИТЬ ПУТЬ И ИМЯ ИСХОДНОГО МЕДИАФАЙЛА ФАЙЛА У ТЕЙКА
    -- В отличии от "reaper.GetMediaSourceFileName(source,filenamebuf)" 
    --                     не ломается на реверсных файлах и видит .png
    -- Если тейк содержит миди, то вернет false
    -- GET THE PATH AND NAME OF THE SOURCE MEDIA FILE FROM THE TAKE
    -- Path,Name = Arc.GetPathAndNameSourceMediaFile_Take(take);
    --====End===============End===============End===============End===============End====






    --215---------- ValueFromMaxRepsIn_Table(array, min_max);  --------------------------
    function Arc_Module.ValueFromMaxRepsIn_Table(array, min_max); 
        if not min_max then min_max = "MAX" end;
        -- создаем статистику
        local t = {};
        for i = 1, #array do;
            local ti = array[i];
            if not t[ti] then t[ti] = 0 end;
            t[ti] = t[ti] + 1;
        end;
        -- находим к-во максимальных вхождений
        local max = 0;
        local value;
        for key, val in pairs(t) do;
            if val > 1 then;
                if val > max then;
                    value = key;
                    max = val;
                elseif val == max then;
                    if val > 1 then;
                        if min_max == "MAX" then;
                            value = math.max(key ,value);
                        elseif min_max == "MIN" then;
                            value = math.min(key ,value);
                        elseif min_max == "RANDOM" then;
                            local rand_T = {key,value};
                            local random = math.random(#rand_T); 
                            value = rand_T[random];
                        end;
                    end;   
                end;
            else;
                if not value then
                value = false
                end
            end;
        end;
        return(value);
    end;
    -- Вернет значение из максимальных повторений в таблице.
    -- array = таблица
    -- min_max = "MIN" , "MAX" , "RANDOM"
    -- пример:
    -- t1{1,2,3,4,5,6,7}; вернет false - повторений нет
    -- t2{1,2,3,3,4,5,6}; вернет 3; min_max необязателен
    -- t3{1,1,2,2,3,4,5}; вернет 1; если min_max = "MIN", 2 если min_max = "MAX",случайное число 1 или 2 если min_max = "RANDOM"
    -- t4{1,1,2,2,5,5,5}; вернет 5; min_max необязателен
    -- t5{1,2,5,5,1,1,5}; вернет 1 или 5 взависимости от min_max (читать t3)
    --====End===============End===============End===============End===============End====





    ------------------------ randomOfVal(...) -------------------------------------------
    function Arc_Module.randomOfVal(...)
        local t = {...};
        local random = math.random(#t); 
        return t[random]
    end
    -- Вернет случайное из значений
    -- пример: Val = randomOfVal("one","two",1,2)
    -- Вывод: "one" или "two" или 1 или 2
    --====End===============End===============End===============End===============End====





    -------------SetToggleButtonOnOff(numb)----------------------------------------------
    function Arc_Module.SetToggleButtonOnOff(numb);
        local _,_,sec,cmd,_,_,_ = reaper.get_action_context();
        reaper.SetToggleCommandState(sec,cmd,numb or 0);
        reaper.RefreshToolbar2(sec, cmd);
    end;
    -- УСТАНОВИТЬ ПЕРЕКЛЮЧАТЕЛЬ ВКЛ ВЫКЛ (ПОДСВЕТКА КНОПКИ)
    -- Set Toggle Button On Off
    --====End===============End===============End===============End===============End====





    --220------- HelpWindow_WithOptionNotToShow(Text,Header,but,reset); -----------------
    function Arc_Module.HelpWindow_WithOptionNotToShow(Text,Header,but,reset);
        local ScriptName,MessageBox = select(2,select(2,reaper.get_action_context()):match("(.+)[\\/](.+)"));
        local TooltipWind = reaper.GetExtState(ScriptName.."Archie_HelpWindowWithDoNotShowOption"..but, ScriptName.."Archie_HelpWindow"..but);
        if TooltipWind == "" then;
            MessageBox = reaper.ShowMessageBox(Text.."\n"..
            "--------------------------------------------------------------------------------------------\n\n"..
            "НЕ ПОКАЗЫВАТЬ ПОЛЬШЕ ЭТО ОКНО  -  ОК\n"..
            "DO NOT SHOW THIS WINDOW - OK",Header,1);
            if MessageBox == 1 then;
                reaper.SetExtState(ScriptName.."Archie_HelpWindowWithDoNotShowOption"..but,ScriptName.."Archie_HelpWindow"..but,MessageBox,true);
            end;
        end;
        if reset == true then;
            reaper.DeleteExtState(ScriptName.."Archie_HelpWindowWithDoNotShowOption"..but, ScriptName.."Archie_HelpWindow"..but,true);
        end;
        if MessageBox == 2 then MessageBox = 0 end;
        return MessageBox or -1;
    end;
    -- ОКНО СПРАВКИ С ОПЦИЕЙ НЕ ПОКАЗЫВАТЬ;
    -- HELP WINDOW WITH OPTION NOT TO SHOW;
    --  but = хоть что strung;
    --  reset = true только для сброса, а так всегда false;
    -- returns: ok 1; cancel 0; otherwise -1
    --====End===============End===============End===============End===============End====





    --------------- HelpWindowWhenReRunning(BottonText,but,reset); --------------------------
    function Arc_Module.HelpWindowWhenReRunning(BottonText,but,reset);-- (BottonText = 1 или 2)
        local ScriptName = select(2,select(2,reaper.get_action_context()):match("(.+)[\\/](.+)"));
        local TooltipWind = reaper.GetExtState(ScriptName.."ArchieAllScriptdefer2Off工具提示窗口"..but, ScriptName.."ArchieAllScriptdefer2Off工具提示窗口"..but);
        if TooltipWind == "" then;
            ----------------------
            if BottonText  == 2 then;
                BottonText = "'NEW INSTANCE'" elseif BottonText  == 1 then;
                BottonText = "'TERMINATE INSTANCES'"else BottonText = "- ??? Error"; 
            end;
            ------------------------------------------------------------------------
            local MessageBox = reaper.ShowMessageBox(
            "Rus.\n"..
            "* Важно:\n"..
            "*   При отключении скрипта появится окно (Reascript task control):\n"..
            "*   Для коректной работы скрипта ставим галку\n"..
            "*   (Remember my answer for this script)\n"..
            "*   Нажимаем: "..BottonText.."\n"..
            "--------------------------------------------------------------------------------------------\n"..
            "Eng.\n"..
            "* Importantly:\n"..
            "*   When you disable script window will appear (Reascript task control):\n"..
            "*   For correct work of the script put the check\n"..
            "*   (Remember my answer for this script)\n"..
            "*   Click: "..BottonText.."\n"..
            "--------------------------------------------------------------------------------------------\n\n"..
            "DO NOT SHOW THIS WINDOW - OK\n"..
            "НЕ ПОКАЗЫВАТЬ ПОЛЬШЕ ЭТО ОКНО  -  ОК",
            "help.",1);
            ---------------------------------------
            if MessageBox == 1 then;
                reaper.SetExtState(ScriptName.."ArchieAllScriptdefer2Off工具提示窗口"..but, ScriptName.."ArchieAllScriptdefer2Off工具提示窗口"..but,MessageBox,true);
            end;
        end;
        if reset == true then;
            reaper.DeleteExtState(ScriptName.."ArchieAllScriptdefer2Off工具提示窗口"..but, ScriptName.."ArchieAllScriptdefer2Off工具提示窗口"..but,true);
        end;
        return ScriptName;
    end;
    -- ОКНО СПРАВКИ ПРИ ПОВТОРНОМ ЗАПУСКЕ СКРИПТА
    -- Help Window When Re Running Script 
    --====End===============End===============End===============End===============End====





    ------------ DeleteMediaItem(item); -------------------------------------------------
    function Arc_Module.DeleteMediaItem(item);
        if item then;
            local tr = reaper.GetMediaItem_Track(item);
            reaper.DeleteTrackMediaItem(tr,item);
        end;
    end;
    -- УДАЛИТЬ ЭЛЕМЕНТ МУЛЬТИМЕДИА
    -- Delete Media Item
    --====End===============End===============End===============End===============End====





    -------- GetSampleNumberPosValue(take,SkipNumberOfSamplesPerChannel,true,true,true); ---------
    function Arc_Module.GetSampleNumberPosValue(take,SkipNumberOfSamplesPerChannel,FeelVolumeOfItem,FeelVolumeOfTake,FeelVolumeOfEnvelopeItem);

        if not take or reaper.TakeIsMIDI(take)then return false,false,false,false,false,false,false end;
        ------------------------------------------------------------------------------------------  
        if not tonumber(SkipNumberOfSamplesPerChannel) then SkipNumberOfSamplesPerChannel = 0 end;
        SkipNumberOfSamplesPerChannel = math.floor(SkipNumberOfSamplesPerChannel+0.5);
        ------------------------------------------------
        local item = reaper.GetMediaItemTake_Item(take);
        -- Reset Play Rate -------------------------------------------------------------
        local PlayRate_Original =  reaper.GetMediaItemTakeInfo_Value(take,"D_PLAYRATE");
        local Item_len_Original = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
        reaper.SetMediaItemInfo_Value(item,"D_LENGTH",Item_len_Original * PlayRate_Original);
        reaper.SetMediaItemTakeInfo_Value(take,"D_PLAYRATE",1);
        -------------------------------------------------------
        local item_pos = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
        local item_len = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
        local accessor = reaper.CreateTakeAudioAccessor(take);
        local source = reaper.GetMediaItemTake_Source(take);
        local samplerate = reaper.GetMediaSourceSampleRate(source);
        local numchannels = reaper.GetMediaSourceNumChannels(source);
        local item_len_idx = math.ceil(item_len);
        -----------------------------------------
        local CountSamples_OneChannel  = math.floor(item_len*samplerate+2);
        local CountSamples_AllChannels = math.floor(item_len*samplerate+2)*numchannels;
        -------------------------------------------------------------------------------
        local NumberSamplesOneChan  = {};
        local NumberSamplesAllChan  = {};
        local Sample_min            = {};
        local Sample_max            = {};
        local TimeSample            = {};
        ---------------------------------
        local breakX,multi;
        -------------------
        for i1 = 1, item_len_idx do
            local buffer = reaper.new_array(samplerate*numchannels); -- 1 sec
            local Accessor_Samples = reaper.GetAudioAccessorSamples(
                                                        accessor   , -- accessor
                                                        samplerate , -- samplerate
                                                        numchannels, -- numchannels
                                                        i1-1       , -- starttime_sec
                                                        samplerate , -- numsamplesperchannel
                                                        buffer     ) -- reaper.array samplebuffer
            -------------------------------------------------------------------------------------
            local ContinueCounting = (i1-1) * samplerate; -- Продолжить Подсчет
            -------------------------------------------------------------------
            for i2 = 1, samplerate*numchannels,numchannels*(SkipNumberOfSamplesPerChannel+1) do;

                --- / Sample Point Number / --------------------------------
                local SamplePointNumb = (i2-1)/numchannels+ContinueCounting;
                ------------------------------------------------------------

                -- / min max sample from all channels /------------
                local Sample_min_all_channels = 9^99;
                local Sample_max_all_channels = 0;
                for i3 = 1, numchannels do;
                    local Sample = math.abs(buffer[i2+(i3-1)]);
                    Sample_min_all_channels = math.min(Sample,Sample_min_all_channels);
                    Sample_max_all_channels = math.max(Sample,Sample_max_all_channels);
                end;

                ---/ Feel volume of take - Чувствительность к громкости тейка /---
                if FeelVolumeOfTake == true then;
                    Sample_min_all_channels = Sample_min_all_channels*reaper.GetMediaItemTakeInfo_Value(take, "D_VOL");
                    Sample_max_all_channels = Sample_max_all_channels*reaper.GetMediaItemTakeInfo_Value(take, "D_VOL");
                end;

                ---/ Feel volume of item - Чувствительность к громкости элемента /---
                if FeelVolumeOfItem == true then;
                    Sample_min_all_channels = Sample_min_all_channels*reaper.GetMediaItemInfo_Value(item, "D_VOL");
                    Sample_max_all_channels = Sample_max_all_channels*reaper.GetMediaItemInfo_Value(item, "D_VOL");
                end;

                --- / Feel Volume Of Envelope Item /------------
                if FeelVolumeOfEnvelopeItem == true then;
                    local Envelope = reaper.GetTakeEnvelopeByName(take,"Volume");
                    if Envelope then;
                       local retval,value,_,_,_ = reaper.Envelope_Evaluate(Envelope,SamplePointNumb/samplerate,samplerate,0);
                       if retval > 0 then;
                           Sample_min_all_channels = Sample_min_all_channels * value;
                           Sample_max_all_channels = Sample_max_all_channels * value;
                       end;
                    end;
                end; 

                -- / min max sample from all channels /------------
                Sample_min[#Sample_min+1] = Sample_min_all_channels;
                Sample_max[#Sample_max+1] = Sample_max_all_channels;
                ----------------------------------------------------

                --- Sample Number - One / All Channels ---------------------------------
                NumberSamplesAllChan[#NumberSamplesAllChan+1] = (i2 + ContinueCounting);
                if numchannels > 2 then multi = 1 else multi = 0 end;
                NumberSamplesOneChan[#NumberSamplesOneChan+1] = math.floor(((i2 + ContinueCounting)/numchannels)+0.5)+multi;
                ------------------------------------------------------------------------------------------------------------

                --- GetTime ------------------------------------------------------------------------
                TimeSample[#TimeSample+1] = SamplePointNumb/samplerate/PlayRate_Original + item_pos;
                                
                --- End Of Element, To Complete Cycle ---------------------------------------------
               if TimeSample[#TimeSample] > Item_len_Original + item_pos then breakX = 1 break end;
               ------------------------------------------------------------------------------------
            end;
            buffer.clear();
            if breakX == 1 then break end;
        end
        reaper.DestroyAudioAccessor(accessor);
        ---
        -- Restore Play Rate -------------------------------------------------------
        reaper.SetMediaItemInfo_Value(item,"D_LENGTH",item_len / PlayRate_Original);
        reaper.SetMediaItemTakeInfo_Value(take,"D_PLAYRATE",PlayRate_Original);
        -----------------------------------------------------------------------
        TimeSample[1] = item_pos; 
        TimeSample[#TimeSample] = item_pos + Item_len_Original;
        -----------------------------------------------------------------------------
        return CountSamples_AllChannels,CountSamples_OneChannel,NumberSamplesAllChan,
               NumberSamplesOneChan,Sample_min,Sample_max,TimeSample;----------------
    end;----------------------------------------
    -- Get Sample Number Position Value
    -- ПОЛУЧИТЬ У ОБРАЗЦА НОМЕР ЗНАЧЕНИЕ ПОЗИЦИЮ.
    -- samples_skip = сколько сэмплов пропустить в секунду (обычно
    --       плэйрейт делим на сто - получится 100 точек в секунду) 
    -- FeelVolumeOfItem = false - не реагировать на громкость элемента 
    -- FeelVolumeOfItem = true - реагировать на громкость элемента
    -- FeelVolumeOfTake = false - не реагировать на громкость тейка
    -- FeelVolumeOfTake = true - реагировать на громкость тейка
    -- FeelVolumeOfEnvelopeItem = false - не реагировать на автоматизацию громкости элемента 
    -- FeelVolumeOfEnvelopeItem = true - реагировать на автоматизацию громкости элемента 
    --====End===============End===============End===============End===============End====





    ------------SetMediaItemLeftTrim2----------------------------------------------------
    function Arc_Module.SetMediaItemLeftTrim2(position,item)
        reaper.PreventUIRefresh(3864598);
        local sel_item = {};
        for i = 1, reaper.CountSelectedMediaItems(0) do;
            sel_item[i] = reaper.GetSelectedMediaItem(0,i-1);
        end;
        reaper.SelectAllMediaItems(0,0);
        reaper.SetMediaItemSelected(item,1);
        reaper.ApplyNudge(0,1,1,0,position,0,0);
        reaper.SetMediaItemSelected(item,0);
        for _, item in ipairs(sel_item) do;
            reaper.SetMediaItemSelected(item,1);
        end;
        reaper.PreventUIRefresh(-3864598);
    end -- Удлинить укоротить Медиа Элемент Слева
    --====End===============End===============End===============End===============End====





    -----------Save_Selected_Items_Slot()------------------------------------------------
    -------------------------------------Restore_Selected_Items_Slot()-------------------
    function Arc_Module.Save_Selected_Items_GuidSlot(Slot);
        local CountSelItem = reaper.CountSelectedMediaItems(0);
        if CountSelItem == 0 then return false end;
        local t = {};
        _G["SaveSelItem_"..Slot] = t;
        for i = 1, CountSelItem do;
            local sel_item = reaper.GetSelectedMediaItem(0,i-1);
            t[i] = reaper.BR_GetMediaItemGUID(sel_item);
        end;
        return true;
    end;
    ------------------------------------------------------
    function Arc_Module.Restore_Selected_Items_GuidSlot(Slot,clean);
        t = _G["SaveSelItem_"..Slot];
        if t then;
            reaper.SelectAllMediaItems(0,0);
            for i = 1, #t do;
                local item = reaper.BR_GetMediaItemByGUID(0,t[i]);
                if item then;
                    reaper.SetMediaItemSelected(item,1);
                end;
            end;
            if clean == true or clean == 1 then;
                _G["SaveSelItem_"..Slot] = nil;
                t = nil;
            end;
            reaper.UpdateArrange();
        end;
    end;
    --====End===============End===============End===============End===============End====





    -------SaveSoloMuteStateAllTracksSlot()----------------------------------------------
    --------------------------------------RestoreSoloMuteStateAllTracksSlot()------------
    function Arc_Module.SaveSoloMuteStateAllTracksGuidSlot(Slot);
        local CountTracks = reaper.CountTracks(0);
        if CountTracks == 0 then return false end;
        local t = {};_G['SavSolMutTrSlot_'..Slot] = t;
        for i = 1, CountTracks do;
            local track = reaper.GetTrack(0, i - 1);
            t[i] = reaper.GetTrackGUID(track)..'{'..
            reaper.GetMediaTrackInfo_Value(track,'B_MUTE')..'}{'..
            reaper.GetMediaTrackInfo_Value(track,'I_SOLO')..'}';
        end;
        return true;
    end;
    -----------------------------------------------------------------
    function Arc_Module.RestoreSoloMuteStateAllTracksGuidSlot(Slot,clean);
        local t = _G['SavSolMutTrSlot_'..Slot];
        if t then;
            for i = 1, #t do;
                local guin,mute,solo = string.match (t[i],'({.+}){(.+)}{(.+)}');
                local track = reaper.BR_GetMediaTrackByGUID(0,guin);
                reaper.SetMediaTrackInfo_Value(track, 'B_MUTE', mute);
                reaper.SetMediaTrackInfo_Value(track, 'I_SOLO', solo);
            end;
            if clean == 1 or clean == true then;
                _G['SavSolMutTrSlot_'..Slot] = nil;
                t = nil;
            end;
        end;    
    end;
    -- Save Restore Solo Mute State All Tracks, Slots
    -- Сохранить Восстановить Соло Mute Состояние Всех Дорожек, Слоты
    -- clean = true или 1 - зачистить сохраненную информацию за собой
    --====End===============End===============End===============End===============End==== 





    --------------SaveMuteStateAllItemsSlot----------------------------------------------
    -----------------------------------------RestoreMuteStateAllItemsSlot----------------
    function Arc_Module.SaveMuteStateAllItemsGuidSlot(Slot);
        local CountItem = reaper.CountMediaItems(0);
        if CountItem == 0 then return false end;
        local GuidAndMute = {};
        _G["Save_GuidAndMuteSlot_"..Slot] = GuidAndMute;
        for i = 1, CountItem do;
            local Item = reaper.GetMediaItem(0,i-1);
            GuidAndMute[i] = reaper.BR_GetMediaItemGUID(Item)..' '..
                             reaper.GetMediaItemInfo_Value(Item,"B_MUTE");
        end ;
        return true;
    end;
    -- Save Mute State All Items, Slots
    -- Сохранить Состояние Отключения Звука На Всех Элементах Слоты
    -------------------------------------------------------------------------
    function Arc_Module.RestoreMuteStateAllItemsGuidSlot(Slot, clean);
        local T = _G["Save_GuidAndMuteSlot_"..Slot];
        if T then;
            for i = 1, #T do;
                local Item = reaper.BR_GetMediaItemByGUID(0,T[i]:match("{.+}"));
                if Item then;
                    reaper.SetMediaItemInfo_Value(Item,"B_MUTE",T[i]:gsub("{.+}",""));
                end;
            end;
            if clean == true or clean == 1 then;
                T = nil;
                _G["Save_GuidAndMuteSlot_"..Slot] = nil;
            end;
            reaper.UpdateArrange();
        end
    end
    -- Restore Mute State All Items, Slots
    -- Восстановить Беззвучное Состояние Всех Элементов, Слотов
    -- clean = true или 1 - зачистить сохраненную информацию за собой
    --====End===============End===============End===============End===============End====





    ----------------GetPositionOfFirstItemAndEndOfLast-----------------------------------
    function Arc_Module.GetPositionOfFirstItemAndEndOfLast();
        local CountItem = reaper.CountMediaItems(0);
        if CountItem == 0 then return false, false end;
        local Fir = 99^99;
        local End = 0;
        for i = 1, CountItem do;
            local It = reaper.GetMediaItem(0,i-1);
            local Posit = reaper.GetMediaItemInfo_Value(It,"D_POSITION");
            local Lengt = reaper.GetMediaItemInfo_Value(It,"D_LENGTH");
            if Posit < Fir then;
                Fir = Posit;
            end;
            if Posit + Lengt > End then;
                End = Posit + Lengt;
            end;
        end;
        return Fir,End;
    end;
    -- Get Position Of First Item And End Of Last
    -- Получить Позицию Первого Элемента И Конец Последнего     
    -- PosFirstIt,EndLastIt = GetPositionOfFirstItemAndEndOfLast()
    --====End===============End===============End===============End===============End====





    ----------------GetPositionOfFirstSelectedItemAndEndOfLast---------------------------
    function Arc_Module.GetPositionOfFirstSelectedItemAndEndOfLast();
        local CountSelItem = reaper.CountSelectedMediaItems(0);
        if CountSelItem == 0 then return false, false end;
        local Fir = 99^99;
        local End = 0;
        for i = 1, CountSelItem do;
            local SelIt = reaper.GetSelectedMediaItem(0,i-1);
            local Posit = reaper.GetMediaItemInfo_Value(SelIt,"D_POSITION");
            local Lengt = reaper.GetMediaItemInfo_Value(SelIt,"D_LENGTH");
            if Posit < Fir then;
                Fir = Posit;
            end;
            if Posit + Lengt > End then;
                End = Posit + Lengt;
            end;
        end;
        return Fir,End;
    end;
    -- Get Position Of First Selected Item And End Of Last
    -- Получить Позицию Первого Выделенного Элемента И Конец Последнего     
    -- PosFirstIt,EndLastIt = GetPositionOfFirstSelectedItemAndEndOfLast()
    --====End===============End===============End===============End===============End====





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
        local CountSelTrack = reaper.CountSelectedTracks(0);
        if CountSelTrack == 0 then return false end;
        local t = {};
        _G['SaveSelTr_'..Slot] = t;
        for i = 1, reaper.CountSelectedTracks(0) do;
            local sel_tracks = reaper.GetSelectedTrack(0,i-1);
            t[i] = reaper.GetTrackGUID(sel_tracks);
        end;
        return true;
    end;
    ---------------------------------------------------------
    function Arc_Module.RestoreSelTracksGuidSlot(Slot,clean);
       local tr = reaper.GetTrack(0,0);
       reaper.SetOnlyTrackSelected(tr);
       reaper.SetTrackSelected(tr, 0);
       ---
       local t = _G['SaveSelTr_'..Slot];
       if t then;
           for i = 1, #t do;
               local track = reaper.BR_GetMediaTrackByGUID(0,t[i]);
               if track then;
                   reaper.SetTrackSelected(track,1);
               end;
           end;
           if clean == 1 or clean == true then;
               _G['SaveSelTr_'..Slot] = nil;
               t = nil;
           end;
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



   
    --217---------GetMediaItemInfo_Value-------------------------------------------------
    function Arc_Module.GetMediaItemInfo_Value(item, parmname);
        if parmname == "END" or parmname == "D_END" then return
            reaper.GetMediaItemInfo_Value(item,"D_POSITION")+
            reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
        else;
            return reaper.GetMediaItemInfo_Value(item,parmname);
        end;
    end;
  -- D_END :Получить конечную позицию элемента от начала проекта в секундах
    --====End===============End===============End===============End===============End====




    --217---------SetMediaItemInfo_Value-------------------------------------------------
    function Arc_Module.SetMediaItemInfo_Value(item, parmname,val);
        if parmname == "END" or parmname == "D_END" then;
            local pos = reaper.GetMediaItemInfo_Value(item,"D_POSITION"); 
            return reaper.SetMediaItemInfo_Value(item,"D_LENGTH",val-pos);
        else;
            return reaper.SetMediaItemInfo_Value(item,parmname,val);
        end;
    end;
    -- D_END :Установить конечную позицию элемента от начала проекта в секундах
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