function cxxparametricsubtypes(t::Type{T}, mod=parentmodule(t)) where T
    typename = replace(string(T), r"^Simbody." => "")
    ms = methods(getproperty(mod, Symbol("__cxxwrap_dt_"*typename)))
    ms = filter(==(pkgdir(CxxWrap))∘dirname∘dirname∘(f -> string(f.file)), ms)
    return map(f -> f.sig.parameters[1].parameters[1], ms) |> unique
end

