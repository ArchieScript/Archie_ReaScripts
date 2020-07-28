--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Routing 
   * Description: Copy Output routing of focused plug-in 
   * Author:      Archie 
   * Version:     1.0 
   * Описание:    Копировать маршрут вывода сфокусированного плагина 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Дима Горелик(Rmm) 
   * Gave idea:   Дима Горелик(Rmm) 
   * Changelog:   v.1.0 [31.10.19] 
   *                  + initialе 
--]] 
     
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    local function CopyOutput_FocusedFX_Pin(NameScript,persist); 
     
	   local retval,tracknumber,itemnumber,fxnumber = reaper.GetFocusedFX(); 
	   local track = reaper.GetTrack(0,tracknumber-1); 
	   if not track then return -1 end; 
	    
	   local t = {}; 
	   if retval > 0 then; 
		  reaper.DeleteExtState(NameScript,"CopyOutputPlugin",persist); 
		  if itemnumber < 0 then; 
			 ---- 
			 local _,_,outputPins = reaper.TrackFX_GetIOSize(track,fxnumber); 
			 for i = 1,outputPins do; 
				local retval, high32 = reaper.TrackFX_GetPinMappings(track,fxnumber,1,i-1); 
				t[#t+1]= "{".. i-1 .. "&" .. retval.."}"; 
			 end; 
		  else; 
			 local take_numb = fxnumber >> 16; 
			 local fx_number = fxnumber & 65535; 
			 local Item = reaper.GetTrackMediaItem(track,itemnumber); 
			 local Take = reaper.GetTake(Item,take_numb); 
			 local _,_,outputPins = reaper.TakeFX_GetIOSize(Take,fx_number); 
			  
			 for i = 1,outputPins do; 
				local retval, high32 = reaper.TakeFX_GetPinMappings(Take,fx_number,1,i-1); 
				t[#t+1]= "{".. i-1 .. "&" .. retval.."}"; 
			 end;  
		  end; 
		  t = table.concat(t); 
		  reaper.SetExtState(NameScript,"CopyOutputPlugin",t,persist);--NameScript 
	   else; 
		  return -1; 
	   end; 
    end; 
     
     
    CopyOutput_FocusedFX_Pin("Archie_Rout;CopyOutputRoutingOfFocusedPlugIn.lua",false); 
    reaper.defer(function()end); 