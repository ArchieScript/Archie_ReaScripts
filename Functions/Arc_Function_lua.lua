local VersionMod = "v.2.4.4"
--[[
   * Category:    Function
   * Description: Arc_Function_lua
   * Author:      Archie
   * Version:     2.4.4
   * AboutScript: Functions for use with some scripts Archie
   * О скрипте:   Функции для использования с некоторыми скриптами Archie
   * Provides:    [nomain].
   * Function:    http://arc-website.github.io/Library_Function/Arc_Function_lua/index.html
   * ----------------------]]

local Arc_Module = {}; 
function Arc_Module.VersionArc_Function_lua(version); if not VersionMod then VersionMod = "0" else VersionMod = tostring(VersionMod);end; VersionMod = tonumber((VersionMod:gsub("%D",""))); if not VersionMod then VersionMod = (0) end; version = tonumber((tostring(version):gsub("%D",""))); if not version then version = (999^999) end; if version > VersionMod then; local path = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/(Arc_Function_lua.lua)'; reaper.ClearConsole(); reaper.ShowConsoleMsg('ENG:\n\n'.. 'The file "Arc_Function_lua" is not relevant, Obsolete.\n'.. 'Download the Arc_Function_lua file at this URL:\n\n'.. 'https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/'.. 'ArchieScript/Archie_ReaScripts/blob/master/Functions/Arc_Function_lua.lua\n\n'.. 'And put it along the way:\n\n'..path..'\n\n\n\n'.. 'RUS:\n\n'.. 'Файл "Arc_Function_lua" не актуален, Устарел.\n'.. 'Скачайте файл "Arc_Function_lua" по этому URL:\n\n'.. 'https://minhaskamal.github.io/DownGit/#/home?url=https://github.com/'.. 'ArchieScript/Archie_ReaScripts/blob/master/Functions/Arc_Function_lua.lua\n\n'.. 'И положите его по пути:\n\n'..path); return false; end; return true; end; VersionArc_Function_lua = Arc_Module.VersionArc_Function_lua; 
function Arc_Module.no_undo()reaper.defer(function()end)end; no_undo = Arc_Module.no_undo; 
function Arc_Module.Action(...); local Table = {...}; for i = 1, #Table do; reaper.Main_OnCommand(reaper.NamedCommandLookup(Table[i]),0); end; end; Action = Arc_Module.Action; 
function Arc_Module.TrackFx_Rename(Track,idx_Fx,Rename); local retval,str = reaper.GetTrackStateChunk(Track,"",false); str = string.gsub(str,"<","\n\n<").."\n\n"; local TrackChunk; local ret,buf = reaper.TrackFX_GetFXName(Track,idx_Fx,""); if ret then; local buf = buf:gsub("%(","%%("):gsub("%)","%%)") :gsub("%{","%%{"):gsub("%}","%%}") :gsub("%[","%%["):gsub("%]","%%]"); local GUID = reaper.TrackFX_GetFXGUID(Track,idx_Fx); for var in string.gmatch(str,"<.-\n\n") do; local guid = string.match(var,"FXID ({.-})"); if guid == GUID then; local pref = string.match(buf,".-: ") or ""; var = string.gsub(var,buf,pref..Rename); end; TrackChunk = (TrackChunk or "")..var; end; TrackChunk = string.gsub(TrackChunk,"\n\n","\n") reaper.SetTrackStateChunk(Track,TrackChunk,false); return true; end; return false; end; TrackFx_Rename = Arc_Module.TrackFx_Rename; 
function Arc_Module.RemoveAllSendTr(track,category); local R,Rem = false; for iS = reaper.GetTrackNumSends(track,category)-1,0,-1 do; Rem = reaper.RemoveTrackSend(track,category,iS); if Rem == true then R = true end; end; return R; end; RemoveAllSendTr = Arc_Module.RemoveAllSendTr; 
function Arc_Module.RemoveAllItemTr_Sel(track,rem_Idx); local D = false; for i = reaper.CountTrackMediaItems(track)-1,0,-1 do; local item = reaper.GetTrackMediaItem(track,i); if rem_Idx == 0 or rem_Idx == 1 then; local sel = reaper.GetMediaItemInfo_Value(item,"B_UISEL"); if sel == rem_Idx then; local Del = reaper.DeleteTrackMediaItem(track,item); if Del == true then D = true end; end; else local Del = reaper.DeleteTrackMediaItem(track,item); if Del == true then D = true end; end; end; return D; end; RemoveAllItemTr_Sel = Arc_Module.RemoveAllItemTr_Sel; 
function Arc_Module.SelectAllTracks(numb); if numb > 0 then numb = 1 else numb = 0 end; reaper.PreventUIRefresh(3864597); for i = 1, reaper.CountTracks(0) do; local track = reaper.GetTrack(0,i-1); local sel = reaper.GetMediaTrackInfo_Value(track,"I_SELECTED"); if sel == math.abs (numb - 1) then; reaper.SetMediaTrackInfo_Value(track,"I_SELECTED", numb); end; end; reaper.PreventUIRefresh(-3864597); end; SelectAllTracks = Arc_Module.SelectAllTracks; 
function Arc_Module.SaveSoloMuteSelStateAllTracksGuidSlot(Slot); local CountTracks = reaper.CountTracks(0); if CountTracks == 0 then return false end; local t = {};_G['SavSolMutSelTrSlot_'..Slot] = t; for i = 1, CountTracks do; local track = reaper.GetTrack(0, i - 1); t[i] = reaper.GetTrackGUID(track)..'{'.. reaper.GetMediaTrackInfo_Value(track,'B_MUTE')..'}{'.. reaper.GetMediaTrackInfo_Value(track,'I_SOLO')..'}{'.. reaper.GetMediaTrackInfo_Value(track,'I_SELECTED')..'}'; end; return true; end; Arc_Module.SaveSoloMuteSelStateAllTracksGuidSlot_SWS = Arc_Module.SaveSoloMuteSelStateAllTracksGuidSlot; SaveSoloMuteSelStateAllTracksGuidSlot_SWS = Arc_Module.SaveSoloMuteSelStateAllTracksGuidSlot; 
function Arc_Module.RestoreSoloMuteSelStateAllTracksGuidSlot(Slot,clean); local t = _G['SavSolMutSelTrSlot_'..Slot]; if t then; for i = 1, #t do; local guin,mute,solo,sel = string.match (t[i],'({.+}){(.+)}{(.+)}{(.+)}'); local track = reaper.BR_GetMediaTrackByGUID(0,guin); reaper.SetMediaTrackInfo_Value(track, 'B_MUTE' , mute); reaper.SetMediaTrackInfo_Value(track, 'I_SOLO' , solo); reaper.SetMediaTrackInfo_Value(track, 'I_SELECTED', sel ); end; if clean == 1 or clean == true then; _G['SavSolMutSelTrSlot_'..Slot] = nil; t = nil; end; end; end; Arc_Module.RestoreSoloMuteSelStateAllTracksGuidSlot_SWS = Arc_Module.RestoreSoloMuteSelStateAllTracksGuidSlot; RestoreSoloMuteSelStateAllTracksGuidSlot_SWS = Arc_Module.RestoreSoloMuteSelStateAllTracksGuidSlot; 
function Arc_Module.js_ReaScriptAPI(boolean,JS_API_Version); if type(JS_API_Version)~= "number" then JS_API_Version = 0 end; local MB,version,Ret; if not reaper.JS_ReaScriptAPI_Version then; if boolean == true then; MB = reaper.MB( "ENG:\n\n".. "There is no file reaper_js_ReaScriptAPI...!\n".. "Script requires an extension 'reaper_js_ReaScriptAPI'.\n".. "Install repository 'ReaTeam Extensions'.\n\n".. "Go to website ReaPack - OK. \n\n".. "RUS:\n\n".. "Отсутствует файл reaper_js_ReaScriptAPI...!\n".. "Для работы скрипта требуется расширение 'reaper_js_ReaScriptAPI'.\n".. "Установите репозиторий 'ReaTeam Extensions'\n\n".. "Перейти на сайт ReaPack - OK. \n" ,"Error.",1); end; Ret = true; else; version = reaper.JS_ReaScriptAPI_Version(); if version < JS_API_Version then; if boolean == true then; MB = reaper.MB( "ENG:\n\n".. "File reaper_js_ReaScriptAPI Outdated!\n".. "Update repository 'ReaTeam Extensions'.\n\n".. "Go to website ReaPack - OK. \n\n".. "RUS:\n\n".. "Файл reaper_js_ReaScriptAPI Устарел!\n".. "Обновите репозиторий 'ReaTeam Extensions'\n\n".. "Перейти на сайт ReaPack - OK. \n" ,"Error.",1); end; Ret = true; end; end; if MB == 1 then; local OS = reaper.GetOS(); if OS == "OSX32" or OS == "OSX64" then; os.execute("open https://reapack.com/repos"); else; os.execute("start https://reapack.com/repos"); end; end; if Ret == true then return false,version end; return true,version; end; js_ReaScriptAPI = Arc_Module.js_ReaScriptAPI; 
function Arc_Module.SWS_API(boolean); if not reaper.BR_GetMediaItemGUID then; if boolean == true then; local MB = reaper.MB( "ENG:\n\n".. "Missing extension 'SWS'!\n".. "Script requires an extension SWS.\n".. "Install extension 'SWS'. \n\n".. "Go to website SWS - OK \n\n".. "RUS:\n\n".. "Отсутствует расширение 'SWS'!\n".. "Для работы сценария требуется расширение 'SWS'\n".. "Установите расширение 'SWS'. \n\n".. "Перейти на сайт SWS - OK \n" ,"Error.",1); if MB == 1 then; local OS = reaper.GetOS(); if OS == "OSX32" or OS == "OSX64" then; os.execute("open ".."http://www.sws-extension.org/index.php"); else os.execute("start ".."http://www.sws-extension.org/index.php"); end; end; end; local function Undo()end;reaper.defer(Undo); return false; end; return true; end; SWS_API = Arc_Module.SWS_API; 
function Arc_Module.SetCollapseFolderMCP(track,clickable,is_show); if clickable == 0 or clickable == 1 then; if clickable == 0 then clickable = 1 else clickable = 0 end; if reaper.GetToggleCommandState(41154)== clickable then reaper.Main_OnCommand(41154,-1)end; end; local _,tr_chunk = reaper.GetTrackStateChunk(track,'',true); local BUSCOMP_var1 = tr_chunk:match('BUSCOMP (%d+)'); if is_show ~= 1 then is_show = 0 end; local tr_chunk_out = tr_chunk:gsub('BUSCOMP '..BUSCOMP_var1..' %d+', 'BUSCOMP '..BUSCOMP_var1..' '..is_show); reaper.SetTrackStateChunk(track, tr_chunk_out,true); end; SetCollapseFolderMCP = Arc_Module.SetCollapseFolderMCP; 
function Arc_Module.GetPathAndNameSourceMediaFile_Take(take); local guidStringTAKE = reaper.BR_GetMediaItemTakeGUID(take); local item = reaper.GetMediaItemTake_Item(take); local retval, str = reaper.GetItemStateChunk(item,"",false); local T = {}; for ChunkTake in string.gmatch(str, '.->') do; T[#T+1] = ChunkTake; end; for i = 1, #T do; for guid,pach in string.gmatch(T[i],'[^IGUID]GUID ({.-}).-FILE (".-")') do; if guid == guidStringTAKE and pach then; local Path,Name = string.match (pach, "(.+)[\\/](.+)"); Path =string.gsub(Path,'"',""); Name =string.gsub(Name,'"',""); return Path,Name; end; guid,pach = nil,nil; end; end; return false,false; end; Arc_Module.GetPathAndNameSourceMediaFile_Take_SWS = Arc_Module.GetPathAndNameSourceMediaFile_Take; GetPathAndNameSourceMediaFile_Take_SWS = Arc_Module.GetPathAndNameSourceMediaFile_Take; 
function Arc_Module.SetToggleButtonOnOff(numb,set); local _,_,sec,cmd,_,_,_ = reaper.get_action_context(); if set == 0 or set == false then; return reaper.GetToggleCommandStateEx(sec,cmd); else; reaper.SetToggleCommandState(sec,cmd,numb or 0); reaper.RefreshToolbar2(sec,cmd); end end; SetToggleButtonOnOff = Arc_Module.SetToggleButtonOnOff; Arc_Module.GetSetToggleButtonOnOff=Arc_Module.SetToggleButtonOnOff; GetSetToggleButtonOnOff=Arc_Module.SetToggleButtonOnOff; 
function Arc_Module.HelpWindow_WithOptionNotToShow(Text,Header,but,reset); local ScriptName,MessageBox = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)"); local TooltipWind = reaper.GetExtState(ScriptName..'___'..but, "HelpWindow_WithOptionNotToShow"..'___'..but); if TooltipWind == "" then; MessageBox = reaper.ShowMessageBox(Text.."\n\n\n\n".. "НЕ ПОКАЗЫВАТЬ ПОЛЬШЕ ЭТО ОКНО - ОК\nDO NOT SHOW THIS WINDOW - OK",Header,1); if MessageBox == 1 then; reaper.SetExtState(ScriptName..'___'..but, "HelpWindow_WithOptionNotToShow"..'___'..but,MessageBox,true); end; end; if reset == true then; reaper.DeleteExtState(ScriptName..'___'..but, "HelpWindow_WithOptionNotToShow"..'___'..but,true); end; if MessageBox == 2 then MessageBox = 0 end; return MessageBox or -1; end; HelpWindow_WithOptionNotToShow=Arc_Module.HelpWindow_WithOptionNotToShow; 
function Arc_Module.HelpWindowWhenReRunning(BottonText,but,reset); local ScriptName = ({reaper.get_action_context()})[2]:match(".+[\\/](.+)"); local TooltipWind = reaper.GetExtState(ScriptName..'___'..but, "HelpWindowWhenReRunning"..'___'..but); if TooltipWind == "" then; if BottonText == 2 then; BottonText = "'NEW INSTANCE'" elseif BottonText == 1 then; BottonText = "'TERMINATE INSTANCES'"else BottonText = "- ??? Error"; end; local MessageBox = reaper.ShowMessageBox( "RUS.\n\n".. "ВАЖНО:\n".. "При отключении скрипта появится окно (Reascript task control):\n".. "Для коректной работы скрипта ставим галку\n".. "(Remember my answer for this script)\n".. "Нажимаем: "..BottonText.."\n".. "\n\n".. "ENG.\n\n".. "IMPORTANTLY:\n".. "When you disable script window will appear (Reascript task control):\n".. "For correct work of the script put the check\n".. "(Remember my answer for this script)\n".. "Click: "..BottonText.."\n".. "\n\n\n".. "DO NOT SHOW THIS WINDOW - OK\n".. "НЕ ПОКАЗЫВАТЬ ПОЛЬШЕ ЭТО ОКНО - ОК", "help.",1); if MessageBox == 1 then; local MB = reaper.MB("RUS: / ENG:\n\nЗапомни ! / Remember ! \n\n"..BottonText,"help.",1); if MB == 1 then; reaper.SetExtState(ScriptName..'___'..but, "HelpWindowWhenReRunning"..'___'..but,MessageBox,true); end; end; end; if reset == true then; reaper.DeleteExtState(ScriptName..'___'..but, "HelpWindowWhenReRunning"..'___'..but,true); end; return ScriptName; end; HelpWindowWhenReRunning = Arc_Module.HelpWindowWhenReRunning; 
function Arc_Module.DeleteMediaItem(item); if item then; local tr = reaper.GetMediaItem_Track(item); reaper.DeleteTrackMediaItem(tr,item); end; end; DeleteMediaItem = Arc_Module.DeleteMediaItem; 
function Arc_Module.GetSampleNumberPosValue(take,SkipNumberOfSamplesPerChannel,FeelVolumeOfItem,FeelVolumeOfTake,FeelVolumeOfEnvelopeItem);
if not take or reaper.TakeIsMIDI(take)then return false,false,false,false,false,false,false end;
if not tonumber(SkipNumberOfSamplesPerChannel) then SkipNumberOfSamplesPerChannel = 0 end;
SkipNumberOfSamplesPerChannel = math.floor(SkipNumberOfSamplesPerChannel+0.5);
local item = reaper.GetMediaItemTake_Item(take);
local PlayRate_Original = reaper.GetMediaItemTakeInfo_Value(take,"D_PLAYRATE");
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
local CountSamples_OneChannel = math.floor(item_len*samplerate+2);
local CountSamples_AllChannels = math.floor(item_len*samplerate+2)*numchannels;
local NumberSamplesOneChan = {};
local NumberSamplesAllChan = {};
local Sample_min = {};
local Sample_max = {};
local TimeSample = {};
local breakX,multi;
for i1 = 1, item_len_idx do
local buffer = reaper.new_array(samplerate*numchannels); 
local Accessor_Samples = reaper.GetAudioAccessorSamples(
accessor , 
samplerate , 
numchannels, 
i1-1 , 
samplerate , 
buffer ) 
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
function Arc_Module.SetMediaItemLeftTrim2(position,item); reaper.PreventUIRefresh(3864598); local sel_item = {}; for i = 1, reaper.CountSelectedMediaItems(0) do; sel_item[i] = reaper.GetSelectedMediaItem(0,i-1); end; reaper.SelectAllMediaItems(0,0); reaper.SetMediaItemSelected(item,1); reaper.ApplyNudge(0,1,1,0,position,0,0); reaper.SetMediaItemSelected(item,0); for _, item in ipairs(sel_item) do; reaper.SetMediaItemSelected(item,1); end; reaper.PreventUIRefresh(-3864598); end; SetMediaItemLeftTrim2=Arc_Module.SetMediaItemLeftTrim2; 
function Arc_Module.Save_Selected_Items_GuidSlot(Slot); local CountSelItem = reaper.CountSelectedMediaItems(0); if CountSelItem == 0 then return false end; local t = {}; _G["SaveSelItem_"..Slot] = t; for i = 1, CountSelItem do; local sel_item = reaper.GetSelectedMediaItem(0,i-1); t[i] = reaper.BR_GetMediaItemGUID(sel_item); end; return true; end; Arc_Module.Save_Selected_Items_GuidSlot_SWS=Arc_Module.Save_Selected_Items_GuidSlot; Save_Selected_Items_GuidSlot_SWS=Arc_Module.Save_Selected_Items_GuidSlot; 
function Arc_Module.Restore_Selected_Items_GuidSlot(Slot,clean); t = _G["SaveSelItem_"..Slot]; if t then; reaper.SelectAllMediaItems(0,0); for i = 1, #t do; local item = reaper.BR_GetMediaItemByGUID(0,t[i]); if item then; reaper.SetMediaItemSelected(item,1); end; end; if clean == true or clean == 1 then; _G["SaveSelItem_"..Slot] = nil; t = nil; end; reaper.UpdateArrange(); end; end; Arc_Module.Restore_Selected_Items_GuidSlot_SWS=Arc_Module.Restore_Selected_Items_GuidSlot; Restore_Selected_Items_GuidSlot_SWS=Arc_Module.Restore_Selected_Items_GuidSlot; 
function Arc_Module.SaveSoloMuteStateAllTracksGuidSlot(Slot); local CountTracks = reaper.CountTracks(0); if CountTracks == 0 then return false end; local t = {};_G['SavSolMutTrSlot_'..Slot] = t; for i = 1, CountTracks do; local track = reaper.GetTrack(0, i - 1); t[i] = reaper.GetTrackGUID(track)..'{'.. reaper.GetMediaTrackInfo_Value(track,'B_MUTE')..'}{'.. reaper.GetMediaTrackInfo_Value(track,'I_SOLO')..'}'; end; return true; end; Arc_Module.SaveSoloMuteStateAllTracksGuidSlot_SWS=Arc_Module.SaveSoloMuteStateAllTracksGuidSlot; SaveSoloMuteStateAllTracksGuidSlot_SWS=Arc_Module.SaveSoloMuteStateAllTracksGuidSlot; 
function Arc_Module.RestoreSoloMuteStateAllTracksGuidSlot(Slot,clean); local t = _G['SavSolMutTrSlot_'..Slot]; if t then; for i = 1, #t do; local guin,mute,solo = string.match (t[i],'({.+}){(.+)}{(.+)}'); local track = reaper.BR_GetMediaTrackByGUID(0,guin); reaper.SetMediaTrackInfo_Value(track, 'B_MUTE', mute); reaper.SetMediaTrackInfo_Value(track, 'I_SOLO', solo); end; if clean == 1 or clean == true then; _G['SavSolMutTrSlot_'..Slot] = nil; t = nil; end; end; end; Arc_Module.RestoreSoloMuteStateAllTracksGuidSlot_SWS=Arc_Module.RestoreSoloMuteStateAllTracksGuidSlot; RestoreSoloMuteStateAllTracksGuidSlot_SWS=Arc_Module.RestoreSoloMuteStateAllTracksGuidSlot; 
function Arc_Module.SaveMuteStateAllItemsGuidSlot(Slot); local CountItem = reaper.CountMediaItems(0); if CountItem == 0 then return false end; local GuidAndMute = {}; _G["Save_GuidAndMuteSlot_"..Slot] = GuidAndMute; for i = 1, CountItem do; local Item = reaper.GetMediaItem(0,i-1); GuidAndMute[i] = reaper.BR_GetMediaItemGUID(Item)..' '.. reaper.GetMediaItemInfo_Value(Item,"B_MUTE"); end ; return true; end; Arc_Module.SaveMuteStateAllItemsGuidSlot_SWS = Arc_Module.SaveMuteStateAllItemsGuidSlot; SaveMuteStateAllItemsGuidSlot_SWS = Arc_Module.SaveMuteStateAllItemsGuidSlot; 
function Arc_Module.RestoreMuteStateAllItemsGuidSlot(Slot, clean); local T = _G["Save_GuidAndMuteSlot_"..Slot]; if T then; for i = 1, #T do; local Item = reaper.BR_GetMediaItemByGUID(0,T[i]:match("{.+}")); if Item then; reaper.SetMediaItemInfo_Value(Item,"B_MUTE",T[i]:gsub("{.+}","")); end; end; if clean == true or clean == 1 then; T = nil; _G["Save_GuidAndMuteSlot_"..Slot] = nil; end; reaper.UpdateArrange(); end end Arc_Module.RestoreMuteStateAllItemsGuidSlot_SWS = Arc_Module.RestoreMuteStateAllItemsGuidSlot; RestoreMuteStateAllItemsGuidSlot_SWS = Arc_Module.RestoreMuteStateAllItemsGuidSlot; 
function Arc_Module.GetPositionOfFirstItemAndEndOfLast(); local CountItem = reaper.CountMediaItems(0); if CountItem == 0 then return false, false end; local Fir = 99^99; local End = 0; for i = 1, CountItem do; local It = reaper.GetMediaItem(0,i-1); local Posit = reaper.GetMediaItemInfo_Value(It,"D_POSITION"); local Lengt = reaper.GetMediaItemInfo_Value(It,"D_LENGTH"); if Posit < Fir then; Fir = Posit; end; if Posit + Lengt > End then; End = Posit + Lengt; end; end; return Fir,End; end; GetPositionOfFirstItemAndEndOfLast = Arc_Module.GetPositionOfFirstItemAndEndOfLast; 
function Arc_Module.GetPositionOfFirstSelectedItemAndEndOfLast(); local CountSelItem = reaper.CountSelectedMediaItems(0); if CountSelItem == 0 then return false, false end; local Fir = 99^99; local End = 0; for i = 1, CountSelItem do; local SelIt = reaper.GetSelectedMediaItem(0,i-1); local Posit = reaper.GetMediaItemInfo_Value(SelIt,"D_POSITION"); local Lengt = reaper.GetMediaItemInfo_Value(SelIt,"D_LENGTH"); if Posit < Fir then; Fir = Posit; end; if Posit + Lengt > End then; End = Posit + Lengt; end; end; return Fir,End; end; GetPositionOfFirstSelectedItemAndEndOfLast = Arc_Module.GetPositionOfFirstSelectedItemAndEndOfLast; 
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
reaper.BR_EnvSetProperties(EnvAlloc,false ,visible,armed,
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
function Arc_Module.SaveSelTracksGuidSlot(Slot); local CountSelTrack = reaper.CountSelectedTracks(0); if CountSelTrack == 0 then return false end; local t = {}; _G['SaveSelTr_'..Slot] = t; for i = 1, reaper.CountSelectedTracks(0) do; local sel_tracks = reaper.GetSelectedTrack(0,i-1); t[i] = reaper.GetTrackGUID(sel_tracks); end; return true; end; Arc_Module.SaveSelTracksGuidSlot_SWS = Arc_Module.SaveSelTracksGuidSlot; SaveSelTracksGuidSlot_SWS = Arc_Module.SaveSelTracksGuidSlot; 
function Arc_Module.RestoreSelTracksGuidSlot(Slot,clean); local tr = reaper.GetTrack(0,0); reaper.SetOnlyTrackSelected(tr); reaper.SetMediaTrackInfo_Value(tr,"I_SELECTED",0); local t = _G['SaveSelTr_'..Slot]; if t then; for i = 1, #t do; local track = reaper.BR_GetMediaTrackByGUID(0,t[i]); if track then; reaper.SetMediaTrackInfo_Value(track,"I_SELECTED",1); end; end; if clean == 1 or clean == true then; _G['SaveSelTr_'..Slot] = nil; t = nil; end; end; end; Arc_Module.RestoreSelTracksGuidSlot_SWS = Arc_Module.RestoreSelTracksGuidSlot; RestoreSelTracksGuidSlot_SWS = Arc_Module.RestoreSelTracksGuidSlot; 
function Arc_Module.GetPreventSpectralPeaksInTrack(Track) local _,str = reaper.GetTrackStateChunk(Track,"",false); local Perf = str:match('PERF (%d+)'); if Perf == "4" then return true end return false end GetPreventSpectralPeaksInTrack = Arc_Module.GetPreventSpectralPeaksInTrack; 
function Arc_Module.SetPreventSpectralPeaksInTrack(Track,Perf); if Perf == true then Perf = 4 end; if Perf == false then Perf = 0 end; local _,str = reaper.GetTrackStateChunk(Track,"",false); local str2 = str:gsub('PERF %d+',"PERF".." "..Perf); reaper.SetTrackStateChunk(Track,str2,false); end; SetPreventSpectralPeaksInTrack = Arc_Module.SetPreventSpectralPeaksInTrack; 
function Arc_Module.CloseAllFxInAllItemsAndAllTake(chain,float); local CountItem = reaper.CountMediaItems(0); if CountItem == 0 then Arc_Module.no_undo() return -1 end; for j = CountItem-1,0,-1 do; local Item = reaper.GetMediaItem(0,j); local CountTake = reaper.CountTakes(Item); for i = CountTake-1,0,-1 do; local Take = reaper.GetMediaItemTake(Item,i); local CountTakeFX = reaper.TakeFX_GetCount(Take); for ij = CountTakeFX-1,0,-1 do; if chain == 1 or chain == true then; reaper.TakeFX_Show(Take,ij,0); end; if float == 1 or float == true then; reaper.TakeFX_Show(Take,ij,2); end; end; end; end; return true end; CloseAllFxInAllItemsAndAllTake = Arc_Module.CloseAllFxInAllItemsAndAllTake; 
function Arc_Module.SetShow_HideTrackMCP(Track,show_hide ); local _,str = reaper.GetTrackStateChunk(Track,"",true); local SHOWINMIX = str:match('SHOWINMIX %d+'); local str = string.gsub(str,SHOWINMIX, "SHOWINMIX"..' '..show_hide); reaper.SetTrackStateChunk(Track, str, true); end; SetShow_HideTrackMCP = Arc_Module.SetShow_HideTrackMCP; 
function Arc_Module.CloseAllFxInAllTracks(chain, float) local CountTr = reaper.CountTracks(0) if CountTr == 0 then reaper.ReaScriptError("No Tracks in project") Arc_Module.no_undo() return end for i = 1, CountTr do local Track = reaper.GetTrack(0,i-1) local CountFx = reaper.TrackFX_GetCount(Track) for i2 = 1, CountFx do if chain == 1 or chain == true then reaper.TrackFX_Show(Track,i2-1,0) end if float == 1 or float == true then reaper.TrackFX_Show(Track,i2-1,2) end end end end CloseAllFxInAllTracks = Arc_Module.CloseAllFxInAllTracks; 
function Arc_Module.CloseToolbarByNumber(ToolbarNumber ) local CloseToolbar_T = {[0]=41651,41679,41680,41681,41682,41683,41684,41685, 41686,41936,41937,41938,41939,41940,41941,41942,41943} local state = reaper.GetToggleCommandState(CloseToolbar_T[ToolbarNumber]) if state == 1 then reaper.Main_OnCommand(CloseToolbar_T[ToolbarNumber],0) end end CloseToolbarByNumber = Arc_Module.CloseToolbarByNumber; 
function Arc_Module.GetMediaItemInfo_Value(item, parmname); if parmname == "END" or parmname == "D_END" then return reaper.GetMediaItemInfo_Value(item,"D_POSITION")+ reaper.GetMediaItemInfo_Value(item,"D_LENGTH"); else; return reaper.GetMediaItemInfo_Value(item,parmname); end; end; GetMediaItemInfo_Value = Arc_Module.GetMediaItemInfo_Value; 
function Arc_Module.SetMediaItemInfo_Value(item, parmname,val); if parmname == "END" or parmname == "D_END" then; local pos = reaper.GetMediaItemInfo_Value(item,"D_POSITION"); return reaper.SetMediaItemInfo_Value(item,"D_LENGTH",val-pos); else; return reaper.SetMediaItemInfo_Value(item,parmname,val); end; end; SetMediaItemInfo_Value = Arc_Module.SetMediaItemInfo_Value; 
function Arc_Module.Get_Format_ProjectGrid(divisionIn) local grid_div if divisionIn < 1 then grid_div = (1 / divisionIn) if math.fmod(grid_div,3) == 0 then grid_div = "1/"..string.format("%.0f",grid_div/1.5).."T" else grid_div = "1/"..string.format("%.0f",grid_div) end else grid_div = tonumber(string.format("%.0f",divisionIn)) end return grid_div end Get_Format_ProjectGrid = Arc_Module.Get_Format_ProjectGrid; 
function Arc_Module.CountTrackSelectedMediaItems(track); local CountTrItems = reaper.CountTrackMediaItems(track); local count = 0; for i = 1,CountTrItems do; local Items = reaper.GetTrackMediaItem(track,i-1); local sel = reaper.IsMediaItemSelected(Items); if sel then count = count + 1 end; end; return count; end; CountTrackSelectedMediaItems = Arc_Module.CountTrackSelectedMediaItems; 
function Arc_Module.GetTrackSelectedMediaItems(track,idx); local CountTrItems = reaper.CountTrackMediaItems(track); local count = -1; for i = 1,CountTrItems do; local Items = reaper.GetTrackMediaItem(track,i-1); local sel = reaper.IsMediaItemSelected(Items); if sel then count = count + 1 end; if count == idx then return Items end; end; end; GetTrackSelectedMediaItems = Arc_Module.GetTrackSelectedMediaItems; 
function Arc_Module.GetSetHeigthMCPTrack(track,numb,set); local ret,err = pcall(reaper.GetTrackGUID,track);if not ret then error("GetSetHeigthMCPTrack - "..err,2)end; if set~=0 and set~=1 then error("GetSetHeigthMCPTrack - expected 0 or 1 got "..(tonumber(set)or type(set)),2)end; if set == 1 then; if type(numb)~="number"then error("bad argument #2 to 'GetSetHeigthMCPTrack' (number expected, got "..type(numb)..")",2)end; end; local retval,str = reaper.GetTrackStateChunk(track,"",false); local heigth = string.match(str,"SHOWINMIX%s+%S-%s+(%S-)%s"); if set == 1 then; if numb > 1 then numb = 1 end; if numb < 0 then numb = 0 end; local strSHOWINMIX = string.match(str,"SHOWINMIX.-\n"); local FirstHalfLine,SecondHalfLine = string.match(str,"(SHOWINMIX%s+%S-%s+)%S+(.-\n)"); local str2 = string.gsub(str,strSHOWINMIX,FirstHalfLine..numb..SecondHalfLine); reaper.SetTrackStateChunk(track,str2,false); else; return tonumber(heigth); end; end; GetSetHeigthMCPTrack = Arc_Module.GetSetHeigthMCPTrack; 
function Arc_Module.If_Equals(EqualsToThat,...); for _,v in ipairs {...} do; if v == EqualsToThat then return true end; end; return false; end; If_Equals = Arc_Module.If_Equals; 
function Arc_Module.ValueFromMaxRepsIn_Table(array, min_max); if not min_max then min_max = "MAX" end; local t = {}; for i = 1, #array do; local ti = array[i]; if not t[ti] then t[ti] = 0 end; t[ti] = t[ti] + 1; end; local max = 0; local value; for key, val in pairs(t) do; if val > 1 then; if val > max then; value = key; max = val; elseif val == max then; if val > 1 then; if min_max == "MAX" then; value = math.max(key ,value); elseif min_max == "MIN" then; value = math.min(key ,value); elseif min_max == "RANDOM" then; local rand_T = {key,value}; local random = math.random(#rand_T); value = rand_T[random]; end; end; end; else; if not value then value = false end end; end; return(value); end; ValueFromMaxRepsIn_Table = Arc_Module.ValueFromMaxRepsIn_Table; 
function Arc_Module.randomOfVal(...); local t = {...}; local random = math.random(#t); return t[random]; end; randomOfVal = Arc_Module.randomOfVal; 
function Arc_Module.invert_number(X); local X = X - X * 2; return X; end; invert_number = Arc_Module.invert_number; 
return Arc_Module; 