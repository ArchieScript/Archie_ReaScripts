--[[ 
   * Тест только на windows  /  Test only on windows. 
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website) 
   * Bug Reports: If you find any errors, please report one of the links below (*Website) 
   * 
   * Category:    Envelope 
   * Description: Glue automation items (Clean) 
   * Author:      Archie 
   * Version:     1.04 
   * Описание:    Склеить элементы автоматизации (очистить огибающую от лишних точек) 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   *              http://rmmedia.ru/threads/134701/ 
   * DONATION:    http://money.yandex.ru/to/410018003906628 
   * Customer:    Maxim Kokarev(VK)$ 
   * Gave idea:   Maxim Kokarev(VK)$ 
   * Extension:   Reaper 6.03+ http://www.reaper.fm/ 
   *              SWS v.2.10.0 http://www.sws-extension.org/index.php 
   * Changelog:    
   *              v.1.04 [060320] 
   *                  + initialе 
--]]  
    --====================================================================================== 
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\ 
    --====================================================================================== 
     
    local TIME  = 0.005 --sec      | Удалить точку, если время меньше установленного 
    local VALUE = 1 -- (% 0-100) | и значение меньше установленного между 2-х точек 
     
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    local function Convert_EnvVOLUME_InPercent_DB_SWS(env,value,PerVal); 
        local _,_,_,_,_,_,min,max,_,_,faderS = reaper.BR_EnvGetProperties(reaper.BR_EnvAlloc(env,true)); 
        reaper.BR_EnvFree(reaper.BR_EnvAlloc(env,true),true); 
        local DBmin = math.floor((20*math.log(min+3e-8,10))+.5); 
        local DBmax = math.floor((20*math.log(max-3e-8,10))+.5); 
        local DB_total = math.abs(DBmin)+math.abs(DBmax); 
        if PerVal == 0 then; 
            local val = ((20*math.log(value+3e-8,10))-DBmin); 
            value = val/(DB_total/100); 
            return math.floor(value); 
        elseif PerVal == 1 then; 
            return DBmin+(DB_total/100*value); 
        end; 
    end; 
     
     
     
    local function Convert_Env_ValueInValueAndInPercent_SWS(envelope,valPoint,PerVal); 
        local _,_,_,_,_,_,min,max,_,_,faderS = reaper.BR_EnvGetProperties(reaper.BR_EnvAlloc(envelope,true)); 
        reaper.BR_EnvFree(reaper.BR_EnvAlloc(envelope,true),true); 
        local interval = (max - min); 
        if PerVal == 0 then return (valPoint-min)/interval*100; 
        elseif PerVal == 1 then return (valPoint/100)*interval + min; 
        end; 
    end; 
     
     
    local Percent2,time2; 
     
    if TIME  < 1e-10 then TIME  = 1e-10 end; 
    if VALUE < 1e-10 or VALUE > 100 then VALUE = 1e-10 end; 
     
     
    local Env = reaper.GetSelectedTrackEnvelope(0); 
    if Env then; 
         
        reaper.PreventUIRefresh(1); 
        reaper.Undo_BeginBlock(); 
         
        reaper.Main_OnCommand(42089,0);--Envelope: Glue automation items 
         
        local CountAutoItem = reaper.CountAutomationItems(Env); 
         
        for i = 0,CountAutoItem do; 
             
            local CountEnvPoint = reaper.CountEnvelopePointsEx(Env,i-1); 
             
            for p = CountEnvPoint-1,0,-1 do; 
                --- 
                local retval,time,value,shape,tension,selected = reaper.GetEnvelopePointEx(Env,i-1,p); 
                local ScalingPre = reaper.GetEnvelopeScalingMode(Env); 
                if ScalingPre == 1 then; 
                     value = reaper.ScaleFromEnvelopeMode(1,value); 
                end; 
                 
                local Percent; 
                local retval,env_name = reaper.GetEnvelopeName(Env); 
                if env_name == "Volume" or env_name == "Trim Volume" then; 
                    Percent = Convert_EnvVOLUME_InPercent_DB_SWS(Env,value,0); 
                else; 
                    Percent = Convert_Env_ValueInValueAndInPercent_SWS(Env,value,0); 
                end; 
                 
                -- do return end; 
                if time2 and Percent2 then; 
                     
                    if time2-time <= TIME then; 
                         
                        if math.abs(Percent2-Percent) <= VALUE then; 
                             
                            reaper.DeleteEnvelopePointRangeEx(Env,i-1,time-1e-8,time+1e-8); 
                            time = time2; 
                            Percent2 = Percent; 
                        end; 
                    end; 
                end; 
                time2    = time; 
                Percent2 = Percent; 
            end; 
            time2    = nil; 
            Percent2 = nil; 
        end; 
    end; 
     
    reaper.Undo_EndBlock("Glue automation items (Clean)",-1); 
    reaper.PreventUIRefresh(-1); 
     
    reaper.UpdateArrange(); 