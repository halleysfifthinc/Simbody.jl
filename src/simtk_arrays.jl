import .Broadcast: Broadcasted, BroadcastStyle, ArrayStyle

using CxxWrap: reference_type_union, dereference_argument

Base.size(x::SimTKArray) = (Int(cppsize(x)),)
Base.IndexStyle(::Type{<:SimTKArray}) = IndexLinear()

Base.size(x::SimTKVector) = (Int.(cppsize(x))...,)
Base.IndexStyle(::Type{<:SimTKVector}) = IndexLinear()

Base.size(x::SimTKMatrix) = (Int.(cppsize(x))...,)

Base.size(x::SimTKVec{N}) where N = (N,)
Base.IndexStyle(::Type{<:SimTKVec}) = IndexLinear()

Base.size(x::SimTKRow{N}) where N = (1,N)
Base.IndexStyle(::Type{<:SimTKRow}) = IndexLinear()

Base.size(x::SimTKMat{N,M}) where {N,M} = (N,M)
Base.size(x::SimTKSymMat{N}) where {N} = (N,N)

for T in (SimTKArray, SimTKVector, SimTKMatrix, SimTKVec, SimTKRow, SimTKMat, SimTKSymMat)
    @eval begin

function Base.show(io::IO, x::reference_type_union(($T)))
    if typeof(x) <: ($T)
        invoke(show, Tuple{IO,AbstractArray}, io, x)
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
        invoke(show, Tuple{IO,AbstractArray}, io, dereference_argument(x))
        print(io, ')')
    end
end

    end
end

# SimTKArray
################

(::Type{SimTKArray{T}})(x) where T = SimTKArray{T,UInt32}(x)

for arrt in cxxparametricsubtypes(SimTKArray)
    local T = eltype(arrt)

    # Bitstypes already have constructor methods for arrays
    if !isbitstype(T)
        @eval begin
function (::Type{($arrt)})(x::Vector{T}) where T <: $T
    ax = GC.@preserve x begin
        ($arrt)(unsafe_wrap(Vector{Any}, Ptr{Any}(pointer(x)), Base.size(x)))
    end
    return ax
end
        end
    end

    @eval begin

function Base.unsafe_copyto!(dest::reference_type_union($arrt), doffs::Integer, src::reference_type_union($arrt), soffs::Integer, N::Integer)
    unsafe_copyto!(dereference_argument(dest), doffs, 
        dereference_argument(src), soffs, N)
    return dest
end

function Base.unsafe_copyto!(dest::reference_type_union($arrt), doffs::Integer, src::Vector{T}, soffs::Integer, N::Integer) where T <: $T
    GC.@preserve dest src begin
        unsafe_copyto!(dereference_argument(dest), doffs,
            unsafe_wrap(Vector{Any}, Ptr{Any}(pointer(src)), Base.size(src)), soffs,
            N)
    end
    return dest
end

function Base.unsafe_copyto!(dest::Vector{T}, doffs::Integer, src::reference_type_union($arrt), soffs::Integer, N::Integer) where T <: $T
    GC.@preserve dest src begin
        unsafe_copyto!(
            unsafe_wrap(Vector{Any}, Ptr{Any}(pointer(src)), Base.size(src)), doffs,
            dereference_argument(dest), soffs,
            N)
    end
    return dest
end

    end
end

function Base.similar(a::SimTKArray{U,I where I}, ::Type{T}, dims::Tuple{Int,Vararg{Int,N}}) where {U,T,N}
    return SimTKArray{T,UInt32}(dims[1])
end

function Base.similar(a::SimTKArray{U,I}, ::Type{T}, dims::Tuple{Int,Vararg{Int,N}}) where {U,I,T,N}
    return SimTKArray{T,I}(dims[1])
end

BroadcastStyle(::Type{<:SimTKArray{T,I}}) where {T,I} = ArrayStyle{SimTKArray{T,I}}()

function Base.similar(bc::Broadcasted{ArrayStyle{SimTKArray{T,I}}}, ::Type{U}) where {T,I,U}
    V = promote_type(T,U)
    if hasmethod(SimTKArray{V,I}, Tuple{Int})
        return SimTKArray{V,I}(length(axes(bc)[1]))
    else
        if U <: UInt32 && hasmethod(SimTKArray{V,UInt32}, Tuple{Int})
            return SimTKArray{V,UInt32}(length(axes(bc)[1]))
        elseif U <: Int32 && hasmethod(SimTKArray{V,Int32}, Tuple{Int})
            return SimTKArray{V,Int32}(length(axes(bc)[1]))
        elseif hasmethod(convert, Tuple{Type{T},V})
            return SimTKArray{T,I}(length(axes(bc)[1]))
        else
            throw(TypeError(:SimTKArray,
                "materializing the broadcast: the C++ type SimTK::Array_<$V,$I> has not been wrapped, and $V is not convertible to $T", SimTKArray{T,I}, SimTKArray{V,I}))
        end
    end
