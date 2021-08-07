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
    arrow_dst = collect(tern2cart(base_dst_tern)) .+ 2 .* oriented_dfg
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
        tick_offset = normalize(collect(start_point .- end_point)) ./ (1 / tick_length)
        tick_startpoints[i] = start_point
        tick_endpoints[i] = start_point .+ tickmult .* tick_offset
    end

    return tick_startpoints, tick_endpoints
end
