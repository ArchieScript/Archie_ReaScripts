--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Item
   * Description: Item;  Glue cracks in items.lua
   * Author:      Archie
   * Version:     1.0
   * Описание:    Склеить соприкасающиеся элементы
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    Archie(---)
   * Gave idea:   Kokarev Maxim(Rmm)
   * Extension:   Reaper 6.08+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.0 [060420]
   *                  + initialе
--]] 
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    local sel_item = {};
    local function Save_Selected_Items();
	   for i = 1, reaper.CountSelectedMediaItems(0) do;
		  sel_item[i] = reaper.GetSelectedMediaItem(0,i-1);
	   end;
    end;
    ---
    local function Restore_Selected_Items();
	   for i=1,#sel_item do;
		  pcall(reaper.SetMediaItemSelected,sel_item[i],1);
	   end;
    end;
    ---
    local function compare(x,y);
	   local floatShare = 0.0000001;
	   return math.abs(x-y)<floatShare;
    end;
    ---- 
    
    reaper.PreventUIRefresh(1);
    reaper.Undo_BeginBlock();
    
    local lastX;
    ::restart::;
    local pos2,track2,item2;
    local itT = {};
    local itT2 = {};
    Save_Selected_Items();
    for i = reaper.CountSelectedMediaItems(0)-1,0,-1 do;
	   local item = reaper.GetSelectedMediaItem(0,i);
	   local pos = reaper.GetMediaItemInfo_Value(item,'D_POSITION');
	   local End = reaper.GetMediaItemInfo_Value(item,'D_LENGTH')+pos; 
	   ::last::;
	   if compare(End,(pos2 or-1))and track2 == track and not lastX then;
		  if not itT2[tostring(item)]then;
			 itT2[tostring(item)]=true;
			 itT[#itT+1]=item;
		  end;
		  if not itT2[tostring(item2)]then;
			 itT2[tostring(item2)]=true;
			 itT[#itT+1]=item2;
		  end;
		  if i == 0 then lastX=1 goto last end;
	   else;
		  if #itT >= 2 then;
			 reaper.SelectAllMediaItems(0,0);
			 for t = 1,#itT do;
				reaper.SetMediaItemInfo_Value(itT[t],'B_UISEL',1);
			 end;
			 reaper.Main_OnCommand(40257,0);--Glue items
			 Restore_Selected_Items();
			 goto restart;
		  else;
			 itT = {};
		  end;
	   end;
	   pos2 = pos;
	   track2 = track;
	   item2 = item;
    end;
    
    reaper.PreventUIRefresh(-1);
    reaper.Undo_EndBlock("Glue cracks in items",-1);
    reaper.UpdateArrange();
    
    
    