
struct BlockTests end

function createBlock(::BlockTests)
    block = Block(1)
    addStep(block, Step(identity(1)))
    gate = BlockGate(block, 1)
end

mutable struct DummyBlockGate <: AbstractBlockGate
    idx::Int
    inverse::Bool
    block::Block
    addedStep::Union{Nothing, Step}
    function DummyBlockGate(idx, step)
        gate = new(idx, false)
        gate.block = createBlock(gate)
        gate.addedStep = step
        return gate
    end
end

DummyBlockGate(idx) = DummyBlockGate(idx, nothing)

function createBlock(::DummyBlockGate)
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

function createBlock(::GenericBlockGate)
    answer = Block("Generic", dim)
    for step in gate.steps
        addStep(answer, step)
    end
    return answer
end

hasOptimization(::GenericBlockGate) = true

@testset "Block Tests" begin

    #    @Test
    #    public void addWrongIndex()
    #        Block block =  Block(2)
    #        addStep(block, Step(x(0)))
    #        assertThrows(
    #                IllegalArgumentException.class,
    #                () . block.addGate(x(2)))
    #        assertThrows(
    #                IllegalArgumentException.class,
    #                () . block.addGate(cnot(2, 1)))
    #        block.addGate(x(1))
    #    }
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
end
#=
    @testset "compareBlock2" begin
        for (int a = 1  a < 2  a++)
            for (int b = 0  b < 1  b++)
                 prep =  Step()
                if (a % 2 == 1)
                    addGate(prep, X(1))
                end
                if (b % 2 == 1)
                    addGate(prep, X(2))
                end

                 p =  Program(4)

                 s0 =  Step( Toffoli(1,2,3))
                 s1 =  Step( Cnot(1, 2))
                addSteps(p,prep, s0, s1)
                 normal = runProgram(p)
                 normalQ = normal.getQubits()

                 carry =  Block("carry", 4)
                addStep(carry, Step( Toffoli(1,2,3)))
                addStep(carry, Step( Cnot(1, 2)))

                 bp =  Program(4)
                 bs0 =  Step( BlockGate(carry, 0))
                baddSteps(p,prep, bs0)
                 blockResult = runProgram(bp)
                 blockQ = blockResult.getQubits()

                @test normalQ.length ==  blockQ.length
                for (int i = 0  i < normalQ.length  i++)
                    @test normalQ[i].measure() ==  blockQ[i].measure()
                end
            end
        end
    end

    @testset "testDummyBlockGate" begin
         dbg =  DummyBlockGate(0)
         bp =  Program(2)
         bs0 =  Step(dbg)
        baddSteps(p,bs0)
         result = runProgram(bp)
         qubits = getQubits(result)
        @test 1 ==  measure(qubits[1])
        @test 1 ==  measure(qubits[2])
    end

    @testset "testDummyBlockGate2" begin
         dbg =  DummyBlockGate(1)
         bp =  Program(3)
         bs0 =  Step(dbg)
        baddSteps(p,bs0)
         result = runProgram(bp)
         qubits = getQubits(result)
        @test 0 ==  measure(qubits[1])
        @test 1 ==  measure(qubits[2])
        @test 1 ==  measure(qubits[3])
    end

    @testset "testDummyBlockGateInv" begin
         dbg =  DummyBlockGate(0).inverse()
         bp =  Program(2)
         bs0 =  Step(dbg)
        baddSteps(p,bs0)
         result = runProgram(bp)
         qubits = getQubits(result)
        @test 0 ==  measure(qubits[1])
        @test 1 ==  measure(qubits[2])
    end

    @testset "testDummyBlockGateInv2" begin
         dbg =  DummyBlockGate(1).inverse()
         bp =  Program(3)
         bs0 =  Step(dbg)
        baddSteps(p,bs0)
         result = runProgram(bp)
         qubits = getQubits(result)
        @test 0 ==  measure(qubits[1])
        @test 0 ==  measure(qubits[2])
        @test 1 ==  measure(qubits[3])
    end

    @testset "testDummyBlockGateR" begin
         dbg =  DummyBlockGate(0,  Step( R(2,0)))
         bp =  Program(2)
         bs0 =  Step(dbg)
        baddSteps(p,bs0)
         result = runProgram(bp)
         qubits = getQubits(result)
        @test 1 ==  measure(qubits[1])
        @test 1 ==  measure(qubits[2])
    end

    @testset "testDummyBlockGateR2" begin
         dbg =  DummyBlockGate(1,  Step( R(2,0)))
         bp =  Program(3)
         bs0 =  Step(dbg)
        baddSteps(p,bs0)
         result = runProgram(bp)
         qubits = getQubits(result)
        @test 0 ==  measure(qubits[1])
        @test 1 ==  measure(qubits[2])
        @test 1 ==  measure(qubits[3])
    end

    @testset "testDummyBlockGateRinv" begin
         dbg =  DummyBlockGate(0,  Step( R(2,0))).inverse()
         bp =  Program(2)
         bs0 =  Step(dbg)
        baddSteps(p,bs0)
         result = runProgram(bp)
         qubits = getQubits(result)
        @test 0 ==  measure(qubits[1])
        @test 1 ==  measure(qubits[2])
    end

    @testset "testDummyBlockGateRinv2" begin
         dbg =  DummyBlockGate(1,  Step( R(2,0))).inverse()
         bp =  Program(3)
         bs0 =  Step(dbg)
        baddSteps(p,bs0)
         result = runProgram(bp)
         qubits = getQubits(result)
        @test 0 ==  measure(qubits[1])
        @test 0 ==  measure(qubits[2])
        @test 1 ==  measure(qubits[3])
    end

    @testset "testGenericBlockGateHHF" begin
         prep =  Step( X(0))
        <Step> steps =  ArrayList<>()
        steps.add( Step( Hadamard(0),  Hadamard(1)))
        steps.add( Step( Fourier(2,0)))
         dbg =  GenericBlockGate(0, 2, steps).inverse()
         bp =  Program(2)
         bs0 =  Step(dbg)
        baddSteps(p,prep, bs0)
         result = runProgram(bp)
         probability = result.getProbability()
         EPS = (Float32)1e-4
        @test 0, probability[1].r ==  EPS
        @test 0, probability[1].i ==  EPS
        @test 0, probability[2].r ==  EPS
        @test 0, probability[2].i ==  EPS
        @test 0.5, probability[3].r ==  EPS
        @test -0.5, probability[3].i ==  EPS
        @test 0.5, probability[4].r ==  EPS
        @test 0.5, probability[4].i ==  EPS

    end

    @testset "testGenericBlockGateAMF" begin
        <Step> steps =  ArrayList<>()
         prep =  Step( X(2))
        int x0 = 0  int x1 = 1  int N = 1  int dim = 3  int y0 = 2  int y1 = 3

         addN =  AddInteger(x0,x1,N)
         cbg =  AbstractControlledBlockGate(addN, x0,2)
        steps.add( Step(cbg))

         dbg =  GenericBlockGate(0, dim, steps).inverse()
         bp =  Program(3)
         bs0 =  Step(dbg)
        baddSteps(p,prep, bs0)
         result = runProgram(bp)
         qubits = getQubits(result)
        for (int i = 0  i < dim  i++)
         #   System.err.println("m["+i+"]: "+measure(qubits[i]))
        end
        @test 1 ==  measure(qubits[1])
        @test 1 ==  measure(qubits[2])
        @test 1 ==  measure(qubits[3])
    end
=#
