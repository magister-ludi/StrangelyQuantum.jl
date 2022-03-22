
@testset "Arithmetic #2" begin
    @testset "addmod0" begin
        n = 2
        nn = 3
        dim = 2 * (n + 1) + 1
        p = Program(dim)
        prep = Step()
        addGates(prep, X(1))
        addStep(p, prep)
        add = Add(1, 3, 4, 6)
        addStep(p, Step(add))

        result = runProgram(p)
        q = getQubits(result)
        @test 7 == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
        @test 0 == measure(q[7])
    end

    @testset "addmod1" begin
        n = 2
        nn = 3
        dim = 2 * (n + 1) + 1
        p = Program(dim)
        prep = Step()
        addGates(prep, X(1))
        addStep(p, prep)
        add = Add(1, 3, 4, 6)
        addStep(p, Step(add))

        min = inverse(AddInteger(1, 3, nn))
        addStep(p, Step(min))
        addStep(p, Step(Cnot(3, dim)))

        result = runProgram(p)
        q = getQubits(result)
        @test 7 == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
        @test 1 == measure(q[7])
    end

    @testset "addmod2" begin
        n = 2
        nn = 3
        dim = 2 * (n + 1) + 1
        p = Program(dim)
        prep = Step()
        addGates(prep, X(1))
        addStep(p, prep)
        add = Add(1, 3, 4, 6)
        addStep(p, Step(add))

        min = inverse(AddInteger(1, 3, nn))
        addStep(p, Step(min))
        addStep(p, Step(Cnot(3, dim)))
        addN = AddInteger(1, 3, nn)
        cbg = ControlledBlockGate(addN, 1, dim)
        addStep(p, Step(cbg))

        result = runProgram(p)
        q = getQubits(result)
        @test 7 == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
        @test 1 == measure(q[7])
    end

    @testset "addmod3" begin
        n = 2
        nn = 3
        dim = 2 * (n + 1) + 1
        p = Program(dim)
        prep = Step()
        addGates(prep, X(1))
        addStep(p, prep)
        add = Add(1, 3, 4, 6)
        addStep(p, Step(add))

        min = inverse(AddInteger(1, 3, nn))
        addStep(p, Step(min))
        addStep(p, Step(Cnot(3, dim)))
        addN = AddInteger(1, 3, nn)
        cbg = ControlledBlockGate(addN, 1, dim)
        addStep(p, Step(cbg))

        add2 = inverse(Add(1, 3, 4, 6))
        addStep(p, Step(add2))
        addStep(p, Step(X(dim)))

        result = runProgram(p)
        q = getQubits(result)
        @test 7 == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
        @test 0 == measure(q[7])
    end

    @testset "addmod4" begin
        n = 2
        nn = 3
        dim = 2 * (n + 1) + 1
        p = Program(dim)
        prep = Step()
        addGates(prep, X(1))
        addStep(p, prep)
        add = Add(1, 3, 4, 6)
        addStep(p, Step(add))

        min = inverse(AddInteger(1, 3, nn))
        addStep(p, Step(min))
        addStep(p, Step(Cnot(3, dim)))
        addN = AddInteger(1, 3, nn)
        cbg = ControlledBlockGate(addN, 1, dim)
        addStep(p, Step(cbg))

        add2 = inverse(Add(1, 3, 4, 6))
        addStep(p, Step(add2))
        addStep(p, Step(X(dim)))

        block = Block(1)
        addStep(block, Step(X(1)))
        cbg2 = ControlledBlockGate(block, dim, 3)
        addStep(p, Step(cbg2))

        result = runProgram(p)
        q = getQubits(result)
        @test 7 == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
        @test 0 == measure(q[7])
    end

    @testset "addmod5" begin
        n = 2
        nn = 3
        dim = 2 * (n + 1) + 1
        p = Program(dim)
        prep = Step()
        addGates(prep, X(1))
        addStep(p, prep)
        add = Add(1, 3, 4, 6)
        addStep(p, Step(add))

        min = inverse(AddInteger(1, 3, nn))
        addStep(p, Step(min))
        addStep(p, Step(Cnot(3, dim)))
        addN = AddInteger(1, 3, nn)
        cbg = ControlledBlockGate(addN, 1, dim)
        addStep(p, Step(cbg))

        add2 = inverse(Add(1, 3, 4, 6))
        addStep(p, Step(add2))
        addStep(p, Step(X(dim)))

        block = Block(1)
        addStep(block, Step(X(1)))
        cbg2 = ControlledBlockGate(block, dim, 3)
        addStep(p, Step(cbg2))

        add3 = Add(1, 3, 4, 6)
        addStep(p, Step(add3))

        result = runProgram(p)
        q = getQubits(result)
        @test 7 == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
        @test 0 == measure(q[7])
    end

    @testset "addmod1plus1mod3" begin
        n = 2
        nn = 3
        dim = 2 * (n + 1) + 1
        p = Program(dim)
        prep = Step()
        addGates(prep, X(1), X(4))
        addStep(p, prep)
        add = Add(1, 3, 4, 6)
        addStep(p, Step(add))

        min = inverse(AddInteger(1, 3, nn))
        addStep(p, Step(min))
        addStep(p, Step(Cnot(3, dim)))
        addN = AddInteger(1, 3, nn)
        cbg = ControlledBlockGate(addN, 1, dim)
        addStep(p, Step(cbg))

        add2 = inverse(Add(1, 3, 4, 6))
        addStep(p, Step(add2))
        addStep(p, Step(X(dim)))

        block = Block(1)
        addStep(block, Step(X(1)))
        cbg2 = ControlledBlockGate(block, dim, 3)
        addStep(p, Step(cbg2))

        add3 = Add(1, 3, 4, 6)
        addStep(p, Step(add3))

        result = runProgram(p)
        q = getQubits(result)
        @test 7 == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
        @test 0 == measure(q[3])
        @test 1 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
        @test 0 == measure(q[7])
    end

    @testset "addmod2p2mod3" begin
        n = 2
        nn = 3
        dim = 2 * (n + 1) + 1
        p = Program(dim)
        prep = Step()
        addGates(prep, X(2), X(5))
        addStep(p, prep)
        add = Add(1, 3, 4, 6)
        addStep(p, Step(add))

        min = inverse(AddInteger(1, 3, nn))
        addStep(p, Step(min))
        addStep(p, Step(Cnot(3, dim)))
        addN = AddInteger(1, 3, nn)
        cbg = ControlledBlockGate(addN, 1, dim)
        addStep(p, Step(cbg))

        add2 = inverse(Add(1, 3, 4, 6))
        addStep(p, Step(add2))
        addStep(p, Step(X(dim)))

        block = Block(1)
        addStep(block, Step(X(1)))
        cbg2 = ControlledBlockGate(block, dim, 3)
        addStep(p, Step(cbg2))

        add3 = Add(1, 3, 4, 6)
        addStep(p, Step(add3))

        result = runProgram(p)
        q = getQubits(result)
        @test 7 == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 1 == measure(q[5])
        @test 0 == measure(q[6])
        @test 0 == measure(q[7])
    end

    @testset "addmod2p2mod3step1" begin
        n = 2
        nn = 3
        dim = 2 * (n + 1) + 1
        p = Program(dim)
        prep = Step()
        addGates(prep, X(2), X(5))
        addStep(p, prep)
        add = Add(1, 3, 4, 6)
        addStep(p, Step(add))

        min = inverse(AddInteger(1, 3, nn))
        addStep(p, Step(min))
        addStep(p, Step(Cnot(3, dim)))
        addN = AddInteger(1, 3, nn)
        cbg = ControlledBlockGate(addN, 1, dim)
        addStep(p, Step(cbg))

        result = runProgram(p)
        q = getQubits(result)
        @test 7 == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 1 == measure(q[5])
        @test 0 == measure(q[6])
        @test 0 == measure(q[7])
    end

    @testset "addmod2p2mod3step2" begin
        n = 2
        nn = 3
        dim = 2 * (n + 1) + 1
        p = Program(dim)
        prep = Step()
        addGates(prep, X(2), X(5))
        addStep(p, prep)
        add = Add(1, 3, 4, 6)
        addStep(p, Step(add))

        min = inverse(AddInteger(1, 3, nn))
        addStep(p, Step(min))
        addStep(p, Step(Cnot(3, dim)))
        addN = AddInteger(1, 3, nn)
        cbg = ControlledBlockGate(addN, 1, dim)
        addStep(p, Step(cbg))

        add2 = inverse(Add(1, 3, 4, 6))
        addStep(p, Step(add2))
        addStep(p, Step(X(dim)))

        result = runProgram(p)
        q = getQubits(result)
        @test 7 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
        @test 0 == measure(q[4])
        @test 1 == measure(q[5])
        @test 0 == measure(q[6])
        @test 1 == measure(q[7])
    end

    @testset "addmod2p2mod3step3" begin
        n = 2
        nn = 3
        dim = 2 * (n + 1) + 1
        p = Program(dim)
        prep = Step()
        addGates(prep, X(2), X(5))
        addStep(p, prep)
        add = Add(1, 3, 4, 6)
        addStep(p, Step(add))

        min = inverse(AddInteger(1, 3, nn))
        addStep(p, Step(min))
        addStep(p, Step(Cnot(3, dim)))
        addN = AddInteger(1, 3, nn)
        cbg = ControlledBlockGate(addN, 1, dim)
        addStep(p, Step(cbg))

        add2 = inverse(Add(1, 3, 4, 6))
        addStep(p, Step(add2))
        addStep(p, Step(X(dim)))

        block = Block(1)
        addStep(block, Step(X(1)))
        cbg2 = ControlledBlockGate(block, dim, 3)
        addStep(p, Step(cbg2))

        result = runProgram(p)
        q = getQubits(result)
        @test 7 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
        @test 0 == measure(q[4])
        @test 1 == measure(q[5])
        @test 0 == measure(q[6])
        @test 0 == measure(q[7])
    end

    @testset "addmodgate" begin
        n = 2
        nn = 3
        dim = 2 * (n + 1) + 1
        p = Program(dim)
        prep = Step()
        addGates(prep, X(2), X(5))
        addStep(p, prep)

        mod = Step(AddModulus(1, 3, 4, 6, nn))
        addStep(p, mod)
        result = runProgram(p)
        q = getQubits(result)
        @test 7 == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 1 == measure(q[5])
        @test 0 == measure(q[6])
        @test 0 == measure(q[7])
    end

    @testset "multiplyMod5x3andswapandcleans1" begin
        # 5 x 3 mod 6 = 3
        p = Program(9)
        prep = Step()
        mul = 5
        nn = 6
        addGates(prep, X(5), X(6))  # 3 in high register
        addStep(p, prep)
        for _ = 1:mul
            add = AddModulus(1, 4, 5, 8, nn)
            addStep(p, Step(add))
        end
        result = runProgram(p)
        q = getQubits(result)
        @test 9 == length(q)
        @test 1 == measure(q[1])  # q2,q1,q0,q3 should be clean
        @test 1 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 1 == measure(q[5])  # result in q4,q5,q6,q7
        @test 1 == measure(q[6])
        @test 0 == measure(q[7])
        @test 0 == measure(q[8])
        @test 0 == measure(q[9])
    end

    @testset "multiplyMod5x3andswapandcleans2" begin
        # 5 x 3 mod 6 = 3
        # |A00110000> .
        p = Program(9)
        prep = Step()
        mul = 5
        nn = 6
        addGates(prep, X(5), X(6))  # 3 in high register
        addStep(p, prep)
        #for ( i = 0  i < 1  i++)
        add = AddModulus(1, 4, 5, 8, nn)
        addStep(p, Step(add))
        #end
        addStep(p, Step(Swap(1, 5)))
        addStep(p, Step(Swap(2, 6)))
        addStep(p, Step(Swap(3, 7)))
        addStep(p, Step(Swap(4, 8)))

        invsteps = getInverseModulus(mul, nn)
        for _ = 1:invsteps
            addModulus = inverse(AddModulus(1, 4, 5, 8, nn))
            addStep(p, Step(addModulus))
        end
        result = runProgram(p)
        q = getQubits(result)
        @test 9 == length(q)
        @test 0 == measure(q[1])  # q2,q1,q0,q3 should be clean
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 1 == measure(q[5])  # result in q4,q5,q6,q7
        @test 1 == measure(q[6])
        @test 0 == measure(q[7])
        @test 0 == measure(q[8])
        @test 0 == measure(q[9])
    end

    # This test is broken (disabled in original Java code).
    #@testset "findPeriod7_15" begin
    #    # 5 x 3 mod 6 = 3
    #    p = Program(9)
    #    mul = 7
    #    n = 3
    #    prep = Step()
    #    addGates(prep, X(5), X(6))  # 3 in high register
    #    s = Step(MulModulus(1, 4, mul, n))
    #    addStep(p, prep)
    #    addStep(p, s)
    #    result = runProgram(p)
    #    q = getQubits(result)
    #    #println("results: ")
    #    #for ( i = 0  i < 9  i++)
    #    #    println("m[",i,"]: ",measure(q[i]))
    #    #end
    #    @test 9 == length(q)
    #    @test 0 == measure(q[1])  # q2,q1,q0,q3 should be clean
    #    @test 0 == measure(q[2])
    #    @test 0 == measure(q[3])
    #    @test 0 == measure(q[4])
    #    @test 1 == measure(q[5])  # result in q4,q5,q6,q7
    #    @test 1 == measure(q[6])
    #    @test 0 == measure(q[7])
    #    @test 0 == measure(q[8])
    #    @test 0 == measure(q[9])
    #end
end
