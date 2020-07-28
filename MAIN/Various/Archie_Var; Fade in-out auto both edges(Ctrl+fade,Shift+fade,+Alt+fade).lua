--[[ 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Various 
   * Description: Fade in-out auto both edges(Ctrl+fade,Shift+fade,*+Alt+fade)              
   * Author:      Archie 
   * Version:     1.0 
   * AboutScript: Fade in-out auto both edges(Ctrl+fade-evenly, Shift+fade-initial,Ctrl/Shift+Alt+fade- All sel items) 
   * О скрипте:   Повышение затухание автоматически оба края (Ctrl+fade-равномерно,Shift+fade-исходный,Ctrl/Shift+Alt+fade все выделенные элементы) 
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * Donation:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Iskander,AlexLazer(RMM) 
   * Gave idea:   Iskander,AlexLazer(RMM) 
   * Changelog:   v.1.0 [03.07.19] 
   *                  + initialе 
 
    -- Тест только на windows  /  Test only on windows. 
    --======================================================================================= 
       SYSTEM REQUIREMENTS:           |  СИСТЕМНЫЕ ТРЕБОВАНИЯ:          
    (+) - required for installation      | (+) - обязательно для установки 
    (-) - not necessary for installation | (-) - не обязательно для установки 
    ----------------------------------------------------------------------------------------- 
    (+) Reaper v.5.978 +            --| http://www.reaper.fm/download.php 
    (-) SWS v.2.10.0 +              --| http://www.sws-extension.org/index.php 
    (-) ReaPack v.1.2.2 +           --| http://reapack.com/repos 
    (-) Arc_Function_lua v.2.4.4 +  --| Repository - Archie-ReaScripts  http://clck.ru/EjERc   
    (+) reaper_js_ReaScriptAPI64    --| Repository - ReaTeam Extensions http://clck.ru/Eo5Nr or http://clck.ru/Eo5Lw     
    (-) Visual Studio С++ 2015      --|  http://clck.ru/Eq5o6 
    =======================================================================================]]  
     
     
     
    --====================================================================================== 
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
     
            -- ** При отключении скрипта появится окно "Reascript task control:" 
            --    Для коректной работы скрипта ставим галку(Remember my answer for this script) 
            --    Нажимаем: 'TERMINATE INSTANCES' 
                  ----------------------- 
            -- ** When you disable script window will appear (Reascript task controll, 
            --    For correct work of the script put the check 
            --    (Remember my answer for this script) 
            --    Click: 'TERMINATE INSTANCES' 
            ---------------------------------- 
     
     
     
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    ------------------------------------------------ 
    function no_undo()reaper.defer(function()end)end 
    ------------------------------------------------ 
     
     
    local APIExists = reaper.APIExists("JS_Mouse_GetState"); 
    if not APIExists then; 
        reaper.MB('Eng\n'.. 
                  'Missing extension "js_ReaScriptAPI" \n'.. 
                  'Install repository "ReaTeam Extensions" \n\n'.. 
                  'Rus \n'.. 
                  'Отсутствует расширение "js_ReaScriptAPI" \n'.. 
                  'Установите репозиторий "ReaTeam Extensions" \n',"ERROR",0); 
                  no_undo() return; 
    end; 
     
     
    local fadeIn,fadeOut,fadeIn2,fadeOut2,posIt,lenIt,retval2,fadeOutActive,fadeInActive 
     
    function loop() 
         
        local retval, position = reaper.BR_ItemAtMouseCursor(); 
         
        if retval or retval2 then; 
             
              GetState = reaper.JS_Mouse_GetState(127); 
            if GetState == 5 or GetState == 21 or GetState == 9 or GetState == 25 then; 
                 
                if not retval2 then; 
                    retval2 = retval; 
                end; 
                 
                if not fadeOutActive and not fadeInActive then; 
                 
                    if not fadeOut and not fadeIn then; 
                        fadeOut = reaper.GetMediaItemInfo_Value(retval2 ,"D_FADEOUTLEN"); 
                        fadeIn = reaper.GetMediaItemInfo_Value(retval2,"D_FADEINLEN");               
                    end; 
                 
                    fadeIn2 = reaper.GetMediaItemInfo_Value(retval2,"D_FADEINLEN"); 
                    fadeOut2 = reaper.GetMediaItemInfo_Value(retval2 ,"D_FADEOUTLEN"); 
                     
                    if fadeIn ~= fadeIn2 then; 
                        fadeInActive = true; 
                    elseif fadeOut ~= fadeOut2 then; 
                        fadeOutActive = true; 
                    end; 
                end; 
                 
                --- 
                if fadeInActive or fadeOutActive then; 
                    posIt = reaper.GetMediaItemInfo_Value(retval2,"D_POSITION"); 
                    lenIt = reaper.GetMediaItemInfo_Value(retval2,"D_LENGTH"); 
                end; 
                --- 
                 
                 
                 
                if GetState == 9 or GetState == 25 then; 
                    if fadeInActive then; 
                             
                        local fadeInS2 = reaper.GetMediaItemInfo_Value(retval2,"D_FADEINLEN"); 
                        local SaveFade = fadeInS2-(fadeIn - fadeOut); 
                        if SaveFade < 0 then SaveFade = 0 end; 
                        reaper.SetMediaItemInfo_Value(retval2,"D_FADEOUTLEN",SaveFade); 
                         
                    elseif fadeOutActive then;      
                         
                        fadeOut2 = reaper.GetMediaItemInfo_Value(retval2,"D_FADEOUTLEN"); 
                        SaveFade = fadeOut2-(fadeOut - fadeIn); 
                        if SaveFade < 0 then SaveFade = 0 end; 
                        reaper.SetMediaItemInfo_Value(retval2,"D_FADEINLEN",SaveFade);                
                    end;     
                end; 
                 
                 
                 
                 
                if GetState == 5 or GetState == 21 then; 
                    if fadeInActive then; 
                         
                        local fadeIn = reaper.GetMediaItemInfo_Value(retval2,"D_FADEINLEN"); 
                        if fadeIn < lenIt/2 then; 
                            reaper.SetMediaItemInfo_Value(retval2,"D_FADEOUTLEN",fadeIn); 
                        else; 
                             reaper.SetMediaItemInfo_Value(retval2,"D_FADEOUTLEN",lenIt-fadeIn); 
                        end; 
                          
                    elseif fadeOutActive then; 
                         
                        local fadeOut = reaper.GetMediaItemInfo_Value(retval2,"D_FADEOUTLEN"); 
                        if fadeOut < lenIt/2 then; 
                            reaper.SetMediaItemInfo_Value(retval2,"D_FADEINLEN",fadeOut); 
                        else; 
                            reaper.SetMediaItemInfo_Value(retval2,"D_FADEINLEN",lenIt-fadeOut); 
                        end; 
                    end; 
                end; 
                 
                 
                 
                if GetState == 21 or GetState == 25 then; 
                 
                    local fadeIn_ = reaper.GetMediaItemInfo_Value(retval2,"D_FADEINLEN"); 
                    local fadeOut_ = reaper.GetMediaItemInfo_Value(retval2,"D_FADEOUTLEN"); 
                     
                    for i = 1,reaper.CountSelectedMediaItems(0) do; 
                         local SelItem = reaper.GetSelectedMediaItem(0,i-1); 
                         if SelItem ~= retval2 then; 
                             reaper.SetMediaItemInfo_Value(SelItem,"D_FADEINLEN",fadeIn_); 
                             reaper.SetMediaItemInfo_Value(SelItem,"D_FADEOUTLEN",fadeOut_); 
                         end; 
                    end; 
                end; 
                   
            else; 
                fadeInActive = nil; 
                fadeOutActive = nil; 
                fadeOut = nil; 
                fadeIn = nil; 
                retval2 = nil; 
            end; 
             
        end; 
        reaper.defer(loop) 
    end; 
     
     
    is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context(); 
    reaper.SetToggleCommandState(sectionID,cmdID,1); 
     
    function exit(); 
        reaper.SetToggleCommandState(sectionID,cmdID,0); 
    end; 
     
    loop(); 
     
    reaper.atexit(exit); 
    no_undo(); 