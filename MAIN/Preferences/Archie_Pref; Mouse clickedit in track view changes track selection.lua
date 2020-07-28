--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Preferences 
   * Description: Mouse click/edit in track view changes track selection 
   * Author:      Archie 
   * Version:     1.0 
   * Описание:    Щелчок мыши / редактирование в режиме просмотра трека изменяет выбор трека 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    smrz1(Rmm) 
   * Gave idea:   smrz1(Rmm) 
   * Extension:   Reaper 5.981+ http://www.reaper.fm/ 
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php 
   * Changelog:   v.1.0 [1.12.19] 
   *                  + initialе 
--]] 
     
     
    --====================================================================================== 
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\ 
    --====================================================================================== 
     
    -- WARNING: New instance  
    -- http://avatars.mds.yandex.net/get-pdb/2187751/fdabe0ce-d16b-4b96-9aaa-f3cfe5599773/s1200 
     
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
     
    ------------------------------------------------------- 
    local function no_undo()reaper.defer(function()end)end; 
    ------------------------------------------------------- 
     
     
    local track_sel_mouse = reaper.SNM_GetIntConfigVar("trackselonmouse",0); 
    local tselm; 
     
    if track_sel_mouse == 0 then; 
     
        tselm = track_sel_mouse | (track_sel_mouse | 1); 
        reaper.SNM_SetIntConfigVar("trackselonmouse",tselm); 
          
    else; 
     
        tselm = track_sel_mouse &~ (track_sel_mouse  &1); 
        reaper.SNM_SetIntConfigVar("trackselonmouse",tselm); 
         
    end; 
     
     
    local ActiveOn,ActiveOff; 
    local ActiveDoubleScr,stopDoubleScr; 
    local _,extnameProj,sec,cmd,_,_,_ = reaper.get_action_context(); 
     
     
    function loop(); 
         
        ----- stop Double Script ------- 
        if not ActiveDoubleScr then; 
            stopDoubleScr = (tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr"))or 0)+1; 
            reaper.SetExtState(extnameProj,"stopDoubleScr",stopDoubleScr,false); 
            ActiveDoubleScr = true; 
        end; 
         
        local stopDoubleScr2 = tonumber(reaper.GetExtState(extnameProj,"stopDoubleScr")); 
        if stopDoubleScr2 > stopDoubleScr then  return  end; 
        -------------------------------- 
         
        local trackselonmouse = reaper.SNM_GetIntConfigVar("trackselonmouse",0)&1; 
         
        if trackselonmouse == 0 then; 
            if not ActiveOff then; 
                reaper.SetToggleCommandState(sec,cmd,0); 
                reaper.RefreshToolbar2(sec, cmd); 
                ActiveOn = nil; 
                ActiveOff = true; 
            end; 
        else; 
            if not ActiveOn then; 
                reaper.SetToggleCommandState(sec,cmd,1); 
                reaper.RefreshToolbar2(sec, cmd); 
                ActiveOff = nil; 
                ActiveOn = true; 
            end; 
        end; 
        reaper.defer(loop); 
    end; 
     
    loop(); 
    no_undo(); 