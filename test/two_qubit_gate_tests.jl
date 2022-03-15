
@testset "TwoQubitGate" begin

    @testset "double I Gate" begin
        p = Program(2, Step(Identity(1), Identity(2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 2 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
    end

    @testset "swapGate 11" begin
        p = Program(2, Step(Identity(1), Identity(2)), Step(Swap(1, 2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 2 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
    end

    @testset "swapGate 12" begin
        p = Program(2, Step(Identity(1), X(2)), Step(Swap(1, 2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 2 == length(qubits)
        @test 1 == measure(qubits[1])
        @test 0 == measure(qubits[2])
    end

    @testset "swapGate 21" begin
        p = Program(2, Step(Identity(2), X(1)), Step(Swap(1, 2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 2 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 1 == measure(qubits[2])
    end

    @testset "swapGate 22" begin
        p = Program(2, Step(X(1), X(2)), Step(Swap(1, 2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 2 == length(qubits)
        @test 1 == measure(qubits[1])
        @test 1 == measure(qubits[2])
    end

    @testset "swapGate 123" begin
        p = Program(3, Step(X(1)), Step(Swap(1, 2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 1 == measure(qubits[2])
        @test 0 == measure(qubits[3])
    end

    @testset "swapGate 233" begin
        p = Program(3, Step(X(2)), Step(Swap(2, 3)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
        @test 1 == measure(qubits[3])
    end

    @testset "swapGate 133" begin
        p = Program(3, Step(X(1)), Step(Swap(1, 3)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
        @test 1 == measure(qubits[3])
    end

    @testset "swapGate 313" begin
        p = Program(3, Step(X(1)), Step(Swap(3, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
        @test 1 == measure(qubits[3])
    end

    @testset "cnot 12" begin
        p = Program(2, Step(Cnot(1, 2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 2 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
    end

    @testset "cnot_x_12" begin
        p = Program(2, Step(X(1)), Step(Cnot(1, 2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 2 == length(qubits)
        @test 1 == measure(qubits[1])
        @test 1 == measure(qubits[2])
    end

    @testset "cnot_x_21" begin
        p = Program(2, Step(X(2)), Step(Cnot(2, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 2 == length(qubits)
        @test 1 == measure(qubits[1])
        @test 1 == measure(qubits[2])
    end

    @testset "cnot_x_13" begin
        p = Program(3, Step(X(1)), Step(Cnot(1, 3)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 1 == measure(qubits[1])
        @test 0 == measure(qubits[2])
        @test 1 == measure(qubits[3])
    end

    @testset "cnot_x_31" begin
        p = Program(3, Step(X(3)), Step(Cnot(3, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 1 == measure(qubits[1])
        @test 0 == measure(qubits[2])
        @test 1 == measure(qubits[3])
    end

    @testset "cnot_x_32" begin
        p = Program(3, Step(X(3)), Step(Cnot(3, 2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 1 == measure(qubits[2])
        @test 1 == measure(qubits[3])
    end

    @testset "cz_12" begin
        p = Program(2, Step(Cz(1, 2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 2 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
    end

    @testset "cz_x_12" begin
        p = Program(2, Step(X(1)), Step(Cz(1, 2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 2 == length(qubits)
        @test 1 == measure(qubits[1])
        @test 0 == measure(qubits[2])
    end

    @testset "cz_xx_12" begin
        p = Program(2, Step(X(1), X(2)), Step(Cz(1, 2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 2 == length(qubits)
        @test 1 == measure(qubits[1])
        @test 1 == measure(qubits[2])
    end

    @testset "IMcnot21" begin
        p = Program(2, Step(Identity(1)), Step(Measurement(1)))
        @test_throws ErrorException addStep(p, Step(Cnot(2, 1)))
    end

    @testset "IMcnot" begin
        p = Program(2, Step(Identity(1)), Step(Measurement(1)), Step(Cnot(1, 2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 2 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
    end
end