end

function Base.getindex(x::SimTKArray{T,I}, i::J) where {T,I,J}
    return getindex(x, I(i))
end

function Base.getindex(x::SimTKArray{T,I}, i::I) where {T,I}
    @boundscheck checkbounds(x, i)
    return cppgetindex(x,i-1)
end

# Automatically dereference Numbers
function Base.getindex(x::SimTKArray{T,I}, i::I) where {T<:Number,I<:Integer}
    @boundscheck checkbounds(x,i)
    val = cppgetindex(x, i-1)
    return val[]
end

function Base.setindex!(x::SimTKArray{T}, val, i::Int) where {T}
    @boundscheck checkbounds(x, i)
    return cppsetindex!(x, i-1, convert(T,val))
end

function Base.fill!(x::SimTKArray{T}, val) where T
    fill!(x, convert(T, val))
    return x
end

function Base.resize!(x::SimTKArray, n)
    resize!(x, n)
    return x
end

function Base.sizehint!(x::SimTKArray, n)
    if n == size(x,1)
        shrink_to_fit!(x)
    else
        sizehint!(x, n)
    end

    return x
end

@doc """
    erase!(x, i)

Uses zero-based indexing; not bounds checked.

!!! danger Out-of-bounds indexes will crash Julia.

See also: [`deleteat!`](@ref)
""" erase!

function Base.deleteat!(x::SimTKArray, i)
    @boundscheck checkbounds(x, i)
    erase!(x, i-1)
    return x
end

function Base.deleteat!(x::SimTKArray, r::UnitRange{<:Integer})
    @boundscheck checkbounds(x, r)
    erase!(x, first(r)-1, last(r))
    return x
end

function Base.push!(x::SimTKArray{T}, val) where {T}
  push_back!(x, convert(T,val))
  return x
end

function Base.pop!(x::SimTKArray)
    val = copy(last(x))
    pop_back!(x)
    return val
end

function Base.insert!(x::SimTKArray{T}, i, val) where T
    @boundscheck checkbounds(x, i)
    insert!(x, i-1, convert(T, val))
    return x
end

# Vec and Row common type constructors and indexing
################

for T in (SimTKVec, SimTKRow)
    @eval begin

(::Type{($T){N}})(args::Vararg{T,N}) where {T,N} = ($T){N,T,1}(args...)
(::Type{($T){N,T}})(args...) where {N,T} = ($T){N,T,1}(T.(args)...)
(::Type{($T){N,T}})(args::Vararg{U,N}) where {N,T,U<:T} = ($T){N,T,1}(args...)

(::Type{($T){N,T,S}})(x::AbstractVector{T}) where {N,T,S} = ($T){N,T,S}(collect(x))
(::Type{($T){N,T,S}})(x::AbstractVector{U}) where {N,T,U,S} = ($T){N,T,S}(convert.(T,x))

function (::Type{($T){N}})(x::Vector{T}) where {T,N}
    if T <: Union{SimTKVec,SimTKRow}
        return ($T){N,supertype(T),1}(x)
    else
        return ($T){N,T,1}(x)
    end
end

function Base.getindex(x::($T){N,T}, i::Int) where {N,T}
    @boundscheck checkbounds(x, i)
    return cppgetindex(x,i-1)
end

# Automatically dereference Numbers
function Base.getindex(x::($T){N,T}, i::Int) where {N,T<:Union{Float64,ComplexF64}}
    @boundscheck checkbounds(x, i)
    return cppgetindex(x,i-1)[]
end

function Base.setindex!(x::($T){N,T}, val, i::Int) where {N,T}
    @boundscheck checkbounds(x, i)
    return cppsetindex!(x, i-1, convert(T,val))
end

function Base.zero(::Type{<:($T){N,T,S}}) where {N,T,S}
    z = ($T){N,T,S}()
    setToZero(z)
    return z
end

function Base.one(::Type{<:($T){N,T,S}}) where {N,T,S}
    return ($T){N,T,S}(one(T))
end

    end
end

for arrt in [cxxparametricsubtypes(SimTKVec); cxxparametricsubtypes(SimTKRow)]
    local T = eltype(arrt)

    # Bitstypes already have constructor methods for arrays
    if !isbitstype(T)
        @eval begin
