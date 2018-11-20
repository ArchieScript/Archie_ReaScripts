--[[
   * Category:    FX
   * Description: Add Fx by Name in selected tracks (a description of settings inside script)
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Add Fx by Name in selected track(s)
   *              NOTE THE SETTINGS BELOW
   * О скрипте:   Добавить Fx по имени в выбранные трек(и)
   *              ОБРАТИТЕ ВНИМАНИЕ НА НАСТРОЙКИ НИЖЕ
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    Maestro Sound(Rmm/forum)
   * Gave idea:   Maestro Sound(Rmm/forum)
   * Changelog:   +  initialе / v.1.0
--===========================================================
SYSTEM REQUIREMENTS: / СИСТЕМНЫЕ ТРЕБОВАНИЯ: 
    Reaper v.5.961 -------- \http://www.reaper.fm/download.php -------\(and above \ и выше)\
    SWS v.2.9.7 ------------ \ http://www.sws-extension.org/index.php -\(and above \ и выше)\
    ReaPack v.1.2.2 --------- \  http://reapack.com/repos --------------\(and above \ и выше)\
    Arc_Function_lua v.1.0.4 - \ http://clck.ru/EjERc -------------------\(and above \ и выше)\
--===========================================================================================]]




    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local NameFX = "ReaEQ (Cockos)" --( = "" OFF / = "name" ON)
              -- = | "ВВЕДИТЕ СЮДА ИМЯ ПЛАГИНА" 
              -- = | "ENTER HERE THE NAME OF THE PLUGIN"
              ------------------------------------------


    local NamePreset = "name preset" --( = "" OFF / = "name" ON)
                  -- = | "ВВЕДИТЕ СЮДА ИМЯ ПРЕСЕТА" 
                  -- = | "ENTER HERE THE NAME OF THE PRESET"
                  ------------------------------------------


    local PlaceFxOn = 0
                 -- = 0 | ДОБАВЛЯТЬ ЭФФЕКТ В ПОСЛЕДНИЙ СЛОТ
                 -- = 1 | ДОБАВЛЯТЬ ЭФФЕКТ В ПЕРВЫЙ СЛОТ
                 -- = 2 | УДАЛИТЬ ВСЕ ПРЕДЫДУЩИЕ ЭФФЕКТЫ И ВСТАВИТЬ ЭФФЕКТ
                                                 -------------------------
                 -- = 0 | ADD THE FX IN THE LAST SLOT
                 -- = 1 | TO ADD THE FX INTO THE FIRST SLOT
                 -- = 2 | TO DELETE ALL PREVIOUS FX AND INSERT EFFECT
                 ----------------------------------------------------


    local TrackName = "" --( = "" OFF / = "name" ON)
                 -- = | "ВВЕДИТЕ ИМЯ ЕСЛИ НАДО ПЕРЕИМЕНОВАТЬ ТРЕКИ"
                 -- = | "ENTER A NAME IF YOU NEED TO RENAME THE TRACKS"
                 ------------------------------------------------------


    local OpenFx = 1  -- -1 OFF;
              -- = -1 | НЕ ОТКРЫВАТЬ ЭФФЕКТ
              -- =  0 | ОТКРЫТЬ ЭФФЕКТ В ЦЕПОЧКЕ
              -- =  1 | ОТКРЫТЬ ЭФФЕКТ ПЛАВАЮЩИЙ
                                  --------------
              -- = -1 | DOES NOT OPEN THE EFFECT
              -- =  0 | OPEN EFFECT IN THE CHAIN
              -- =  1 | TO OPEN A FLOATING EFFECT
              -----------------------------------


    local RecordArm = -1  -- -1 OFF;
                 -- = -1 | НЕ АКТИВИРОВАТЬ ТРЕК ДЛЯ ЗАПИСИ
                 -- =  0 | ДЕАКТИВИРОВАТЬ ПОДГОТОВКУ ЗАПИСИ/ OFF
                 -- =  1 | АКТИВИРОВАТЬ ТРЕК ДЛЯ ЗАПИСИ   / ON
                 -- =  2 | АКТИВИРОВАТЬ АВТОМАТИЧЕСКУЮ ПОДГОТОВКУ ЗАПИСИ / AUTO
                                       ----------------------------------------
                 -- = -1 | DO NOT ACTIVATE THE TRACK RECORDING
                 -- =  0 | DEACTIVATE TRAINING RECORDS \ OFF
                 -- =  1 | ACTIVATE THE TRACK RECORDING \ ON
                 -- =  2 | TO ACTIVATE THE AUTOMATIC PREPARATION OF RECORDING / AUTO
                 -------------------------------------------------------------------


    local RecordMonitoring = -1 -- -1 OFF;
                  -- = -1 | НИЧЕГО НЕ ДЕЛАТЬ
                  -- =  0 | ВЫКЛЮЧИТЬ МОНИТОРИНГ ЗАПИСИ / OFF
                  -- =  1 | ВКЛЮЧИТЬ МОНИТОРИНГ ЗАПИСИ / ON
                  -- =  2 | ВКЛЮЧИТЬ АВТОМАТИЧЕСКИЙ МОНИТОРИНГ ЗАПИСИ / AUTO
                                     ---------------------------------------
                  -- = -1 | DO NOTHING
                  -- =  0 | DISABLE RECORD MONITORING ON / OFF
                  -- =  1 | ENABLE RECORD MONITORING: ON
                  -- =  2 | TO ENABLE AUTOMATIC MONITORING OF RECORDING / AUTO
                  ------------------------------------------------------------
                  --==========================================================



    local AdditionalFxName = ""  --( = "" OFF / = "name" ON)
                        -- = | "ВВЕДИТЕ СЮДА ИМЯ ДОПОЛНИТЕЛЬНОГО ПЛАГИНА" 
                        -- = | "ENTER HERE THE NAME OF AN ADDITIONAL PLUGIN"
                        ----------------------------------------------------


    local AdditionalNamePreset = ""    --( = "" OFF / = "name" ON)
                            -- = | "ВВЕДИТЕ СЮДА ИМЯ ПРЕСЕТА ДОПОЛНИТЕЛЬНОГО ЭФФЕКТА" 
                            -- = | "ENTER HERE THE NAME OF THE PRESET ADDITIONAL EFFECT"
                            ------------------------------------------------------------


    local AdditionalFxOpen = 1  -- -1 OFF;
                        -- = -1 | НЕ ОТКРЫВАТЬ ДОПОЛНИТЕЛЬНЫЙ ЭФФЕКТ
                        -- =  0 | ОТКРЫТЬ ДОПОЛНИТЕЛЬНЫЙ ЭФФЕКТ В ЦЕПОЧКЕ
                        -- =  1 | ОТКРЫТЬ ДОПОЛНИТЕЛЬНЫЙ ЭФФЕКТ ПЛАВАЮЩИЙ
                                            -----------------------------
                        -- = -1 | DO NOT OPEN AN ADDITIONAL EFFECT
                        -- = 0 | OPEN AN ADDITIONAL EFFECT IN THE CHAIN
                        -- = 1 | OPEN THE SECONDARY EFFECT OF FLOATING
                        ----------------------------------------------
                        --============================================



    local CloseAllPreviousFx = -1
                  -- = -1 | НЕ ЗАКРЫВАТЬ ПРЕДЫДУЩИЕ ЭФФЕКТЫ
                  -- =  0 | ЗАКРЫТЬ ВСЕ ПРЕДЫДУЩИЕ ЭФФЕКТЫ ТОЛЬКО В ЦЕПИ
                  -- =  1 | ЗАКРЫТЬ ВСЕ ПРЕДЫДУЩИЕ ЭФФЕКТЫ ТОЛЬКО ПЛАВАЮЩИЕ 
                  -- =  2 | ЗАКРЫТЬ ВСЕ РЕДЫДУЩИЕ ЭФФЕКТЫ
                                   ----------------------
                  -- = -1 | DO NOT CLOSE THE PREVIOUS Fx
                  -- =  0 | TO CLOSE ALL THE PREVIOUS Fx ONLY IN THE CIRCUIT
                  -- =  1 | TO CLOSE ALL THE PREVIOUS Fx ARE JUST FLOATING
                  -- =  2 | TO CLOSE ALL PREDYDUSHIE Fx
                  -------------------------------------



    local CloseToolbarNumber = -1  -- -1 OFF;
                          -- = -1 | НЕ ЗАКРЫТЬ ПАНЕЛЬ ИНСТРУМЕНТОВ
                          --    ИНАЧЕ ВВЕДИТЕ НОМЕР ПАНЕЛИ ИНСТРУМЕНТОВ
                          --    0 = ГЛАВНАЯ, 0-16
                          -- некорректно работает если закрывающая панель 
                          --          инструментов дублем открыта в верху
                                                  -----------------------
                          -- = -1 | DO NOT CLOSE TOOLBAR
                          --     OTHERWISE ENTER THE NUMBER OF THE TOOLBAR
                          --     0 = MAIN, 0-16
                          -- does not work correctly if the closing panel 
                          --              double tools open at the top
                          --------------------------------------------



    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================




    --Mod------------------Mod---------------------Mod--
    local function GetSubdirectoriesUpToLevelFive(Path);
      local T,Enu,s,h = {Path},reaper.EnumerateSubdirectories,"\\",math.huge; 
      for i=0,h do;f1 = Enu(Path,i);if f1 then;T[#T+1]=Path..s..f1;
        for i2=0,h do;f2=Enu(Path..s..f1,i2)if f2 then T[#T+1]=Path..s..f1..s..f2;
          for i3=0,h do;f3=Enu(Path..s..f1..s..f2,i3)if f3 then T[#T+1]=Path..s..f1..s..f2..s..f3;
            for i4=0,h do;f4 = Enu(Path..s..f1..s..f2..s..f3,i4)if f4 then T[#T+1]=Path..s..f1..s..f2..s..f3..s..f4;
              for i5=0,h do;f5=Enu(Path..s..f1..s..f2..s..f3..s..f4,i5)if f5 then T[#T+1]=Path..s..f1..s..f2..s..f3..s..f4..s..f5;
              ----------
              end;if not f5 then break end;end;
            end;if not f4 then break end;end;
          end;if not f3 then break end;end;
        end;if not f2 then break end;end; 
      end;if not f1 then return T end;end;
    end;
    ---
    local function GetModule(Path,file);
      local FolPath,mod,Way = GetSubdirectoriesUpToLevelFive(Path);
      for i=0,#FolPath do;if not FolPath[i]then FolPath[i]=select(2,reaper.get_action_context()):match("(.+)[\\]")end;
        for i2 = 0,math.huge do; local f = reaper.EnumerateFiles(FolPath[i],i2);
          if f == file then mod=true Way=FolPath[i]break end;if not f then break end;
        end; if mod then return mod,Way end;
      end----------------------------------
    end------------------------------------
    ---------------------------------------
    local found_mod,ScriptPath,Arc = GetModule(reaper.GetResourcePath(),"Arc_Function_lua.lua")
    if not found_mod then reaper.ReaScriptError("Missing 'Arc_Function_lua' file,"-------------
                            .." install ReaPack to install this file.") return end
    package.path = package.path..";"..ScriptPath.."/?.lua"------------------------
    Arc = require "Arc_Function_lua"----------------------
    --==============================




    local CountSelTr = reaper.CountSelectedTracks(0)
    if CountSelTr == 0 then Arc.no_undo() return end


    NameFX = NameFX:gsub(".+:%s+","") 
    AdditionalFxName = AdditionalFxName:gsub(".+:%s+","") 
    local ChainFloat, StopAction, IDX, pos


    reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock()


    if CloseAllPreviousFx >= 0 and CloseAllPreviousFx <= 2 then
        if CloseAllPreviousFx == 0 then chain = true float = false end
        if CloseAllPreviousFx == 1 then float = true chain = false end
        if CloseAllPreviousFx == 2 then float = true chain = true  end
        Arc.CloseAllFxInAllTracks(chain, float) 
    end


    if CloseToolbarNumber >= 0 and CloseToolbarNumber <= 16 then
        Arc.CloseToolbarByNumber(CloseToolbarNumber)
    end


    for j = 1,CountSelTr do
        local SelTrack = reaper.GetSelectedTrack(0,j-1)
        ----

        ----/ Insert Fx /----
        if PlaceFxOn == 0 then 
            IDX = reaper.TrackFX_AddByName(SelTrack,NameFX,false,-1)
            local CountFx = reaper.TrackFX_GetCount(SelTrack)
            reaper.TrackFX_SetPreset(SelTrack,CountFx-1,NamePreset)

        elseif PlaceFxOn == 1 then

            IDX = reaper.TrackFX_AddByName(SelTrack,NameFX,false,-1)
            local CountFx = reaper.TrackFX_GetCount(SelTrack)
            for i = CountFx-1,0,-1 do
                reaper.SNM_MoveOrRemoveTrackFX(SelTrack,i,-1)
            end
            reaper.TrackFX_SetPreset(SelTrack,0,NamePreset)

        elseif PlaceFxOn == 2 then

            local CountFx = reaper.TrackFX_GetCount(SelTrack)
            for i = CountFx-1,0,-1 do
                reaper.SNM_MoveOrRemoveTrackFX(SelTrack,i,0)
            end
            IDX = reaper.TrackFX_AddByName(SelTrack,NameFX,false,-1)
            reaper.TrackFX_SetPreset(SelTrack,0,NamePreset)
        end------------------------------------------------
        ---------------------------------------------------



        ----------/ Rename track /-----------
        if TrackName and TrackName ~= "" then
            reaper.GetSetMediaTrackInfo_String(SelTrack,"P_NAME",TrackName,1)
        end------------------------------------------------------------------
        ---------------------------------------------------------------------



        ---------/ Open Fx /------------
        if OpenFx >= 0 and IDX >= 0 then --(IDX ► Insert Fx)
            if OpenFx == 0 then ChainFloat = 1 else ChainFloat = 3 end
            local idx
            if PlaceFxOn == 0 then
                idx = reaper.TrackFX_GetCount(SelTrack)-1
            else
                idx = 0
            end
            reaper.TrackFX_Show(SelTrack,idx, ChainFloat) 
        end----------------------------------------------
        -------------------------------------------------



        -------------/ Record Arm /-----------------------------
        if RecordArm == 0 then
            reaper.SetMediaTrackInfo_Value(SelTrack,"I_RECARM",0)
        elseif RecordArm == 1 then
            reaper.SetMediaTrackInfo_Value(SelTrack,"I_RECARM",1)
        elseif RecordArm > 1 then 
            if not StopAction then
                Arc.Action(40737)
                StopAction = "Action"
            end
        end----------------------------
        ---------------------------------



        -------------/ Record Monitoring /----------------------
        if RecordMonitoring == 0 then
            reaper.SetMediaTrackInfo_Value(SelTrack,"I_RECMON",0)
        elseif RecordMonitoring == 1 then
            reaper.SetMediaTrackInfo_Value(SelTrack,"I_RECMON",1)
        elseif RecordMonitoring == 2 then
            reaper.SetMediaTrackInfo_Value(SelTrack,"I_RECMON",2)
        end------------------------------------------------------
        ---------------------------------------------------------



        --------/ AdditionalFx /--------
        if tostring(AdditionalFxName)then
            if #AdditionalFxName > 3 then
                if IDX >= 0 then pos = 2 else pos = 1 end --(IDX ► Insert Fx)
                local Idx = reaper.TrackFX_AddByName(SelTrack,AdditionalFxName,false,-1)
                reaper.TrackFX_SetPreset(SelTrack,Idx,AdditionalNamePreset)
                if Idx >= 0 then
                    if PlaceFxOn == 1 then
                        for i = Idx,pos,-1 do
                           reaper.SNM_MoveOrRemoveTrackFX(SelTrack,i,-1)
                           Idx = i - 1
                        end
                    end
                    if AdditionalFxOpen >= 0 then
                        if AdditionalFxOpen == 0 then ChainFloat = 1 else ChainFloat = 3 end
                        reaper.TrackFX_Show(SelTrack,Idx,ChainFloat) 
                    end
                end
            end
        end-------------------------------------------------------
        --------------------------------------------------------
    end


    reaper.Undo_EndBlock("Add Fx by Name".." / "..NameFX.." / "..AdditionalFxName,-1)
    reaper.PreventUIRefresh(-1)
