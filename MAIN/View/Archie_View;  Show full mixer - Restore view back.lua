--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    View
   * Description: Show full mixer - Restore view back
   * Author:      Archie
   * Version:     1.0
   * Описание:    Показать полный микшер - восстановить вид назад
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    smrz1(Rmm Forum)
   * Gave idea:   smrz1(Rmm Forum)
   *                              http://rmmedia.ru/threads/134701/post-2397574
   * Extension:   Reaper 5.983+ http://www.reaper.fm/
   *              !? reaper_js_ReaScriptAPI64 Repository - (ReaTeam Extensions) http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw
   *              Arc_Function_lua v.2.6.5+  (Repository: Archie-ReaScripts) http://clck.ru/EjERc
   * Changelog:   v.1.0 [24.09.19]
   *                  + initialе
--]]
    
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    local POSITION_MASTER =  -1
				   -- = -1 Мастер трек в микшере в зависимости от настроек в Reaper.
				   -- =  0 Мастер трек в микшере всегда слева.
				   -- =  1 Мастер трек в микшере всегда справа.
						 ------------------------------------
				   -- = -1 Master track in the mixer, depending on the settings in Reaper.
				   -- =  0 Master track in the mixer is always on the left.
				   -- =  1 Master track in the mixer is always on the right.
				   ---------------------------------------------------------
    
    
    
    local MIXER_FULL_SCREEN = 1
					-- = 0 Окно микшера будет открываться в предыдущем размере
					-- = 1 Окно микшера будет открываться в полноэкранном размере*
					--   * Требуется расширение reaper_js_ReaScriptAPI
				   
					-- = 0 Mixer window will open at an affordable size.
					-- = 1 Mixer window will open in full screen.*
					--   * Extension required reaper_js_ReaScriptAPI
					------------------------------------------------
					
    
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================    
    
    
    
    
    --============== FUNCTION MODULE FUNCTION ========================= FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    local Fun,Load,Arc = reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions'; Load,Arc = pcall(dofile,Fun..'/Arc_Function_lua.lua');--====
    if not Load then reaper.RecursiveCreateDirectory(Fun,0);reaper.MB('Missing file / Отсутствует файл !\n\n'..Fun..'/Arc_Function_lua.lua',"Error",0);
    return end; if not Arc.VersionArc_Function_lua("2.6.5",Fun,"")then Arc.no_undo() return end;--=====================================================
    --============== FUNCTION MODULE FUNCTION ======▲=▲=▲============== FUNCTION MODULE FUNCTION ============== FUNCTION MODULE FUNCTION ==============
    
    
    
    local scrName = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)");
    local section = "MIXER__"..scrName;
    
    Arc.HelpWindowWhenReRunning(2,"Arc_Function_lua",false,"/ "..scrName);
    
    local function showMixer();
	   
	   local mixerInDocker = reaper.GetToggleCommandStateEx(0,40083); -- mixer in Docker
	   local mixerVisible  = reaper.GetToggleCommandStateEx(0,40078); -- mixerVisible
	   local masterDocked  = reaper.GetToggleCommandStateEx(0,41610); -- master in Docker
	   local masterSepWind = reaper.GetToggleCommandStateEx(0,41636); -- master Separate Window
	   
	   if reaper.HasExtState(section,"mixerInDocker")then;
		  reaper.DeleteExtState(section,"mixerInDocker",true);
	   end;
	   if reaper.HasExtState(section,"mixerVisible")then;
		  reaper.DeleteExtState(section,"mixerVisible",true);
	   end;
	   if reaper.HasExtState(section,"masterDocked")then;
		  reaper.DeleteExtState(section,"masterDocked",true);
	   end;
	   if reaper.HasExtState(section,"masterSepWind")then;
		  reaper.DeleteExtState(section,"masterSepWind",true);
	   end;
	   
	   reaper.SetExtState(section,"mixerInDocker",mixerInDocker,true);
	   reaper.SetExtState(section,"mixerVisible" ,mixerVisible ,true);
	   reaper.SetExtState(section,"masterDocked" ,masterDocked ,true);
	   reaper.SetExtState(section,"masterSepWind",masterSepWind,true);
	   
	   -----
	   if POSITION_MASTER == 0 or POSITION_MASTER == 1 then;
		  local masterShowRight = reaper.GetToggleCommandStateEx(0,40389); -- master track show right
		  
		  if reaper.HasExtState(section,"masterShowRight")then;
			 reaper.DeleteExtState(section,"masterShowRight",true);
		  end;
		  
		  reaper.SetExtState(section,"masterShowRight",masterShowRight,true);
		  if POSITION_MASTER == 0 and masterShowRight == 1 then;
			 reaper.Main_OnCommand(40389,0);
		  elseif POSITION_MASTER == 1 and masterShowRight == 0 then;
			 reaper.Main_OnCommand(40389,0);
		  end;
	   else;
		  if not reaper.GetExtState(section,"masterShowRight")==""then;
			 reaper.DeleteExtState(section,"masterShowRight",true);
		  end;
	   end;
	   -----
	   
	   local masterSepWind = reaper.GetToggleCommandStateEx(0,41636); -- master Separate Window
	   if masterSepWind == 1 then;
		  reaper.Main_OnCommand(41636,0);
	   end;
	   
	   local masterDocked = reaper.GetToggleCommandStateEx(0,41610); -- master in Docker
	   if masterDocked == 1 then;
		  reaper.Main_OnCommand(41610,0);
	   end;
	   
	   local mixerInDocker = reaper.GetToggleCommandStateEx(0,40083); -- mixer in Docker
	   if mixerInDocker == 1 then;
		  reaper.Main_OnCommand(40083,0);
	   end;
	   
	   local mixerVisible = reaper.GetToggleCommandStateEx(0,40078); -- mixerVisible
	   if mixerVisible == 0 then;
		  reaper.Main_OnCommand(40078,0);
	   end;
	   
	   ------ / Mixer Full Screen / -----
	   if MIXER_FULL_SCREEN == 1 then;
		  if reaper.APIExists("JS_Window_Find") then;
			 local Window_Mixer = reaper.JS_Window_Find("Mixer",true);
			 if Window_Mixer then;
				local _,_, scr_x, scr_y = reaper.my_getViewport(0,0,0,0,0,0,0,0,1);
				reaper.JS_Window_SetPosition(Window_Mixer,0,0,scr_x, scr_y);
			 end;
		  end;
	   end;
	   -----
    end;
    
    
    local function restoreView();
	   
	   local mixerVisibleEx  = tonumber(reaper.GetExtState(section,"mixerVisible" ));
	   local mixerInDockerEx = tonumber(reaper.GetExtState(section,"mixerInDocker"));
	   local masterDockedEx  = tonumber(reaper.GetExtState(section,"masterDocked" ));
	   local masterSepWindEx = tonumber(reaper.GetExtState(section,"masterSepWind"));
	   
	   if not mixerVisibleEx or not mixerInDockerEx or not masterDockedEx or not masterSepWindEx then;
		  local str = "Rus:\n\nДа: Закрыть Микшер\nНет: Отправить Микшер в док\n"..("-"):rep(30).."\n\n"..
				    "Eng:\n\nYes: Close Mixer\nNo: Send the Mixer in the dock\n"..("-"):rep(30);
		  local MB = reaper.MB(str,"Close Mixer",3);
		  if MB == 2 then no_undo() return end;
		  if MB == 6 then;
			 local mixerVisible = reaper.GetToggleCommandStateEx(0,40078); -- mixerVisible
			 if mixerVisible == 1 then reaper.Main_OnCommand(40078,0) end;
		  end;
		  if MB == 7 then;
			 local mixerInDocker = reaper.GetToggleCommandStateEx(0,40083); -- mixer in Docker
			 if mixerInDocker == 0 then reaper.Main_OnCommand(40083,0) end;
		  end;   
	   else;
		  
		  if POSITION_MASTER == 0 or POSITION_MASTER == 1 then;
			 local masterShowRightEx = tonumber(reaper.GetExtState(section,"masterShowRight"));
			 if masterShowRightEx then;
				local masterShowRight = reaper.GetToggleCommandStateEx(0,40389); -- master track show right
				if masterShowRight ~= masterShowRightEx then;
				    reaper.Main_OnCommand(40389,0);
				end;
			 end;
		  end;
		  
		  local masterDocked  = reaper.GetToggleCommandStateEx(0,41610); -- master in Docker
		  if masterDocked ~= masterDockedEx then;
			 reaper.Main_OnCommand(41610,0);
		  end;
		  
		  local masterSepWind = reaper.GetToggleCommandStateEx(0,41636); -- master Separate Window
		  if masterSepWind ~= masterSepWindEx then;
			 reaper.Main_OnCommand(41636,0);
		  end;
		  
		  if mixerVisibleEx ~= 0 then
			  local mixerInDocker = reaper.GetToggleCommandStateEx(0,40083); -- mixer in Docker
			  if mixerInDocker ~= mixerInDockerEx then;
				 reaper.Main_OnCommand(40083,0);
			  end;
		  end;
		  
		  local mixerVisible  = reaper.GetToggleCommandStateEx(0,40078); -- mixerVisible
		  if mixerVisible ~= mixerVisibleEx then;
			 reaper.Main_OnCommand(40078,0); 
		  end;  
	   end;
	   
	   if reaper.HasExtState(section,"mixerVisible")then;
		  reaper.DeleteExtState(section,"mixerVisible",true);
	   end;
	   
	   if reaper.HasExtState(section,"mixerInDocker")then;
		  reaper.DeleteExtState(section,"mixerInDocker",true);
	   end;
	   
	   if reaper.HasExtState(section,"masterDocked")then;
		  reaper.DeleteExtState(section,"masterDocked",true);
	   end;
	   
	   if reaper.HasExtState(section,"masterSepWind")then;
		  reaper.DeleteExtState(section,"masterSepWind",true);
	   end;
	   
	   if reaper.HasExtState(section,"masterShowRight")then;
		  reaper.DeleteExtState(section,"masterShowRight",true);
	   end; 
    end;  
    
    
    local function loop();
	   --t=(t or 0)+1;
	   --reaper.ShowConsoleMsg(t);
	   
	   local returnLoop = tonumber(reaper.GetExtState(section,"returnLoop"));
	   if returnLoop then;
		  reaper.DeleteExtState(section,"returnLoop",false);
		  no_undo() return;
	   end;
	   
	   local mixerVis = reaper.GetToggleCommandStateEx(0,40078); -- mixerVisible
	   if mixerVis == 0 then;
		  restoreView();
		  no_undo() return;
	   end;
	   reaper.defer(loop);
    end;
    
    
    local mixerInDocker = reaper.GetToggleCommandStateEx(0,40083); -- mixer in Docker
    local mixerVisible  = reaper.GetToggleCommandStateEx(0,40078); -- mixerVisible
    if mixerInDocker == 1 or mixerVisible == 0 then;--show mixer
	   -----
	   showMixer();
	   reaper.DeleteExtState(section,"returnLoop",false);
	   loop();
    else; -- hide mixer
	  reaper.SetExtState(section,"returnLoop",1,false);
	  restoreView();
    end;
    
    no_undo();
    reaper.UpdateArrange();--На всякий случай.))