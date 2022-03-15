
@testset "ThreeQubitGate" begin

    @testset "ToffoliGate0" begin
        # |000> . |000>
        p = Program(3, Step(Toffoli(3, 2, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
        @test 0 == measure(qubits[3])
    end

    @testset "ToffoliGate1" begin
        # |100> . |100>
        p = Program(3, Step(X(3)), Step(Toffoli(3, 2, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
        @test 1 == measure(qubits[3])
    end

    @testset "ToffoliGate2" begin
        # |110> . |111>
        p = Program(3, Step(X(3), X(2)), Step(Toffoli(3, 2, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 1 == measure(qubits[1])
        @test 1 == measure(qubits[2])
        @test 1 == measure(qubits[3])
    end

    @testset "ToffoliGate3" begin
        # |111> . |110>
        p = Program(3, Step(X(3), X(2), X(1)), Step(Toffoli(3, 2, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 1 == measure(qubits[2])
        @test 1 == measure(qubits[3])
    end

    @testset "ToffoliGate4" begin
        # |001> . |001>
        p = Program(3, Step(X(1)), Step(Toffoli(3, 2, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 1 == measure(qubits[1])
        @test 0 == measure(qubits[2])
        @test 0 == measure(qubits[3])
    end

    @testset "ToffoliGateR0" begin
        # |000> . |000>
        p = Program(3, Step(Toffoli(3, 2, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
        @test 0 == measure(qubits[3])
    end

    @testset "ToffoliGateR1" begin
        # |100> . |100>
        p = Program(3, Step(X(3)), Step(Toffoli(3, 2, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
        @test 1 == measure(qubits[3])
    end

    @testset "ToffoliGateR2" begin
        # |011> . |111>
        p = Program(3, Step(X(1), X(2)), Step(Toffoli(1, 2, 3)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 3 == length(qubits)
        @test 1 == measure(qubits[1])
        @test 1 == measure(qubits[2])
        @test 1 == measure(qubits[3])
    end

    @testset "ToffoliGateR3" begin
        # |110> . |111>
        p = Program(4, Step(X(3), X(4)), Step(Toffoli(4, 3, 2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 4 == length(qubits)
        @test 0 == measure(qubits[1])
        @test 1 == measure(qubits[2])
        @test 1 == measure(qubits[3])
        @test 1 == measure(qubits[4])
    end

    @testset "ToffoliGateR4" begin
        # |1100> . |1101>
        p = Program(4, Step(X(3), X(4)), Step(Toffoli(4, 3, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 4 == length(qubits)
        @test 1 == measure(qubits[1])
        @test 0 == measure(qubits[2])
        @test 1 == measure(qubits[3])
        @test 1 == measure(qubits[4])
    end

    @testset "ToffoliGateS2" begin
        # |0101> . |1101>
        p = Program(4, Step(X(1), X(3)), Step(Toffoli(1, 3, 4)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 4 == length(qubits)
        @test 1 == measure(qubits[1])
        @test 0 == measure(qubits[2])
        @test 1 == measure(qubits[3])
        @test 1 == measure(qubits[4])
    end
end
