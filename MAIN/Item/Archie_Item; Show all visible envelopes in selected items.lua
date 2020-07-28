--[[ 
   * Category:    Item 
   * Description: Show all visible envelopes in selected items  
   * Author:      Archie 
   * Version:     1.01 
   * AboutScript: Show all visible envelopes in selected items  
   * О скрипте:   Показать все видимые конверты в выбранных элементах 
   * GIF:         http://clck.ru/Eevx9 
   * Website:     http://forum.cockos.com/showthread.php?t=212819 
   * Donation:    http://money.yandex.ru/to/410018003906628 
   * Customer:    mr.preacher(RMM Forum)  
   * Gave idea:   mr.preacher(RMM Forum)  
   * Changelog:   +! Fixed curve display when visibility is disabled / v.1.01 
                  +! Исправлено отображение кривой при отключенной видимости / v.1.01 
                  + initialе / v.1.0  
--================================================================================== 
SYSTEM  REQUIREMENTS:  Reaper v.5.96 |  SWS v.2.9.7  (and above) 
СИСТЕМНЫЕ ТРЕБОВАНИЯ:  Reaper v.5.96 |  SWS v.2.9.7     (и выше) 
--============================================================]] 
 
 
 
 
    --====================================================================================== 
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\ 
    --====================================================================================== 
     
     
     
    ----------------------------------------------------------------------------- 
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end 
    ----------------------------------------------------------------------------- 
     
     
     
    local CountSelIt = reaper.CountSelectedMediaItems(0) 
    if CountSelIt == 0 then no_undo() return end 
     
    local name_script,undo = "Show all visible envelopes in selected items" 
      
    for it = 1,CountSelIt do   
        local Sel_Item = reaper.GetSelectedMediaItem(0,it-1) 
        ---- 
        local CountTakes = reaper.CountTakes( Sel_Item ) 
        for i = 1,CountTakes  do 
            local Take = reaper.GetMediaItemTake( Sel_Item, i-1 ) 
            local CountTakeEnv = reaper.CountTakeEnvelopes( Take ) 
            for i2 = 1,CountTakeEnv  do 
                local TakeEnv = reaper.GetTakeEnvelope( Take, i2-1 ) 
                --- 
                local Env = reaper.BR_EnvAlloc( TakeEnv, true ) 
                local active      , 
                      visible     , 
                      armed       , 
                      inLane      , 
                      laneHeight  , 
                      defaultShape, 
                      minValue    , 
                      maxValue    , 
                      centerValue , 
                      types       , 
                      faderScaling = reaper.BR_EnvGetProperties( Env ) 
                      if visible == false then undo = 0 end 
                reaper.BR_EnvSetProperties( Env         ,  
                                            true        , 
                                            true        ,  
                                            armed       ,  
                                            inLane      ,  
                                            laneHeight  ,  
                                            defaultShape,  
                                            faderScaling) 
                reaper.BR_EnvFree( Env, true ) 
            end     
        end 
        --- 
    end 
    if undo == 0 then    
        reaper.Undo_BeginBlock()  
        reaper.Undo_EndBlock(name_script,-1) 
    else 
        no_undo() 
    end 