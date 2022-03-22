
struct BlockTests end

function createBlock(::BlockTests)
    block = Block(1)
    addStep(block, Step(identity(1)))
    gate = BlockGate(block, 1)
end

mutable struct DummyBlockGate <: AbstractBlockGate
    idx::Int
    inverse::Bool
    addedStep::Union{Nothing, Step}
    block::Block
    function DummyBlockGate(idx, step)
        gate = new(idx, false, nothing)
        gate.block = createBlock(gate)
        gate.addedStep = step
        return gate
    end
end

DummyBlockGate(idx) = DummyBlockGate(idx, nothing)

function createBlock(gate::DummyBlockGate)
    answer = Block("Dummy", 2)
    addStep(answer, Step(X(2)))
    if gate.addedStep !== nothing
        addStep(answer, gate.addedStep)
    end
    addStep(answer, Step(Cnot(2, 1)))
    return answer
end

hasOptimization(::DummyBlockGate) = true

mutable struct GenericBlockGate <: AbstractBlockGate
    idx::Int
    inverse::Bool
    dim::Int
    steps::Vector{Step}
    block::Block
    function GenericBlockGate(idx, dim, steps)
        gate = new(idx, false, dim, steps)
        gate.block = createBlock(gate)
        return gate
    end
end

GenericBlockGate(idx, dim) = GenericBlockGate(idx, dim, [])

function createBlock(gate::GenericBlockGate)
    answer = Block("Generic", gate.dim)
    for step in gate.steps
        addStep(answer, step)
    end
    return answer
end

hasOptimization(::GenericBlockGate) = true

@testset "Block Tests" begin
    @testset "create Block In Program" begin
        block = Block(1)
        addStep(block, Step(Identity(1)))
        gate = BlockGate(block, 1)
        p = Program(1)
        addStep(p, Step(gate))
        result = runProgram(p)
        qubits = getQubits(result)
        @test 0 == measure(qubits[1])
    end

    @testset "create X Block In Program" begin
        block = Block(1)
        bs = Step(X(1))
        addStep(block, bs)
        gate = BlockGate(block, 1)
        p = Program(1)
        addStep(p, Step(gate))
        result = runProgram(p)
        qubits = getQubits(result)
        @test 1 == measure(qubits[1])
    end

    @testset "create X Block In Program Add Pos 2" begin
        block = Block(1)
        addStep(block, Step(X(1)))
        gate = BlockGate(block, 2)
        p = Program(2)
        addStep(p, Step(gate))
        result = runProgram(p)
        qubits = getQubits(result)
        @test 0 == measure(qubits[1])
        @test 1 == measure(qubits[2])
    end

    @testset "create Many X Blocks In Program Add Pos 2" begin
        block = Block(1)
        addStep(block, Step(X(1)))
        gate = BlockGate(block, 2)
        gate2 = BlockGate(block, 1)
        gate3 = BlockGate(block, 2)
        p = Program(2)
        addSteps(p, Step(gate), Step(gate2), Step(gate3))
        result = runProgram(p)
        qubits = getQubits(result)
        @test 1 == measure(qubits[1])
        @test 0 == measure(qubits[2])
    end

    @testset "create XX Block In Program" begin
        block = Block(1)
        addStep(block, Step(X(1)))
        addStep(block, Step(X(1)))
        gate = BlockGate(block, 1)
        p = Program(1)
        addSteps(p, Step(gate))
        result = runProgram(p)
        qubits = getQubits(result)
        @test 0 == measure(qubits[1])
    end

    @testset "create XX Block In Program Add Pos 2" begin
        block = Block(1)
        addStep(block, Step(X(1)))
        addStep(block, Step(X(1)))
        gate = BlockGate(block, 2)
        p = Program(2)
        addSteps(p, Step(gate))
        result = runProgram(p)
        qubits = getQubits(result)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
    end
end

