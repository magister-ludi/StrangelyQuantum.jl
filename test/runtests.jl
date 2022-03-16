#!/usr/bin/env julia

using Test
using StrangelyQuantum

function StrangelyQuantum.runProgram(program::Program)
    qee = SimpleQuantumExecutionEnvironment()
    return runProgram(qee, program)
end

@testset "StrangelyQuantum" begin
    include("initial_state_tests.jl")
    include("syntax_tests.jl")
    include("single_qubit_gate_tests.jl")
    include("two_qubit_gate_tests.jl")
    include("three_qubit_gate_tests.jl")
    include("block_tests.jl")
    include("fourier_test.jl")
end

#include("add_integer_modulus_tests.jl")
#include("arithmetic_tests.jl")
#include("arithmetic2_tests.jl")
#include("arithmetic4_tests.jl")
#include("bell_state_test.jl")
#include("classic_tests.jl")
#include("controlled_block_tests.jl")
#include("exp_mul_tests.jl")
#include("inverse_tests.jl")
#include("mul_modulus_tests.jl")
#include("oracle_tests.jl")
#include("overflow_tests.jl")
#include("person.jl")
#include("rotation_tests.jl")
#include("single_test.jl")
