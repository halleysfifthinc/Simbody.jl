module Simbody

using CxxWrap, jlsimbody_jll

get_libjlsimbody_path() = jlsimbody_jll.libjlsimbody::String

@wrapmodule(get_libjlsimbody_path)

function __init__()
    @initcxx
end

# Types
export SimTKArray, SimTKVec, SimTKRow, SimTKMat, SimTKUnitVec, Quaternion, Rotation,
    InverseRotation, Transform, InverseTransform, Inertia, UnitInertia, SpatialInertia,
    ArticulatedInertia, MassProperties, DecorativeGeometryRepresentation, PolygonalMesh,
    DecorativeGeometry, DecorativePoint, DecorativeLine, DecorativeCircle, DecorativeSphere,
    DecorativeEllipsoid, DecorativeBrick, DecorativeCylinder, DecorativeFrame,
    DecorativeText, DecorativeMesh, DecorativeMeshFile, DecorativeTorus, DecorativeArrow,
    DecorativeCone, Decorations, Stage, StageLevel, EventCauseNum, EventTrigger,
    HandleEventsOption, HandleEventsResult, Event, EventCause, EventTriggerInfo,
    HandleEventsOptions, HandleEventsResults, State, AbstractValue, EventHandler,
    ScheduledEventHandler, TriggeredEventHandler, PeriodicEventHandler, EventReporter,
    ScheduledEventReporter, TriggeredEventReporter, PeriodicEventReporter

# Type-aliases
export Vec3, Row3, Mat33, UnitVec, SpatialVec, SpatialMat

# export cxxparametricsubtypes

# include("utils.jl")
include("simtk_arrays.jl")
include("orientation_transformation.jl")
include("massproperties.jl")
include("decorations.jl")
include("state.jl")

end