@testset "compareBlock" begin
    for a = 1:4
        for b = 1:4
            prep = Step()
            if iseven(a)
                addGate(prep, X(2))
            end
            if iseven(b)
                addGate(prep, X(3))
            end
            if a > 2
                addGate(prep, X(5))
            end
            if b > 2
                addGate(prep, X(6))
            end
            p = Program(7)
            s0 = Step(Toffoli(2, 3, 4))
            s1 = Step(Cnot(2, 3))
            s2 = Step(Toffoli(1, 3, 4))
            addSteps(p, prep, s0, s1, s2)
            normal = runProgram(p)
            normalQ = getQubits(normal)

            carry = Block("carry", 4)
            addStep(carry, Step(Toffoli(2, 3, 4)))
            addStep(carry, Step(Cnot(2, 3)))
            addStep(carry, Step(Toffoli(1, 3, 4)))
            bp = Program(7)
            bs0 = Step(BlockGate(carry, 1))
            addSteps(bp, prep, bs0)
            blockResult = runProgram(bp)
            blockQ = getQubits(blockResult)

            @test length(normalQ) == length(blockQ)
            for i = 1:length(normalQ)
                @test measure(normalQ[i]) == measure(blockQ[i])
            end
        end
    end

    @testset "compareBlock2" begin
        a = 1
        b = 0
        prep = Step()
        if isodd(a)
            addGate(prep, X(2))
        end
        if isodd(b)
            addGate(prep, X(3))
        end

        p = Program(4)

        s0 = Step(Toffoli(2, 3, 4))
        s1 = Step(Cnot(2, 3))
        addSteps(p, prep, s0, s1)
        normal = runProgram(p)
        normalQ = getQubits(normal)

        carry = Block("carry", 4)
        addStep(carry, Step(Toffoli(2, 3, 4)))
        addStep(carry, Step(Cnot(2, 3)))

        bp = Program(4)
        bs0 = Step(BlockGate(carry, 1))
        addSteps(bp, prep, bs0)
        blockResult = runProgram(bp)
        blockQ = getQubits(blockResult)

        @test length(normalQ) == length(blockQ)
        for i = 1:length(normalQ)
            @test measure(normalQ[i]) == measure(blockQ[i])
        end
    end

    @testset "testDummyBlockGate" begin
        dbg = DummyBlockGate(1)
        bp = Program(2)
        bs0 = Step(dbg)
        addSteps(bp, bs0)
        result = runProgram(bp)
        qubits = getQubits(result)
        @test 1 == measure(qubits[1])
        @test 1 == measure(qubits[2])
    end

    @testset "testDummyBlockGate2" begin
        dbg = DummyBlockGate(2)
        bp = Program(3)
        bs0 = Step(dbg)
        addSteps(bp, bs0)
        result = runProgram(bp)
        qubits = getQubits(result)
        @test 0 == measure(qubits[1])
        @test 1 == measure(qubits[2])
        @test 1 == measure(qubits[3])
    end

    @testset "testDummyBlockGateInv" begin
        dbg = inverse(DummyBlockGate(1))
        bp = Program(2)
        bs0 = Step(dbg)
        addSteps(bp, bs0)
        result = runProgram(bp)
        qubits = getQubits(result)
        @test 0 == measure(qubits[1])
        @test 1 == measure(qubits[2])
    end
end

@testset "testDummyBlockGateInv2" begin
    dbg = inverse(DummyBlockGate(2))
    bp = Program(3)
    bs0 = Step(dbg)
    addSteps(bp, bs0)
    result = runProgram(bp)
    qubits = getQubits(result)
    @test 0 == measure(qubits[1])
    @test 0 == measure(qubits[2])
    @test 1 == measure(qubits[3])
end

@testset "testDummyBlockGateR" begin
    dbg = DummyBlockGate(1, Step(R(2, 1)))
    bp = Program(2)
    bs0 = Step(dbg)
    addSteps(bp, bs0)
    result = runProgram(bp)
    qubits = getQubits(result)
    @test 1 == measure(qubits[1])
    @test 1 == measure(qubits[2])
end

@testset "testDummyBlockGateR2" begin
    dbg = DummyBlockGate(2, Step(R(2, 1)))
    bp = Program(3)
    bs0 = Step(dbg)
    addSteps(bp, bs0)
    result = runProgram(bp)
    qubits = getQubits(result)
    @test 0 == measure(qubits[1])
    @test 1 == measure(qubits[2])
    @test 1 == measure(qubits[3])
end

@testset "testDummyBlockGateRinv" begin
    dbg = inverse(DummyBlockGate(1, Step(R(2, 1))))
    bp = Program(2)
    bs0 = Step(dbg)
    addSteps(bp, bs0)
    result = runProgram(bp)
    qubits = getQubits(result)
    @test 0 == measure(qubits[1])
    @test 1 == measure(qubits[2])
end

@testset "testDummyBlockGateRinv2" begin
    dbg = inverse(DummyBlockGate(2, Step(R(2, 1))))
    bp = Program(3)
    bs0 = Step(dbg)
    addSteps(bp, bs0)
    result = runProgram(bp)
    qubits = getQubits(result)
    @test 0 == measure(qubits[1])
    @test 0 == measure(qubits[2])
    @test 1 == measure(qubits[3])
end

@testset "testGenericBlockGateHHF" begin
    prep = Step(X(1))
    steps = Step[]
    push!(steps, Step(Hadamard(1), Hadamard(2)))
    push!(steps, Step(Fourier(2, 1)))
    dbg = inverse(GenericBlockGate(1, 2, steps))
    bp = Program(2)
    bs0 = Step(dbg)
    addSteps(bp, prep, bs0)
    result = runProgram(bp)
    probability = getProbability(result)
    EPS = 1e-4
    @test 0 ≈ real(probability[1]) atol = EPS
    @test 0 ≈ imag(probability[1]) atol = EPS
    @test 0 ≈ real(probability[2]) atol = EPS
    @test 0 ≈ imag(probability[2]) atol = EPS
    @test 0.5 ≈ real(probability[3]) atol = EPS
    @test -0.5 ≈ imag(probability[3]) atol = EPS
    @test 0.5 ≈ real(probability[4]) atol = EPS
    @test 0.5 ≈ imag(probability[4]) atol = EPS
end

@testset "testGenericBlockGateAMF" begin
    steps = Step[]
    prep = Step(X(3))
    x0 = 1
    x1 = 2
    nn = 1
    dim = 3
    y0 = 3
    y1 = 4

    addN = AddInteger(x0, x1, nn)
    cbg = ControlledBlockGate(addN, x0, 3)
    push!(steps, Step(cbg))

    dbg = inverse(GenericBlockGate(1, dim, steps))
    bp = Program(3)
    bs0 = Step(dbg)
    addSteps(bp, prep, bs0)
    result = runProgram(bp)
    qubits = getQubits(result)
    @test 1 == measure(qubits[1])
    @test 1 == measure(qubits[2])
    @test 1 == measure(qubits[3])
end
