--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Fx
   * Description: Toggle Bypass necessary Fx in selected tracks(user input through space)
   * Author:      Archie
   * Version:     1.02
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    vax(Rmm)
   * Gave idea:   vax(Rmm)
   * Changelog:   v.1.0 [13.12.19]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
     --[   <<< Вот здесь поменять  <<< Change here
    
        local msg = 
        "Eng:\nScript: Toggle Bypass necessary Fx in selected tracks(user input through space)\n"..
        "In the window that appears, enter the Fx names that You want to bypass/unbypass  separated by a comma (,) or semicolon(;)\n"..
        "For example: Delay, name2; name3\n"..
        "Or enter the Fx numbers separated by a comma or semicolon(;)\n"..
        "adding *(asterisk) before the name\n"..
        "For example: *1, 3, 5\n"..
        "In order not to appear this a hint window, go to the script and mark, the settings in the line -- [add a sign [ to get it --[[\n\n\n"..
    
        "Rus:\nСкрипт: переключатель - байпас необходимых Fx в выбранных треках(пользовательский ввод  через пробел)\n"..
        "Введите в появившемся окне имена Fx , которые нужно забайпасить/разбайпасить через запятую(,) или точку с запятой(;)\n"..
        "Например: Delay,name2;name3\n"..
        "Или введите номера Fx через запятую или точку с запятой(;)\n"..
        " добавив *(звездочку) перед именем\n"..
        "Например: *1, 3, 5\n"..
        "Для того чтобы не появлялось это окно с подсказкой зайдите в скрипт и в пометке настройки в строке --[ добавьте знак [ чтобы получилось --[[\n"
   
   
        reaper.ShowConsoleMsg("");
        reaper.ShowConsoleMsg(msg);
    
    --]]
    
    local WINDOW_RESTART = true 
                      -- = true  | Повторно открыть окно 
                      -- = false | Не открывать Повторно окно
        
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================  
    
    
    
    -------------------------------------------------------
    local function no_ubdo()reaper.defer(function()end)end;
    -------------------------------------------------------
    
    
    
    -------------------------------------------------------------------------------------------
    local function retT(X)local x for key,val in pairs(X)do x=(x or 0)+1 end return x or 0 end;
    -------------------------------------------------------------------------------------------
    
    
    
    ---------------------------------------------------------
    local function SC(x)return string.gsub(x,'%p','%%%0')end;
    ---------------------------------------------------------
    
    
    
    ::RESTART::
    local 
    ExtState = reaper.GetExtState('gs94DPKEKEOPEPOKPE85klpgkh','iJ9iuGDGHiIHPIUGGol0lu0oi9OK');
    local 
    retval, str = reaper.GetUserInputs("Toggle Bypass fx in selected tracks by number or name",1,"Name Fx or *number (by comma),extrawidth=150",ExtState);
    if not retval or #str:gsub("%s","")==0 then no_ubdo()return end;
    str = str:gsub(',',';')
    reaper.SetExtState('gs94DPKEKEOPEPOKPE85klpgkh','iJ9iuGDGHiIHPIUGGol0lu0oi9OK',str,false);
    
    
    
    local NT = {};
    local T = {};
    local NameNumb;
    
    
    if str:match("%S")=='*' then;
        str = str:gsub('%s-*','',1);
        for S in string.gmatch(str,"%d+") do;
            if tonumber(S) then;
                T[tonumber(S)]=tonumber(S);
            end;
        end;
    else;
        for S in string.gmatch(str..';',"(.-);") do;
            NT[#NT+1]=S:lower();
        end;
    end;
    
    
    if retT(T) == 0 and retT(NT) == 0 then no_ubdo()return end;
 
    if retT(T) > 0 then NameNumb = 'NUMB' elseif retT(NT) > 0 then NameNumb = 'NAME' end;
    
    
    local GetEnabled, SetEnabled, Undo, strU;
    local 
    CountSelTrack = reaper.CountSelectedTracks(0);
    for i = 1,CountSelTrack do;
        local SelTrack = reaper.GetSelectedTrack(0,i-1);
        local FX_Count = reaper.TrackFX_GetCount(SelTrack);
        for ifx = 1,FX_Count do;
            
            if NameNumb == 'NAME' then;
                
                local _, nameFx = reaper.TrackFX_GetFXName(SelTrack,ifx-1,'');
                
                for inm = 1, #NT do;
                    
                    nameFx = nameFx:lower();
                    
                    if nameFx:match(SC(NT[inm])) then;
                        
                        if not GetEnabled then;
                            GetEnabled = reaper.TrackFX_GetEnabled(SelTrack,ifx-1);
                            if GetEnabled then SetEnabled = false else SetEnabled = true GetEnabled = true end;
                        end;
                        if not Undo then;
                            reaper.Undo_BeginBlock();
                            reaper.PreventUIRefresh(1);
                            Undo = true;
                        end;
                        reaper.TrackFX_SetEnabled(SelTrack,ifx-1,SetEnabled);
                        if SetEnabled == true then strU = "Unbypass Fx" else strU = "Bypass Fx" end;
                        break;
                    end;
                end;
            elseif NameNumb == 'NUMB' then;
                if T[ifx] then;
                    if not GetEnabled then;
                        GetEnabled = reaper.TrackFX_GetEnabled(SelTrack,ifx-1);
                        if GetEnabled then SetEnabled = false else SetEnabled = true GetEnabled = true end;
                    end;
                    
                    if not Undo then;
                        reaper.Undo_BeginBlock();
                        reaper.PreventUIRefresh(1);
                        Undo = true;
                        if SetEnabled == true then strU = "Unbypass Fx" else strU = "Bypass Fx" end
                    end;
                    reaper.TrackFX_SetEnabled(SelTrack,ifx-1,SetEnabled);
                end;
            end;
        end;
    end;
    
    if Undo then;
        reaper.PreventUIRefresh(-1);
        reaper.Undo_EndBlock(strU,-1);
    else;
        no_ubdo();
    end;
    
    if WINDOW_RESTART == true then;
        goto RESTART;
    end;
    