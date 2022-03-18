
@testset "ControlledBlockTests" begin
    @testset "cnot block 00" begin
        p = Program(2)
        block = Block(1)
        addStep(block, Step(X(1)))
        gate = BlockGate(block, 1)
        cbg = ControlledBlockGate(gate, 1, 2)
        addStep(p, Step(cbg))
        result = runProgram(p)
        q = getQubits(result)
        @test 2 == length(q)
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
    end

    @testset "cnot block 10" begin
        #10 -> 11
        # q0 -----X-- 1
        #         |
        # q1 --X--o-- 1
        p = Program(2)
        prep = Step(X(2))
        block = Block(1)
        addStep(block, Step(X(1)))
        gate = BlockGate(block, 1)
        cbg = ControlledBlockGate(gate, 1, 2)
        # m = getMatrix(cbg)

        addStep(p, prep)
        addStep(p, Step(cbg))
        result = runProgram(p)
        q = getQubits(result)
        @test 2 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
    end

    @testset "cnot block 01" begin
        #01 -> 11
        # q0 --X--o-- 1
        #         |
        # q1 -----X-- 1
        p = Program(2)
        prep = Step(X(1))
        block = Block(1)
        addStep(block, Step(X(1)))
        gate = BlockGate(block, 1)
        cbg = ControlledBlockGate(gate, 2, 1)
        #m = cbg.getMatrix()

        addStep(p, prep)
        addStep(p, Step(cbg))
        result = runProgram(p)
        q = getQubits(result)
        @test 2 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
    end

    @testset "cnot block 100a" begin
        #100 -> 110
        p = Program(3)
        prep = Step(X(3))
        block = Block(1)
        addStep(block, Step(X(1)))
        gate = BlockGate(block, 1)
        cbg = ControlledBlockGate(gate, 2, 3)
        #m = getMatrix(cbg)

        addStep(p, prep)
        addStep(p, Step(cbg))
        result = runProgram(p)
        q = getQubits(result)
        @test 3 == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
    end

    @testset "cnot block 100b2" begin
        #100 -> 111
        p = Program(3)
        prep = Step(X(3))
        block = Block(2)
        addStep(block, Step(X(1), X(2)))
        gate = BlockGate(block, 1)
        cbg = ControlledBlockGate(gate, 1, 3)
        #m = cbg.getMatrix()

        addStep(p, prep)
        addStep(p, Step(cbg))
        result = runProgram(p)
        q = getQubits(result)
        @test 3 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
    end

    @testset "cnot block 100b2inv" begin
        #100 -> 111
        p = Program(3)
        prep = Step(X(1))
        block = Block(2)
        addStep(block, Step(X(1), X(2)))
        gate = BlockGate(block, 1)
        cbg = ControlledBlockGate(gate, 2, 1)
        #m = cbg.getMatrix()

        addStep(p, prep)
        addStep(p, Step(cbg))
        result = runProgram(p)
        q = getQubits(result)
        @test 3 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
    end

    @testset "cnot block 101" begin
        #101 -> 001
        p = Program(3)
        prep = Step(X(1), X(3))
        block = Block(1)
        addStep(block, Step(X(1)))
        gate = BlockGate(block, 1)
        cbg = ControlledBlockGate(gate, 3, 1)
        #m = cbg.getMatrix()

        addStep(p, prep)
        addStep(p, Step(cbg))
        result = runProgram(p)
        #probability = getProbability(result)
        #@show probability
        q = getQubits(result)
        @test 3 == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
    end

    @testset "cnot block 1010" begin
        #1010 -> 0010
        p = Program(4)
        prep = Step(X(2), X(4))
        block = Block(1)
        addStep(block, Step(X(1)))
        gate = BlockGate(block, 1)
        cbg = ControlledBlockGate(gate, 4, 2)
        #m = cbg.getMatrix()

        addStep(p, prep)
        addStep(p, Step(cbg))
        result = runProgram(p)
        #probability = result.getProbability()
        #@show probability
        q = getQubits(result)
        @test 4 == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
    end

    @testset "cnot block 1010inv" begin
        #1010 -> 0010
        p = Program(4)
        prep = Step(X(2), X(4))
        block = Block(1)
        addStep(block, Step(X(1)))
        gate = BlockGate(block, 1)
        cbg = ControlledBlockGate(gate, 2, 4)
        #m = cbg.getMatrix()

        addStep(p, prep)
        addStep(p, Step(cbg))
        result = runProgram(p)
        #probability = result.getProbability()
        #@show probability
        q = getQubits(result)

        @test 4 == length(q)
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 1 == measure(q[4])
    end
end
