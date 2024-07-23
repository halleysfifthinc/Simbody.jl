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
    GeodesicOptions, DecorationGenerator, GeodesicDecorator, PathDecorator, Contact,
    UntrackedContact, BrokenContact, CircularPointContact, EllipticalPointContact,
    BrickHalfSpaceContact, TriangleMeshContact, PointContact, ContactGeometry,
    ContactHalfSpace, ContactCylinder, ContactSphere, ContactEllipsoid,
    ContactSmoothHeightMap, ContactBrick, ContactTriangleMesh, ContactTorus, Plane, OBBTree,
    OBBNode, BicubicSurface, BicubicFunction, ContactTriangleMesh_OBBTreeNode,
    OrientedBoundingBox, GeodHitPlaneEvent, PlaneDecorator, ContactTracker,
    HalfSpaceSphere_ContactTracker, HalfSpaceEllipsoid_ContactTracker,
    HalfSpaceBrick_ContactTracker, SphereSphere_ContactTracker,
    HalfSpaceTriangleMesh_ContactTracker, SphereTriangleMesh_ContactTracker,
    TriangleMeshTriangleMesh_ContactTracker, HalfSpaceConvexImplicit_ContactTracker,
    ConvexImplicitPair_ContactTracker, GeneralImplicitPair_ContactTracker, ContactMaterial,
    ContactSurface, Body, RigidBody, MasslessBody, GroundBody, Motion, SinusoidMotion,
    SteadyMotion, CustomMotion, MobilizedBody, GroundMobilizedBody, BallMobilizedBody,
    BendStretchMobilizedBody, BushingMobilizedBody, CylinderMobilizedBody,
    EllipsoidMobilizedBody, FreeMobilizedBody, FreeLineMobilizedBody,
    FunctionBasedMobilizedBody, GimbalMobilizedBody, LineOrientationMobilizedBody,
    PinMobilizedBody, PlanarMobilizedBody, ScrewMobilizedBody, SliderMobilizedBody,
    SphericalCoordsMobilizedBody, TranslationMobilizedBody, UniversalMobilizedBody,
    WeldMobilizedBody, SimbodyMatterSubsystem, Constraint, UnilateralContact,
    DecorationSubsystem, ContactSnapshot, ContactTrackerSubsystem, GeneralContactSubsystem,
    CableTrackerSubsystem, CablePath, CableObstacle, ViaPointCableObstacle,
    SurfaceCableObstacle, ForceSubsystem, GeneralForceSubsystem, Force,
    TwoPointLinearSpringForce, TwoPointLinearDamperForce, TwoPointConstantForceForce,
    ConstantForceForce, ConstantTorqueForce, GlobalDamperForce, UniformGravityForce,
    DiscreteForcesForce, GravityForce, LinearBushingForce, MobilityConstantForceForce,
    MobilityDiscreteForceForce, MobilityLinearDamperForce, MobilityLinearSpringForce,
    MobilityLinearStopForce, ThermostatForce, HuntCrossleyForce, CableSpring,
    ElasticFoundationForce

# Enum types
export StageLevel, EventCauseNum, EventTrigger, HandleEventsOption, HandleEventsResult,
    ProjectOption, ProjectResult, RealizeOption, Measure_ExtremeOperation, ContactCondition,
    MotionLevel, MotionMethod, MobilizedBodyDirection

# Type-aliases
export Vec3, Row3, Mat33, UnitVec, SpatialVec, SpatialMat, TorsionMobilizedBody,
    RevoluteMobilizedBody, PrismaticMobilizedBody, CartesianMobilizedBody,
    CartesianCoordsMobilizedBody, OrientationMobilizedBody, SphericalMobilizedBody

# export cxxparametricsubtypes

# include("utils.jl")
include("simtk_arrays.jl")
include("orientation_transformation.jl")
include("massproperties.jl")
include("decorations.jl")
include("state.jl")
include("system_subsystem.jl")
include("geo.jl")
include("body.jl")

end