function (::Type{($arrt)})(x::Array{<:$T})
    ax = GC.@preserve x begin
        ($arrt)(unsafe_wrap(Array{Any}, Ptr{Any}(pointer(x)), Base.size(x)))
    end
    return ax
end
        end
    end

    @eval begin
function Base.unsafe_copyto!(dest::reference_type_union($arrt), doffs::Integer, src::reference_type_union($arrt), soffs::Integer, N::Integer)
    unsafe_copyto!(dereference_argument(dest), doffs, 
        dereference_argument(src), soffs, N)
    return dest
end

function Base.unsafe_copyto!(dest::reference_type_union($arrt), doffs::Integer, src::Array{<:$T}, soffs::Integer, N::Integer)
    GC.@preserve dest src begin
        unsafe_copyto!(dereference_argument(dest), doffs,
            unsafe_wrap(Array{Any}, Ptr{Any}(pointer(src)), Base.size(src)), soffs,
            N)
    end
    return dest
end

function Base.unsafe_copyto!(dest::Array{<:$T}, doffs::Integer, src::reference_type_union($arrt), soffs::Integer, N::Integer)
    GC.@preserve dest src begin
        unsafe_copyto!(
            unsafe_wrap(Array{Any}, Ptr{Any}(pointer(src)), Base.size(src)), doffs,
            dereference_argument(dest), soffs,
            N)
    end
    return dest
end
    end
end

# Vec
################

const Vec3 = SimTKVec{3,Float64,1}
const UnitVec = SimTKUnitVec{Float64,1}

function Base.similar(a::SimTKVec, ::Type{T}, dims::Tuple{Int,Vararg{Int,N}})::AbstractMatrix{T} where {T,N}
    f, rest... = dims
    if length(dims) == 1 || all(==(1), rest)
        return SimTKVec{f,T,1}()
    elseif length(dims) == 2
        return SimTKMat{f,rest[1],T,f,1}()
    end
end
Base.similar(a::SimTKVec{N}, ::Type{T}) where {N,T} = SimTKVec{N,T}()

BroadcastStyle(::Type{<:SimTKVec}) = ArrayStyle{SimTKVec}()

function Base.similar(bc::Broadcasted{ArrayStyle{SimTKVec}}, ::Type{T}) where T <: Union{Float64, ComplexF64, SimTKVec{3,Float64,1}, SimTKRow{3,Float64,1}}
    return SimTKVec{length(axes(bc)[1]),T}()
end

# Row
################

const Row3 = SimTKRow{3,Float64,1}

function Base.similar(a::SimTKRow, ::Type{T}, dims::Tuple{Int,Vararg{Int,N}})::AbstractMatrix{T} where {T,N}
    f, rest... = dims
    if length(dims) == 1 || all(==(1), rest)
        return SimTKRow{f,T,1}()::SimTKRow{f,T,1}
    elseif length(dims) == 2
        return SimTKMat{f,rest[1],T,f,1}()
    end
end
Base.similar(a::SimTKRow{N}, ::Type{T}) where {N,T} = SimTKRow{N,T,1}()

BroadcastStyle(::Type{<:SimTKRow}) = ArrayStyle{SimTKRow}()

function Base.similar(bc::Broadcasted{ArrayStyle{SimTKRow}}, ::Type{Float64})
    return SimTKRow{length(axes(bc)[2]),Float64,1}()
end

# Mat
################

Base.similar(a::SimTKMat, ::Type{T}, dims...) where T = SimTKMat{dims[1],dims[2],T,1}()
Base.similar(a::SimTKMat{N,M}, ::Type{T}) where {N,M,T} = SimTKMat{N,M,T,1}()

BroadcastStyle(::Type{<:SimTKMat}) = ArrayStyle{SimTKMat}()

const Mat33 = SimTKMat{3,3,Float64,3,1}

# Rerun the commented out lines if/when changing wrapped Mat parameters
# WRAPPED_MAT_ELTYPES = Union{eltype.(cxxparametricsubtypes(SimTKMat))...}
# NONARRAY_MAT_ELTYPES = Union{filter(x -> !(x <: AbstractArray), unique(eltype.(cxxparametricsubtypes(SimTKMat))))...}
const NONARRAY_MAT_ELTYPES = Union{Float64,ComplexF64}
const WRAPPED_MAT_ELTYPES = Union{Vec3,Row3,Mat33,NONARRAY_MAT_ELTYPES}

