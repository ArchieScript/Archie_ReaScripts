--[[
   * Category:    Options 
   * Description: Solo in front' dimming -1 dB from set value
   * Oписание:    Соло спереди' затемнение -1 дБ от заданного значения
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    Supa75[RMM Forum] 
   * gave idea:   Supa75[RMM Forum]  
--================================]]  

    
    local DB = 1
             -- установите значение на сколько дб уменьшить
             -- set the value to how much dB to reduce
             
 
 
    --===========================================================================
    --//////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================


 
    
    
    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------
    
    

    if not tonumber(DB) then return end;
    
    reaper.Undo_BeginBlock();
    local dimming = reaper.SNM_GetIntConfigVar("solodimdb10",0); 
    reaper.SNM_SetIntConfigVar("solodimdb10",dimming+(tonumber(-math.abs(DB))*10));      
    local undo = reaper.SNM_GetIntConfigVar("solodimdb10",0)/10;
    
    reaper.Undo_EndBlock(undo.."/"..-DB.."db Solo in front' dimming",1);