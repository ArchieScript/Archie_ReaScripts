local VersionMod = "v.2.7.6"
--[[
   * Category:    Function
   * Description: Arc_Function_lua
   * Author:      Archie
   * Version:     2.7.6
   * AboutScript: Functions for use with some scripts Archie
   * О скрипте:   Функции для использования с некоторыми скриптами Archie
   * Provides:    [nomain].
   * Function:    http://arc-website.github.io/Library_Function/Arc_Function_lua/index.html
   
   * 
   * Changelog:   
   * 
   *  REAPER_Lib
   *      v.108   + no_undo();
   *      v.108   + Action(id,...);
   *      v.268   + boolean = TrackFx_Rename(Track,idx_Fx,Rename);
   *      v.268   + NameDefault,Name =  TrackFX_GetFXNameEx(Track,idx_fx);
   *      v.229   + boolean = RemoveAllSendTr(track,category);
   *      v.229   + boolean = RemoveAllItemTr_Sel(track,rem_Idx);
   *      v.227   + SelectAllTracks(numb);
   *      v.226   + SaveSoloMuteSelStateAllTracksGuidSlot_SWS(Slot);
   *      v.226   + RestoreSoloMuteSelStateAllTracksGuidSlot_SWS(Slot,clean);
   *      v.237   + boolean = js_ReaScriptAPI(boolean,numb__JS_API_Version);
   *      v.225   + boolean = SWS_API(boolean); 
   *      v.219   + SetCollapseFolderMCP(track,clickable,is_show);
   *      v.216   + Path,Name = GetPathAndNameSourceMediaFile_Take_SWS(take);
   *      v.242   + GetSetToggleButtonOnOff(numb,boolean set); numb:0 or 1;
   *      v.220   + _ = HelpWindow_WithOptionNotToShow(Text,Header,but,reset);
   *      v.257   + HelpWindowWhenReRunning(BottonText,but,reset);
   *      v.119   + DeleteMediaItem(item);
   *      v.118   + GetSampleNumberPosValue(take,SkipNumberOfSamplesPerChannel,FeelVolumeOfItem);
   *      v.117   + SetMediaItemLeftTrim2(position,item);
   *      v.116   + Save_Selected_Items_GuidSlot_SWS(Slot);
   *      v.116   + Restore_Selected_Items_GuidSlot_SWS(Slot,clean);
   *      v.115   + SaveSoloMuteStateAllTracksGuidSlot_SWS(Slot);
   *      v.115   + RestoreSoloMuteStateAllTracksGuidSlot_SWS(Slot,clean);
   *      v.114   + SaveMuteStateAllItemsGuidSlot_SWS(Slot);
   *      v.114   + RestoreMuteStateAllItemsGuidSlot_SWS(Slot,clean);
   *      v.113   + PosFirstIt,EndLastIt = GetPositionOfFirstItemAndEndOfLast();
   *      v.112   + PosFirstIt,EndLastIt = GetPositionOfFirstSelectedItemAndEndOfLast();
   *      v.111   + RemoveStretchMarkersSavingTreatedWave_Render_SWS(Take);
   *      v.110   + SaveSelTracksGuidSlot_SWS(Slot);
   *      v.110   + RestoreSelTracksGuidSlot_SWS(Slot,clean);
   *      v.109   + GetPreventSpectralPeaksInTrack(Track);
   *      v.108   + SetPreventSpectralPeaksInTrack(Track,Perf);--[=[Perf = true;false]=]
   *      v.107   + CloseAllFxInAllItemsAndAllTake(chain,float);
   *      v.106   + SetShow_HideTrackMCP(Track,show_hide--[=[0;1]=]);
   *      v.105   + CloseAllFxInAllTracks(chain, float);
   *      v.247   + CloseToolbarByNumber(ToolbarNumber--[=[1-16]=]);
   *      v.217   + GetMediaItemInfo_Value(item,parmname);/[D_END] 
   *      v.217   + SetMediaItemInfo_Value(item,parmname,val);/[D_END] 
   *      v.103   + Get_Format_ProjectGrid(divisionIn);
   *      v.102   + CountTrackSelectedMediaItems(track);
   *      v.101   + GetTrackSelectedMediaItems(track,idx);
   *      v.244   + numb = GetSetHeigthMCPTrack(track,numb,set);
   *      v.245   + openFileURL(pathUrl);
   *      v.249   + GetIDByScriptName(scriptName,scriptPath); 
   *      v.246   + GetScriptNameByID(id);
   *      v.253   + GetTrackAutoRecArm(Track);
   *      v.253   + SetTrackAutoRecArm(Track,val);
   *      v.259   + boolean, numb = SetHeightTrack_Env_TCP(Track,Height,minHeigth,resetHeigthEnv,PercentageDefault);
   *      v.265   + SetStartupScript(nameAction,id,nameFun,Clean);
   *      v.265   + boolean, boolean = GetStartupScript(id,nameFun);
   *      v.275   + GetSetTerminateAllInstancesOrStartNewOneKB_ini(set,newState,ScrPath,ScrName);
   *  LUA_Lib
   *      v.247   + If_Equals_Or(EqualsToThat,...);
   *      v.248   + If_Equals_OrEx(EqualsToThat,...);
   *      v.215   + ValueFromMaxRepsIn_Table(array, min_max);
   *      v.230   + randomOfVal(...);   
   *      v.230   + invert_number(X);
--=======================================================]]


    local Arc_Module = {};
    function Arc_Module.VersionArc_Function_lua(version);
        if not VersionMod then VersionMod = "0" else VersionMod = tostring(VersionMod);end;
        VersionMod = tonumber((VersionMod:gsub("%D","")));
        if not VersionMod then VersionMod = (0) end;
        version = tonumber((tostring(version):gsub("%D","")));
        if not version then version = (999^999) end;
        if version > VersionMod then; 
            local path = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/(Arc_Function_lua.lua)';
            reaper.ClearConsole();
            reaper.ShowConsoleMsg('ENG:\n\n'..
                'The file "Arc_Function_lua" is not relevant, Obsolete.\n'.. 
                'Download the Arc_Function_lua file at this URL:\n\n'.. 
                'https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/'.. 
                'ArchieScript/Archie_ReaScripts/blob/master/Functions/Arc_Function_lua.lua\n\n'.. 
                'And put it along the way:\n\n'..path..'\n\n\n\n'.. 
                'RUS:\n\n'.. 
                'Файл "Arc_Function_lua" не актуален, Устарел.\n'.. 
                'Скачайте файл "Arc_Function_lua" по этому URL:\n\n'.. 
                'https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/'.. 
                'ArchieScript/Archie_ReaScripts/blob/master/Functions/Arc_Function_lua.lua\n\n'.. 
                'И положите его по пути:\n\n'..path);
            return false; 
        end; 
        return true; 
    end;
    VersionArc_Function_lua = Arc_Module.VersionArc_Function_lua; 
    function Arc_Module.no_undo()reaper.defer(function()end)end;
    no_undo = Arc_Module.no_undo;
    function Arc_Module.Action(...);
       local Table = {...};
       for i = 1, #Table do;
         reaper.Main_OnCommand(reaper.NamedCommandLookup(Table[i]),0);
       end;
    end;
    Action = Arc_Module.Action;
   function Arc_Module.TrackFx_Rename(Track,idx_fx,newName);
       local strT,found,slot = {};
       local Pcall,FXGUID = pcall(reaper.TrackFX_GetFXGUID,Track,idx_fx);
       if not Pcall or not FXGUID then return false end;
       local retval,str = reaper.GetTrackStateChunk(Track,"",false);
       for l in (str.."\n"):gmatch(".-\n")do table.insert(strT,l)end;
       for i = #strT,1,-1 do;
           if strT[i]:match(FXGUID:gsub("%p","%%%0"))then found = true end;
           if strT[i]:match("^<")and found and not strT[i]:match("JS_SER")then;
               found = nil;
               local nStr = {};
               for S in strT[i]:gmatch("%S+")do;
                   if not X then nStr[#nStr+1] = S else nStr[#nStr] = nStr[#nStr].." "..S end;
                   if S:match('"') and not S:match('""')and not S:match('".-"') then;
                       if not X then;X = true;else;X = nil;end;
                   end;
               end;
               if strT[i]:match("^<%s-JS")then;
                   slot = 3;
               elseif strT[i]:match("^<%s-AU")then;
                   slot = 4;
               elseif strT[i]:match("^<%s-VST")then;
                   slot = 5;
               end;
               if not slot then error("Failed to rename",2)end;
               nStr[slot] = newName:gsub(newName:gsub("%p","%%%0"),'"%0"');
               nStr[#nStr+1]="\n";
               strT[i] = table.concat(nStr," ");
               break;
           end;
       end;
       return reaper.SetTrackStateChunk(Track,table.concat(strT),false);
   end;
   TrackFx_Rename = Arc_Module.TrackFx_Rename;
   function Arc_Module.TrackFX_GetFXNameEx(Track,idx_fx);
       local strT,found,Name,slot = {};
       local Pcall,FXGUID = pcall(reaper.TrackFX_GetFXGUID,Track,idx_fx);
       if not Pcall or not FXGUID then return end;
       local retval,str = reaper.GetTrackStateChunk(Track,"",false);
       for l in (str.."\n"):gmatch(".-\n")do table.insert(strT,l)end;
       for i = #strT,1,-1 do;
           if strT[i]:match(FXGUID:gsub("%p","%%%0"))then found = true end;
           if strT[i]:match("^<")and found and not strT[i]:match("JS_SER")then;
               found = nil;
               local nStr = {};
               for S in strT[i]:gmatch("%S+")do;
                   if not X then nStr[#nStr+1] = S else nStr[#nStr] = nStr[#nStr].." "..S end;
                   if S:match('"') and not S:match('""')and not S:match('".-"') then;
                       if not X then;X = true;else;X = nil;end;
                   end;
               end;
               if strT[i]:match("^<%s-JS")then;
                   slot = 3;
               elseif strT[i]:match("^<%s-AU")then;
                   slot = 4;
               elseif strT[i]:match("^<%s-VST")then;
                   slot = 5;
               end;
               if slot then;
                   Name = nStr[slot]:gsub('"','');
                   nStr[slot] = '""';
                   nStr[#nStr+1]="\n";
                   strT[i] = table.concat(nStr," ");
                   break;
               end;
           end;   
       end;
       reaper.SetTrackStateChunk(Track,table.concat(strT),false);
       local ret,NameDefault = reaper.TrackFX_GetFXName(Track,idx_fx,"");
       reaper.SetTrackStateChunk(Track,str,false);
       return NameDefault,Name or "";
   end;
   TrackFX_GetFXNameEx = Arc_Module.TrackFX_GetFXNameEx;
    function Arc_Module.RemoveAllSendTr(track,category);
         local R,Rem = false;
         for iS = reaper.GetTrackNumSends(track,category)-1,0,-1 do;
             Rem = reaper.RemoveTrackSend(track,category,iS);
             if Rem == true then R = true end;
         end;
         return R;
    end;
    RemoveAllSendTr = Arc_Module.RemoveAllSendTr;
    function Arc_Module.RemoveAllItemTr_Sel(track,rem_Idx);
        local D = false;
        for i = reaper.CountTrackMediaItems(track)-1,0,-1 do;
            local item = reaper.GetTrackMediaItem(track,i);
            if rem_Idx == 0 or rem_Idx == 1 then;
                local sel = reaper.GetMediaItemInfo_Value(item,"B_UISEL");
                if sel == rem_Idx then;
                    local Del = reaper.DeleteTrackMediaItem(track,item);
                    if Del == true then D = true end;
                end;
            else   
                local Del = reaper.DeleteTrackMediaItem(track,item);
                if Del == true then D = true end;                   
            end;
        end; 
        return D;        
    end;
    RemoveAllItemTr_Sel = Arc_Module.RemoveAllItemTr_Sel; 
    function Arc_Module.SelectAllTracks(numb);
        if numb > 0 then numb = 1 else numb = 0 end;  
        reaper.PreventUIRefresh(3864597);    
        for i = 1, reaper.CountTracks(0) do;
            local track = reaper.GetTrack(0,i-1);
            local sel = reaper.GetMediaTrackInfo_Value(track,"I_SELECTED");
            if sel == math.abs (numb - 1) then;
                reaper.SetMediaTrackInfo_Value(track,"I_SELECTED", numb);
            end;
        end;
    reaper.PreventUIRefresh(-3864597);
    end;
    SelectAllTracks = Arc_Module.SelectAllTracks;
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
    Arc_Module.SaveSoloMuteSelStateAllTracksGuidSlot_SWS = Arc_Module.SaveSoloMuteSelStateAllTracksGuidSlot;
    SaveSoloMuteSelStateAllTracksGuidSlot_SWS = Arc_Module.SaveSoloMuteSelStateAllTracksGuidSlot;
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
    Arc_Module.RestoreSoloMuteSelStateAllTracksGuidSlot_SWS = Arc_Module.RestoreSoloMuteSelStateAllTracksGuidSlot;
    RestoreSoloMuteSelStateAllTracksGuidSlot_SWS = Arc_Module.RestoreSoloMuteSelStateAllTracksGuidSlot;
    function Arc_Module.js_ReaScriptAPI(boolean,JS_API_Version);
        if type(JS_API_Version)~= "number" then JS_API_Version = 0 end;
        local MB,version,Ret;
        if not reaper.JS_ReaScriptAPI_Version then;
            if boolean == true then;
                MB = reaper.MB(
                "ENG:\n\n"..
                "There is no file reaper_js_ReaScriptAPI...!\n"..
                "Script requires an extension 'reaper_js_ReaScriptAPI'.\n"..
                "Install repository 'ReaTeam Extensions'.\n\n".. 
                "Go to website ReaPack - OK. \n\n"..
                "RUS:\n\n"..
                "Отсутствует файл reaper_js_ReaScriptAPI...!\n"..
                "Для работы скрипта требуется расширение 'reaper_js_ReaScriptAPI'.\n"..
                "Установите репозиторий 'ReaTeam Extensions'\n\n"..
                "Перейти на сайт ReaPack - OK. \n"
                ,"Error.",1);
            end;
            Ret = true;
        else;
            version = reaper.JS_ReaScriptAPI_Version();
            if version < JS_API_Version then;
                if boolean == true then;
                    MB = reaper.MB(
                    "ENG:\n\n"..
                    "File reaper_js_ReaScriptAPI Outdated!\n"..
                    "Update repository 'ReaTeam Extensions'.\n\n".. 
                    "Go to website ReaPack - OK. \n\n"..
                    "RUS:\n\n"..
                    "Файл reaper_js_ReaScriptAPI Устарел!\n"..
                    "Обновите репозиторий 'ReaTeam Extensions'\n\n"..
                    "Перейти на сайт ReaPack - OK. \n"
                    ,"Error.",1);   
                end;
                Ret = true;
            end;
        end;     
        if MB == 1 then;
            local OS = reaper.GetOS();
            if OS == "OSX32" or OS == "OSX64" then;
                os.execute("open https://reapack.com/repos");
            else;
                os.execute("start https://reapack.com/repos");
            end;
        end;
        if Ret == true then return false,version end;
        return true,version;
    end;
    js_ReaScriptAPI = Arc_Module.js_ReaScriptAPI;
    function Arc_Module.SWS_API(boolean);
        if not reaper.BR_GetMediaItemGUID then;
            if boolean == true then;
                local MB = reaper.MB(
                "ENG:\n\n"..
                "Missing extension 'SWS'!\n"..
                "Script requires an extension SWS.\n"..
                "Install extension 'SWS'. \n\n"..
                "Go to website SWS - OK   \n\n"..
                "RUS:\n\n"..
                "Отсутствует расширение 'SWS'!\n"..
                "Для работы сценария требуется расширение 'SWS'\n"..
                "Установите расширение 'SWS'. \n\n"..
                "Перейти на сайт SWS - OK \n"
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
    SWS_API = Arc_Module.SWS_API;
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
    SetCollapseFolderMCP = Arc_Module.SetCollapseFolderMCP;
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
    Arc_Module.GetPathAndNameSourceMediaFile_Take_SWS = Arc_Module.GetPathAndNameSourceMediaFile_Take;
    GetPathAndNameSourceMediaFile_Take_SWS = Arc_Module.GetPathAndNameSourceMediaFile_Take;
    function Arc_Module.SetToggleButtonOnOff(numb,set);
        local _,_,sec,cmd,_,_,_ = reaper.get_action_context();
        if set == 0 or set == false then;
            return reaper.GetToggleCommandStateEx(sec,cmd);
        else;
            reaper.SetToggleCommandState(sec,cmd,numb or 0);
            reaper.RefreshToolbar2(sec,cmd);
        end
    end;
    SetToggleButtonOnOff = Arc_Module.SetToggleButtonOnOff;
    Arc_Module.GetSetToggleButtonOnOff=Arc_Module.SetToggleButtonOnOff;
    GetSetToggleButtonOnOff=Arc_Module.SetToggleButtonOnOff;
    function Arc_Module.HelpWindow_WithOptionNotToShow(Text,Header,but,reset);
        local ScriptName,MessageBox = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)");
        local TooltipWind = reaper.GetExtState(ScriptName..'___'..but, "HelpWindow_WithOptionNotToShow"..'___'..but);
        if TooltipWind == "" then;
            MessageBox = reaper.ShowMessageBox(Text.."\n\n\n\n"..
            "НЕ ПОКАЗЫВАТЬ ПОЛЬШЕ ЭТО ОКНО  -  ОК\nDO NOT SHOW THIS WINDOW - OK",Header,1);
            if MessageBox == 1 then;
                reaper.SetExtState(ScriptName..'___'..but, "HelpWindow_WithOptionNotToShow"..'___'..but,MessageBox,true);
            end;
        end;
        if reset == true then;
            reaper.DeleteExtState(ScriptName..'___'..but, "HelpWindow_WithOptionNotToShow"..'___'..but,true);
        end;
        if MessageBox == 2 then MessageBox = 0 end;
        return MessageBox or -1;
    end;
    HelpWindow_WithOptionNotToShow=Arc_Module.HelpWindow_WithOptionNotToShow;
    function Arc_Module.HelpWindowWhenReRunning(BottonText,but,reset,header);
        if type(header)~="string" then header = "" end;
        local BottonTextS,NotReadTextR,NotReadTextE::NotRead::local time = os.time();
        local ScriptName = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)"):upper();
        local TooltipWind = reaper.GetExtState(ScriptName,"HelpWindowWhenReRunning"..'_'..but);
        if TooltipWind == "" then;
            if BottonText == 2 then;
                BottonTextS = "'NEW INSTANCE'" elseif BottonText == 1 then;
                BottonTextS = "'TERMINATE INSTANCES'"else BottonTextS = "- ??? Error"; 
            end;
            local MessageBox = reaper.ShowMessageBox(
            "RUS.\n\n"..
            "ВАЖНО:\n"..
            (NotReadTextR or "")..
            "При отключении или повторном включении скрипта появится окно (Reascript task control):\n"..
            "Для коректной работы скрипта ставим галку\n"..
            "(Remember my answer for this script)\n"..
            "Нажимаем: "..BottonTextS.."\n"..
            ("-"):rep(50)..
            "\n\n"..
            "ENG.\n\n"..
            "IMPORTANTLY:\n"..
            (NotReadTextE or "")..
            "When you disable or re-enable the script window will appear (Reascript control tasks):\n"..
            "For correct work of the script put the check\n"..
            "(Remember my answer for this script)\n"..
            "Click: "..BottonTextS.."\n"..
            ("-"):rep(50)..
            "\n\n\n"..
            "DO NOT SHOW THIS WINDOW - OK\n"..
            "НЕ ПОКАЗЫВАТЬ ПОЛЬШЕ ЭТО ОКНО  -  ОК\n\n"..
            ("-"):rep(50),
            "help "..header,1);
            if MessageBox == 1 then;
                local time2 = os.time();
                NotReadTextR = "\nВы не прочитали текст !!!\nПрочитайте текст!\nОкно можно будет закрыть по истечению 10 секунд\n\n"
                NotReadTextE = "\nYou have not read the text !!!\nRead the text!\nThe window can be closed after 10 seconds\n\n"
                if time+10 > time2 then goto NotRead end;
                local MB = reaper.MB("RUS: / ENG:\n\nЗапомни ! / Remember ! \n\n"..BottonTextS,"help.",1);
                if MB == 1 then;
                    reaper.SetExtState(ScriptName,"HelpWindowWhenReRunning"..'_'..but,MessageBox,true);
                end;
            end;
        end;
        if reset == true then;
            reaper.DeleteExtState(ScriptName,"HelpWindowWhenReRunning"..'_'..but,true);
        end;
        return ScriptName;
    end;
    HelpWindowWhenReRunning = Arc_Module.HelpWindowWhenReRunning;
    function Arc_Module.DeleteMediaItem(item);
        if item then;
            local tr = reaper.GetMediaItem_Track(item);
            reaper.DeleteTrackMediaItem(tr,item);
        end;
    end;
    DeleteMediaItem = Arc_Module.DeleteMediaItem;
    function Arc_Module.GetSampleNumberPosValue(take,SkipNumberOfSamplesPerChannel,FeelVolumeOfItem,FeelVolumeOfTake,FeelVolumeOfEnvelopeItem);
        if not take or reaper.TakeIsMIDI(take)then return false,false,false,false,false,false,false end;
        if not tonumber(SkipNumberOfSamplesPerChannel) then SkipNumberOfSamplesPerChannel = 0 end;
        SkipNumberOfSamplesPerChannel = math.floor(SkipNumberOfSamplesPerChannel+0.5);
        local item = reaper.GetMediaItemTake_Item(take);
        local PlayRate_Original =  reaper.GetMediaItemTakeInfo_Value(take,"D_PLAYRATE");
        local Item_len_Original = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
        reaper.SetMediaItemInfo_Value(item,"D_LENGTH",Item_len_Original * PlayRate_Original);
        reaper.SetMediaItemTakeInfo_Value(take,"D_PLAYRATE",1);
        local item_pos = reaper.GetMediaItemInfo_Value(item,"D_POSITION");
        local item_len = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
        local accessor = reaper.CreateTakeAudioAccessor(take);
        local source = reaper.GetMediaItemTake_Source(take);
        local samplerate = reaper.GetMediaSourceSampleRate(source);
        local numchannels = reaper.GetMediaSourceNumChannels(source);
        local item_len_idx = math.ceil(item_len);
        local CountSamples_OneChannel  = math.floor(item_len*samplerate+2);
        local CountSamples_AllChannels = math.floor(item_len*samplerate+2)*numchannels;
        local NumberSamplesOneChan  = {};
        local NumberSamplesAllChan  = {};
        local Sample_min            = {};
        local Sample_max            = {};
        local TimeSample            = {};
        local breakX,multi;
        for i1 = 1, item_len_idx do
            local buffer = reaper.new_array(samplerate*numchannels); 
            local Accessor_Samples = reaper.GetAudioAccessorSamples(
                                                        accessor   , 
                                                        samplerate , 
                                                        numchannels, 
                                                        i1-1       , 
                                                        samplerate , 
                                                        buffer     ) 
            local ContinueCounting = (i1-1) * samplerate; 
            for i2 = 1, samplerate*numchannels,numchannels*(SkipNumberOfSamplesPerChannel+1) do;
                local SamplePointNumb = (i2-1)/numchannels+ContinueCounting;
                local Sample_min_all_channels = 9^99;
                local Sample_max_all_channels = 0;
                for i3 = 1, numchannels do;
                    local Sample = math.abs(buffer[i2+(i3-1)]);
                    Sample_min_all_channels = math.min(Sample,Sample_min_all_channels);
                    Sample_max_all_channels = math.max(Sample,Sample_max_all_channels);
                end;
                if FeelVolumeOfTake == true then;
                    Sample_min_all_channels = Sample_min_all_channels*reaper.GetMediaItemTakeInfo_Value(take, "D_VOL");
                    Sample_max_all_channels = Sample_max_all_channels*reaper.GetMediaItemTakeInfo_Value(take, "D_VOL");
                end;
                if FeelVolumeOfItem == true then;
                    Sample_min_all_channels = Sample_min_all_channels*reaper.GetMediaItemInfo_Value(item, "D_VOL");
                    Sample_max_all_channels = Sample_max_all_channels*reaper.GetMediaItemInfo_Value(item, "D_VOL");
                end;
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
                Sample_min[#Sample_min+1] = Sample_min_all_channels;
                Sample_max[#Sample_max+1] = Sample_max_all_channels;
                NumberSamplesAllChan[#NumberSamplesAllChan+1] = (i2 + ContinueCounting);
                if numchannels > 2 then multi = 1 else multi = 0 end;
                NumberSamplesOneChan[#NumberSamplesOneChan+1] = math.floor(((i2 + ContinueCounting)/numchannels)+0.5)+multi;
                TimeSample[#TimeSample+1] = SamplePointNumb/samplerate/PlayRate_Original + item_pos;
               if TimeSample[#TimeSample] > Item_len_Original + item_pos then breakX = 1 break end;
            end;
            buffer.clear();
            if breakX == 1 then break end;
        end
        reaper.DestroyAudioAccessor(accessor);
        reaper.SetMediaItemInfo_Value(item,"D_LENGTH",item_len / PlayRate_Original);
        reaper.SetMediaItemTakeInfo_Value(take,"D_PLAYRATE",PlayRate_Original);
        TimeSample[1] = item_pos; 
        TimeSample[#TimeSample] = item_pos + Item_len_Original;
        return CountSamples_AllChannels,CountSamples_OneChannel,NumberSamplesAllChan,
               NumberSamplesOneChan,Sample_min,Sample_max,TimeSample;
    end;
    GetSampleNumberPosValue=Arc_Module.GetSampleNumberPosValue;
    function Arc_Module.SetMediaItemLeftTrim2(position,item);
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
    end;
    SetMediaItemLeftTrim2=Arc_Module.SetMediaItemLeftTrim2;
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
    Arc_Module.Save_Selected_Items_GuidSlot_SWS=Arc_Module.Save_Selected_Items_GuidSlot;
    Save_Selected_Items_GuidSlot_SWS=Arc_Module.Save_Selected_Items_GuidSlot;
    function Arc_Module.Restore_Selected_Items_GuidSlot(Slot,clean,selPrev);
        t = _G["SaveSelItem_"..Slot];
        if t then;
            if selPrev ~= true and selPrev ~= 1 then;
                reaper.SelectAllMediaItems(0,0);
            end;
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
    Arc_Module.Restore_Selected_Items_GuidSlot_SWS=Arc_Module.Restore_Selected_Items_GuidSlot;
    Restore_Selected_Items_GuidSlot_SWS=Arc_Module.Restore_Selected_Items_GuidSlot;
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
    Arc_Module.SaveSoloMuteStateAllTracksGuidSlot_SWS=Arc_Module.SaveSoloMuteStateAllTracksGuidSlot;
    SaveSoloMuteStateAllTracksGuidSlot_SWS=Arc_Module.SaveSoloMuteStateAllTracksGuidSlot;
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
    Arc_Module.RestoreSoloMuteStateAllTracksGuidSlot_SWS=Arc_Module.RestoreSoloMuteStateAllTracksGuidSlot;
    RestoreSoloMuteStateAllTracksGuidSlot_SWS=Arc_Module.RestoreSoloMuteStateAllTracksGuidSlot;
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
    Arc_Module.SaveMuteStateAllItemsGuidSlot_SWS = Arc_Module.SaveMuteStateAllItemsGuidSlot;
    SaveMuteStateAllItemsGuidSlot_SWS = Arc_Module.SaveMuteStateAllItemsGuidSlot;
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
    Arc_Module.RestoreMuteStateAllItemsGuidSlot_SWS = Arc_Module.RestoreMuteStateAllItemsGuidSlot;
    RestoreMuteStateAllItemsGuidSlot_SWS = Arc_Module.RestoreMuteStateAllItemsGuidSlot;
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
    GetPositionOfFirstItemAndEndOfLast = Arc_Module.GetPositionOfFirstItemAndEndOfLast;
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
    GetPositionOfFirstSelectedItemAndEndOfLast = Arc_Module.GetPositionOfFirstSelectedItemAndEndOfLast;
    function Arc_Module.RemoveStretchMarkersSavingTreatedWave_Render(Take);
        if not Take then reaper.ReaScriptError("bad argument #1 to"..
            "'RemoveStretchMarkersSavingTreatedWave_Render' (Take expected)");
            return
        end;
        if not reaper.TakeIsMIDI(Take) then;
            if reaper.GetTakeNumStretchMarkers(Take) > 0 then;
                reaper.PreventUIRefresh(195638945);
                reaper.Undo_BeginBlock2(0);
                local Guid = {};
                for i = 1, reaper.CountSelectedMediaItems(0) do;
                    local sel_item = reaper.GetSelectedMediaItem(0,i-1);
                    Guid[i] = reaper.BR_GetMediaItemGUID(sel_item);
                end;
                reaper.SelectAllMediaItems(0,0);
                local item = reaper.GetMediaItemTake_Item(Take);
                reaper.SetMediaItemSelected(item,1);
                local Len = reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
                local PlayRat = reaper.GetMediaItemTakeInfo_Value(Take,"D_PLAYRATE");
                local active,visible,armed,inLane,laneHeight,defaultShape,minValue,
                      maxValue,centerValue,typeS,faderScaling,EnvelopePresent = {};
                local CountTakeEnv = reaper.CountTakeEnvelopes(Take);
                if CountTakeEnv > 0 then;
                    EnvelopePresent = "Active";
                    for i = 1,CountTakeEnv do;
                        local EnvTake = reaper.GetTakeEnvelope(Take,i-1);
                        local NotCreateStart,NotCreateEnd,valuestart,valueEnd = nil,nil,nil,nil;
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
                        reaper.DeleteEnvelopePointRange(EnvTake,0.0000001,0.01);
                        reaper.DeleteEnvelopePointRange(EnvTake,(Len*PlayRat)+0.0000001,9^99);
                        reaper.DeleteEnvelopePointRange(EnvTake,(Len*PlayRat)-0.01,(Len*PlayRat)-0.0000001);
                        local EnvAlloc = reaper.BR_EnvAlloc(EnvTake,false);
                        active[i],visible,armed,inLane,laneHeight,defaultShape,minValue,maxValue,
                        centerValue,typeS,faderScaling = reaper.BR_EnvGetProperties(EnvAlloc);     
                        reaper.BR_EnvSetProperties(EnvAlloc,false--[=[active]=],visible,armed,
                                               inLane,laneHeight,defaultShape,faderScaling);
                        reaper.BR_EnvFree(EnvAlloc,true);
                    end;
                end;
                local FX_Enabled = {};
                local CountFx = reaper.TakeFX_GetCount(Take);
                for i = 1,CountFx do;
                    FX_Enabled[i] = reaper.TakeFX_GetEnabled(Take,i-1);
                    reaper.TakeFX_SetEnabled(Take,i-1,0);
                end;
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
                local itemfxtail = reaper.SNM_GetIntConfigVar("itemfxtail",0);
                reaper.SNM_SetIntConfigVar("itemfxtail",0);
                Arc_Module.Action(41999);
                local Take_X = reaper.GetActiveTake(item);
                reaper.SNM_SetIntConfigVar("itemfxtail",itemfxtail);
                local NumStrMar = reaper.GetTakeNumStretchMarkers(Take);
                reaper.DeleteTakeStretchMarkers(Take, 0, NumStrMar);
                reaper.SetMediaItemTakeInfo_Value(Take,"D_STARTOFFS",0);
                reaper.SetMediaItemTakeInfo_Value(Take,"D_PLAYRATE",1);
                local retval,section,start,length,fade,reverse = reaper.BR_GetMediaSourceProperties(Take_X);
                reaper.BR_SetMediaSourceProperties(Take,section,start,length,fade,reverse);
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
                local Take_X_Source = reaper.GetMediaItemTake_Source(Take_X);
                local Filenamebuf = reaper.GetMediaSourceFileName(Take_X_Source,"");
                reaper.BR_SetTakeSourceFromFile(Take,Filenamebuf,true);
                reaper.SetMediaItemTakeInfo_Value(Take,"D_PITCH",Pich);
                reaper.SetMediaItemTakeInfo_Value(Take,"B_PPITCH",PreserPitch);
                reaper.SetMediaItemTakeInfo_Value(Take,"D_VOL",vol);
                reaper.SetMediaItemTakeInfo_Value(Take,"D_PAN",pan);
                reaper.SetMediaItemTakeInfo_Value(Take,"I_CHANMODE",Chanmode);
                reaper.SetMediaItemTakeInfo_Value(Take,"I_PITCHMODE",PichMode);
                Arc_Module.Action(40129);
                reaper.SetActiveTake(Take);
                for i = 1, #FX_Enabled do;
                    reaper.TakeFX_SetEnabled(Take,i-1,FX_Enabled[i]);
                end;
                reaper.SelectAllMediaItems(0,0);
                for i = 0, #Guid do; 
                    local item = reaper.BR_GetMediaItemByGUID(0,Guid[i]);
                    if item then;
                        reaper.SetMediaItemSelected(item,1);
                    end;
                end;
                reaper.Undo_EndBlock2(0,"RemoveStretchMarkersSavingTreatedWave",-1);
                reaper.PreventUIRefresh(-195638945);
            end;
        end;
        reaper.UpdateArrange();
    end;
    Arc_Module.RemoveStretchMarkersSavingTreatedWave_Render_SWS=Arc_Module.RemoveStretchMarkersSavingTreatedWave_Render;
    RemoveStretchMarkersSavingTreatedWave_Render_SWS=Arc_Module.RemoveStretchMarkersSavingTreatedWave_Render;
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
    Arc_Module.SaveSelTracksGuidSlot_SWS = Arc_Module.SaveSelTracksGuidSlot;
    SaveSelTracksGuidSlot_SWS = Arc_Module.SaveSelTracksGuidSlot;
    function Arc_Module.RestoreSelTracksGuidSlot(Slot,clean);
       local tr = reaper.GetTrack(0,0);
       reaper.SetOnlyTrackSelected(tr);
       reaper.SetMediaTrackInfo_Value(tr,"I_SELECTED",0);
       local t = _G['SaveSelTr_'..Slot];
       if t then;
           for i = 1, #t do;
               local track = reaper.BR_GetMediaTrackByGUID(0,t[i]);
               if track then;
                   reaper.SetMediaTrackInfo_Value(track,"I_SELECTED",1);
               end;
           end;
           if clean == 1 or clean == true then;
               _G['SaveSelTr_'..Slot] = nil;
               t = nil;
           end;
       end;
    end;
    Arc_Module.RestoreSelTracksGuidSlot_SWS = Arc_Module.RestoreSelTracksGuidSlot;
    RestoreSelTracksGuidSlot_SWS = Arc_Module.RestoreSelTracksGuidSlot;
    function Arc_Module.GetPreventSpectralPeaksInTrack(Track)
        local _,str = reaper.GetTrackStateChunk(Track,"",false);
        local Perf = str:match('PERF (%d+)');
        if Perf == "4" then return true end
        return false
    end
    GetPreventSpectralPeaksInTrack = Arc_Module.GetPreventSpectralPeaksInTrack;
    --- 108 ---SetPreventSpectralPeaksInTrack ----- [[Perf = true;false]] 
    function Arc_Module.SetPreventSpectralPeaksInTrack(Track,Perf);
        if Perf == true then Perf = 4 end;
        if Perf == false then Perf = 0 end;
        local _,str = reaper.GetTrackStateChunk(Track,"",false);
        local str2 = str:gsub('PERF %d+',"PERF".." "..Perf);
        reaper.SetTrackStateChunk(Track,str2,false);
    end;
    SetPreventSpectralPeaksInTrack = Arc_Module.SetPreventSpectralPeaksInTrack;
    function Arc_Module.CloseAllFxInAllItemsAndAllTake(chain,float);
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
    CloseAllFxInAllItemsAndAllTake = Arc_Module.CloseAllFxInAllItemsAndAllTake;
    function Arc_Module.SetShow_HideTrackMCP(Track,show_hide--[[0;1]]);
        local _,str = reaper.GetTrackStateChunk(Track,"",true);
        local SHOWINMIX = str:match('SHOWINMIX %d+');
        local str = string.gsub(str,SHOWINMIX, "SHOWINMIX"..' '..show_hide);
        reaper.SetTrackStateChunk(Track, str, true);
    end;
    SetShow_HideTrackMCP = Arc_Module.SetShow_HideTrackMCP;
    function Arc_Module.CloseAllFxInAllTracks(chain, float)
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
    CloseAllFxInAllTracks = Arc_Module.CloseAllFxInAllTracks;
    function Arc_Module.CloseToolbarByNumber(ToolbarNumber--[[1-16]]);
        local Toolbar_T = {[0]=41651,41679,41680,41681,41682,41683,41684,41685,
                          41686,41936,41937,41938,41939,41940,41941,41942,41943};
        reaper.PreventUIRefresh(6548);
        local stateTopDock = (reaper.GetToggleCommandState(41297)==1);
        if stateTopDock then reaper.Main_OnCommand(41297,0) end;
        local state = reaper.GetToggleCommandState(Toolbar_T[ToolbarNumber]);
        if state == 1 then;
            reaper.Main_OnCommand(Toolbar_T[ToolbarNumber],0);
        end;
        local stateTopDock_End = (reaper.GetToggleCommandState(41297)==1);
        if stateTopDock_End ~= stateTopDock then reaper.Main_OnCommand(41297,0) end; 
        reaper.PreventUIRefresh(-6548);
    end;
    CloseToolbarByNumber = Arc_Module.CloseToolbarByNumber;
    function Arc_Module.GetMediaItemInfo_Value(item, parmname);
        if parmname == "END" or parmname == "D_END" then return
            reaper.GetMediaItemInfo_Value(item,"D_POSITION")+
            reaper.GetMediaItemInfo_Value(item,"D_LENGTH");
        else;
            return reaper.GetMediaItemInfo_Value(item,parmname);
        end;
    end;
    GetMediaItemInfo_Value = Arc_Module.GetMediaItemInfo_Value;
    function Arc_Module.SetMediaItemInfo_Value(item, parmname,val);
        if parmname == "END" or parmname == "D_END" then;
            local pos = reaper.GetMediaItemInfo_Value(item,"D_POSITION"); 
            return reaper.SetMediaItemInfo_Value(item,"D_LENGTH",val-pos);
        else;
            return reaper.SetMediaItemInfo_Value(item,parmname,val);
        end;
    end;
    SetMediaItemInfo_Value = Arc_Module.SetMediaItemInfo_Value;
    function Arc_Module.Get_Format_ProjectGrid(divisionIn)
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
    Get_Format_ProjectGrid = Arc_Module.Get_Format_ProjectGrid;
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
    CountTrackSelectedMediaItems = Arc_Module.CountTrackSelectedMediaItems;
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
    GetTrackSelectedMediaItems = Arc_Module.GetTrackSelectedMediaItems;
    function Arc_Module.GetSetHeigthMCPTrack(track,numb,set);
        local ret,err = pcall(reaper.GetTrackGUID,track);if not ret then error("GetSetHeigthMCPTrack - "..err,2)end;
        if set~=0 and set~=1 then error("GetSetHeigthMCPTrack - expected 0 or 1 got "..(tonumber(set)or type(set)),2)end;
        if set == 1 then;
            if type(numb)~="number"then error("bad argument #2 to 'GetSetHeigthMCPTrack' (number expected, got "..type(numb)..")",2)end;
        end;
        local retval,str = reaper.GetTrackStateChunk(track,"",false);
        local heigth = string.match(str,"SHOWINMIX%s+%S-%s+(%S-)%s");
        if set == 1 then;
            if numb > 1 then numb = 1 end;
            if numb < 0 then numb = 0 end;
            local strSHOWINMIX = string.match(str,"SHOWINMIX.-\n");
            local FirstHalfLine,SecondHalfLine = string.match(str,"(SHOWINMIX%s+%S-%s+)%S+(.-\n)");
            local str2 = string.gsub(str,strSHOWINMIX,FirstHalfLine..numb..SecondHalfLine);
            reaper.SetTrackStateChunk(track,str2,false);
        else;
            return tonumber(heigth);
        end;
    end;
    GetSetHeigthMCPTrack = Arc_Module.GetSetHeigthMCPTrack;
    function Arc_Module.openFileURL(pathUrl);
        if type(pathUrl)~="string"then error("openFileURL - expected string got "..type(pathUrl),2)end;
        if #pathUrl:gsub(" ","") <= 0 then error("openFileURL - expected at least one symbol, got zero symbol.",2)end;
        local OS = reaper.GetOS();
        if OS == OS:match("OSX") then;
            os.execute('open "'..pathUrl..'"');
        else;
            os.execute('start "" '..pathUrl);
        end;
    end;
    openFileURL = Arc_Module.openFileURL;
    function Arc_Module.GetIDByScriptName(scriptName,scriptPath); 
        if type(scriptName)~="string"then error("expects a 'string', got "..type(scriptName),2) end;
        if type(scriptPath)~= "string" or #scriptPath:gsub('%s','')== 0 then scriptPath = nil end;
        local file = io.open(reaper.GetResourcePath()..'/reaper-kb.ini','r');if not file then return -1 end;
        local scrName = scriptName:gsub('Script:%s+','',1):gsub("%p",'%%%0');local DesiredID;
        for var in file:lines()do;
            if var:match('"Custom:%s-'..scrName..'"')then; 
                if scriptPath then;
                    if (var:gsub("[\\/]","")):match(((scriptPath:gsub("[\\/]","")):gsub(((reaper.GetResourcePath().."Scripts")
                        :gsub("[\\/]",""):gsub("%p","%%%0")),"" )):gsub("%p","%%%0"))then; DesiredID = true;
                    end;
                else;
                    DesiredID = true;
                end;
                if DesiredID then;
                    return "_"..var:match(".-%s+.-%s+.-%s+(.-)%s"):gsub('"',""):gsub("'","");
                end;   
            end;
        end;  
       return -1;   
    end;  
    GetIDByScriptName = Arc_Module.GetIDByScriptName;
    function Arc_Module.GetScriptNameByID(id);
        if type(id)~="string"then error("expects a 'string', got "..type(id),2) end;
        local file = io.open(reaper.GetResourcePath()..'/reaper-kb.ini','r');
        if not file or (#id<1) then return -1 end;local text = file:read('a');file:close();
        id = id:match('%_*(%S+)');return
        text:match("%s"..id..'%s-"Custom:%s-.(.-)"')or
        text:match('"'..id..'"%s-"Custom:%s-.(.-)"')or-1;
    end;
    GetScriptNameByID = Arc_Module.GetScriptNameByID;
    function Arc_Module.GetTrackAutoRecArm(Track);
        local retval, str = reaper.GetTrackStateChunk(Track,"",false);
        local str2 = tonumber(str:match("AUTO_RECARM%s-(%d+)"));
        if str2 ~= 1 then return 0 else return 1 end;
    end;
    GetTrackAutoRecArm = Arc_Module.GetTrackAutoRecArm;
    function Arc_Module.SetTrackAutoRecArm(Track,val);
        if tonumber(val)and val >= 1 or val == true then val = 1 else val = 0 end;
        local retval, str = reaper.GetTrackStateChunk(Track,"",false);local str2;
        if str:match("AUTO_RECARM") then;
            str2 = str:gsub("AUTO_RECARM%s-%d+","AUTO_RECARM "..val);
        else;
            str2 = str:gsub("REC%s%d.-\n","%0AUTO_RECARM "..val);
        end;
        reaper.SetTrackStateChunk(Track,str2,false);
    end;
    SetTrackAutoRecArm = Arc_Module.SetTrackAutoRecArm;
    function Arc_Module.SetHeightTrack_Env_TCP(Track,Height,minHeigth,resetHeigthEnv,PercentageDefault); 
        if not tonumber(minHeigth) then minHeigth = 24 end;
        if not tonumber(PercentageDefault) then PercentageDefault = 0.75 end;
        local Pcall,CountTrEnv = pcall(reaper.CountTrackEnvelopes,Track);
        if not Pcall then error(CountTrEnv,2)end;
        if reaper.GetMediaTrackInfo_Value(Track,"I_WNDH")== Height then return end;
        local CustomH_EnvTr, TotalHeight, countEnv,ret = {},0,0;
        for i = 1,CountTrEnv do;
            local env = reaper.GetTrackEnvelope(Track,i-1);
            local retval, str = reaper.GetEnvelopeStateChunk(env,"",false);
            local visEnvTr,visInline = str:match("VIS%s-(%d+)%s-(%d+)");
            local visibleEnvTr = tonumber(visEnvTr);
            local visibleInline = tonumber(visInline); 
            local heightEnvTr = tonumber(str:match("LANEHEIGHT%s-(%d+)%s"));
            if visibleEnvTr == 1 then;
                if visibleInline == 1 then;
                    if heightEnvTr == 0 then;
                        countEnv = countEnv + 1;
                    elseif tonumber(heightEnvTr) and heightEnvTr ~= 0 then;
                        TotalHeight = TotalHeight + heightEnvTr;
                        CustomH_EnvTr[#CustomH_EnvTr+1] = env;
                    end;
                end;
            end; 
        end;
        if ((Height-TotalHeight)-(countEnv*minHeigth)) < 30 then PercentageDefault = 1 end;
        local heightSet = (Height - TotalHeight) / (1+(PercentageDefault*countEnv));
        reaper.PreventUIRefresh(10);
        if heightSet < minHeigth and #CustomH_EnvTr == 0 then;
            heightSet = minHeigth; 
        elseif heightSet < minHeigth and #CustomH_EnvTr > 0 then;
            local reduceEnv = (TotalHeight-(Height-(minHeigth*(countEnv+1))))/#CustomH_EnvTr;
            heightSet = minHeigth;
            local removeEnv,repeatEnvRecount,t;
            repeat;
                repeatEnvRecount = nil;
                for i = #CustomH_EnvTr,1,-1 do;
                    local retval,str = reaper.GetEnvelopeStateChunk(CustomH_EnvTr[i],"",false);
                    local heightEnvTr = tonumber(str:match("LANEHEIGHT%s-(%d+)%s"))or 0;
                    local newHeightEnvTr = heightEnvTr - reduceEnv;
                    if newHeightEnvTr <= minHeigth then;
                        repeatEnvRecount = (repeatEnvRecount or 0)+(minHeigth - newHeightEnvTr);
                        if resetHeigthEnv == 1 then newHeightEnvTr = 0 else newHeightEnvTr = minHeigth end;
                        removeEnv = true;
                    end;
                    local str = str:gsub("LANEHEIGHT%s-%d+","LANEHEIGHT "..newHeightEnvTr);
                    reaper.SetEnvelopeStateChunk(CustomH_EnvTr[i],str,false);
                    if removeEnv then table.remove(CustomH_EnvTr,i)removeEnv = nil end;
                end; 
                if repeatEnvRecount then reduceEnv = repeatEnvRecount / #CustomH_EnvTr end;
                t = (t or 0)+1 if t == 1e+6 then break end;
            until not repeatEnvRecount;
        end;
        if reaper.GetMediaTrackInfo_Value(Track,"I_HEIGHTOVERRIDE") ~= heightSet then;
            ret = reaper.SetMediaTrackInfo_Value(Track,"I_HEIGHTOVERRIDE",heightSet);
        end;
        reaper.PreventUIRefresh(-10);
        return ret;
    end;                
    SetHeightTrack_Env_TCP = Arc_Module.SetHeightTrack_Env_TCP;
     function Arc_Module.SetStartupScript(nameAction,id,nameFun,Clean);
        if type(nameAction)~="string"then;error("#1 expects 'string', got "..type(nameAction),2)end;
        local nameAction = nameAction:gsub('[%s%p]','_'):gsub('__','_'):gsub('__','_'):upper();
        if #nameAction < 5 then;error("#1 expected a string 5 or more characters, got "..#nameAction,2)end;
        if Clean ~= "ALL" and Clean ~= "ONE" then;
            local CheckId=reaper.NamedCommandLookup(id);if CheckId<1 then error("#2 enter the relevant ID",2)end;
        end;
        local ScrName = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)");
        if ScrName:match("^Archie_")or ScrName:match("^Arc_")and not nameFun then nameFun = "Archie"end;
        if type(nameFun)~="string"then;error("#3 expects 'string', got "..type(nameFun),2)end;
        local nameFun=nameFun:gsub('[%s%p]',''):gsub('.','_%0',1)
        if #nameFun < 7 then;error("expected a string 6 or more characters, got "..#nameFun-1,2)end;
        if Clean == "ALL" then goto ALL end; if Clean == "ONE" then goto ONE end;
        do;
            local file = io.open(reaper.GetResourcePath().."/Scripts/__startup.lua",'r');
            if not file then
                io.open(reaper.GetResourcePath().."/Scripts/__startup.lua",'w'):close();
                file = io.open(reaper.GetResourcePath().."/Scripts/__startup.lua",'r');
            end; local text = file:read('a')..'\n'; file:close();
            text = text:gsub("\n%s-\n%s-\n%s-\n","\n\n\n");
            local line_T = {};
            local CheckFun,var2;
            for var in text:gmatch(".-\n") do;
                if var:match("^%s-function%s+StartupScript"..nameFun.."%s-%(.-%)")then;
                    var = var..(" "):rep(4)..nameAction.."=reaper.Main_OnCommand(reaper.NamedCommandLookup('"..id.."'),0)\n";
                    CheckFun = true;
                end;
                table.insert(line_T,var);
            end;
            if not CheckFun then;
                var2 = text.."\n\nfunction StartupScript"..nameFun.."()\n"..
                (" "):rep(4)..nameAction.."=reaper.Main_OnCommand(reaper.NamedCommandLookup('"..id.."'),0)\n"..
                "end StartupScript"..nameFun.."()";
            else;
                var2 = table.concat(line_T);
            end;
            local header = var2;
            file = io.open(reaper.GetResourcePath().."/Scripts/__startup.lua",'w');
            file:write(header); file:close();
            local file = io.open(reaper.GetResourcePath().."/Scripts/__startup.lua",'r');
            local text = file:read('a')..'\n'; file:close();
            local line_T = {};
            local T = {}; local var2,X,StartF;
            for var in text:gmatch(".-\n") do;
                if StartF and var:match("^.-StartupScript"..nameFun.."%s-%(.-%)")then; StartF=nil T={} end;
                if not StartF and var:match("^%s-function%s-StartupScript"..nameFun.."%s-%(.-%)")then; StartF = true end;
                if StartF then;
                    if var:match("^%s-\n")then var = nil end;
                    if var then;
                        T[#T+1] = var:match("^.-NamedCommandLookup%('(.-)'.-\n");
                        for i = 1,#T do;
                            if T[i] == var:match("^.-NamedCommandLookup%('(.-)'.-\n")then;
                                X=(X or 0)+1;
                                if X > 1 then; var = nil; T[#T]=nil; break end;
                            end;
                        end; X = nil;
                    end;
                end;
                if var then table.insert(line_T,var)end;
            end;
            local header = table.concat(line_T);
            file = io.open(reaper.GetResourcePath().."/Scripts/__startup.lua",'w');
            file:write(header); file:close();
        end;
        ::ALL::::ONE::
        if Clean == "ALL" or Clean == "ONE" then;
            local file = io.open(reaper.GetResourcePath().."/Scripts/__startup.lua",'r');
            if not file then return end; local text = file:read('a')..'\n'; file:close();
            local line_T = {};
            local ChangesAre,StartF;
            if Clean == "ALL" then;
                for var in text:gmatch(".-\n") do;
                    if StartF and var:match("^.-StartupScript"..nameFun.. "%s-%(.-%)")then;StartF = 2 end;
                    if not StartF and var:match("^%s-function%s-StartupScript"..nameFun.."%s-%(.-%)")then;StartF = 1 end;
                    if StartF == 1 or StartF == 2 then;
                        var = nil;
                        ChangesAre = true;
                        if StartF == 2 then StartF = nil end;
                    end;
                    if var then table.insert(line_T,var)end;
                end;
            elseif Clean == "ONE" then;
                for var in text:gmatch(".-\n") do;
                    if StartF and var:match("^.-StartupScript"..nameFun.. "%s-%(.-%)")then;StartF = 2 end;
                    if not StartF and var:match("^%s-function%s-StartupScript"..nameFun.."%s-%(.-%)")then;StartF = 1 end;
                    if StartF == 1 or StartF == 2 then;
                        if var:match("^.-NamedCommandLookup%('(.-)'.-\n") == id then var = nil ChangesAre = true; end;
                        if StartF == 2 then StartF = nil end;   
                    end;
                    if var then table.insert(line_T,var)end;
                end;
            end;
            if ChangesAre then;
                local header = table.concat(line_T);
                file = io.open(reaper.GetResourcePath().."/Scripts/__startup.lua",'w');
                file:write(header); file:close();
            end; 
        end;
    end;
    Arc_Module.SetStartupScript = Arc_Module.SetStartupScript;
    -- local scrPath,scrName = ({reaper.get_action_context()})[2]:match("(.+)[/\\](.+)");
    function Arc_Module.GetStartupScript(id,nameFun);
        if type(id)~="string" and type(id)~="number" then;
            error("#1 expected a string or number, got "..type(id),2);
        end;
        if #id:gsub('[%s]','') < 1 then error("#1 invalid ID",2)end;
        if not nameFun then nameFun = "Archie" end;
        if type(nameFun)~="string" then error("#2 expected a string, got "..type(nameFun),2)end;
        local nameFun = nameFun:gsub('[%s%p]',''):gsub('.','_%0',1);
        if #nameFun < 7 then;error("#2 expected a string 6 or more characters, got "..#nameFun-1,2)end;
        local file = io.open(reaper.GetResourcePath().."/Scripts/__startup.lua",'r');
        if not file then return false; end;
        local text = file:read('a')..'\n'; file:close();
        local nameFun2,StartF;
        for var in text:gmatch(".-\n") do;
            if StartF and var:match("^.-StartupScript"..nameFun.. "%s-%(.-%)")then;StartF = 2 end;
            if not StartF and var:match("^%s-function%s-StartupScript"..nameFun.."%s-%(.-%)")then;StartF = 1 end;
            if StartF == 1 or StartF == 2 then;
                nameFun2 = nameFun:gsub('^_','',1);
                local check_Id = var:match("^.-NamedCommandLookup%('(.-)'.-$");
                if check_Id == id or check_Id == "_"..id then return true, nameFun:gsub('^_','',1); end;
                if StartF == 2 then StartF = nil end;
            end;
        end;
        return false, nameFun2;
    end;
    GetStartupScript = Arc_Module.GetStartupScript;
    function Arc_Module.GetSetTerminateAllInstancesOrStartNewOneKB_ini(set,newState,ScrPath,ScrName);
        local ResPath = reaper.GetResourcePath();
        newState = tonumber(newState);
        if not newState or (newState~=260 and newState~=516) then newState = 4 end;
        local file = io.open(ResPath.."/reaper-kb.ini","r");
        if file then;
            local ScrNameX = ScrName:gsub("[%p]","%%%0");
            local ScrPathX = ScrPath:gsub("[\\/]",""):gsub("[%p]","%%%0");
            local ScrPth1 = (ScrPath:gsub("[\\/]",""));
            local ScrPth2 = ((ResPath.."Scripts"):gsub("[\\/]","")):gsub("[%p]","%%%0");
            local ScrPath2X = ScrPth1:gsub(ScrPth2,""):gsub("[%p]","%%%0");
            local line_T, found,Stop,state = {};
            for line in file:lines()do;
                if not found then;
                    if line:match(ScrNameX) then;
                        if line:gsub("[\\/]",""):match(ScrPathX..ScrNameX)or
                            line:gsub("[\\/]",""):match(ScrPath2X..ScrNameX) then;
                            found = true;
                            state = tonumber(line:match("^%S+%s+(%d+)"));
                            if (set==0 or set==false)then;file:close();return true,state end;
                            if state == newState then; file:close();return false,state end;
                            line = line:gsub( line:match("^%S+%s+%d+"),line:match("^%S+%s+%d+"):gsub("%s%d+"," "..newState,1),1);
                        end;
                    end;
                end;
                table.insert(line_T,line);
            end;
            if (set==0 or set==false)then;file:close();return false end;
            if found then;
                file:close();
                if #line_T > 0 then;
                    local newLine = table.concat(line_T,"\n");
                    local file = io.open(reaper.GetResourcePath().."/reaper-kb.ini","w");
                    file:write(newLine);
                    file:close();
                    return true,state;
                end;
            end;
        end;
        return false;
    end;
    function Arc_Module.If_Equals_Or(EqualsToThat,...);
        for _,v in pairs {...} do;
            if v == EqualsToThat then return true end;
        end;
        return false;
    end;
    Arc_Module.If_Equals = Arc_Module.If_Equals_Or;
    If_Equals_Or = Arc_Module.If_Equals_Or;
    function  Arc_Module.If_Equals_OrEx(EqualsToThat,...);
        local T = {};
        for _,v in pairs{...} do;
            if type(v) == "table" then;
                for _,v2 in pairs(v) do;
                    T[#T+1] = v2;
                end;
            else;
                T[#T+1] = v;
            end;
        end;
        for _,v in pairs(T) do;
            if v == EqualsToThat then return true end;
        end;
        return false;
    end;
    If_Equals_OrEx = Arc_Module.If_Equals_OrEx;
    function Arc_Module.ValueFromMaxRepsIn_Table(array, min_max); 
        if not min_max then min_max = "MAX" end;
        local t = {};
        for i = 1, #array do;
            local ti = array[i];
            if not t[ti] then t[ti] = 0 end;
            t[ti] = t[ti] + 1;
        end;
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
    ValueFromMaxRepsIn_Table = Arc_Module.ValueFromMaxRepsIn_Table;
    function Arc_Module.randomOfVal(...);
        local t = {...};
        local random = math.random(#t); 
        return t[random];
    end;
    randomOfVal = Arc_Module.randomOfVal;
    function Arc_Module.invert_number(X);
        local X = X - X * 2;
        return X;
    end;
    invert_number = Arc_Module.invert_number;
    return Arc_Module;
