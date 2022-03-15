
@testset "SingleQubitGate" begin

    @testset "simple I Gate" begin
        p = Program(1, Step(Identity(1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 0 == measure(qubits[1])
    end

    @testset "simple X Gate" begin
        p = Program(1, Step(X(1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 1 == measure(qubits[1])
    end

    @testset "simple IX Gate" begin
        p = Program(2, Step(X(1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 1 == measure(qubits[1])
    end

    @testset "simple XI Gate" begin
        p = Program(2, Step(X(2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 1 == measure(qubits[2])
    end

    @testset "simple XII Gate" begin
        p = Program(3, Step(X(3)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 1 == measure(qubits[3])
    end

    @testset "simple Y Gate" begin
        p = Program(1, Step(Y(1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 1 == measure(qubits[1])
    end

    @testset "simple Z Gate" begin
        p = Program(1, Step(Z(1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 0 == measure(qubits[1])
    end

    @testset "simple H Gate" begin
        results = [0, 0]
        for _ = 1:100
            p = Program(1, Step(Hadamard(1)))
            res = runProgram(p)
            qubits = getQubits(res)
            results[1 + measure(qubits[1])] += 1
        end
        @test results[1] > 10
        @test results[2] > 10
    end

    @testset "simple Together Gate" begin
        p = Program(4, Step(X(1), Y(2), Z(3), Identity(4)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 1 == measure(qubits[1])
        @test 1 == measure(qubits[2])
        @test 0 == measure(qubits[3])
        @test 0 == measure(qubits[4])
    end

    @testset "simple IM" begin
        p = Program(1, Step(Identity(1)), Step(Measurement(1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 0 == measure(qubits[1])
    end

    @testset "simple XM" begin
        p = Program(1, Step(X(1)), Step(Measurement(1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 1 == measure(qubits[1])
    end

    @testset "simple XMH" begin
        p = Program(1, Step(X(1)), Step(Measurement(1)))
        @test_throws ErrorException addStep(p, Step(Hadamard(1)))
    end
end
