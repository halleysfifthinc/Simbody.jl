module Simbody

using CxxWrap, jlsimbody_jll

get_libjlsimbody_path() = jlsimbody_jll.libjlsimbody::String

@wrapmodule(get_libjlsimbody_path)

function __init__()
    @initcxx
end

export SimTKArray, SimTKVec, SimTKRow, SimTKMat, SimTKUnitVec, Rotation, InverseRotation,
    Transform, InverseTransform

export Vec3, Row3, Mat33, UnitVec, SpatialVec, SpatialMat

# export cxxparametricsubtypes

# include("utils.jl")
include("simtk_arrays.jl")
include("orientation_transformation.jl")
include("massproperties.jl")
include("decorations.jl")

end
