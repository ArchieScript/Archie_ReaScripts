--[[
   * Category:    Track
   * Description: Make folder from selected tracks
   * Author:      Archie
   * Version:     1.0
   * AboutScript: Make folder from selected tracks,scattered around project 
   * О скрипте:   Создать папку из выбранных треков, разбросанных по проекту 
   * GIF:         http://clck.ru/Eey8D
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Customer:    ---
   * Gave idea:   --- 
   * Changelog:   + initialе / v.1.0 
--=============================================================
SYSTEM  REQUIREMENTS:  Reaper v.5.96 |  SWS v.2.9.7  (and above)
СИСТЕМНЫЕ ТРЕБОВАНИЯ:  Reaper v.5.96 |  SWS v.2.9.7     (и выше)
--============================================================]]



    --======================================================================================
    --////////////  НАСТРОЙКИ  \\\\\\\\\\\\  SETTINGS  ////////////  НАСТРОЙКИ  \\\\\\\\\\\\
    --======================================================================================



    local ActivInput = 0
                       -- ActivInput = 1 - Активировать окно для ввода имени папки
                       -- ActivInput = 0  Не активировать
                                                 --------
                       -- ActivInput = 1 - Enable the window to enter the folder name
                       -- ActivInput = 0  Do not activate
                       ----------------------------------                         
                         
    local FoldName = "Folder"
                          -- FoldName = Задайте имя создаваемой папки 
                          --Для отсутствия имени задайте имя "nil"
                                                         --------
                          --FoldName = Specify the name of the created folder
                          --For the absence of a name, give the name "nil"
                          ----------------------------------------------
    
    local R, G, B = nil, nil, nil
                      -- R, G, B = Задайте цвет создаваемой папки R, G, B 
                      -- например:local R, G, B = 162, 171, 171
                      -- для рандомного выбора цвета задайте значения
                      -- local R, G, B = "random","random","random"
                      -- иначе задайте значения 
                      -- local R, G, B = nil, nil, nil
                                          ------------
                      -- R, G, B = Specify the color of the created folder R, G, B 
                      -- eg: local R, G, B = 162, 171, 171
                      -- To randomly select a color, set the values
                      -- local R, G, B = "random","random","random"
                      -- otherwise, specify values  
                      -- local R, G, B = nil, nil, nil
                          -- http://csscolor.ru/rgb/162,171,171
                      ----------------------------------------
    
    local FoldTrCol = 0
                    -- FoldTrCol = 0 - Отключить раскрашивание треков в папке
                    -- FoldTrCol = 1 - Покрасить все треки в созданной папки и
                                          -- во всех подпапках в цвет созданной папки
                    -- FoldTrCol = 2 - Покрасить все треки в созданной папки в 
                                       -- цвет созданной папки за исключением подпапок
                    -- FoldTrCol = 3 - Покрасить все треки в созданной папки в 
                    --цвет созданной папки и все треки подпапок в родительский цвет подпапки
                                                              ------------------------------
                    -- FoldTrCol = 0 - Disable coloring of tracks in the folder
                    -- FoldTrCol = 1 - Color all tracks in the created folder and
                                -- in all subfolders in the color of the created folder
                    -- FoldTrCol = 2 - Color all tracks in the created folder into the 
                                --color of the created folder except for the sub-folders
                    -- FoldTrCol = 3 - Color all tracks in the created folder into the 
                      --color of the created folder and all the subfolders'
                               -- tracks in the parent color of the subfolder
                    ---------------------------------------------------------  
    
    local SelFolder = 0
                    -- SelFolder = 0 - Не выделять трек созданной папки
                    -- SelFolder = 1 - Выделить трек созданной папки
                                             -----------------------
                    -- SelFolder = 0 - Do not highlight the track of the created folder
                    -- SelFolder = 1 - Select the track of the created folder
                    ---------------------------------------------------------
    
 
 
 
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================
    
    
    
    
    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    local SelTrack = reaper.GetSelectedTrack(0,0)
    if not SelTrack then no_undo() return end


    reaper.PreventUIRefresh(1)
    reaper.Undo_BeginBlock() 


    local name_script = "Make a folder of selected tracks,scattered around project"
    
    local numb = reaper.GetMediaTrackInfo_Value(SelTrack,"IP_TRACKNUMBER")
    reaper.InsertTrackAtIndex(numb-1,true)

    reaper.ReorderSelectedTracks(numb,1)
    local track = reaper.GetTrack(0,numb-1)
    reaper.SetMediaTrackInfo_Value(track,"I_SELECTED",1)
    reaper.SetOnlyTrackSelected(track)
    if SelFolder <= 0 then
        reaper.SetMediaTrackInfo_Value(track,"I_SELECTED",0)
    end
    
    if not FoldName or FoldName == "nil"  then FoldName = "" end
    reaper.GetSetMediaTrackInfo_String(track,'P_NAME',FoldName,1)
    
    local color
    if tonumber(R) and tonumber(G) and tonumber(B) then
        SF,color = string.format,1
        R,G,B = SF('%.3s',SF('%.0f',R)),SF('%.3s',SF('%.0f',G)),SF('%.3s',SF('%.0f',B))
    elseif R == "random" or G == "random" or B == "random"
        or R == "Random" or G == "Random" or B == "Random" then
        mr,color = math.random,1
        R,G,B = mr(999),mr(999),mr(999)
    end
    if color == 1 then
        local RGB = reaper.ColorToNative(R, G, B)
        reaper.SetTrackColor(track, RGB)
    end
    ------------------------------
    
    
   
    if FoldTrCol > 0 and FoldTrCol <= 3 then
    
        local FoldColor,TrDepth,numb = {},{},{}
        
        FoldColor[#FoldColor+1] = reaper.GetTrackColor(track)
        TrDepth[#TrDepth+1] = reaper.GetTrackDepth(track)
        numb[#numb+1] = reaper.GetMediaTrackInfo_Value(track,"IP_TRACKNUMBER")
        
        for i = numb[1], reaper.CountTracks(0)-1 do
            local track = reaper.GetTrack(0,i)
            local Depth = reaper.GetTrackDepth(track)

            if Depth > TrDepth[1] then
                if reaper.GetMediaTrackInfo_Value(track,"I_FOLDERDEPTH")== 1 then
                    FoldColor[#FoldColor+1]= reaper.GetTrackColor( track )
                    TrDepth[#TrDepth+1]  = reaper.GetTrackDepth( track )
                    numb[#numb+1] = reaper.GetMediaTrackInfo_Value(track,"IP_TRACKNUMBER")
                end
            end
        end  
        ----
        if FoldTrCol == 1 then   
            for i = numb[1], reaper.CountTracks(0)-1 do 
                local track = reaper.GetTrack(0,i-1)
                local Depth = reaper.GetTrackDepth( track )
                if Depth > TrDepth[1] then
                    --reaper.SetTrackColor(track, FoldColor[1])
                    reaper.SetMediaTrackInfo_Value(track,"I_CUSTOMCOLOR",FoldColor[1]) 
                end   
            end
        end    
        ---
        if FoldTrCol == 2 then    
            for i = numb[1], reaper.CountTracks(0)-1 do 
                local track = reaper.GetTrack(0,i-1)
                local Depth = reaper.GetTrackDepth( track )
                if Depth == TrDepth[1]+1 then
                    if reaper.GetMediaTrackInfo_Value(track,"I_FOLDERDEPTH")~= 1 then
                        --reaper.SetTrackColor(track, FoldColor[1])
                        reaper.SetMediaTrackInfo_Value(track,"I_CUSTOMCOLOR",FoldColor[1]) 
                    end 
                end   
            end
        end    
        ---
        if FoldTrCol == 3 then    
            for i = 1,#numb do 
                for i2 = numb[i], reaper.CountTracks(0)-1 do 
                    local track = reaper.GetTrack(0,i2-1)
                    local Depth = reaper.GetTrackDepth( track )
                    if Depth == TrDepth[i]+1 then
                        if reaper.GetMediaTrackInfo_Value(track,"I_FOLDERDEPTH")~= 1 then
                            --reaper.SetTrackColor(track, FoldColor[i])
                            reaper.SetMediaTrackInfo_Value(track,"I_CUSTOMCOLOR",FoldColor[i]) 
                        end 
                    end   
                end
            end
        end    
        ---
    end   
    ---        
       
    reaper.PreventUIRefresh(-1)
    if ActivInput == 1 then
        reaper.Main_OnCommand(40696,0)
        -- Rename last touched track
    end    
    reaper.Undo_EndBlock(name_script,-1)