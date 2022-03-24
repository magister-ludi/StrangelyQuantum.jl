#!/usr/bin/env julia

using Test
using Random
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
    include("controlled_block_tests.jl")
    include("oracle_tests.jl")
    include("inverse_tests.jl")
    include("overflow_tests.jl")
    include("bell_state_test.jl")
    include("rotation_tests.jl")
    include("arithmetic_1_tests.jl")
    include("arithmetic_2_tests.jl")
    include("arithmetic_3_tests.jl")
    include("add_integer_modulus_tests.jl")
    include("exp_mul_tests.jl")
    include("mul_modulus_tests.jl")
    include("classic_tests.jl")
end
