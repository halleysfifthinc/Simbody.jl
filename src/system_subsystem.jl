# Simbody doesn't define a copy-constructor
function ProjectOptions(o::reference_type_union(ProjectOptions))
    po = ProjectOptions(getAccuracy(o))
    setOvershootFactor(po, getOvershootFactor(o))
    setProjectionLimit(po, getProjectionLimit(o))
    bwor!(po, o)
    return po
end

# Separate def because ProjectOptions doesn't define
# operator&=(ProjectOptions, HandleEventsOption)
function Base.:(&)(a::ProjectOptions, b::reference_type_union(ProjectOptions))
    c = ProjectOptions(a)
    bwand!(c, b)
    return c
end

for (op, func) in zip((:|, :-), (bwor!, sub!))
@eval function Base.$(op)(a::ProjectOptions, b::Union{reference_type_union(ProjectOptions), ProjectOption})
          c = ProjectOptions(a)
          ($func)(c, b)
          return c
      end
end

function realize(
    system::reference_type_union(System),
    state::reference_type_union(State))
    return realize(system, state, Stage(Stage_HighestRuntime))
end
