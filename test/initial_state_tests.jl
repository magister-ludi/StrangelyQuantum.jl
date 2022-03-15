
@testset "Initial State" begin

    @testset "don't Initialize" begin
        p = Program(1, Step(Identity(1)))
        res = runProgram(p)
        qubits = getQubits(res)
        #@show qubits
        @test 0 == measure(qubits[1])
    end

    @testset "no Step" begin
        p = Program(0)
        res = runProgram(p)
        @test 0 == length(getQubits(res))
    end

    @testset "initialize 0" begin
        p = Program(1, Step(Identity(1)))
        initializeQubit(p, 1, 1)
        res = runProgram(p)
        qubits = getQubits(res)
        @test 0 == measure(qubits[1])
    end

    @testset "initialize 1" begin
        p = Program(1, Step(Identity(1)))
        initializeQubit(p, 1, 0)
        res = runProgram(p)
        qubits = getQubits(res)
        @test 1 == measure(qubits[1])
    end

    @testset "initialize 1 Not" begin
        p = Program(1, Step(X(1)))
        initializeQubit(p, 1, 0)
        res = runProgram(p)
        qubits = getQubits(res)
        @test 0 == measure(qubits[1])
    end

    # 2 qubits, initally 1. Flip the first one, keep the second
    @testset "TwoQubit initialize 1 Not" begin
        p = Program(2, Step(X(1)))
        initializeQubit(p, 1, 0)
        initializeQubit(p, 2, 0)
        res = runProgram(p)
        qubits = getQubits(res)
        @test 0 == measure(qubits[1])
        @test 1 == measure(qubits[2])
    end

    # 1 qubit, 50% change 0 or 1, should at least be once 0 and once 1 in 100 tries
    @testset "initialize Fifty" begin
        p = Program(1, Step(Identity(1)))
        sq = sqrt(0.5)
        initializeQubit(p, 1, sq)
        cnt = 0
        got0 = false
        got1 = false
        i = 0
        while i < 100 && !(got0 && got1)
            res = runProgram(p)
            qubits = getQubits(res)
            q1 = measure(qubits[1])
            if q1 == 0
                got0 = true
            end
            if q1 == 1
                got1 = true
            end
            i += 1
        end
        @test got0
        @test got1
    end

    # 1 qubit, 10% change 0, should be more 1 than 0 in 100 tries
    @testset "initializeLowHigh" begin
        p = Program(1, Step(Identity(1)))
        sq = sqrt(0.1)
        initializeQubit(p, 1, sq)

        for c = 1:10
            cnt0 = 0
            cnt1 = 1
            for _ = 1:100
                res = runProgram(p)
                qubits = getQubits(res)
                q1 = measure(qubits[1])
                if q1 == 0
                    cnt0 += 1
                end
                if q1 == 1
                    cnt1 += 1
                end
            end
            @test cnt1 > cnt0
        end
    end
end
