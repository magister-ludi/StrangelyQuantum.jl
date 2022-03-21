
#const Δ_Arithmetic1 = 0.000000001d

@testset "Arithmetic #1" begin
    @testset "add 00" begin
        p = Program(2)
        prep = Step()
        addStep(p, prep)
        add = Add(1, 1, 2, 2)
        addStep(p, Step(add))
        result = runProgram(p)
        q = getQubits(result)
        @test 2 == length(q)
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
    end

    @testset "add 10" begin
        p = Program(2)
        prep = Step()
        addGate(prep, X(1))
        addStep(p, prep)
        add = Add(1, 1, 2, 2)
        addStep(p, Step(add))
        result = runProgram(p)
        q = getQubits(result)
        @test 2 == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
    end

    @testset "add 010" begin
        p = Program(3)
        prep = Step()
        addGate(prep, X(2))
        addStep(p, prep)
        add = Add(2, 2, 3, 3)
        addStep(p, Step(add))
        result = runProgram(p)
        q = getQubits(result)
        @test 3 == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
        @test 0 == measure(q[3])
    end

    @testset "add 01" begin
        p = Program(2)
        prep = Step()
        addGate(prep, X(2))
        addStep(p, prep)
        add = Add(1, 1, 2, 2)
        addStep(p, Step(add))
        result = runProgram(p)
        q = getQubits(result)
        @test 2 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
    end

    @testset "add 11" begin
        p = Program(2)
        prep = Step()
        addGates(prep, X(1), X(2))
        addStep(p, prep)
        add = Add(1, 1, 2, 2)
        addStep(p, Step(add))
        result = runProgram(p)
        q = getQubits(result)
        @test 2 == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
    end

    @testset "add 61" begin
        p = Program(6)
        prep = Step()
        addGates(prep, X(2), X(3), X(4))
        addStep(p, prep)
        add = Add(1, 3, 4, 6)
        addStep(p, Step(add))
        result = runProgram(p)
        q = getQubits(result)
        @test 6 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
        @test 1 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
    end

    @testset "add mod p0" begin
        N = 1
        dim = 2
        p = Program(dim)
        min = inverse(AddInteger(1, 2, N))
        addStep(p, Step(min))
        result = runProgram(p)
        q = getQubits(result)
        @test dim == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
    end

    @testset "add 0 num 0" begin
        p = Program(1)
        prep = Step()
        addStep(p, prep)
        add = AddInteger(1, 1, 0)
        addStep(p, Step(add))
        result = runProgram(p)
        q = getQubits(result)
        @test 1 == length(q)
        @test 0 == measure(q[1])
    end

    @testset "add 0 num 1" begin
        p = Program(1)
        prep = Step()
        addStep(p, prep)
        add = AddInteger(1, 1, 1)
        addStep(p, Step(add))
        result = runProgram(p)
        q = getQubits(result)
        @test 1 == length(q)
        @test 1 == measure(q[1])
    end

    @testset "add 1 num 0" begin
        p = Program(1)
        prep = Step()
        addGate(prep, X(1))
        addStep(p, prep)
        add = AddInteger(1, 1, 0)
        addStep(p, Step(add))
        result = runProgram(p)
        q = getQubits(result)
        @test 1 == length(q)
        @test 1 == measure(q[1])
    end

    @testset "add 1 num 1" begin
        p = Program(1)
        prep = Step()
        addGates(prep, X(1))
        addStep(p, prep)
        add = AddInteger(1, 1, 1)
        addStep(p, Step(add))
        result = runProgram(p)
        q = getQubits(result)
        @test 1 == length(q)
        @test 0 == measure(q[1])
    end

    @testset "add 5 num 2" begin
        p = Program(3)
        prep = Step()
        addGates(prep, X(1), X(3))
        addStep(p, prep)
        add = AddInteger(1, 3, 2)
        addStep(p, Step(add))
        result = runProgram(p)
        q = getQubits(result)
        @test 3 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
    end

    @testset "add 5 num 2p" begin
        p = Program(4)
        prep = Step()
        addGates(prep, X(2), X(4))
        addStep(p, prep)
        add = AddInteger(2, 4, 2)
        addStep(p, Step(add))
        result = runProgram(p)
        q = getQubits(result)
        @test 4 == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
        @test 1 == measure(q[4])
    end

    @testset "add 5 num 4" begin
        p = Program(3)
        prep = Step()
        addGates(prep, X(1), X(3))
        addStep(p, prep)
        add = AddInteger(1, 3, 4)
        addStep(p, Step(add))
        result = runProgram(p)
        q = getQubits(result)
        @test 3 == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
    end

    @testset "add mod11 num 4" begin
        p = Program(4)
        prep = Step()
        addGates(prep, X(1))
        addStep(p, prep)
        add = AddIntegerModulus(1, 2, 1, 3)
        addStep(p, Step(add))
        result = runProgram(p)
        q = getQubits(result)
        @test 4 == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
    end

    @testset "adjoint" begin
        p = Program(6)
        prep = Step()
        addGates(prep, X(2), X(3), X(4))
        addStep(p, prep)
        add = Add(1, 3, 4, 6)
        addStep(p, Step(add))
        min = inverse(Add(1, 3, 4, 6))
        addStep(p, Step(min))
        result = runProgram(p)
        q = getQubits(result)
        @test 6 == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
        @test 1 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
    end

    @testset "multiply 5x3" begin
        # 5 x 3 mod 8 = 7
        p = Program(6)
        prep = Step()
        addGates(prep, X(4), X(5))  # 5 in second register
        addStep(p, prep)
        for _ = 1:5
            add = Add(1, 3, 4, 6)
            addStep(p, Step(add))
        end
        result = runProgram(p)
        q = getQubits(result)
        @test 6 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
        @test 1 == measure(q[4])
        @test 1 == measure(q[5])
        @test 0 == measure(q[6])
    end

    @testset "multiply 5x7" begin
        # 5 x 7 mod 8 = 3
        p = Program(6)
        prep = Step()
        addGates(prep, X(4), X(5), X(6))
        addStep(p, prep)
        for _ = 1:5
            add = Add(1, 3, 4, 6)
            addStep(p, Step(add))
        end
        result = runProgram(p)
        q = getQubits(result)
        @test 6 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
        @test 0 == measure(q[3])
        @test 1 == measure(q[4])
        @test 1 == measure(q[5])
        @test 1 == measure(q[6])
    end

    @testset "multiply 5x3 and swap" begin
        # 5 x 3 mod 8 = 7
        p = Program(6)
        prep = Step()
        addGates(prep, X(4), X(5))  # 5 in second register
        addStep(p, prep)
        for _ = 1:5
            add = Add(1, 3, 4, 6)
            addStep(p, Step(add))
        end
        addStep(p, Step(Swap(1, 4)))
        addStep(p, Step(Swap(2, 5)))
        addStep(p, Step(Swap(3, 6)))
        result = runProgram(p)
        q = getQubits(result)
        @test 6 == length(q)
        @test 1 == measure(q[1])  # result in q2,q1,q0
        @test 1 == measure(q[2])
        @test 0 == measure(q[3])
        @test 1 == measure(q[4])
        @test 1 == measure(q[5])
        @test 1 == measure(q[6])
    end

    @testset "getInverseModulus" begin
        answer = getInverseModulus(56, 69)
        @test 53 == answer
    end

    @testset "multiply 5x3 and swap and clean" begin
        # 5 x 3 mod 8 = 7
        p = Program(6)
        prep = Step()
        mul = 5
        addGates(prep, X(4), X(5))  # 3 in high register
        addStep(p, prep)
        for _ = 1:mul
            add = Add(1, 3, 4, 6)
            addStep(p, Step(add))
        end
        addStep(p, Step(Swap(1, 4)))
        addStep(p, Step(Swap(2, 5)))
        addStep(p, Step(Swap(3, 6)))

        invsteps = getInverseModulus(mul, 8)
        for _ = 1:invsteps
            add = inverse(Add(1, 3, 4, 6))
            addStep(p, Step(add))
        end
        result = runProgram(p)
        q = getQubits(result)
        @test 6 == length(q)
        @test 0 == measure(q[1])  # q2,q1,q0 should be clean
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 1 == measure(q[4])  # result in q3,q4,q5
        @test 1 == measure(q[5])
        @test 1 == measure(q[6])
    end

    @testset "mul 01" begin
        p = Program(2)
        s = Step(Mul(1, 1, 1))
        addStep(p, s)
        result = runProgram(p)
        q = getQubits(result)
        @test 2 == length(q)
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
    end

    @testset "mul 11" begin
        p = Program(2)
        prep = Step()
        addGates(prep, X(2))
        s = Step(Mul(1, 1, 1))
        addStep(p, prep)
        addStep(p, s)
        result = runProgram(p)
        q = getQubits(result)
        @test 2 == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
    end

    @testset "mul 13" begin
        # 0100 -> 1100
        p = Program(4)
        prep = Step()
        addGates(prep, X(3))
        s = Step(Mul(1, 2, 3))
        addStep(p, prep)
        addStep(p, s)
        result = runProgram(p)
        q = getQubits(result)
        @test 4 == length(q)
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
        @test 1 == measure(q[3])
        @test 1 == measure(q[4])
    end

    @testset "mul 55" begin
        # 101000 -> 001000
        p = Program(6)
        prep = Step()
        addGates(prep, X(4), X(6))
        s = Step(Mul(1, 3, 5))
        addStep(p, prep)
        addStep(p, s)
        result = runProgram(p)
        q = getQubits(result)
        @test 6 == length(q)
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 1 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
    end

    @testset "controlled Add 001" begin
        p = Program(3)
        s = Step()
        add = Add(1, 1, 2, 2)
        cbg = ControlledBlockGate(add, 2, 1)
        #m = getMatrix(cbg)
        prep = Step()
        addGates(prep, X(1))
        addStep(p, prep)
        cg = Step(cbg)
        addStep(p, cg)
        result = runProgram(p)
        q = getQubits(result)
        @test 3 == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
    end

    @testset "controlled Add 100" begin
        # q_0 = q_1(0) + q_0(0) = 0
        p = Program(3)
        s = Step()
        add = Add(1, 1, 2, 2)
        cbg = ControlledBlockGate(add, 1, 3)
        #m = cbg.getMatrix()
        prep = Step()
        addGates(prep, X(3))
        addStep(p, prep)
        cg = Step(cbg)
        addStep(p, cg)
        result = runProgram(p)
        q = getQubits(result)
        @test 3 == length(q)
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
        @test 1 == measure(q[3])
    end

    @testset "controlled Add 101" begin
        # q_0 = q_1(0) + q_0 (1) = 1
        p = Program(3)
        s = Step()
        add = Add(1, 1, 2, 2)
        cbg = ControlledBlockGate(add, 2, 1)
        #m = cbg.getMatrix()
        prep = Step()
        addGates(prep, X(1), X(3))
        addStep(p, prep)
        cg = Step(cbg)
        addStep(p, cg)
        result = runProgram(p)
        q = getQubits(result)
        @test 3 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
    end

    @testset "controlled Add 110" begin
        # q_0 = q_1(1) + q_0 (0) = 1
        p = Program(3)
        s = Step()
        add = Add(1, 1, 2, 2)
        cbg = ControlledBlockGate(add, 1, 3)
        #m = cbg.getMatrix()
        prep = Step()
        addGates(prep, X(2), X(3))
        addStep(p, prep)
        cg = Step(cbg)
        addStep(p, cg)
        result = runProgram(p)
        q = getQubits(result)
        @test 3 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
    end

    @testset "controlled Add 111" begin
        # q_0 = q_1(1) + q_0 (1) = 0
        p = Program(3)
        s = Step()
        add = Add(1, 1, 2, 2)
        cbg = ControlledBlockGate(add, 1, 3)
        #m = cbg.getMatrix()
        prep = Step()
        addGates(prep, X(1), X(2), X(3))
        addStep(p, prep)
        cg = Step(cbg)
        addStep(p, cg)
        result = runProgram(p)
        q = getQubits(result)
        @test 3 == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
    end

    @testset "expmul" begin
        len = 2
        a = 3
        p = Program(3 * len)
        prepAnc = Step(X(3 * len))
        addStep(p, prepAnc)
        for i = 1:len
            m = a << (len - i)  # 2^(n-i)
            mul = Mul(len + 1, 2 * len, a)
            if i < len
                swap = Swap(i, len)
                addStep(p, Step(swap))
            end
            cbg = ControlledBlockGate(mul, len + 1, len)
            addStep(p, Step(cbg))
            if i < len
                swap = Swap(i, len)
                addStep(p, Step(swap))
            end
        end
        result = runProgram(p)
        q = getQubits(result)
        @test 6 == length(q)
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 1 == measure(q[6])
    end

    @testset "minus1" begin
        # 1 - 3 = -2
        # -2 + 8 = 6
        N = 3
        dim = 3
        p = Program(dim)
        prep = Step()
        addGates(prep, X(1))
        addStep(p, prep)

        min = inverse(AddInteger(1, 3, N))
        addStep(p, Step(min))
        result = runProgram(p)
        q = getQubits(result)
        @test dim == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
    end

    @testset "minus2" begin
        # 1-3 = -2
        # -2 + 8 = 6
        n = 2
        nn = 3
        dim = 2 * (n + 1) + 1
        p = Program(dim)
        prep = Step()
        addGates(prep, X(1))
        addStep(p, prep)

        min = inverse(AddInteger(1, 3, nn))
        addStep(p, Step(min))

        result = runProgram(p)
        q = getQubits(result)
        @test 7 == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
        @test 1 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
        @test 0 == measure(q[7])
    end

    @testset "addmod0" begin
        # 0 + 1 = 1
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
        addStep(p, Step(Cnot(2, dim)))
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
        # |A00110000> ->
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

    @testset "multiplyModGate5x3mod6" begin
        # 5 x 3 mod 6 = 3
        p = Program(8)
        mul = 5
        nn = 6
        prep = Step()
        addGates(prep, X(1), X(2))  # 3 in low register
        s = Step(MulModulus(1, 3, mul, nn))
        addStep(p, prep)
        addStep(p, s)
        result = runProgram(p)
        q = getQubits(result)

        @test 8 == length(q)
        @test 1 == measure(q[1])  # q2,q1,q0 contain result
        @test 1 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
        @test 0 == measure(q[7])
        @test 0 == measure(q[8])
    end

    @testset "multiplyModGate5x3mod6p" begin
        # 5 x 3 mod 6 = 3
        p = Program(9)
        mul = 5
        nn = 6
        prep = Step()
        addGates(prep, X(2), X(3))  # 3 in high register
        s = Step(MulModulus(2, 4, mul, nn))
        addStep(p, prep)
        addStep(p, s)
        result = runProgram(p)
        q = getQubits(result)
        @test 9 == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])  # q2,q1,q0,q3 should be clean
        @test 1 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])  # result in q4,q5,q6,q7
        @test 0 == measure(q[7])
        @test 0 == measure(q[8])
        @test 0 == measure(q[9])
    end

    @testset "inverse and invInverse" begin
        x1 = 3
        x0 = 1
        y0 = 4
        y1 = 6
        n = x1 - x0
        nn = 3
        dim = 2 * (n + 1) + 1
        answer = Program(7)

        addStep(answer, Step(X(1), X(2), X(3), X(5)))
        add1 = Add(x0, x1, y0, y1)
        addStep(answer, Step(inverse(add1)))

        add2 = Add(x0, x1, y0, y1)
        addStep(answer, Step(inverse(inverse(add2))))

        result = runProgram(answer)
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

    @testset "invInverse and inverse" begin
        x1 = 3
        x0 = 1
        y0 = 4
        y1 = 6
        n = x1 - x0
        nn = 3
        dim = 2 * (n + 1) + 1
        answer = Program(7)

        addStep(answer, Step(X(1), X(2), X(3), X(5)))

        add1 = Add(x0, x1, y0, y1)
        addStep(answer, Step(inverse(inverse(add1))))
        add2 = Add(x0, x1, y0, y1)
        addStep(answer, Step(inverse(add2)))
        result = runProgram(answer)
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

    @testset "addmod part2" begin
        x1 = 3
        x0 = 1
        y0 = 4
        y1 = 6
        n = x1 - x0
        nn = 3
        dim = 2 * (n + 1) + 1
        answer = Program(7)

        addStep(answer, Step(X(1), X(5)))

        add3 = Add(x0, x1, y0, y1)
        addStep(answer, Step(inverse(add3)))

        blockinv = Block(1)
        addStep(blockinv, Step(X(1)))
        cbginv = inverse(ControlledBlockGate(blockinv, dim, x1))
        addStep(answer, Step(cbginv))
        result = runProgram(answer)
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

    #@testset "findPeriod 7_15" begin
    #    # 5 x 3 mod 6 = 3
    #
    #    This test is broken, as is the original Java test:
    #    1. The program fails as 10 qubits are required, not 10
    #    2. The measured bits are then 1 1 0 0 0 0 0 0 0 0
    #
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
