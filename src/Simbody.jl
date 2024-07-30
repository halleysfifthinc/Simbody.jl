module Simbody

using CxxWrap, jlsimbody_jll, LinearAlgebra, OpenBLAS32_jll

get_libjlsimbody_path() = jlsimbody_jll.libjlsimbody::String

@wrapmodule(get_libjlsimbody_path)

function __init__()
    @initcxx
    config = LinearAlgebra.BLAS.lbt_get_config()
    if !any(lib -> lib.interface == :lp64, config.loaded_libs)
        LinearAlgebra.BLAS.lbt_forward(OpenBLAS32_jll.libopenblas_path)
    end
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
    ElasticFoundationForce, ContactPatch, ContactForceGenerator, CompliantContactSubsystem,
    HuntCrossleyContact, ContactDetail, HertzCircularContactForceGenerator,
    HertzEllipticalContactForceGenerator, BrickHalfSpacePenaltyContactForceGenerator,
    ElasticFoundationContactForceGenerator, DoNothingContactForceGenerator,
    ThrowErrorContactForceGenerator, Timestepper, Integrator, CPodesIntegrator,
    ExplicitEulerIntegrator, RungeKutta2Integrator, RungeKutta3Integrator,
    RungeKuttaFeldbergIntegrator, RungeKuttaMersonIntegrator, SemiExplicitEuler2Integrator,
    SemiExplicitEulerIntegrator, VerletIntegrator, Optimizer, OptimizerSystem

# Enum types
export StageLevel, EventCauseNum, EventTrigger, HandleEventsOption, HandleEventsResult,
    ProjectOption, ProjectResult, RealizeOption, Measure_ExtremeOperation, ContactCondition,
    MotionLevel, MotionMethod, MobilizedBodyDirection, IntegratorSuccessfulStepStatus,
    IntegratorTerminationReason, CPodesLinearMultistepMethod,
    CPodesNonlinearSystemIterationType, OptimizerAlgorithm, DifferentiatorMethod

# Type-aliases
export Vec3, Row3, Mat33, UnitVec, SpatialVec, SpatialMat, TorsionMobilizedBody,
    RevoluteMobilizedBody, PrismaticMobilizedBody, CartesianMobilizedBody,
    CartesianCoordsMobilizedBody, OrientationMobilizedBody, SphericalMobilizedBody,
    HertzCircular, HertzElliptical, BrickHalfSpacePenalty, ElasticFoundation, DoNothing,
    ThrowError

# export cxxparametricsubtypes

include("utils.jl")
include("simtk_arrays.jl")
include("orientation_transformation.jl")
include("massproperties.jl")
include("decorations.jl")
include("state.jl")
include("system_subsystem.jl")
include("geo.jl")
include("body.jl")
include("force.jl")

end
