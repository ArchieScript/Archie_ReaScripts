--[[
   * Category:    Grid
   * Description: Swing grid plus one percent(arrange)
   * Oписание:    качание сетки плюс один процент(аранжировка)
   * GIF:         ---
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   * Donation:    http://money.yandex.ru/to/410018003906628
   * Author:      Archie
   * Version:     1.0
   * customer:    Maestro Sound(RMM Forum)
   * gave idea:   Maestro Sound(RMM Forum)
--=================================================]]



    local SWING = ( 1 )
                -- Установить процент качания от -200 до 200
                -- To set the percentage of swing from -200 to 200
                ---------------------------------------------------

    local SwingArrangeOnOff = (0)
                      -- SwingArrangeOnOff = 0 - скрипт сработает только в том случае,
                          -- если  включено качания
                                                       -----------
                      -- SwingArrangeOnOff = 1 - скрипт сам включит качания
                        -----------------------------------------------------------
                     -- SwingArrangeOnOff = 1 - The script will only work if,
                            -- the swing is on
                                                      -----------
                     -- SwingArrangeOnOff = 0 - the script itself will include swings
                       -----------------------------------------------------------



    --===========================================================================
    --////////////////////////////   SCRIPT   \\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\\
    --===========================================================================



    -----------------------------------------------------------------------------
    local function No_Undo()end; local function no_undo()reaper.defer(No_Undo)end
    -----------------------------------------------------------------------------



    if not tonumber(SWING)then no_undo() return end
    if not tonumber(SwingArrangeOnOff)then SwingArrangeOnOff = 0 end
    if SWING < -200 or SWING > 200 then SWING = 1 end

    local _,grid,swingOnOff,swing = reaper.GetSetProjectGrid(0,0)
    if swingOnOff == 0 then
        if SwingArrangeOnOff == 1 then
            swingOnOff = select(3,reaper.GetSetProjectGrid(0,1,nil,1,nil))
        else
            no_undo() return
        end
    end

    swing = select(4,reaper.GetSetProjectGrid(0,1,grid,swingOnOff,swing+SWING/100))

    if swing <= -1.0 then swing = -1.0 end
    if swing >=  1.0 then swing =  1.0 end

    local plus
    if SWING > 0  then SWING = "+"..SWING end
    local swing = tonumber(string.format('%.2f',swing))
    if swing > 0 then plus = "+" else plus = "" end
    local Undo = swing *100 .."%  / swing ".. SWING .." /"
    reaper.Undo_BeginBlock()
    reaper.Undo_EndBlock(plus..Undo,1)