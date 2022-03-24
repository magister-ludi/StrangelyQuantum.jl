
function expmod(a, mod, len)
    # q0 -> q2: 4
    # q3 -> q5: ancilla (0 before, 0 after)
    # q6 -> q8: result
    p = Program(3 * len - 1)
    prep = Step(X(3))  # exp = 4
    prepAnc = Step(X(len))
    addStep(p, prep)
    addStep(p, prepAnc)
    for i = (len - 1):-1:1
        m = 1
        for j = 1:(1 << (i - 1))
            m = m * a % mod
        end
        mul = MulModulus(len, 2 * len - 2, m, mod)
        cbg = ControlledBlockGate(mul, len, i)
        addStep(p, Step(cbg))
    end
    result = runProgram(p)
    q = getQubits(result)
    return q
end

function measurePeriod(a, mod)
    len = ceil(Int, log2(mod))
    offset = len + 1
    p = Program(2 * len + 2 + offset)
    prep = Step()
    for i = 1:len
        addGate(prep, Hadamard(i))
    end
    prepAnc = Step(X(offset))
    addStep(p, prep)
    addStep(p, prepAnc)
    for i = len:-1:1 # - 1  i > len - 1 - offset  i--)
        m = 1
        for _ = 1:(1 << (i - 1))
            m = m * a % mod
        end
        mul = MulModulus(len + 1, 2 * len, m, mod)
        cbg = ControlledBlockGate(mul, offset, i)
        addStep(p, Step(cbg))
    end
    addStep(p, Step(InvFourier(len, 1)))
    result = runProgram(p)
    q = getQubits(result)
    answer = 0
    for i = 1:offset
        answer += measure(q[i]) * (1 << (i - 1))
    end
    return answer
end

