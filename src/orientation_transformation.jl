# Rotation/InverseRotation

function Base.propertynames(::Union{reference_type_union(Rotation),reference_type_union(InverseRotation)}, private=false)
    return (:x,:y,:z)
end

function Base.getproperty(r::Union{reference_type_union(Rotation),reference_type_union(InverseRotation)}, prop::Symbol)
    if prop == :x
        return x(r)
    elseif prop == :y
        return y(r)
    elseif prop == :z
        return z(r)
    else
        return getfield(r, prop)
    end
end

# Transform/InverseTransform
function Base.propertynames(::Union{reference_type_union(Transform),reference_type_union(InverseTransform)}, private=false)
    return (:x,:y,:z,:R,:RInv,:p,:pInv,:T)
end

function Base.getproperty(t::Union{reference_type_union(Transform),reference_type_union(InverseTransform)}, prop::Symbol)
    if prop == :x || prop == :y || prop == :z
        return getproperty(t.R, prop)
    elseif prop == :R
        return R(t)
    elseif prop == :RInv
        return RInv(t)
    elseif prop == :p
        return p(t)
    elseif prop == :pInv
        return pInv(t)
    elseif prop == :T
        return T(t)
    else
        return getfield(t, prop)
    end
end

function Base.setproperty!(t::Union{reference_type_union(Transform),reference_type_union(InverseTransform)}, prop::Symbol, val)
    if prop == :P
        return setP!(t, val)
    elseif prop == :PInv
        return setPInv!(t, val)
    elseif prop == :R
        r = updR!(t)
        assign!(r, val)
        return r
    else
        setfield!(t, prop, val)
    end
end

for T in (Transform, InverseTransform)
    @eval begin

function show_transform(io::IO, x::($T))
    arr_io = IOBuffer()
    Base.print_array(IOContext(arr_io, :limit=>true), x.R[])
    lines = eachline(arr_io)
    padwidth = maximum(textwidth.(lines); init=0) + 3
    summary(io, x)
    println(io, ':')
    seekstart(arr_io)
    for (i, l) in enumerate(lines)
        print(io, rpad(l, padwidth), " | ", x.T[i], ifelse(i==3,"", "\n"))
    end
end

function Base.show(io::IO, x::($T))
    if isnothing(get(io, :typeinfo, nothing))
        summary(io, x)
    end
    print(io, '(')
    print(IOContext(io, :limit=>true), dereference_argument(x.R), ", ", dereference_argument(x.T), ')')
end

function Base.show(io::IO, ::MIME"text/plain", x::reference_type_union(($T)))
    if typeof(x) <: ($T)
        show_transform(io, x)
    else
        if typeof(x) <: CxxRef
            print(io, "CxxRef(")
        elseif typeof(x) <: ConstCxxRef
            print(io, "ConstCxxRef(")
        else
            print(io, typeof(x), '(')
        end
        prefix, implicit = Base.typeinfo_prefix(stdout, x)
        print(io, prefix)
        if !implicit
            io = IOContext(io, :typeinfo => eltype(x))
        end
        show(io, dereference_argument(x))
        print(io, ')')
    end
end

    end
end

function Base.:*(
    x1::Union{reference_type_union(Transform),reference_type_union(InverseTransform)},
    x2::Union{reference_type_union(Transform),reference_type_union(InverseTransform)})
    return compose(x1, x2)
end
