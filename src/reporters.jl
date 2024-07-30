function julia_userfunction_real(f, _system::Ptr{Cvoid}, _state::Ptr{Cvoid})
    system = ConstCxxRef{System}(_system)[]
    state = ConstCxxRef{State}(_state)[]
    res = f(system, state)::Float64
    return res
end

function get_julia_userfunction_real()
    return @cfunction(julia_userfunction_real, Float64, (Any,Ptr{Cvoid},Ptr{Cvoid}))
end

function julia_userfunction_vector(f, _system::Ptr{Cvoid}, _state::Ptr{Cvoid})
    system = ConstCxxRef{System}(_system)[]
    state = ConstCxxRef{State}(_state)[]
    res = f(system, state)::SimTKVector{Float64}
    return res.cpp_object
end

function get_julia_userfunction_vector()
    return @cfunction(julia_userfunction_vector, Float64, (Any,Ptr{Cvoid},Ptr{Cvoid}))
end

function JuliaUserFunction(f)
    ret = Base.return_types(f, Tuple{System, State})
    length(ret) == 1 || throw(ArgumentError("badly specified function"))
    if only(ret) == Float64
        return JuliaUserFunctionReal(f)
    elseif only(ret) == SimTKVector{Float64}
        return JuliaUserFunctionVector(f)
    else
        throw(ArgumentError("badly specified function"))
    end
end
