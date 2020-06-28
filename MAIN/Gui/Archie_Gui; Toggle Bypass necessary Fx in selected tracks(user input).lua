--[[     TERMINATE INSTANCES
   * Тест только на windows  /  Test only on windows.
   * Отчет об ошибке: Если обнаружите какие либо ошибки, то сообщите по одной из указанных ссылок ниже (*Website)
   * Bug Reports: If you find any errors, please report one of the links below (*Website)
   *
   * Category:    Gui
   * Description: Toggle Bypass necessary Fx in selected tracks(user input)
   * Author:      Archie
   * Version:     1.05
   * VIDEO:       http://youtu.be/H1m9PMSRfVg?t=1486 (Предыдущяя версия)
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628/1000
   * Customer:    vax(Rmm)
   * Gave idea:   vax(Rmm)
   * Changelog:   
   
   *              v.1.0 [150420]
   *                  + Bypass / Unbypass all effects

   *              v.1.0 [19.01.20]
   *                  + initialе
--]]
    
    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================
    
    
    
    --=========================================
    local function MODULE(file);
        local E,A=pcall(dofile,file);if not(E)then;reaper.ShowConsoleMsg("\n\nError - "..debug.getinfo(1,'S').source:match('.*[/\\](.+)')..'\nMISSING FILE / ОТСУТСТВУЕТ ФАЙЛ!\n'..file:gsub('\\','/'))return;end;
        if not A.VersArcFun("2.8.5",file,'')then A.no_undo()return;end;return A;
    end;local Arc=MODULE((reaper.GetResourcePath()..'/Scripts/Archie-ReaScripts/Functions/Arc_Function_lua.lua'):gsub('\\','/'));
    if not Arc then return end;
    local ArcFileIni = reaper.GetResourcePath():gsub('\\','/')..'/reaper-Archie.ini';
    --=========================================
    
    
    
    
    --============================================================
    local function Help();
    
        local msg = 
        '\n\nTERMINATE INSTANCES\n\n'..
        "Rus:\n\n"..
        'v.1.03 - "*0" или "all" - вкл / выкл все эффекты\n\n'..
        "Скрипт: "..
        "Переключатель - байпас необходимых Fx в выбранных треках\n"..
        "(пользовательский ввод  через запятую или точка с запятой)\n"..
        "Нажмите на ввод имени и введите в появившемся окне имена Fx,\n"..
        "которые нужно забайпасить/разбайпасить через запятую(,) или точку с запятой(;)\n"..
        "Например: Delay,name2;name3\n"..
        "Имена можно прописывать не полностью, а только часть имени\n"..
        "Например: Del,me2;me3\n"..
        "Или\n"..
        "введите номера Fx через запятую(,) или точку с запятой(;)\n"..
        "добавив *(звездочку) в начале\n"..
        "Например: *1, 3, 5\n"..
        "Правый клик или кнопка 'P' вызовет меню для сохранения пресетов.\n"..
        "Mode: Mode 1 - байпас всех Fx в одно состояние, Mode 2 - переключать зеркально\n"..
        "т.е. если один fx включен, а второй выключен, то они поменяются местами.\n\n"..
        '\n\nTERMINATE INSTANCES\n\n\n'..
        "Eng:\n\n"..
        'V. 1. 03 - "*0 " or "all" - Bypass / Unbypass all effects\n\n'..
        "Script: "..
        "Toggle-bypass required Fx in selected tracks\n"..
        "(user input separated by a comma or semicolon)\n"..
        "Click on enter a name and enter the Fx names in The window that appears,\n"..
        "that need to be pasted / unpacked with a comma (,) or semicolon(;)\n"..
        "For example: Delay, name2; name3\n"..
        "Names can be spelled out not completely, but only part of the name\n"..
        "For example: Del, me2;me3\n"..
        "Or\n"..
        "enter the Fx numbers separated by a comma (,) or semicolon(;)\n"..
        "adding *(asterisk) at the beginning\n"..
        "For example: *1, 3, 5\n"..
        "Right click or 'P' button will open the menu for saving presets.\n"..
        "Mode: Mode 1-bypass all Fx in one state, Mode 2 - switch mirror\n"..
        "that is, if one fx is enabled and the other is bypassed they will switch places."..
        '\n\nTERMINATE INSTANCES\n\n'
        
        
        
        ------------------------------------
        reaper.ShowConsoleMsg("");
        reaper.ShowConsoleMsg(msg);
        ---
        if reaper.JS_Window_Find then;
            local title = reaper.JS_Localize("ReaScript console output","common");
            local wind = reaper.JS_Window_Find(title,true);
            if wind then;
                reaper.JS_Window_Resize(wind,670,630);
            end;
        end
        ---
        ------------------------------------
    end;
    --============================================================
    
    
    
    --=================================
    ---------------------------------
    local function CountTable(table);
        local x = 0;
        for k,v in pairs(table)do;
            x = x + 1;
        end;
        return x;
    end;  
    ---------------------------------
    --=================================
    
    
    
    --=============================================================================================
    local function ToggleBypass(str,MASTER_TRACK,Mode);--str,true
        
        ---------------------------------------------------------
        local function SC(x)return string.gsub(x,'%p','%%%0')end;
        ---------------------------------------------------------
        
        -------------------------------------------------------------------------------------------
        local function retT(X)local x for key,val in pairs(X)do x=(x or 0)+1 end return x or 0 end;
        -------------------------------------------------------------------------------------------
        
        ---------------
        local numT = {}; 
        local strT = {};-- NT
        local NameNumb;
        ---------------
        
        -----------------------------------------
        if str:match("%S")=='*' then;
            str = str:gsub('%s-*','',1);
            for S in string.gmatch(str,"%d+") do;
                if tonumber(S) then;
                    numT[tonumber(S)]=tonumber(S);
                end;
            end;
        else;
            for S in string.gmatch(str..';',"(.-);") do;
                strT[#strT+1]=S:upper();
            end;
        end;
        -----------------------------------------
        
        ------------------------------------------------------------------------------------------
        if retT(numT) > 0 then NameNumb = 'NUMB' elseif retT(strT) > 0 then NameNumb = 'NAME' end;
        ------------------------------------------------------------------------------------------
        --RR=numT
        
        local GetEnabled, SetEnabled, Undo, strU;
        
        if NameNumb and (NameNumb == 'NUMB' or NameNumb == 'NAME') then;
            
            local CountSelTrackMast = reaper.CountSelectedTracks2(0,true);
            if CountSelTrackMast > 0 then;
                
                local CountSelTrack = reaper.CountSelectedTracks(0);
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
                                
                                for key,val in pairs(strT)do;
                                
                                    nameFx = nameFx:upper();
                                    
                                    if strT[key]:gsub('%s','')=='ALL'and #strT==1 then ALL_B = true end;--v.1.03
                                    
                                    if (nameFx:match(SC(strT[key])) and #strT[key]>=1)or ALL_B then;
                                        
                                        if not GetEnabled then;
                                            GetEnabled = reaper.TrackFX_GetEnabled(SelTrack,ifx-1);
                                            if GetEnabled then SetEnabled = false else SetEnabled = true end;
                                            if Mode == 2 then GetEnabled = nil else GetEnabled = true end;
                                        end;
                                        
                                        if not Undo then;
                                            reaper.Undo_BeginBlock();
                                            reaper.PreventUIRefresh(1);
                                            Undo = true;
                                        end;
                                        
                                        reaper.TrackFX_SetEnabled(SelTrack,ifx-1,SetEnabled);
                                        
                                        if Mode == 2 then;
                                            strU = "Toggle Bypass Fx by name (reflect)"
                                        else;
                                            if SetEnabled == true then strU = "Unbypass Fx by name" else strU = "Bypass Fx by name" end;
                                        end;
                                        
                                        break;
                                    end; 
                                end;
                                ALL_B = nil;--v.1.03
                                ---------
                                -----------
                            elseif NameNumb == 'NUMB' then;
                                -----------
                                ---------
                                if numT[ifx] or (CountTable(numT)==1 and numT[0]==0) then;
                                    
                                    if not GetEnabled then;
                                        GetEnabled = reaper.TrackFX_GetEnabled(SelTrack,ifx-1);
                                        if GetEnabled then SetEnabled = false else SetEnabled = true end;
                                        if Mode == 2 then GetEnabled = nil else GetEnabled = true end;
                                    end;
                                    
                                    if not Undo then;
                                        reaper.Undo_BeginBlock();
                                        reaper.PreventUIRefresh(1);
                                        Undo = true;
                                        
                                        if Mode == 2 then;
                                            strU = "Toggle Bypass Fx by number (reflect)";
                                        else;
                                            if SetEnabled == true then strU = "Unbypass Fx by number" else strU = "Bypass Fx by number" end;
                                        end;
                                    end;
                                    reaper.TrackFX_SetEnabled(SelTrack,ifx-1,SetEnabled);
                                end;
                                ---------
                                -----------
                            end;
                        end;
                        --================================================    
                    end;
                end;
            end;
        end;
        
        if Undo then;
            reaper.PreventUIRefresh(-1);
            reaper.Undo_EndBlock(strU,-1);
        end;   
    end;
    --=============================================================================================
    
    
    
    
    --================================================================
    local function Mouse_Is_Inside(x, y, w, h);
        local mouse_x, mouse_y = gfx.mouse_x, gfx.mouse_y
        local inside =
        mouse_x >= x and mouse_x < (x + w) and
        mouse_y >= y and mouse_y < (y + h);
        return inside;
    end;
    -----------------------------------------
    local mouse_btn_down,fake,lamp = {},{},{};
    local function LeftMouseButton(x, y, w, h,numbuf);
        if Mouse_Is_Inside(x, y, w, h) then;
            if gfx.mouse_cap&1 == 0 then fake[numbuf] = 1 end;
            if gfx.mouse_cap&1 == 0 and lamp[numbuf] ~= 0 then mouse_btn_down[numbuf] = 0 end;
            if gfx.mouse_cap&1 == 1 and fake[numbuf]==1 then mouse_btn_down[numbuf]=1 lamp[numbuf]=0; end; 
            if mouse_btn_down[numbuf] == 2 then mouse_btn_down[numbuf] = -1 end;
            if gfx.mouse_cap&1 == 0 and fake[numbuf] == 1 and mouse_btn_down[numbuf] == 1 then;
                mouse_btn_down[numbuf] = 2 lamp[numbuf] = nil;
            end;
        else;
            mouse_btn_down[numbuf] = -1 lamp[numbuf]=nil;
            if gfx.mouse_cap&1 == 1 and fake[numbuf] == 1 then mouse_btn_down[numbuf] = 1 end;
            if gfx.mouse_cap&1 == 0 then fake[numbuf] = nil end;
        end;
        return mouse_btn_down[numbuf];
    end;
    --================================================================
    
    
    
    --===================================================================================
    local function AttachTopmostPin(nameWin);
        local PcallWindScr,ShowWindScr = pcall(reaper.JS_Window_Find,nameWin,true);
        if PcallWindScr and type(ShowWindScr)=="userdata" then reaper.JS_Window_AttachTopmostPin(ShowWindScr)end;
    end;
    --===================================================================================
    
    
    
    --===================================================================================
    local section = ({reaper.get_action_context()})[2]:match(".+[/\\](.+)");
    --local PositionWind = reaper.GetExtState(section,"PositionWind");
    local PositionWind = Arc.iniFileReadLua(section,"PositionWind",ArcFileIni);
    local xWinPos,yWinPos = PositionWind:match('(.-)&(.-)&');
    if not xWinPos or not yWinPos then;
        local  _,_, scr_x, scr_y = reaper.my_getViewport(0,0,0,0,0,0,0,0,1);
        xWinPos = scr_x/2-200;
        yWinPos = scr_y/2-40;
    end;
    
    local wWinSize,hWinSize = 400,80;
    local nameWin = 'Toggle Bypass fx in selected tracks by number or name';
    gfx.init(nameWin,wWinSize,hWinSize,0,xWinPos,yWinPos);
    --reaper.DeleteExtState(section,"SaveUserInput",true);
    --Arc.iniFileWriteLua(section,"SaveUserInput",'',ArcFileIni);
    --local SaveUserInput = reaper.GetExtState(section,"SaveUserInput"); 
    local SaveUserInput = Arc.iniFileReadLua(section,"SaveUserInput",ArcFileIni);
    AttachTopmostPin(nameWin);
    --===================================================================================
    
    
    
    --===================================================================================
    local 
    --ModeState = tonumber(reaper.GetExtState(section,"ModeState"))or 1;
    ModeState = tonumber(Arc.iniFileReadLua(section,"ModeState",ArcFileIni))or 1;
    --===================================================================================
    
    
    
    --===================================================================================
    local function loop();
        
        
        gfx.gradrect(0,0,gfx.w,gfx.h, .2,.2,.2,1);-- background
        
        gfx.setfont(1,"Arial",17,nil);
        
        gfx.set(1,1,1,1);
        
        gfx.x = 15;
        gfx.y = 14;
        gfx.drawstr(" Name Fx\n    or\n*number (by comma)");
        
        
        
        gfx.gradrect(230,45,75,25,  .4,.4,.4,1);
        gfx.x = 230;
        gfx.y = 48;
        gfx.drawstr("   Bypass");
        
        
        
        gfx.gradrect(315,45,75,25,  .4,.4,.4,1);
        gfx.x = 315;
        gfx.y = 48;
        gfx.drawstr("     Exit");
        
        
        
        gfx.gradrect(155,10,235,25,  .4,.4,.4,1);
        gfx.set(.5,.5,.5,1);
        gfx.rect(155,10,235,25,0);
        
        
        
        -------------
        gfx.dest = 500
        gfx.setimgdim(500,-1,-1);
        
        gfx.setimgdim(500,gfx.w,gfx.h);
        gfx.a = 1;
        
        gfx.set(1,1,1,1);
        
        for i = 1,2 do 
            gfx.x = 160
            gfx.y = 14
            gfx.drawstr(SaveUserInput);
        end;
        
        gfx.dest = -1;
        gfx.a = 1;
        gfx.blit(500,0,0, 155,10,230,25,  155,10,230,25, 0,0);
        --------
        
        
        --------
        gfx.setfont(1,"Arial",12,nil);
        gfx.gradrect(0,0,10,10,  .4,.4,.4,1);
        gfx.x = 2;
        gfx.y = 0;
        gfx.drawstr("P");
        ---------
        
        
        ---------
        gfx.gradrect(20,0,30,10,  .4,.4,.4,1);
        gfx.x = 20;
        gfx.y = -1;
        gfx.drawstr(" Mode");
        ---------
        
        
        
        ---------
        gfx.gradrect(0,hWinSize-10,27,10,  .4,.4,.4,1);
        gfx.x = 0;
        gfx.y = hWinSize-11;
        gfx.drawstr(" Help");
        ---------
        
        
        
        
        -- / click Button / ----------------------------------------------------------
        local ButtonBypass = LeftMouseButton(230,45,75,25,'ButtonBypass');
        if ButtonBypass == 0 then;
            gfx.set(1,1,1,.4);
            gfx.rect(230,45,75,25,0);
        elseif ButtonBypass == 1 or ButtonBypass == 2 then;
            gfx.set(.4,.7,0,1);
            gfx.rect(230+1,45+1,75-2,25-2,0);
            if ButtonBypass == 2 then;
                ToggleBypass(SaveUserInput,true,ModeState);
            end;
        end;
        
        
        local ButtonExit = LeftMouseButton(315,45,75,25,'ButtonExit');
        if ButtonExit == 0 then;
            gfx.set(1,1,1,.4);
            gfx.rect(315,45,75,25,0);
        elseif ButtonExit == 1 or ButtonExit == 2 then;
            gfx.set(.4,.7,0,1);
            gfx.rect(315+1,45+1,75-2,25-2,0);
            if ButtonExit == 2 then;
                exit();
            end;
        end;
        
        
        
        local ButtonUser = LeftMouseButton(155,10,235,25,'ButtonUser');
        if ButtonUser >= 0 then;
            gfx.set(1,1,1,.5);
            gfx.rect(155,10,235,25,0);
            gfx.set(.4,.7,0,.5);
            gfx.rect(155+1,10+1,235-2,25-2,0);
            if ButtonUser == 2 then;
                --SaveUserInput = reaper.GetExtState(section,"SaveUserInput");
                SaveUserInput = Arc.iniFileReadLua(section,"SaveUserInput",ArcFileIni);
                local retval, str = reaper.GetUserInputs(nameWin,1,'Name Fx or *number (by comma),extrawidth=150',SaveUserInput);
                if retval then;
                    str = str:gsub(',',';');
                    --reaper.SetExtState(section,'SaveUserInput',str,true);
                    Arc.iniFileWriteLua(section,"SaveUserInput",str,ArcFileIni);
                    SaveUserInput = str;
                end;  
            end;
        end;
        
        
        
        local ButtonMode = LeftMouseButton(20,0,30,10,'ButtonMode');
        if ButtonMode >= 0 then;
            gfx.set(1,1,1,.5);
            gfx.rect(20,0,30,10,0);
            if ButtonMode == 2 then;
                ---
                --ModeState = tonumber(reaper.GetExtState(section,"ModeState"))or 1;
                ModeState = tonumber(Arc.iniFileReadLua(section,"ModeState",ArcFileIni))or 1;
                local M1,M2;
                if ModeState==1 then M1='!'M2=''elseif ModeState==2 then M1=''M2='!'else M1=''M2=''end;
                gfx.x,gfx.y = gfx.screentoclient(reaper.GetMousePosition());
                --gfx.x,gfx.y = 0,0;
                local showmenuMode = gfx.showmenu("#Mode:||"..M1.."Mode 1 (Default)|"..M2.."Mode 2 (Reflect)");
                if showmenuMode > 0 then;
                    ModeState = showmenuMode-1;
                    --reaper.SetExtState(section,"ModeState",ModeState,true);
                    Arc.iniFileWriteLua(section,"ModeState",ModeState,ArcFileIni);
                end;
                ---
            end;
        end;
        
        
        
        
        local ButtonHelp = LeftMouseButton(0,hWinSize-10,27,10,'ButtonHelp');
        if ButtonHelp >= 0 then;
            gfx.set(1,1,1,.5);
            gfx.rect(0,hWinSize-10,27,10,0);
            if ButtonHelp == 2 then;
                Help();
            end;
        end;
        
        
        -- / click Button End / ------------------------------------------------------
        ------------------------------------------------------------------------------
        
        
        
        
        --- / Preset / ---------------------------------------------------------------
        -- reaper.DeleteExtState(section,"presetList",true);
        -- Arc.iniFileWriteLua(section,"presetList",'',ArcFileIni);
        
        local PresetButton = LeftMouseButton(0,0,9,9,'PresetButton');
        if PresetButton >= 0 then;
            gfx.set(1,1,1,.5);
            gfx.rect(0,0,10,10,0);
        end;
        
        if gfx.mouse_cap == 2 or PresetButton == 2 then;
             
            --local presetList = 'ALL&&&'..reaper.GetExtState(section,"presetList");
            local presetList = 'ALL&&&'..Arc.iniFileReadLua(section,"presetList",ArcFileIni);
            ---
            local T_repetition = {};
            local presetList2 = '';
            for S in string.gmatch(presetList.."&&&", ".-&&&") do;
                if #S:gsub('%s','')>0 then;
                    
                    if T_repetition[S]then S = "" end;
                    T_repetition[S] = S;
                    presetList2 = presetList2..S;
                end;
            end;
            
            presetList2 = presetList2:gsub('&&&$','');
            
            if presetList ~= presetList2 then;
                presetList = presetList2;
                --reaper.SetExtState(section,'presetList',presetList,true);
                Arc.iniFileWriteLua(section,"presetList",presetList,ArcFileIni);
            end;
            ---
            
            ----
            local presetList2 = '';
            for S in string.gmatch(presetList.."&&&", "(.-)&&&") do;
                if #S:gsub('%s','')>0 then;
                    presetList2 = presetList2..S..'|';
                end;
            end;
            if #presetList2:gsub('%s','')>0 then presetList2 = '|'..presetList2 end;
            ----
            
            ----
            gfx.x,gfx.y = gfx.screentoclient(reaper.GetMousePosition());
            --gfx.x,gfx.y = 0,0;
            --local showmenu = gfx.showmenu("#Preset:||>Add / Remove|".."Add||>Remove|Remove||<Remove All|<|"..presetList2);
            local showmenu = gfx.showmenu("#Preset:||>Add / Remove|".."Add|Remove||>Remove All|<Remove All|<|"..presetList2);
            
            
            if showmenu == 2 then;--Add
                ----
                local retval,str = reaper.GetUserInputs(nameWin,1,'Preset: Name Fx or *numb,extrawidth=150',"");
                if retval and #str:gsub('%s','') > 0 then;
                    str = str:gsub(',',';');
                    if presetList == ''then presetList = str else presetList = presetList..'&&&'..str end;
                    --reaper.SetExtState(section,"presetList",presetList,true);
                    Arc.iniFileWriteLua(section,"presetList",presetList,ArcFileIni);
                end;
                ---
                ---
                ----
            elseif showmenu == 3 then; --Remove
                ----
                local t = 0;
                local remShowmenu = gfx.showmenu('#Remove|'..presetList2);
                if remShowmenu > 0 then;
                    for S in string.gmatch(presetList.."&&&", ".-&&&") do;
                        if #S:gsub('%s','')>0 then;
                            t = t + 1;
                            if t == remShowmenu-1 then; 
                                local MB = reaper.MB("Eng:\nDo you really want to delete a preset "..S:gsub('&&&$','').."'\n\n"..
                                "Rus:\nВы действительно хотите удалить пресет '"..S:gsub('&&&$','').."'","Remove",1);
                                if MB == 1 then;
                                    S = '';
                                end;
                            end;
                            remExStat = (remExStat or '')..S;
                        end;
                    end;
                    --- 
                    remExStat = remExStat:gsub('&&&$','');
                    --reaper.SetExtState(section,"presetList",remExStat,true);
                    Arc.iniFileWriteLua(section,"presetList",remExStat,ArcFileIni);
                    remExStat = nil;
               end;
               ------------------
           elseif showmenu == 4 then;
               ------------------
               
               local MB = reaper.MB("Eng:\nDo you really want to delete all presets?\n\n"..
               "Rus:\nВы действительно хотите удалить все пресеты?","Remove All",1);
               if MB == 1 then;
                   local MB = reaper.MB("Eng:\nAccurately Delete ALL Presets ???\n\n"..
                                        "Rus:\nТочно Удалить ВСЕ Пресеты???","Remove All",1);
                   if MB == 1 then;
                       --reaper.DeleteExtState(section,"presetList",true);
                       Arc.iniFileWriteLua(section,"presetList",'',ArcFileIni);
                   end; 
               end;
               
               
               
               
               ------------------
           elseif showmenu >= 5 then; 
               -------------
               local t = 0;
               for S in string.gmatch(presetList.."&&&", "(.-)&&&") do;
                   if #S:gsub('%s','')>0 then;
                       t = t + 1;
                       if t == showmenu-4 then;
                           SaveUserInput = S;
                           --reaper.SetExtState(section,'SaveUserInput',SaveUserInput,true);
                           Arc.iniFileWriteLua(section,"SaveUserInput",SaveUserInput,ArcFileIni);
                      end;
                   end;
               end;
               -------------   
           end;    
        end;
        --- / Preset End / -----------------------------------------------------------
        ------------------------------------------------------------------------------
        
        
        
        -------------------------------------------------
        --- / Remove Focus / ----------------------------
        local getchar = gfx.getchar(65536)&2;
        if getchar == 2 and gfx.mouse_cap == 0 then;
            local CurCont = reaper.GetCursorContext();
            if CurCont ~= 0 then;
                reaper.SetCursorContext(0,nil);
            end;
        end;
        -------------------------------------------------
        -------------------------------------------------
         
        
        
        --- / Resize / -------------------
        local dockWin,xWin,yWin,wWin,hWin = gfx.dock(-1,-1,-1,-1,-1);
        if wWin < wWinSize-1 or wWin > wWinSize+1 or 
            hWin < hWinSize-1 or hWin > hWinSize+1  or dockWin ~= 0 then;
            gfx.quit();
            gfx.init(nameWin,wWinSize,hWinSize,0,xWin,yWin);
            AttachTopmostPin(nameWin);
        end;
        ----------------------
        if gfx.getchar() >= 0 then reaper.defer(loop);else;reaper.atexit(exit)return;end;
    end;
    --===================================================================================
    
    
    
    
    
    --=======================================================================
    function exit();
        local _,PosX,PosY,_,_ = gfx.dock(-1,-1,-1,-1,-1);
        --reaper.SetExtState(section,"PositionWind",PosX.."&"..PosY.."&",true);
        Arc.iniFileWriteLua(section,"PositionWind",PosX.."&"..PosY.."&",ArcFileIni,false,true);
        gfx.quit();
    end;
    --=======================================================================
    
    local scriptPath,scriptName = debug.getinfo(1,'S').source:match("^@(.+)[/\\](.+)");
    
    loop();
    Arc.GetSetTerminateAllInstancesOrStartNewOneKB_ini(1,260,scriptPath,scriptName);
    reaper.atexit(exit);