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
