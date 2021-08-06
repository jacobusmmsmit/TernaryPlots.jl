using RecipesBase
using LinearAlgebra

tern2cart(a, b, c) = (1 / 2 * (2b + c) / (a + b + c), √3 / 2 * (c / (a + b + c)))
tern2cart(vec) = tern2cart(vec[1], vec[2], vec[3])

function cart2tern(x, y)
    c = (2 * y) / √3
    b = x - c / 2
    a = 1 - b - c
    return (a, b, c)
end
cart2tern(array) = cart2tern(array[1], array[2])

tupvec(vec) = Tuple([entry] for entry in vec)
coords_to_axes(src, dst) = [src[1], dst[1]], [src[2], dst[2]]

function calculate_guide_pos(axis, arrow_pos, dist_from_graph)
    if axis == "x"
        base_src_tern = (arrow_pos[1], arrow_pos[2], 0)
        base_dst_tern = (arrow_pos[2], arrow_pos[1], 0)
        oriented_dfg = [0, -1] .* dist_from_graph
    elseif axis == "y"
        base_src_tern = (arrow_pos[2], 0, arrow_pos[1])
        base_dst_tern = (arrow_pos[1], 0, arrow_pos[2])
        oriented_dfg = [-1, 1] .* dist_from_graph
    elseif axis == "z"
        base_src_tern = (0, arrow_pos[1], arrow_pos[2])
        base_dst_tern = (0, arrow_pos[2], arrow_pos[1])
        oriented_dfg = [1, 1] .* dist_from_graph
    else
        throw(ArgumentError("Invalid axis (\"x, y, z\""))
    end
    arrow_src = collect(tern2cart(base_src_tern)) .+ 2 .* oriented_dfg
    arrow_dst = collect(tern2cart(base_dst_tern)) .+  2 .* oriented_dfg
    textpos = ((arrow_src .+ arrow_dst) ./ 2) .+ oriented_dfg
    return (arrow_src, arrow_dst, textpos)
end

function calculate_ticks(axis, ticks, tick_length, tickmult)
    tick_endpoints = Vector{Vector{Float64}}(undef, length(ticks))
    tick_startpoints = Vector{Tuple{Float64, Float64}}(undef, length(ticks))

    function start_structure(axis, tick_pos)
        if axis == "x"
            return 1 - tick_pos, tick_pos, 0
        elseif axis == "y"
            return 1 - tick_pos, 0, tick_pos
        elseif axis == "z"
            return 0, tick_pos, 1 - tick_pos
        else
            throw(ArgumentError("Invalid axis (\"x, y, z\""))
        end
    end

    function end_structure(axis, tick_pos)
        if axis == "x"
            return 1 - tick_pos, 0, tick_pos
        elseif axis == "y"
            return 0, 1 - tick_pos, tick_pos
        elseif axis == "z"
            return 1 - tick_pos, tick_pos, 0
        else
            throw(ArgumentError("Invalid axis (\"x, y, z\""))
        end
    end

    for (i, tick_pos) in enumerate(ticks)
        start_point = tern2cart(start_structure(axis, tick_pos)...)
        end_point = tern2cart(end_structure(axis, tick_pos)...)
        tick_offset = LinearAlgebra.normalize(collect(start_point .- end_point)) ./ (1 / tick_length)
        tick_startpoints[i] = start_point
        tick_endpoints[i] = start_point .+ tickmult .* tick_offset
    end
    
    return tick_startpoints, tick_endpoints
end

@userplot Ternary_Axes

