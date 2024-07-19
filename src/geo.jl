Base.size(x::GeoLineSeg) = (2,)
Base.eltype(::Type{GeoLineSeg{T}}) where T = SimTKVec{3,T,1}

function Base.getindex(x::GeoLineSeg{T}, i::Int) where {T}
    @boundscheck checkbounds(x, i)
    return cppgetindex(x,i-1)
end

function Base.setindex!(x::GeoLineSeg{T}, val::SimTKVec{3,T,1}, i::Int) where {T}
    @boundscheck checkbounds(x, i)
    return cppsetindex!(x, i-1, val)
end

function Base.setindex!(x::GeoLineSeg{T}, val, i::Int) where {T}
    @boundscheck checkbounds(x, i)
    return cppsetindex!(x, i-1, eltype(x)(val))
end

Base.size(x::GeoTriangle) = (3,)
Base.eltype(::Type{GeoTriangle{T}}) where T = SimTKVec{3,T,1}

function Base.getindex(x::GeoTriangle{T}, i::Int) where {T}
    @boundscheck checkbounds(x, i)
    return cppgetindex(x,i-1)
end

function Base.setindex!(x::GeoTriangle{T}, val::SimTKVec{3,T,1}, i::Int) where {T}
    @boundscheck checkbounds(x, i)
    return cppsetindex!(x, i-1, val)
end

function Base.setindex!(x::GeoTriangle{T}, val, i::Int) where {T}
    @boundscheck checkbounds(x, i)
    return cppsetindex!(x, i-1, eltype(x)(val))
end

