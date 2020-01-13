--[[
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Fx
   * Description: Toggle Bypass necessary Fx in selected tracks(user input)
   * Author:      Archie
   * Version:     1.01
   * VIDEO:       http://youtu.be/H1m9PMSRfVg?t=1486
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    vax(Rmm)
   * Gave idea:   vax(Rmm)
   * Changelog:   
   *              v.1.02 [14.01.20]
   *                  + Master Track
   *                  ! fixed bug
   
   *              v.1.0 [13.12.19]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
     --[   <<< Вот здесь поменять  <<< Change here
    
        local msg = 
              'Eng:\n\n'..
              'Script:\n'..
              'Toggle - bypass the required Fx in the selected tracks (user input through a comma or semicolon)\n'..
              'In the window that appears, enter the Fx names that need to be bypassed / bypassed through a comma (,) or semicolon (;)\n'..
              'For example: Delay, name2; name3\n'..
              'Names can be spelled out not completely, but only part of the name\n'..
              'For example: Del, me2; me3\n'..
              'Or\n'..
              'enter Fx numbers separated by commas (,) or semicolons (;)\n'..
              'adding *(asterisk) at the beginning\n'..
              'For example: *1, 3, 5\n'..
              'In order for this window not to appear with a hint, go to the script and in the settings mark in the line - [add a character [to make it - [[\n\n\n'..
              
              'Rus:\n\n'..
              'Скрипт:\n'..
              'Переключатель - байпас необходимых Fx в выбранных треках(пользовательский ввод  через запятую или точка с запятой)\n'..
              'Введите в появившемся окне имена Fx , которые нужно забайпасить/разбайпасить через запятую(,) или точку с запятой(;)\n'..
              'Например: Delay,name2;name3\n'..
              'Имена можно прописывать не полностью, а только часть имени\n'..
              'Например: Del,me2;me3\n'..
              'Или\n'..
              'введите номера Fx через запятую(,) или точку с запятой(;)\n'..
              'добавив *(звездочку) в начале\n'..
              'Например: *1, 3, 5\n'..
              'Для того чтобы не появлялось это окно с подсказкой зайдите в скрипт и в пометке настройки в строке --[ добавьте знак [ чтобы получилось --[[\n'
    --]]
    
    local WINDOW_RESTART = true;
                      -- = true;  | Повторно открыть окно 
                      -- = false; | Не открывать Повторно окно
    
    
    local MASTER_TRACK = false; -- true/false
    
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
    
    
    ----------------------------------------------------------------------------------------------
    local is_new_value,filename,sectionID,cmdID,mode,resolution,val = reaper.get_action_context();
    ----------------------------------------------------------------------------------------------
    
    
    
    ::RESTART::
    
    --------------------------------------------------------------
    local CountSelTrack = reaper.CountSelectedTracks(0);
    if CountSelTrack == 0 then;
        local mTr = reaper.GetMasterTrack(0);
        local sel = reaper.GetMediaTrackInfo_Value(mTr,'I_SELECTED');
        if sel == 0 then;
            reaper.MB('No Selected Track','Woops',0)no_ubdo()return;
        end;
    end;
    --------------------------------------------------------------
    
    
    ------------------------------------
    if msg and type(msg)=='string' then;
        reaper.ShowConsoleMsg("");
        reaper.ShowConsoleMsg(msg);
        ---
        if reaper.JS_Window_Find then;
            local title = reaper.JS_Localize("ReaScript console output","common");
            local wind = reaper.JS_Window_Find(title,true);
            if wind then;
                reaper.JS_Window_Resize(wind,950,550);
            end;
        end
        ---  
    end;
    ------------------------------------
    
    
    -----------------------------------------------
    local 
    ExtState = reaper.GetExtState(filename,'value');
    local 
    retval, str = reaper.GetUserInputs("Toggle Bypass fx in selected tracks by number or name",1,"Name Fx or *number (by comma),extrawidth=150",ExtState);
    if not retval or #str:gsub("%s","")==0 then no_ubdo()return end;
    str = str:gsub(',',';');
    reaper.SetExtState(filename,'value',str,false);
    -----------------------------------------------
    
    
    ---------------
    local NT = {};
    local T = {};
    local NameNumb;
    ---------------
    
    
    -----------------------------------------
    if str:match("%S")=='*' then;
        str = str:gsub('%s-*','',1);
        for S in string.gmatch(str,"%d+") do;
            if tonumber(S) then;
                T[tonumber(S)]=tonumber(S);
            end;
        end;
    else;
        for S in string.gmatch(str..';',"(.-);") do;
            NT[#NT+1]=S:upper();
        end;
    end;
    -----------------------------------------
    
    
    -----------------------------------------------------------
    if retT(T) == 0 and retT(NT) == 0 then no_ubdo()return end;
    -----------------------------------------------------------
    
    
    -------------------------------------------------------------------------------------
    if retT(T) > 0 then NameNumb = 'NUMB' elseif retT(NT) > 0 then NameNumb = 'NAME' end;
    -------------------------------------------------------------------------------------
    
    
    ------------------------------------------
    local GetEnabled, SetEnabled, Undo, strU;
    local 
    CountSelTrack = reaper.CountSelectedTracks(0);
    for i = 0, CountSelTrack do;
        
        -----
        local SelTrack;
        if i == 0 then;
            local mTr = reaper.GetMasterTrack(0);
            local sel = reaper.GetMediaTrackInfo_Value(mTr,'I_SELECTED');
            if MASTER_TRACK ~= true then sel = 0 end;
            if sel == 1 then;
                SelTrack = mTr;
            end;
        else;
            SelTrack = reaper.GetSelectedTrack(0,i-1);
        end;
        -----
        
        if SelTrack then;
        
            --================================================
            local FX_Count = reaper.TrackFX_GetCount(SelTrack);
            for ifx = 1, FX_Count do;
        
                if NameNumb == 'NAME' then;
                    -----------
                    ---------
                    local _, nameFx = reaper.TrackFX_GetFXName(SelTrack,ifx-1,'');
                    for inm = 1, #NT do;
                        nameFx = nameFx:upper();
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
                    ---------
                    -----------
                elseif NameNumb == 'NUMB' then;
                    -----------
                    ---------
                    if T[ifx] then;
                        if not GetEnabled then;
                            GetEnabled = reaper.TrackFX_GetEnabled(SelTrack,ifx-1);
                            if GetEnabled then SetEnabled = false else SetEnabled = true GetEnabled = true end;
                        end;
                        
                        if not Undo then;
                            reaper.Undo_BeginBlock();
                            reaper.PreventUIRefresh(1);
                            Undo = true;
                            if SetEnabled == true then strU = "Unbypass Fx" else strU = "Bypass Fx" end;
                        end;
                        reaper.TrackFX_SetEnabled(SelTrack,ifx-1,SetEnabled);
                    end;
                    ---------
                    -----------
                end;
            end;
            --================================================  
        end;    
        -----
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
    