@recipe function f(ta::Ternary_Axes)
    # empty plot without axes
    framestyle := :none
    aspect_ratio := true
    dist_from_graph = get(plotattributes, :arrow_length, 0.04)
    arrow_length = get(plotattributes, :arrow_length, 0.4)
    arrow_pos = (1 - arrow_length) / 2, 1 - (1 - arrow_length) / 2
    tick_length = get(plotattributes, :tick_length, 0.015)

    # calculate where arrows and labels should be
    x_arrow_src, x_arrow_dst, x_guide_pos = calculate_guide_pos("x", arrow_pos, dist_from_graph)
    y_arrow_src, y_arrow_dst, y_guide_pos = calculate_guide_pos("y", arrow_pos, dist_from_graph)
    z_arrow_src, z_arrow_dst, z_guide_pos = calculate_guide_pos("z", arrow_pos, dist_from_graph)

    x_arrow_xs, x_arrow_ys = coords_to_axes(x_arrow_src, x_arrow_dst)
    y_arrow_xs, y_arrow_ys = coords_to_axes(y_arrow_src, y_arrow_dst)
    z_arrow_xs, z_arrow_ys = coords_to_axes(z_arrow_src, z_arrow_dst)
    arrow_axes_xs_yes = [(x_arrow_xs, x_arrow_ys), (y_arrow_xs, y_arrow_ys), (z_arrow_xs, z_arrow_ys)]


    if !get(plotattributes, :axis_arrows, true)
        x_guide_pos = (x_arrow_src .+ x_arrow_dst) ./ 2
        y_guide_pos = (y_arrow_src .+ y_arrow_dst) ./ 2
        z_guide_pos = (z_arrow_src .+ z_arrow_dst) ./ 2
    else
        # draw axis arrows
        for xs_ys in arrow_axes_xs_yes
            @series begin
                seriestype := :path
                primary := false
                seriescolor := :black
                arrow := true
                xs_ys
            end
        end
    end

    # labels
    xguide = get(plotattributes, :xguide, "")
    @series begin
        seriestype := :path
        primary := false
        series_annotations := [text(xguide),]
        tupvec(x_guide_pos)
    end

    yguide = get(plotattributes, :yguide, "")
    @series begin
        seriestype := :path
        primary := false
        series_annotations := [text(yguide, 60.0),]
        tupvec(y_guide_pos)
    end

        zguide = get(plotattributes, :zguide, "")
    @series begin
        seriestype := :path
        primary := false
        series_annotations := [text(zguide, -60.0),]
        tupvec(z_guide_pos)
    end

    # grids
    if get(plotattributes, :gridmajor, true)
        if get(plotattributes, :xgrid, true)
            ticks = get(plotattributes, :xticks, 0.2:0.2:0.8)
            src = tern2cart.(1 .- ticks, ticks, 0)
            dst = tern2cart.(1 .- ticks, 0, ticks)
            sa = get(plotattributes, :xgridalpha, 0.5)
            lw = get(plotattributes, :xgridlinewidth, 0.5)
            ls = get(plotattributes, :xgridstyle, :solid)
            for i in eachindex(ticks)
                @series begin
                    primary := false
                    seriestype := :path
                    seriescolor := :black
                    seriesalpha := sa
                    linewidth := lw
                    linestyle := ls
                    arrow := false
                    [src[i], dst[i]]
                end
            end
        end

        if get(plotattributes, :ygrid, true)
            ticks = get(plotattributes, :yticks, 0.2:0.2:0.8)
            src = tern2cart.(1 .- ticks, ticks, 0)
            dst = tern2cart.(0, ticks, 1 .- ticks)
            sa = get(plotattributes, :ygridalpha, 0.5)
            lw = get(plotattributes, :ygridlinewidth, 0.5)
            ls = get(plotattributes, :ygridstyle, :solid)
            for i in eachindex(ticks)
                @series begin
                    primary := false
                seriestype := :path
                    seriescolor := :black
                    seriesalpha := sa
                    linewidth := lw
                    linestyle := ls
                    [src[i], dst[i]]
                end
            end
        end

        if get(plotattributes, :zgrid, true)
            ticks = get(plotattributes, :zticks, 0.2:0.2:0.8)
            src = tern2cart.(1 .- ticks, 0, ticks)
            dst = tern2cart.(0, 1 .- ticks, ticks)
            sa = get(plotattributes, :zgridalpha, 0.5)
            lw = get(plotattributes, :zgridlinewidth, 0.5)
            ls = get(plotattributes, :zgridstyle, :solid)
            for i in eachindex(ticks)
                @series begin
                    primary := false
                    seriestype := :path
                    seriescolor := :black
                    seriesalpha := sa
                    linewidth := lw
                    linestyle := ls
                    [src[i], dst[i]]
                end
            end
        end
    end

    tick_direction = get(plotattributes, :tick_direction, :in)
    # axis ticks
    if tick_direction != :none
        if tick_direction == :in
            tickmult = -1
        else
            tickmult = 1
        end
        xticks = get(plotattributes, :xticks, 0.2:0.2:0.8)
        yticks = get(plotattributes, :yticks, 0.2:0.2:0.8)
        zticks = get(plotattributes, :zticks, 0.2:0.2:0.8)

        function text_structure(axis)
            if axis == "x"
                return 0.4, -0.8
            elseif axis == "y"
                return -1, 0.2
            elseif axis == "z"
                return 0.5, 1
            else
                throw(ArgumentError("Invalid axis (\"x, y, z\""))
            end
        end

        function axis_angle(axis)
            if axis == "x"
                return 0.0
            elseif axis == "y"
                return 60.0
            elseif axis == "z"
                return -60.0
            else
                throw(ArgumentError("Invalid axis (\"x, y, z\""))
            end
        end

        for (axis, axis_ticks) in zip(("x", "y", "z"), (xticks, yticks, zticks))
            angle = axis_angle(axis)
            ts = text_structure(axis)
            # Better to calculate the offset once by calculating the tick_structure once
            # then just adding the offset to each start_pos
            calculated_ticks = calculate_ticks(axis, axis_ticks, tick_length, tickmult)
            vec_tick_textpos = [start_pos .+ (dist_from_graph .* ts) for start_pos in calculated_ticks[1]]
            
            vec_tick_coords = coords_to_axes.(calculated_ticks...)
            if axis == "x"
                axis_ticks = reverse(axis_ticks)
            end
            for tick_coords in vec_tick_coords
                @series begin
                    primary := false
                    seriestype := :path
                    seriescolor := :black
                    tick_coords
                end
            end
            for (tick, tick_textpos) in zip(collect(axis_ticks), vec_tick_textpos)
                @series begin
                    seriestype := :path
                    primary := false
                    series_annotations := [text(tick, angle, 10),]
                    [tick_textpos]
                end
            end
            
        end
    end

    size --> (580, 550)
    seriestype := :path
                primary := false
    seriescolor := :black
    [1 0 1 / 2; 0 1 / 2 1], [0 0 √3 / 2; 0 √3 / 2 0]
end