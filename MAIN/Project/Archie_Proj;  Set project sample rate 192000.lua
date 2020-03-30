--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Project
   * Description: Proj;  Set project sample rate 192000
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   *              http://vk.com/reaarchie
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Валерий Бадьянов(Rmm)
   * Gave idea:   Валерий Бадьянов(Rmm)
   * Extension:   Reaper 6.05+ http://www.reaper.fm/
   * Changelog:   
   *              v.1.0 [290320]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    
    local SAMPLERATE = 192000;
    
    reaper.defer
    (function();
        local retval = reaper.GetSetProjectInfo(0,'PROJECT_SRATE',0,0);
        if retval ~= SAMPLERATE then;
            reaper.GetSetProjectInfo(0,'PROJECT_SRATE',SAMPLERATE,1);
            reaper.Audio_Quit();
            reaper.Audio_Init();
            reaper.UpdateArrange();
        end;
    end);
    
    