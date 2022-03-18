#=

# This code was in the original Java tests, but doesn't test anything...

const Δ_Overflow = 0.000000001

@testset "add4" begin
    p =  Program(4)
    prep =  Step()
    addStep(p,prep)
    add =  Add(1,2,3,4)
    addStep(p, Step(add))
    result = runProgram(p)
    probs = getProbability(result)
    #@show probs
    q = getQubits(result)
    #@show q
    @show measure.(q)
end
=#

#=
Tests on the size of blockgates
=#
@testset "Overflow" begin
    @testset "Add, not enough space" begin
        p = Program(4)
        prep = Step()
        addStep(p, prep)
        add = Add(2, 3, 4, 5)
        addStep(p, Step(add))
        @test_throws r"Only \d+ qubits available" result = runProgram(p)
    end

    # test to make sure an add gate does not influence nearby qubits
    @testset "Add, no overlap 1" begin
        p = Program(6)
        prep = Step(X(3), X(5))
        addStep(p, prep)
        add = Add(2, 3, 4, 5)
        addStep(p, Step(add))
        result = runProgram(p)
        probs = getProbability(result)
        q = getQubits(result)
        @test 0 == measure(q[1])
        @test 0 == measure(q[6])
    end

    # test to make sure an add gate does not influence nearby qubits
    @testset "Add, no overlap 2" begin
        p = Program(6)
        prep = Step(X(1), X(3), X(5), X(6))
        addStep(p, prep)
        add = Add(2, 3, 4, 5)
        addStep(p, Step(add))
        result = runProgram(p)
        probs = getProbability(result)
        q = getQubits(result)
        @test 1 == measure(q[1])
        @test 1 == measure(q[6])
    end
end
