--[[ 
   * Category:    Item 
   * Description: Smart Template - Add media file(item) by name on track(s) 
   * Author:      Archie 
   * Version:     1.02 
   * AboutScript: --- 
   * О скрипте:   Умный шаблон - добавить медиа-файл(элемент) по имени на трек(и)          
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Maestro Sound[RMM] 
   * Gave idea:   Maestro Sound[RMM] 
   * Changelog:    
   *              + v.1.02 [02022020] 
   *                  Fix bug: add item to cursor 
    
   *              +  initialе / v.1.0 [07082019] 
    
    
   -- Тест только на windows  /  Test only on windows. 
   --======================================================================================= 
	    SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:          
   (+) - required for installation      | (+) - обязательно для установки 
   (-) - not necessary for installation | (-) - не обязательно для установки 
   ----------------------------------------------------------------------------------------- 
   (+ ) Reaper v.5.981 +           --| http://www.reaper.fm/download.php                      
   (- ) SWS v.2.10.0 +             --| http://www.sws-extension.org/index.php                 
   (- ) ReaPack v.1.2.2 +          --| http://reapack.com/repos                               
   (- ) Arc_Function_lua v.2.4.4 + --| Repository - Archie-ReaScripts  http://clck.ru/EjERc   
   (+?) reaper_js_ReaScriptAPI64   --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw     
   (- ) Visual Studio С++ 2015     --|  http://clck.ru/Eq5o6                                 
   =======================================================================================]] 
     
     
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    --------------------------------------------------------- 
    local function no_undo();reaper.defer(function()end);end; 
    --------------------------------------------------------- 
     
     
    local ScriptPath, ScriptName = ({reaper.get_action_context()})[2]:match("(.+)[/\\](.+)"); 
     
    ::Repeat:: 
    local retval, filename_N = reaper.GetUserFileNameForRead("","Add File / "..ScriptName,""); 
    if not retval then no_undo()return end; 
    filename_N = filename_N:gsub("%\\","/"); 
    local source = reaper.PCM_Source_CreateFromFile(filename_N); 
    local NumChannels = reaper.GetMediaSourceNumChannels(source); 
    if type(NumChannels) == "number" and NumChannels < 1 then; 
	   local MB = reaper.MB("Eng:\n * Error\n * Invalid file format. Choose the correct format\n\n".. 
					    "Rus:\n * Ошибка\n * Неверный формат файла. Выберите правильный формат","Woops",5); 
	   if MB == 4 then goto Repeat else no_undo() return end; 
    end; 
     
    local PATH_N       = filename_N 
    local titleUndo_N  = "Add media file(item) by name ("..filename_N:match(".+[/\\](.+)%..-$")..") on track(s)"; 
    local nameScript_N = "Archie_Item;  "..titleUndo_N..".lua" 
    -----     
     
     
    local in_file = io.open(ScriptPath.."/"..nameScript_N,"r"); 
    if in_file then; 
	   in_file:close(); 
	   local MB = reaper.MB("Eng:\n * This script already exists !\n * Overwrite it ? OK\n\n".. 
					    "Rus:\n * Такой скрипт уже существует !\n * Перезаписать его ? OK\n\n\n".. 
					    " Script: \n * "..nameScript_N, 
					    "Error !",1); 
	   if MB == 2 then no_undo() return end; 
    end; 
     
     
    -- / read / -- 
    local in_file = io.open(ScriptPath.."/"..ScriptName,"r"); 
    local StartWrite; 
    for line in in_file:lines() do; 
	   if line == line:match("^[%s-local]+function%s-AddItemByNameToSelectedTracks%(.+$") then StartWrite = 0 end; 
	   if line == line:match("^[-%[%]%s]+AddItemByNameToSelectedTracks%(.+$")then; 
		  line = "    AddItemByNameToSelectedTracks('"..PATH_N.."','"..titleUndo_N.."');"; 
		  StartWrite = 1; 
	   end; 
	   if StartWrite then; 
		  Write_Script = (Write_Script or "--"..ScriptName.."\n\n\n\n\n")..line.."\n"; 
		  if StartWrite == 1 then; 
			 StartWrite = nil; 
		  end; 
	   end; 
    end; 
    in_file:close(); 
    --------------- 
     
     
    -- / write / -- 
    in_file = io.open(ScriptPath.."/"..nameScript_N,"w"); 
    in_file:write(Write_Script); 
    in_file:close(); 
    reaper.AddRemoveReaScript(true,0,ScriptPath.."/"..nameScript_N,true); 
    --------------- 
     
     
     
    reaper.ShowConsoleMsg(""); 
    reaper.ShowConsoleMsg("Rus:\n".. 
					 " * СОЗДАН СКРИПТ \n".. 
					 " * "..nameScript_N.."\n".. 
					 " * ИЩИТЕ В ЭКШЕН ЛИСТЕ \n".. 
					 "-----------------------------------------------\n\n".. 
					 "Eng:\n".. 
					 " * SCRIPT CREATED \n".. 
					 " * "..nameScript_N.."\n".. 
					 " * SEARCH THE ACTION LIST\n".. 
					 "-------------------------------------------------"); 
    if reaper.APIExists("JS_Window_Find")then; 
	   reaper.ShowActionList(); 
	   local winHWND = reaper.JS_Window_Find("Actions",true); 
	   local filter_Act = reaper.JS_Window_FindChildByID(winHWND,1324); 
	   reaper.JS_Window_SetTitle(filter_Act,nameScript_N); 
	   --- 
	   local winHWND = reaper.JS_Window_Find("ReaScript console output",true); 
	   local _,_, scr_x, scr_y = reaper.my_getViewport(0,0,0,0,0,0,0,0,1); 
	   reaper.JS_Window_SetPosition(winHWND,scr_x/2-200,scr_y/2-140,400,280); 
	   reaper.JS_Window_SetForeground(winHWND); 
	   reaper.JS_Window_SetTitle(winHWND,ScriptName) 
    end; 
     
     
     
     
    --------------------------------------------------------------------------------------------------- 
    --------------------------------------------------------------------------------------------------- 
    local function AddItemByNameToSelectedTracks(PATH,titleUndo); 
	    
	   --------------------------------------------------------- 
	   local function no_undo();reaper.defer(function()end);end; 
	   --------------------------------------------------------- 
	    
	    
	   local in_file = io.open(PATH,"r"); 
	   if not in_file then goto RemoveScript end; 
	   in_file:close(); 
	    
	    
	   do; 
		 ----------------------------------------------------- 
		  local CountSelTrack = reaper.CountSelectedTracks(0); 
		  if CountSelTrack == 0 then; --no_undo() return end; 
			 local CountTrack = reaper.CountTracks(0); 
			 if CountTrack == 0 then; 
				no_undo() return; 
			 else; 
				reaper.InsertTrackAtIndex(CountTrack,false); 
				local Track = reaper.GetTrack(0,CountTrack); 
				reaper.SetMediaTrackInfo_Value(Track,"I_SELECTED",1); 
				CountSelTrack = reaper.CountSelectedTracks(0); 
			 end; 
		  end; 
		   
		   
		  reaper.Undo_BeginBlock(); 
		  reaper.PreventUIRefresh(1); 
	     
		  local CursorPosition = reaper.GetCursorPosition(); 
		  reaper.SelectAllMediaItems(0,0); 
		   
		  local source = reaper.PCM_Source_CreateFromFile(PATH); 
		  local NumChannels = reaper.GetMediaSourceNumChannels(source); 
		  if NumChannels > 0 then; 
			 for i = 1,CountSelTrack do; 
				local Track_Sel = reaper.GetSelectedTrack(0,i-1); 
				local NewItem = reaper.CreateNewMIDIItemInProj(Track_Sel,CursorPosition,CursorPosition+0.5,false); 
				local Take = reaper.GetActiveTake(NewItem); 
				local retval,lengthIsQN = reaper.GetMediaSourceLength(source); 
				if lengthIsQN then; 
				    retval = reaper.TimeMap2_QNToTime(-1,retval); 
				end; 
				reaper.SetMediaItemInfo_Value(NewItem,'D_LENGTH',retval); 
				reaper.GetSetMediaItemTakeInfo_String(Take,"P_NAME",PATH:match(".+[/\\](.+)"),1); 
				reaper.SetMediaItemInfo_Value(NewItem,'B_UISEL',1); 
				reaper.SetMediaItemTake_Source(Take,source); 
				reaper.SetEditCurPos(CursorPosition+retval,true,false); 
			 end; 
		  end; 
		  reaper.Main_OnCommand(40047,0); -- build missing peaks 
		  reaper.UpdateArrange(); 
		   
		  reaper.PreventUIRefresh(-1); 
		  reaper.Undo_EndBlock(titleUndo,-1); 
		  ----------------------------------- 
	   end; 
	    
	    
	   ---------------- 
	   ::RemoveScript:: 
	   if not in_file then; 
		  local MB = reaper.MB( 
				  'Eng:\nThere is no file on this path !\n'.. 
				  'Delete the script and create a new one using\n'.. 
				  '"Archie_Item; Smart Template Add item by name to selected tracks.lua"\n\n'.. 
				  'TO REMOVE THE SCRIPT ?\n\n\n'.. 
				  'Rus:\nОтсутствует файл по данному пути !\n'.. 
				  'Удалите скрипт и создайте новый с помощью\n'.. 
				  '"Archie_Item;  Smart Template Add item by name to selected tracks.lua"\n\n'.. 
				  'УДАЛИТЬ СКРИПТ ?' 
				  ,"Woops",1); 
		  if MB == 2 then no_undo() return end; 
		   
		  local ScriptPath = ({reaper.get_action_context()})[2]; 
		     
		  reaper.AddRemoveReaScript(false,0,ScriptPath,true); 
		  os.remove(ScriptPath); 
		  no_undo(); 
	   end; 
	   ------------------------ 
    end; 
    --[[AddItemByNameToSelectedTracks(PATH_N,titleUndo_N);]] 
    --------------------------------------------------------------------------------------------------- 
    --------------------------------------------------------------------------------------------------- 