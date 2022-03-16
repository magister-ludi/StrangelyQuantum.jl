
const Δ_Fourier = 0.000001

@testset "Fourier" begin
    @testset "create Fourier 1" begin
        f = Fourier(1, 1)
        den = 1 / sqrt(2)
        a = getMatrix(f)
        @test (2, 2) == size(a)
        val = a[1, 1]
        @test imag(val) == 0
        @test real(val) ≈ den atol = Δ_Fourier
        val = a[2, 1]
        @test imag(val) == 0
        @test real(val) ≈ den atol = Δ_Fourier
        val = a[1, 2]
        @test imag(val) == 0
        @test real(val) ≈ den atol = Δ_Fourier
        val = a[2, 2]
        @test imag(val) ≈ 0 atol = Δ_Fourier
        @test real(val) ≈ -den atol = Δ_Fourier
    end

    @testset "create Fourier 2" begin
        f = Fourier(2, 1)
        a = getMatrix(f)
        @test (4, 4) == size(a)
        val = a[1, 1]
        @test imag(val) == 0
        @test real(val) == 1 / 2
        val = a[1, 2]
        @test imag(val) == 0
        @test real(val) == 1 / 2
        val = a[1, 3]
        @test imag(val) == 0
        @test real(val) == 1 / 2
        val = a[1, 4]
        @test imag(val) == 0
        @test real(val) == 1 / 2
        val = a[2, 1]
        @test imag(val) == 0
        @test real(val) == 1 / 2
        val = a[2, 2]
        @test imag(val) ≈ 1 / 2 atol = Δ_Fourier
        @test real(val) ≈ 0 atol = Δ_Fourier
        val = a[2, 3]
        @test imag(val) ≈ 0 atol = Δ_Fourier
        @test real(val) ≈ -1 / 2 atol = Δ_Fourier
        val = a[2, 4]
        @test imag(val) ≈ -1 / 2 atol = Δ_Fourier
        @test real(val) ≈ 0 atol = Δ_Fourier
        val = a[3, 1]
        @test imag(val) ≈ 0 atol = Δ_Fourier
        @test real(val) ≈ 1 / 2 atol = Δ_Fourier
        val = a[3, 2]
        @test imag(val) ≈ 0 atol = Δ_Fourier
        @test real(val) ≈ -1 / 2 atol = Δ_Fourier
        val = a[3, 3]
        @test imag(val) ≈ 0 atol = Δ_Fourier
        @test real(val) ≈ 1 / 2 atol = Δ_Fourier
        val = a[3, 4]
        @test imag(val) ≈ 0 atol = Δ_Fourier
        @test real(val) ≈ -1 / 2 atol = Δ_Fourier
        val = a[4, 1]
        @test imag(val) ≈ 0 atol = Δ_Fourier
        @test real(val) ≈ 1 / 2 atol = Δ_Fourier
        val = a[4, 2]
        @test imag(val) ≈ -1 / 2 atol = Δ_Fourier
        @test real(val) ≈ 0 atol = Δ_Fourier
        val = a[4, 3]
        @test imag(val) ≈ 0 atol = Δ_Fourier
        @test real(val) ≈ -1 / 2 atol = Δ_Fourier
        val = a[4, 4]
        @test imag(val) ≈ 1 / 2 atol = Δ_Fourier
        @test real(val) ≈ 0 atol = Δ_Fourier
    end

    @testset "fourier 1 Program" begin
        p = Program(1, Step(Fourier(1, 1)))
        res = runProgram(p)
        probability = getProbability(res)
        @test 2 == length(probability)
        @test 0.5 ≈ abs2(probability[1]) atol = Δ_Fourier
        @test 0.5 ≈ abs2(probability[2]) atol = Δ_Fourier
    end

    @testset "fourier 2 Program" begin
        p = Program(2, Step(Fourier(1, 1)))
        res = runProgram(p)
        probability = getProbability(res)
        @test 4 == length(probability)
        @test 0.5 ≈ abs2(probability[1]) atol = Δ_Fourier
        @test 0.5 ≈ abs2(probability[2]) atol = Δ_Fourier
        @test 0.0 ≈ abs2(probability[3]) atol = Δ_Fourier
        @test 0.0 ≈ abs2(probability[4]) atol = Δ_Fourier
    end

    @testset "invFourier Program" begin
        prep = Step(X(2))
        p = Program(2, prep, Step(Fourier(2, 1)), Step(InvFourier(2, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 0 == measure(qubits[1])
        @test 1 == measure(qubits[2])
    end

    @testset "invFourierPartProgram" begin
        prep = Step(X(2))
        p = Program(3, prep, Step(Fourier(2, 1)), Step(InvFourier(2, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 0 == measure(qubits[1])
        @test 1 == measure(qubits[2])
    end

    # additions with 1 + 1 qubit
    # result in q0
    @testset "fourier addition 00" begin
        p = Program(2, Step(Fourier(1, 1)), Step(Cr(1, 2, 2, 1)), Step(InvFourier(1, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
    end

    @testset "fourier addition 01" begin
        prep = Step(X(2))
        p = Program(2, prep, Step(Fourier(1, 1)), Step(Cr(1, 2, 2, 1)), Step(InvFourier(1, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 1 == measure(qubits[1])
        @test 1 == measure(qubits[2])
    end

    @testset "fourier addition 10" begin
        prep = Step(X(1))
        p = Program(2, prep, Step(Fourier(1, 1)), Step(Cr(1, 2, 2, 1)), Step(InvFourier(1, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 1 == measure(qubits[1])
        @test 0 == measure(qubits[2])
    end

    @testset "fourier addition 11" begin
        prep = Step(X(1), X(2))
        p = Program(2, prep, Step(Fourier(1, 1)), Step(Cr(1, 2, 2, 1)), Step(InvFourier(1, 1)))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 0 == measure(qubits[1])
        @test 1 == measure(qubits[2])
    end

    @testset "fourier addition 0000" begin
        p = Program(
            4,
            Step(Fourier(2, 1)),
            Step(Cr(2, 4, 2, 1)),
            Step(Cr(2, 3, 2, 2)),
            Step(Cr(1, 3, 2, 1)),
            Step(InvFourier(2, 1)),
        )
        res = runProgram(p)
        qubits = getQubits(res)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
        @test 0 == measure(qubits[3])
        @test 0 == measure(qubits[4])
    end

    #     0101 -> 0110
    @testset "fourier addition 0101" begin
        prep = Step(X(1), X(3))
        p = Program(
            4,
            prep,
            Step(Fourier(2, 1)),
            Step(Cr(1, 4, 2, 1)),
            Step(Cr(1, 3, 2, 2)),
            Step(Cr(2, 3, 2, 1)),
            Step(InvFourier(2, 1)),
        )
        res = runProgram(p)
        probability = getProbability(res)
        @test 16 == length(probability)
        for (i, p) in enumerate(probability)
            @test real(p) ≈ (i == 7 ? 1 : 0) atol = Δ_Fourier
            @test imag(p) ≈ 0 atol = Δ_Fourier
        end
        qubits = getQubits(res)
        @test 0 == measure(qubits[1])
        @test 1 == measure(qubits[2])
        @test 1 == measure(qubits[3])
        @test 0 == measure(qubits[4])
    end

    #     1010 -> 0010
    @testset "fourier addition 1010" begin
        prep = Step(X(2), X(4))
        p = Program(
            4,
            prep,
            Step(Fourier(2, 1)),
            Step(Cr(1, 4, 2, 1)),
            Step(Cr(1, 3, 2, 2)),
            Step(Cr(2, 3, 2, 1)),
            Step(InvFourier(2, 1)),
        )
        res = runProgram(p)
        probability = getProbability(res)
        @test 16 == length(probability)
        for (i, p) in enumerate(probability)
            @test real(p) ≈ (i == 9 ? 1 : 0) atol = Δ_Fourier
            @test imag(p) ≈ 0 atol = Δ_Fourier
        end
        qubits = getQubits(res)
        @test 0 == measure(qubits[1])
        @test 0 == measure(qubits[2])
        @test 0 == measure(qubits[3])
        @test 1 == measure(qubits[4])
    end

    # 0011 -> 1111
    @testset "fourier addition 0011" begin
        prep = Step(X(3), X(4))
        p = Program(
            4,
            prep,
            Step(Fourier(2, 1)),
            Step(Cr(2, 3, 2, 1)),
            Step(Cr(1, 3, 2, 2)),
            Step(Cr(1, 4, 2, 1)),
            Step(InvFourier(2, 1)),
        )
        res = runProgram(p)
        probability = getProbability(res)
        @test 16 == length(probability)
        for (i, p) in enumerate(probability)
            @test real(p) ≈ (i == 16 ? 1 : 0) atol = Δ_Fourier
            @test imag(p) ≈ 0 atol = Δ_Fourier
        end
        qubits = getQubits(res)
        @test 1 == measure(qubits[1])
        @test 1 == measure(qubits[2])
        @test 1 == measure(qubits[3])
        @test 1 == measure(qubits[4])
    end
end
