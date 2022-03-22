
@testset "Arithmetic #3" begin
    @testset "testMinOffset" begin
        offset = 2
        n = 2
        dim = 2 * n + offset + 3
        mod = 3
        p = Program(dim)
        prep = Step()
        for i = 1:offset
            addGate(prep, X(i))
        end
        addGates(prep, X(3), X(6))
        addStep(p, prep)
        a1 =
            inverse(AddModulus(offset + 1, n + offset + 1, n + offset + 2, offset + 2 * n + 2, mod))
        addStep(p, Step(a1))
        result = runProgram(p)
        q = getQubits(result)
        @test measure(q[1]) == 1
        @test measure(q[2]) == 1
        @test measure(q[3]) == 0
        @test measure(q[4]) == 0
        @test measure(q[5]) == 0
        @test measure(q[6]) == 1
        @test measure(q[7]) == 0
        @test measure(q[8]) == 0
        @test measure(q[9]) == 0
    end

    @testset "addmodgate" begin
        a = 3
        n = 3
        mod = 4
        dim = n + 2
        p = Program(dim)
        prep = Step()
        addGates(prep, X(2))
        addStep(p, prep)

        modstep = Step(AddIntegerModulus(1, 4, a, mod))
        addStep(p, modstep)
        result = runProgram(p)
        q = getQubits(result)

        @test dim == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
    end

    @testset "testAddIntModParts" begin
        x0 = 1
        x1 = 4
        a = 3
        n = x1 - x0
        nn = 4
        pdim = n + 2
        p = Program(pdim)
        prep = Step()
        addGates(prep, X(2))
        addStep(p, prep)
        answer = Block("AddIntegerModulus", x1 - x0 + 2)

        dim = n + 1

        add = AddInteger(x0, x1, a)
        addStep(answer, Step(add))

        min = inverse(AddInteger(x0, x1, nn))
        addStep(answer, Step(min))
        addStep(answer, Step(Cnot(x1, dim + 1)))
        addN = AddInteger(x0, x1, nn)
        cbg = ControlledBlockGate(addN, x0, dim + 1)
        addStep(answer, Step(cbg))

        add2 = inverse(AddInteger(x0, x1, a))
        addStep(answer, Step(add2))
        addStep(answer, Step(X(dim)))

        block = Block(1)
        addStep(block, Step(X(1)))
        cbg2 = ControlledBlockGate(block, dim, x1)
        addStep(answer, Step(cbg2))
        addStep(answer, Step(X(dim)))

        add3 = AddInteger(x0, x1, a)
        addStep(answer, Step(add3))

        for step in getSteps(answer)
            addStep(p, step)
        end

        result = runProgram(p)
        q = getQubits(result)

        @test pdim == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
    end

    # 2 + 3 = 5
    # 5 - 4 = 1
    @testset "testAddIntModPart1" begin
        x0 = 1
        x1 = 4
        a = 3
        n = x1 - x0
        nn = 4
        pdim = n + 2
        p = Program(pdim)
        prep = Step()
        addGates(prep, X(2))
        addStep(p, prep)
        answer = Block("AddIntegerModulus", x1 - x0 + 2)

        dim = n + 1

        add = AddInteger(x0, x1, a)
        addStep(answer, Step(add))

        min = inverse(AddInteger(x0, x1, nn))
        addStep(answer, Step(min))

        for step in getSteps(answer)
            addStep(p, step)
        end

        result = runProgram(p)
        q = getQubits(result)

        @test pdim == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
    end

    # 2 + 3 = 5
    # 5 - 4 = 1
    # since 5 > 4 we should NOT add 4 again
    @testset "testAddIntModPart2" begin
        x0 = 1
        x1 = 4
        a = 3
        n = x1 - x0
        nn = 4
        pdim = n + 2
        p = Program(pdim)
        prep = Step()
        addGates(prep, X(2))
        addStep(p, prep)
        answer = Block("AddIntegerModulus", x1 - x0 + 2)

        dim = n + 2

        add = AddInteger(x0, x1, a)
        addStep(answer, Step(add))

        min = inverse(AddInteger(x0, x1, nn))
        addStep(answer, Step(min))

        addStep(answer, Step(Cnot(x1, dim)))
        addN = AddInteger(x0, x1, nn)
        cbg = ControlledBlockGate(addN, x0, dim)
        addStep(answer, Step(cbg))

        for step in getSteps(answer)
            addStep(p, step)
        end

        result = runProgram(p)
        q = getQubits(result)

        @test pdim == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
    end

    # 2 + 3 = 5
    # 5 - 4 = 1
    # since 5 > 4 we should NOT add 4 again
    # 1 - 3 = -2 -> -2 + 16 = 14
    @testset "testAddIntModPart3" begin
        x0 = 1
        x1 = 4
        a = 3
        n = x1 - x0
        nn = 4
        pdim = n + 2
        p = Program(pdim)
        prep = Step()
        addGates(prep, X(2))
        addStep(p, prep)
        answer = Block("AddIntegerModulus", x1 - x0 + 2)

        dim = n + 2

        # 2 + 3 = 5
        add = AddInteger(x0, x1, a)
        addStep(answer, Step(add))

        # 5 - 4 = 1
        min = inverse(AddInteger(x0, x1, nn))
        addStep(answer, Step(min))

        # ancilla 0
        addStep(answer, Step(Cnot(x1, dim)))
        addN = AddInteger(x0, x1, nn)
        cbg = ControlledBlockGate(addN, x0, dim)
        addStep(answer, Step(cbg))

        # (1 - 3) MOD 16 = 14
        add2 = inverse(AddInteger(x0, x1, a))
        addStep(answer, Step(add2))

        for step in getSteps(answer)
            addStep(p, step)
        end

        result = runProgram(p)
        q = getQubits(result)

        @test pdim == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
        @test 1 == measure(q[4])
        @test 0 == measure(q[5])
    end

    # 2 + 3 = 5
    # 5 - 4 = 1
    # since 5 > 4 we should NOT add 4 again
    # 1 - 3 = -2 -> -2 + 16 = 14
    # invert msb in b and add cnot to ancilla bit, invert msb in b again
    @testset "testAddIntModPart4" begin
        x0 = 1
        x1 = 4
        a = 3
        n = x1 - x0
        nn = 4
        pdim = n + 2
        p = Program(pdim)
        prep = Step()
        addGates(prep, X(2))
        addStep(p, prep)
        answer = Block("AddIntegerModulus", x1 - x0 + 2)

        dim = n + 2

        # 2 + 3 = 5
        add = AddInteger(x0, x1, a)
        addStep(answer, Step(add))

        # 5 - 4 = 1
        min = inverse(AddInteger(x0, x1, nn))
        addStep(answer, Step(min))

        # ancilla 0
        addStep(answer, Step(Cnot(x1, dim)))
        addN = AddInteger(x0, x1, nn)
        cbg = ControlledBlockGate(addN, x0, dim)
        addStep(answer, Step(cbg))

        # (1 - 3) MOD 16 = 14
        add2 = inverse(AddInteger(x0, x1, a))
        addStep(answer, Step(add2))

        addStep(answer, Step(X(dim - 1)))
        addStep(answer, Step(Cnot(x1, dim)))

        addStep(answer, Step(X(dim - 1)))

        for step in getSteps(answer)
            addStep(p, step)
        end

        result = runProgram(p)
        q = getQubits(result)

        @test pdim == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
        @test 1 == measure(q[4])
        @test 0 == measure(q[5])
    end

    @testset "testAddIntModPartAll" begin
        x0 = 1
        x1 = 4
        a = 3
        n = x1 - x0
        nn = 4
        pdim = n + 2
        p = Program(pdim)
        prep = Step()
        addGates(prep, X(2))
        addStep(p, prep)
        answer = Block("AddIntegerModulus", x1 - x0 + 2)

        dim = n + 2

        # 2 + 3 = 5
        add = AddInteger(x0, x1, a)
        addStep(answer, Step(add))

        # 5 - 4 = 1
        min = inverse(AddInteger(x0, x1, nn))
        addStep(answer, Step(min))

        # ancilla 0
        addStep(answer, Step(Cnot(x1, dim)))
        addN = AddInteger(x0, x1, nn)
        cbg = ControlledBlockGate(addN, x0, dim)
        addStep(answer, Step(cbg))

        # (1 - 3) MOD 16 = 14
        add2 = inverse(AddInteger(x0, x1, a))
        addStep(answer, Step(add2))

        # invert MSB
        addStep(answer, Step(X(dim - 1)))
        # add CNOT
        addStep(answer, Step(Cnot(x1, dim)))
        # invert B again
        addStep(answer, Step(X(dim - 1)))

        # re-add a
        add3 = AddInteger(x0, x1, a)
        addStep(answer, Step(add3))

        for step in getSteps(answer)
            addStep(p, step)
        end

        result = runProgram(p)
        q = getQubits(result)

        @test pdim == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
    end

    # 0 + 3 = 3
    # 3 - 4 = -1
    # since 3 < 4 we should add 4 again
    # -1 + 4 = 3
    @testset "testAddIntMod2Part2" begin
        x0 = 1
        x1 = 4
        a = 3
        n = x1 - x0
        nn = 4
        pdim = n + 2
        p = Program(pdim)

        answer = Block("AddIntegerModulus", x1 - x0 + 2)

        dim = n + 2

        add = AddInteger(x0, x1, a)
        addStep(answer, Step(add))

        min = inverse(AddInteger(x0, x1, nn))
        addStep(answer, Step(min))

        addStep(answer, Step(Cnot(x1, dim)))
        addN = AddInteger(x0, x1, nn)
        cbg = ControlledBlockGate(addN, x0, dim)
        addStep(answer, Step(cbg))

        for step in getSteps(answer)
            addStep(p, step)
        end

        result = runProgram(p)
        q = getQubits(result)

        @test pdim == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 1 == measure(q[5])
    end

    # 0 + 3 = 3
    # 3 - 4 = -1
    # since 3 < 4 we should add 4 again
    # -1 + 4 = 3
    # 3 - 3 = 0 -> -2 + 16 = 14
    @testset "testAddIntMod2Part3" begin
        x0 = 1
        x1 = 4
        a = 3
        n = x1 - x0
        nn = 4
        pdim = n + 2
        p = Program(pdim)

        answer = Block("AddIntegerModulus", x1 - x0 + 2)

        dim = n + 2

        # 0 + 3 = 3
        add = AddInteger(x0, x1, a)
        addStep(answer, Step(add))

        # 3 - 4 = -1
        min = inverse(AddInteger(x0, x1, nn))
        addStep(answer, Step(min))

        # ancilla 1
        addStep(answer, Step(Cnot(x1, dim)))
        addN = AddInteger(x0, x1, nn)
        cbg = ControlledBlockGate(addN, x0, dim)
        # -1 + 4 = 3
        addStep(answer, Step(cbg))

        # 3 - 3 = 0
        add2 = inverse(AddInteger(x0, x1, a))
        addStep(answer, Step(add2))

        for step in getSteps(answer)
            addStep(p, step)
        end

        result = runProgram(p)
        q = getQubits(result)

        @test pdim == length(q)
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 1 == measure(q[5])
    end

    # 0 + 3 = 3
    # 3 - 4 = -1
    # since 3 < 4 we should add 4 again
    # -1 + 4 = 3
    # 3 - 3 = 0 -> -2 + 16 = 14
    # invert msb in b and add cnot to ancilla bit, invert msb in b again
    @testset "testAddIntMod2Part4" begin
        x0 = 1
        x1 = 4
        a = 3
        n = x1 - x0
        nn = 4
        pdim = n + 2
        p = Program(pdim)

        answer = Block("AddIntegerModulus", x1 - x0 + 2)

        dim = n + 2

        # 0 + 3 = 3
        add = AddInteger(x0, x1, a)
        addStep(answer, Step(add))

        # 3 - 4 = -1
        min = inverse(AddInteger(x0, x1, nn))
        addStep(answer, Step(min))

        # ancilla 1
        addStep(answer, Step(Cnot(x1, dim)))
        addN = AddInteger(x0, x1, nn)
        cbg = ControlledBlockGate(addN, x0, dim)
        # -1 + 4 = 3
        addStep(answer, Step(cbg))

        # 3 - 3 = 0
        add2 = inverse(AddInteger(x0, x1, a))
        addStep(answer, Step(add2))

        addStep(answer, Step(X(dim - 1)))
        addStep(answer, Step(Cnot(x1, dim)))

        #        Block block =  Block(1)
        #        addStep(block, Step( X(0)))
        #        ControlledBlockGate cbg2 =  ControlledBlockGate(block, dim, x1)
        #        addStep(answer, Step(cbg2))
        addStep(answer, Step(X(dim - 1)))

        for step in getSteps(answer)
            addStep(p, step)
        end

        result = runProgram(p)
        q = getQubits(result)

        @test pdim == length(q)
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
    end

    @testset "testAddIntMod3PartAll" begin
        # 0 + 1 mod 3 = 1
        x0 = 1
        x1 = 3
        a = 1
        n = x1 - x0
        nn = 3
        pdim = n + 2
        p = Program(pdim)
        prep = Step()
        answer = Block("AddIntegerModulus", x1 - x0 + 2)

        dim = n + 2

        # 2 + 3 = 5
        add = AddInteger(x0, x1, a)
        addStep(answer, Step(add))

        # 5 - 4 = 1
        min = inverse(AddInteger(x0, x1, nn))
        addStep(answer, Step(min))

        # ancilla 0
        addStep(answer, Step(Cnot(x1, dim)))
        addN = AddInteger(x0, x1, nn)
        cbg = ControlledBlockGate(addN, x0, dim)
        addStep(answer, Step(cbg))

        # (1 - 3) MOD 16 = 14
        add2 = inverse(AddInteger(x0, x1, a))
        addStep(answer, Step(add2))

        # invert MSB
        addStep(answer, Step(X(dim - 1)))
        # add CNOT
        addStep(answer, Step(Cnot(x1, dim)))
        # invert B again
        addStep(answer, Step(X(dim - 1)))

        # re-add a
        add3 = AddInteger(x0, x1, a)
        addStep(answer, Step(add3))

        for step in getSteps(answer)
            addStep(p, step)
        end

        result = runProgram(p)
        q = getQubits(result)

        @test pdim == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
    end
end
