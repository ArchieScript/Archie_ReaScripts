--[[
   * Category:    Markers
   * Description: Create region by borders of selected items
   * Oписание:    Создание региона по границам выбранных элементов
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    borisuperful(RMM Forum)
   * gave idea:   borisuperful(RMM Forum)
--=====================================]]



    local Name = "Имя региона"
                           -- Задайте Имя региона 
                           -- Specify Region Name
                                  ---------------
                                  
    local R, G, B = nil, nil, nil
                          -- R, G, B = Задайте цвет создаваемого региона R, G, B 
                          -- например:local R, G, B = 162, 171, 171
                          -- для рандомного выбора цвета задайте значения
                          -- local R, G, B = "random","random","random"
                          -- иначе задайте значения 
                          -- local R, G, B = nil, nil, nil
                          -- http://csscolor.ru/rgb/162,171,171
                                              -----------------
                                              
    local TimeSelection = 0
                     -- = 0 | OFF | ВЫКЛ
                     -- = 1 | ON  |  ВКЛ
                     -------------------



    --===========================================================================
    --///////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================
    
    
    
    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------
  
    
  
    local Count = reaper.CountSelectedMediaItems( 0 )
    if Count == 0 then no_undo() return end
    


    local Undo,POS,END,col = _, 9^9,0
    for i = 1,Count do
        local item = reaper.GetSelectedMediaItem( 0, i-1 )
        local pos_it = reaper.GetMediaItemInfo_Value( item, "D_POSITION")
        local end_it = pos_it + reaper.GetMediaItemInfo_Value( item, "D_LENGTH" )
        if pos_it < POS then POS = pos_it end
        if end_it > END then END = end_it end
    end   
    if TimeSelection == 1 then
        local start, End = reaper.GetSet_LoopTimeRange( 1, 1, POS, END, 0 )
    end
    ---
    
    if R == "random" and G == "random" and B == "random" then 
        local mr = math.random R,G,B = mr(999),mr(999),mr(999)
    end
    
    if R ~= nil and G ~= nil and B ~= nil then 
        
        local RGB = reaper.ColorToNative(R, G, B) 
        reaper.PreventUIRefresh(158)
        reaper.InsertTrackAtIndex( 0, false )
        local track = reaper.GetTrack(0,0)
        reaper.SetTrackColor( track, RGB )
        col = reaper.GetTrackColor( track )
        reaper.DeleteTrack( track )
        reaper.PreventUIRefresh(-158)
    else
        col = 0
    end
    reaper.AddProjectMarker2( 0, 1, POS, END, Name, -1, col)
       
    reaper.Undo_BeginBlock() 
    reaper.Undo_EndBlock("Create region by borders of selected items",1)
