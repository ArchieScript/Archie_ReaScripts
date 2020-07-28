--[[
   * Category:    Item
   * Description: Toggle Loop item source under mouse cursor
   * Author:      Archie
   * Version:     1.0
   * GIF:         http://avatars.mds.yandex.net/get-pdb/2039533/acb4305b-dde0-4933-b5b7-6f3c1ee78e89/orig
   * Website:     http://forum.cockos.com/showthread.php?t=212819
   *              http://rmmedia.ru/threads/134701/
   * DONATION:    http://money.yandex.ru/to/410018003906628
   * Customer:    Archie(---)
   * Gave idea:   Archie(---)
   * Changelog:   v.1.0 [27.01.20]
   *                  + initialе
--]]
    --======================================================================================
    --////////////// SCRIPT \\\\\\\\\\\\\\  SCRIPT  //////////////  SCRIPT  \\\\\\\\\\\\\\\\
    --======================================================================================



    -------------------------------------------------------
    local function no_undo()reaper.defer(function()end)end;
    -------------------------------------------------------

    local x,y = reaper.GetMousePosition();
    local item,take = reaper.GetItemFromPoint(x,y,false);
    if item then;

        reaper.Undo_BeginBlock();

        local loop = reaper.GetMediaItemInfo_Value(item,"B_LOOPSRC");
        if loop == 0 then;
            reaper.SetMediaItemInfo_Value(item,"B_LOOPSRC",1);
        else;
            reaper.SetMediaItemInfo_Value(item,"B_LOOPSRC",0);
        end;

        reaper.Undo_EndBlock('Toggle Loop item source under mouse cursor',-1);

        reaper.UpdateArrange();
    else;
        no_undo()
    end;