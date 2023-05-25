using Simbody
using Test
using Aqua
using JET

@testset "Simbody.jl" begin
    @testset "Code quality (Aqua.jl)" begin
        Aqua.test_all(Simbody)
    end
    @testset "Code linting (JET.jl)" begin
        JET.test_package(Simbody; target_defined_modules = true)
    end
    # Write your tests here.
end
