--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    View 
   * Description: Show hide mixer and master in docker 
   * Author:      Archie 
   * Version:     1.0 
   * Описание:    Показать Скрыть микшер и мастер в докере 
   * GIF:         --- 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    smrz1(Rmm Forum) 
   * Gave idea:   smrz1(Rmm Forum) 
   * Changelog:             
   *              v.1.0 [27.09.19] 
   *                  + initialе 
--]] 
     
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --======================================================================================  
     
     
     
    local mixerVisible = reaper.GetToggleCommandStateEx(0,40078);-- mixerVisible 
    local masterDocked  = reaper.GetToggleCommandStateEx(0,41610); -- master in Docker 
    if mixerVisible == 0 or masterDocked == 0 then; 
         
        local mixerInDocker = reaper.GetToggleCommandStateEx(0,40083); -- mixer in Docker 
        if mixerInDocker == 0 then; 
            reaper.Main_OnCommand(40083,0); 
        end; 
         
        for i = 1,2 do; --иногда не срабатывает с первого раза если закрыть док 
            local masterDocked  = reaper.GetToggleCommandStateEx(0,41610); -- master in Docker 
            if masterDocked == 0 then; 
                reaper.Main_OnCommand(41610,0); 
            end; 
        end; 
         
        local mixerVisible = reaper.GetToggleCommandStateEx(0,40078);-- mixerVisible 
        if mixerVisible == 0 then; 
            reaper.Main_OnCommand(40078,0); 
        end; 
    else; 
         
        local masterDocked  = reaper.GetToggleCommandStateEx(0,41610); -- master in Docker 
        if masterDocked == 1 then; 
            reaper.Main_OnCommand(41610,0); 
        end; 
         
        local mixerVisible = reaper.GetToggleCommandStateEx(0,40078);-- mixerVisible 
        if mixerVisible == 1 then; 
            reaper.Main_OnCommand(40078,0); 
        end; 
    end; 
    reaper.defer(function()end); 