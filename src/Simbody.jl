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
    DecorativeCone, Decorations, Stage, Event, EventCause, EventTriggerInfo,
    HandleEventsOptions, HandleEventsResults, State, AbstractValue, EventHandler,
    ScheduledEventHandler, TriggeredEventHandler, PeriodicEventHandler, EventReporter,
    ScheduledEventReporter, TriggeredEventReporter, PeriodicEventReporter, Subsystem,
    System, ProjectOptions, ProjectResults, DefaultSystemSubsystem, RealizeOptions,
    RealizeResults, CacheEntryInfo, AbstractMeasure, Measure, ConstantMeasure, ZeroMeasure,
    OneMeasure, TimeMeasure, VariableMeasure, ResultMeasure, SinusoidMeasure, PlusMeasure,
    MinusMeasure, ScaleMeasure, IntegrateMeasure, DifferentiateMeasure, ExtremeMeasure,
    MinimumMeasure, MaximumMeasure, MaxAbsMeasure, MinAbsMeasure, GeoPoint, GeoSphere,
    GeoLineSeg, GeoBox, GeoAlignedBox, GeoOrientedBox, GeoTriangle, GeoCubicHermiteCurve,
    GeoBicubicHermitePatch, GeoCubicBezierCurve, GeoBicubicBezierPatch, Geodesic,
    GeodesicOptions

# Enum types
export StageLevel, EventCauseNum, EventTrigger, HandleEventsOption, HandleEventsResult,
    ProjectOption, ProjectResult, RealizeOption, Measure_ExtremeOperation

# Type-aliases
export Vec3, Row3, Mat33, UnitVec, SpatialVec, SpatialMat

# export cxxparametricsubtypes

# include("utils.jl")
include("simtk_arrays.jl")
include("orientation_transformation.jl")
include("massproperties.jl")
include("decorations.jl")
include("state.jl")
include("system_subsystem.jl")
include("geo.jl")

end