function Base.similar(bc::Broadcasted{ArrayStyle{SimTKMat}}, ::Type{T}) where T <: WRAPPED_MAT_ELTYPES
    r, c, = length.(axes(bc))
    if T <: SimTKRow
        return SimTKMat{r,c,T,1,2}()
    else
        return SimTKMat{r,c,T,r,1}()
    end
end

function (::Type{SimTKMat{N,M}})(args::Vararg{U,O}) where {N,M,U,O}
    O == N*M || throw(MethodError(SimTKMat{N,M,U}, args))
    if U <: Number
        if U <: Real
            return SimTKMat{N,M,Float64}(Float64.(args)...)
        elseif U <: Complex
            return SimTKMat{N,M,ComplexF64}(ComplexF64.(args)...)
        end
    else
        return SimTKMat{N,M,U}(args...)
    end
end

function (::Type{SimTKMat{N,M,T}})(args::Vararg{T,O}) where {N,M,T,O}
    O == N*M || throw(MethodError(SimTKMat{N,M,T}, args))
    if T <: SimTKRow
        return SimTKMat{N,M,T,1,2}(args...)
    else
        return SimTKMat{N,M,T,N,1}(args...)
    end
end

function (::Type{SimTKMat{N,M,T,CS,RS}})(args::Vararg{T,O}) where {N,M,T,O,CS,RS}
    O == N*M || throw(MethodError(SimTKMat{N,M,T,CS,RS}, args))
    return SimTKMat{N,M,T,CS,RS}((SimTKVec{N,T,1}(args[(1:3) .+ i]...) for i in 0:(M-1))...)
end

function Base.getindex(x::SimTKMat{N,M,T}, i::Vararg{Int,NI}) where {N,M,T,NI}
    @boundscheck checkbounds(x, i...)
    r, c, = i
    return cppgetindex(x,r-1,c-1)
end

# Automatically dereference Numbers
function Base.getindex(x::SimTKMat{N,M,T}, i::Vararg{Int,NI}) where {N,M,T<:Union{Float64,ComplexF64},NI}
    @boundscheck checkbounds(x, i...)
    r, c, = i
    return cppgetindex(x,r-1,c-1)[]
end

function Base.setindex!(x::SimTKMat{N,M,T}, val, i::Vararg{Int,NI}) where {N,M,T,NI}
    @boundscheck checkbounds(x, i...)
    r, c, = i
    return cppsetindex!(x, r-1, c-1, convert(T,val))
end

function Base.zero(::Type{<:SimTKMat{N,T,S}}) where {N,T,S}
    z = SimTKMat{N,T,S}()
    setToZero(z)
    return z
end

function Base.one(::Type{<:SimTKMat{N,T,S}}) where {N,T,S}
    return SimTKMat{N,T,S}(one(T))
end

# SymMat
################

function Base.similar(a::SimTKSymMat, ::Type{T}, dims...) where T
    dims[1] != dims[2] && 
        throw(DimensionMismatch("SimTKSymMat must be square; expected $((dims[1],dims[1])), but got $dims"))
    return SimTKSymMat{dims[1],T,1}()
end
Base.similar(a::SimTKSymMat{N}, ::Type{T}) where {N,T} = SimTKSymMat{N,T,1}()

BroadcastStyle(::Type{<:SimTKSymMat}) = ArrayStyle{SimTKSymMat}()

function Base.similar(bc::Broadcasted{ArrayStyle{SimTKSymMat}}, ::Type{T}) where T <: WRAPPED_MAT_ELTYPES
    r, c, = length.(axes(bc))
    r != c && 
        throw(DimensionMismatch("SimTKSymMat must be square; expected $((r,r)), but got $((r,c))"))
    return SimTKSymMat{r,T,1}()
end

function Base.getindex(x::SimTKSymMat{N,M,T}, i::Vararg{Int,NI}) where {N,M,T,NI}
    @boundscheck checkbounds(x, i...)
    r, c, = i
    return cppgetindex(x,r-1,c-1)
end

# Automatically dereference Numbers
function Base.getindex(x::SimTKSymMat{N,M,T}, i::Vararg{Int,NI}) where {N,M,T<:Union{Float64,ComplexF64},NI}
    @boundscheck checkbounds(x, i...)
    r, c, = i
    return cppgetindex(x,r-1,c-1)[]
end

function Base.setindex!(x::SimTKSymMat{N,M,T}, val, i::Vararg{Int,NI}) where {N,M,T,NI}
    @boundscheck checkbounds(x, i...)
    r, c, = i
    return cppsetindex!(x, r-1, c-1, convert(T,val))
end


