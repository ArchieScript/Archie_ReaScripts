--[[
   * Category:    Function
   * Description: Arc_Function_lua
   * Author:      Archie
   * Version:     1.0.2
   * AboutScript: Functions for use with some scripts Archie
   * О скрипте:   Функции для использования с некоторыми скриптами Archie
   * Provides:    [nomain].
   * ---------------------
   * Changelog:   + GetMediaItemInfo_Value(item,parmname)/[D_END] 
   *              + Get_Format_ProjectGrid(divisionIn)
   *              + Action(id);
   *              + CountTrackSelectedMediaItems(track);
   *              + GetTrackSelectedMediaItems(track,idx);
--======================================================]]



    --======================================================================================
    --///////////  FUNCTIONS  \\\\\\\\\\\\  FUNCTIONS  ////////////  FUNCTIONS  \\\\\\\\\\\\
    --======================================================================================




    --===================
    local Arc_Module = {}
    --===================



    --------------GetMediaItemInfo_Value-----------------------
    function Arc_Module.GetMediaItemInfo_Value(item, parmname)
        if parmname == "END" or parmname == "D_END" then return
            reaper.GetMediaItemInfo_Value(item,"D_POSITION")+
            reaper.GetMediaItemInfo_Value(item,"D_LENGTH")
        else
            return reaper.GetMediaItemInfo_Value(item,parmname) 
        end
    end 
    --=========================================================



    -----------Get_Format_ProjectGrid----------
    function Get_Format_ProjectGrid(divisionIn)
        local grid_div
        if divisionIn < 1 then
            grid_div = (1 / divisionIn)
            if math.fmod(grid_div,3) == 0 then
                grid_div = "1/"..string.format("%.0f",grid_div/1.5).."T"
            else
                grid_div = "1/"..string.format("%.0f",grid_div) 
            end
        else    
            grid_div = tonumber(string.format("%.0f",divisionIn)) 
        end    
        return grid_div
    end
    -- Форматирует значение сетки проекта в удобочитаемую форму
    --=========================================================



    -------------Action-----------
    function Arc_Module.Action(id)
        reaper.Main_OnCommand(reaper.NamedCommandLookup(id),0)
    end
    -- Выполняет действие, относящееся к разделу основное действие. 
    --=============================================================



    ----------------CountTrackSelectedMediaItems----------------
    function Arc_Module.CountTrackSelectedMediaItems(track);
        local CountTrItems = reaper.CountTrackMediaItems(track);
        local count = 0;
        for i = 1,CountTrItems do;
            local Items =  reaper.GetTrackMediaItem(track,i-1);
            local sel = reaper.IsMediaItemSelected(Items);
            if sel then count = count + 1 end;
        end;
        return count;
    end;
    --Количество в треке Выбранных Элементов
    --==========================================================



    ---------------GetTrackSelectedMediaItems----------------
    function Arc_Module.GetTrackSelectedMediaItems(track,idx);
        local CountTrItems = reaper.CountTrackMediaItems(track);
        local count = -1;
        for i = 1,CountTrItems do;
            local Items = reaper.GetTrackMediaItem(track,i-1);
            local sel = reaper.IsMediaItemSelected(Items);
            if sel then count = count + 1 end;
            if count == idx then return Items end;
        end;
    end;
    -- Получить в треке Выбранный Элемент
    --============================================



    --===============
    return Arc_Module
    --===============
