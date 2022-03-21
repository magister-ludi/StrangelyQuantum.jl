
@testset "Bell State" begin
    @testset "hcnot01" begin
        p = Program(2, Step(Hadamard(1)), Step(Cnot(1, 2)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 2 == length(qubits)
        q0 = measure(qubits[1])
        q1 = measure(qubits[2])
        @test q0 == q1
    end

    #=
    When making multiple measurements on the same Result object, we
    should be able to see different outcomes (0-0 or 1-1)
    =#
    @testset "multimeasurement" begin
        p = Program(2, Step(Hadamard(1)), Step(Cnot(1, 2)))
        res = runProgram(p)
        zeroCount = 0
        RUNS = 100
        for i = 1:RUNS
            measureSystem(res)
            qubits = getQubits(res)
            q0 = measure(qubits[1])
            q1 = measure(qubits[2])
            @test q0 == q1
            if q0 == 0
                zeroCount += 1
            end
        end
        @test zeroCount > 0
        @test zeroCount < RUNS
    end

    #=
    Bell State with a third qubit that is sent through an H gate
    =#
    @testset "cnotH" begin
        p = Program(3, Step(Hadamard(1)), Step(Cnot(1, 2)), Step(Hadamard(3)))
        res = runProgram(p)
        zeroCount = 0
        q2count0 = 0
        RUNS = 100
        for i = 1:RUNS
            measureSystem(res)
            qubits = getQubits(res)
            q0 = measure(qubits[1])
            q1 = measure(qubits[2])
            q2 = measure(qubits[3])
            @test q0 == q1
            if q0 == 0
                zeroCount += 1
            end
            if q2 == 0
                q2count0 += 1
            end
        end
        @test zeroCount > 0
        @test zeroCount < RUNS
        @test q2count0 > 0
        @test q2count0 < RUNS
    end
end
