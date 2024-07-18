# Simbody doesn't define a copy-constructor
HandleEventsOptions(o::reference_type_union(HandleEventsOptions)) = bwor!(HandleEventsOptions(getAccuracy(o)), o)

# Separate def because HandleEventsOptions doesn't define
# operator&=(HandleEventsOptions, HandleEventsOption)
function Base.:(&)(a::HandleEventsOptions, b::reference_type_union(HandleEventsOptions))
    c = HandleEventsOptions(a)
    bwand!(c, b)
    return c
end

for (op, func) in zip((:|, :-), (bwor!, sub!))
@eval function Base.$(op)(a::HandleEventsOptions, b::Union{reference_type_union(HandleEventsOptions), HandleEventsOption})
          c = HandleEventsOptions(a)
          ($func)(c, b)
          return c
      end
end
