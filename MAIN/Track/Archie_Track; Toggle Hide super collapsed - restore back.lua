--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Track 
   * Description: Track; Toggle Hide super collapsed - restore back.lua 
   * Author:      Archie 
   * Version:     1.0 
   * Описание:    Трек;  скрыть супер свернутые - восстановить обратно 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   *              http://vk.com/reaarchie 
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000 
   * Customer:    Archie(---) 
   * Gave idea:   Archie(---) 
   * Extension:   Reaper 6.05+ http://www.reaper.fm/ 
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php 
   * Changelog:    
   *              v.1.0 [260320] 
   *                  + initialе 
--]]  
  --====================================================================================== 
  --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\ 
  --====================================================================================== 
   
  local MIN_HEIGHT = 4   -- Pixel; 
   
  --====================================================================================== 
  --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
  --====================================================================================== 
   
   
   
  ------------------------------------------------------- 
  local function no_undo()reaper.defer(function()end)end; 
  ------------------------------------------------------- 
   
   
  local CountTracks = reaper.CountTracks(0); 
  if CountTracks == 0 then return no_undo() end; 
   
  MIN_HEIGHT = tonumber(MIN_HEIGHT)or 4; 
                    
  local extname = 'ARCHIE_HIDE_SUPER_COLLAPSE__RESTORE_BACK'; 
  local _,ScriptWay,sec,cmd,_,_,_ = reaper.get_action_context(); 
   
   
  local ret = reaper.EnumProjExtState(0,extname,0); 
  if not ret then; 
     
    for i = 1,CountTracks do; 
      local track = reaper.GetTrack(0,i-1); 
      local height = reaper.GetMediaTrackInfo_Value(track,'I_TCPH') 
      if height <= MIN_HEIGHT then; 
        local visible = reaper.IsTrackVisible(track,false); 
        if visible then; 
          local GUID = reaper.GetTrackGUID(track); 
          reaper.SetMediaTrackInfo_Value(track,'B_SHOWINTCP',0); 
          reaper.SetProjExtState(0,extname,GUID,0); 
          if not ButtonOn then; 
            local state = reaper.GetToggleCommandStateEx(sec,cmd); 
            if state ~= 1 then; 
              reaper.SetToggleCommandState(sec,cmd,1); 
            end; 
            ButtonOn = true; 
          end; 
        end; 
      end; 
    end; 
     
  else; 
     
    ---- 
    local i = 0; 
    while 0 do; 
      i=i+1; 
      local retval,key,val = reaper.EnumProjExtState(0,extname,i-1); 
      if not retval then break end; 
      local track = reaper.BR_GetMediaTrackByGUID(0,key); 
      if track then; 
          reaper.SetMediaTrackInfo_Value(track,'B_SHOWINTCP',1); 
      end; 
    end; 
    ---- 
    while 0 do; 
      local retval,key,val = reaper.EnumProjExtState(0,extname,0); 
      if not retval then break end; 
      reaper.SetProjExtState(0,extname,key,''); 
    end; 
    ---- 
    local state = reaper.GetToggleCommandStateEx(sec,cmd); 
    if state ~= 0 then; 
      reaper.SetToggleCommandState(sec,cmd,0); 
    end; 
     
  end; 
   
   
  reaper.RefreshToolbar2(sec,cmd); 
  reaper.TrackList_AdjustWindows(true); 
   
  no_undo(); 
   
   
   
   