@testset "ExpMul Tests" begin
    @testset "expmul3p3" begin
        # 3^3 = 27 -> mod 8 = 3
        len = 3
        nn = 8
        # q0 -> q2: x (3)
        # q3 -> q5: ancilla (0 before, 0 after)
        # q6 -> q8: result
        a = 3
        p = Program(3 * len)
        prep = Step(X(1), X(2))
        prepAnc = Step(X(2 * len + 1))
        addStep(p, prep)
        addStep(p, prepAnc)
        for i = len:-1:1
            m = 1
            for j = 1:(1 << (i - 1))
                m = m * a % nn
            end
            mul = Mul(len + 1, 2 * len, m)
            cbg = ControlledBlockGate(mul, len + 1, i)
            addStep(p, Step(cbg))
        end
        result = runProgram(p)
        q = getQubits(result)
        @test 9 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
        @test 1 == measure(q[7])
        @test 1 == measure(q[8])
        @test 0 == measure(q[9])
    end

    @testset "mul3x3" begin
        # 3^3 = 27 -> mod 8 = 3
        len = 3
        # q0 -> q2: x (3)
        # q3 -> q5: ancilla (0 before, 0 after)
        # q6 -> q8: result
        a = 3
        p = Program(3 * len)
        prep = Step(X(1), X(2))
        prepAnc = Step(X(2 * len + 1))
        addStep(p, prep)
        addStep(p, prepAnc)
        i = 2
        m = 1
        mul = Mul(len + 1, 2 * len, m)
        addStep(p, Step(mul))

        result = runProgram(p)
        q = getQubits(result)
        @test 9 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
        @test 1 == measure(q[7])
        @test 0 == measure(q[8])
        @test 0 == measure(q[9])
    end

    @testset "mul1" begin
        # test Mul that doesn't start at 0
        len = 2
        p = Program(3 * len)
        prep = Step(X(1), X(2))
        prepAnc = Step(X(2 * len + 1))
        addStep(p, prep)
        addStep(p, prepAnc)
        i = 2
        m = 1
        mul = Mul(len + 1, 2 * len, m)
        addStep(p, Step(mul))
        result = runProgram(p)
        q = getQubits(result)
        @test 6 == length(q)
        @test 1 == measure(q[1])
        @test 1 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 1 == measure(q[5])
        @test 0 == measure(q[6])
    end

    @testset "expmul3p4" begin
        # 3^4 = 81 -> mod 8 = 1
        len = 3
        # q0 -> q2: x (4)
        # q3 -> q5: ancilla (0 before, 0 after)
        # q6 -> q8: result
        a = 3
        p = Program(3 * len)
        prep = Step(X(3))
        prepAnc = Step(X(2 * len + 1))
        addStep(p, prep)
        addStep(p, prepAnc)
        for i = len:-1:1
            m = a^(1 << (i - 1))
            mul = Mul(len + 1, 2 * len, m)
            cbg = ControlledBlockGate(mul, len + 1, i)
            addStep(p, Step(cbg))
        end
        result = runProgram(p)
        q = getQubits(result)
        @test 9 == length(q)
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
        @test 1 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
        @test 1 == measure(q[7])
        @test 0 == measure(q[8])
        @test 0 == measure(q[9])
    end

    # @Test //
    function expmul3p4mod7()
        # 3^4 = 81 -> mod 7 = 4
        len = 3
        # q0 -> q2: 4
        # q3 -> q6: ancilla (0 before, 0 after)
        # q7 -> q10: result, start with 1
        a = 3
        mod = 7
        p = Program(3 * len + 3)
        prep = Step(X(3))  # exp = 4
        prepAnc = Step(X(8))

        addStep(p, prep)
        addStep(p, prepAnc)
        for i = len:-1:1
            m = 1
            for j = 1:(1 << (i - 1))
                m = m * a % mod
            end
            #println("M = "+m)
            mul = MulModulus(len + 1, 2 * len + 1, m, mod)
            cbg = ControlledBlockGate(mul, len + 1, i)
            addStep(p, Step(cbg))
        end
        result = runProgram(p)
        q = getQubits(result)
        @test 12 == length(q)
        #println("results: ")
        #for ( i = 0  i < 12  i++)
        #    println("m["+i+"]: "+measure(q[i]))
        #end
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
        @test 1 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])
        @test 0 == measure(q[7])
        @test 0 == measure(q[8])
        @test 0 == measure(q[9])
        @test 1 == measure(q[10])
        @test 0 == measure(q[11])
        @test 0 == measure(q[12])
    end

    @testset "expmul3p4mod7gen" begin
        # 3^4 = 81 -> mod 7 = 4
        q = expmod(3, 7, 4)
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
        @test 1 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 1 == measure(q[6])
        @test 0 == measure(q[7])
        @test 0 == measure(q[8])
        @test 0 == measure(q[9])
        @test 0 == measure(q[10])
        @test 0 == measure(q[11])
    end

    #@testset "expmul7p4mod15gen" begin
    # 3^4 = 81 -> mod 7 = 4
    #     q = expmod(7,15,4)
    #end

    @testset "testexpmodH37" begin
        #  H { 1 x 3 ^ A mod 7}
        mod = 7
        a = 3
        len = ceil(Int, log2(mod))
        offset = 1
        dim0 = 1 << offset
        @test dim0 == 2
        p = Program(2 * len + 2 + offset)
        prep = Step()

        addGate(prep, X(4))

        prepAnc = Step(X(len + 3 + offset))
        addStep(p, prep)
        addStep(p, prepAnc)
        for i = offset:-1:1
            m = 1
            for _ = 1:(1 << (i - 1))
                m = m * a % mod
            end
            mul = MulModulus(len + 1, 2 * len, m, mod)
            cbg = ControlledBlockGate(mul, offset + 1, i)
            addStep(p, Step(cbg))
        end
        addStep(p, Step(InvFourier(offset, 1)))
        result = runProgram(p)
        probs = getProbability(result)
        q = getQubits(result)
        amps = zeros(dim0)
        for i = 1:length(probs)
            amps[mod1(i, dim0)] += abs2(probs[i])
        end
        for i = 1:dim0
            @test amps[i] ≈ 0.5 atol = 0.001
        end
    end

    @testset "testexpmodHH37" begin
        #  H { 1 x 3 ^ A mod 7}
        mod = 7
        a = 3
        len = ceil(Int, log2(mod))
        offset = 2
        dim0 = 1 << offset
        @test dim0 == 4
        p = Program(2 * len + 2 + offset)
        prep = Step()
        for i = 1:offset
            addGate(prep, Hadamard(i))
        end

        prepAnc = Step(X(len + 2 + offset))
        addStep(p, prep)
        addStep(p, prepAnc)
        for i = offset:-1:1
            m = 1
            for j = 1:(1 << (i - 1))
                m = m * a % mod
            end
            mul = MulModulus(len + 1, 2 * len, m, mod)
            cbg = ControlledBlockGate(mul, offset + 1, i)
            addStep(p, Step(cbg))
        end
        addStep(p, Step(InvFourier(offset, 1)))
        result = runProgram(p)
        probs = getProbability(result)
        q = getQubits(result)
        amps = zeros(dim0)
        for i = 1:length(probs)
            amps[mod1(i, dim0)] += abs2(probs[i])
        end
        for i = 1:dim0
            @test amps[i] ≈ 0.25 atol = 0.001
        end
    end

    #@testset "period7_15" begin
    #    p = measurePeriod(7, 15)
    #    @show p
    #    @test 1 > 0
    #end
end
