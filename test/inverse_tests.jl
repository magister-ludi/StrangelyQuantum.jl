

const Δ_Inverse = 0.000000001

#=
         |  1   1   1   1  |
F = 1/2  |  1   i  -1  -i  |
         |  1  -1   1  -1  |
         |  1  -i  -1   i  |
=#
@testset "Inverse" begin
    @testset "fourier 1000" begin
        # 00
        p = Program(2)
        f = Fourier(2, 1)
        addStep(p, Step(f))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[3]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0.5 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[3]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[4]) ≈ 0 atol = Δ_Inverse
    end

    @testset "fourier 0100" begin
        # 01
        p = Program(2)
        f = Fourier(2, 1)
        addStep(p, Step(X(1)))
        addStep(p, Step(f))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0 atol = Δ_Inverse
        @test real(probs[3]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ 0.5 atol = Δ_Inverse
        @test imag(probs[3]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[4]) ≈ -0.5 atol = Δ_Inverse
    end

    @testset "fourier 0010" begin
        # 10
        p = Program(2)
        f = Fourier(2, 1)
        addStep(p, Step(X(2)))
        addStep(p, Step(f))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[3]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[4]) ≈ -0.5 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[3]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[4]) ≈ 0 atol = Δ_Inverse
    end

    @testset "fourier 0001" begin
        # 11
        p = Program(2)
        f = Fourier(2, 1)
        addStep(p, Step(X(1), X(2)))
        addStep(p, Step(f))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0 atol = Δ_Inverse
        @test real(probs[3]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ -0.5 atol = Δ_Inverse
        @test imag(probs[3]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[4]) ≈ 0.5 atol = Δ_Inverse
    end

    @testset "invfourier 1000" begin
        # 00
        p = Program(2)
        f = inverse(Fourier(2, 1))
        addStep(p, Step(f))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[3]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0.5 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[3]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[4]) ≈ 0 atol = Δ_Inverse
    end

    @testset "invfourier 0100" begin
        # 01
        p = Program(2)
        f = inverse(Fourier(2, 1))
        addStep(p, Step(X(1)))
        addStep(p, Step(f))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0 atol = Δ_Inverse
        @test real(probs[3]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ -0.5 atol = Δ_Inverse
        @test imag(probs[3]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[4]) ≈ 0.5 atol = Δ_Inverse
    end

    @testset "invfourier 0010" begin
        # 10
        p = Program(2)
        f = inverse(Fourier(2, 1))
        addStep(p, Step(X(2)))
        addStep(p, Step(f))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[3]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[4]) ≈ -0.5 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[3]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[4]) ≈ 0 atol = Δ_Inverse
    end

    @testset "invfourier 0001" begin
        # 11
        p = Program(2)
        f = inverse(Fourier(2, 1))
        addStep(p, Step(X(1), X(2)))
        addStep(p, Step(f))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0 atol = Δ_Inverse
        @test real(probs[3]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ 0.5 atol = Δ_Inverse
        @test imag(probs[3]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[4]) ≈ -0.5 atol = Δ_Inverse
    end

    @testset "invinvfourier 0100" begin
        # 01
        p = Program(2)
        f = inverse(inverse(Fourier(2, 1)))
        addStep(p, Step(X(1)))
        addStep(p, Step(f))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0 atol = Δ_Inverse
        @test real(probs[3]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ 0.5 atol = Δ_Inverse
        @test imag(probs[3]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[4]) ≈ -0.5 atol = Δ_Inverse
    end

    @testset "fourier 3qX1" begin
        # 01
        p = Program(3)
        f = Fourier(2, 2)
        addStep(p, Step(X(2)))
        addStep(p, Step(f))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0 atol = Δ_Inverse
        @test real(probs[3]) ≈ 0 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0 atol = Δ_Inverse
        @test real(probs[5]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[6]) ≈ 0 atol = Δ_Inverse
        @test real(probs[7]) ≈ 0 atol = Δ_Inverse
        @test real(probs[8]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[3]) ≈ 0.5 atol = Δ_Inverse
        @test imag(probs[4]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[5]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[6]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[7]) ≈ -0.5 atol = Δ_Inverse
        @test imag(probs[8]) ≈ 0 atol = Δ_Inverse
    end

    @testset "fourierinv 3qX1" begin
        # 01
        p = Program(3)
        f = inverse(Fourier(2, 2))
        addStep(p, Step(X(2)))
        addStep(p, Step(f))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0 atol = Δ_Inverse
        @test real(probs[3]) ≈ 0 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0 atol = Δ_Inverse
        @test real(probs[5]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[6]) ≈ 0 atol = Δ_Inverse
        @test real(probs[7]) ≈ 0 atol = Δ_Inverse
        @test real(probs[8]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[3]) ≈ -0.5 atol = Δ_Inverse
        @test imag(probs[4]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[5]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[6]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[7]) ≈ 0.5 atol = Δ_Inverse
        @test imag(probs[8]) ≈ 0 atol = Δ_Inverse
    end

    @testset "block 3Qx1" begin
        p = Program(3)
        block = Block("myfourier", 2)
        addStep(block, Step(Fourier(2, 1)))
        bg = BlockGate(block, 2)
        addStep(p, Step(X(2)))
        addStep(p, Step(bg))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0 atol = Δ_Inverse
        @test real(probs[3]) ≈ 0 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0 atol = Δ_Inverse
        @test real(probs[5]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[6]) ≈ 0 atol = Δ_Inverse
        @test real(probs[7]) ≈ 0 atol = Δ_Inverse
        @test real(probs[8]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[3]) ≈ 0.5 atol = Δ_Inverse
        @test imag(probs[4]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[5]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[6]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[7]) ≈ -0.5 atol = Δ_Inverse
        @test imag(probs[8]) ≈ 0 atol = Δ_Inverse
    end

    @testset "blockinv 3qX1" begin
        p = Program(3)
        block = Block("myfourier", 2)
        addStep(block, Step(inverse(Fourier(2, 1))))
        bg = BlockGate(block, 2)
        addStep(p, Step(X(2)))
        addStep(p, Step(bg))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0 atol = Δ_Inverse
        @test real(probs[3]) ≈ 0 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0 atol = Δ_Inverse
        @test real(probs[5]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[6]) ≈ 0 atol = Δ_Inverse
        @test real(probs[7]) ≈ 0 atol = Δ_Inverse
        @test real(probs[8]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[3]) ≈ -0.5 atol = Δ_Inverse
        @test imag(probs[4]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[5]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[6]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[7]) ≈ 0.5 atol = Δ_Inverse
        @test imag(probs[8]) ≈ 0 atol = Δ_Inverse
    end

    @testset "blockinvgate 3qX1" begin
        p = Program(3)
        block = Block("myfourier", 2)
        addStep(block, Step(Fourier(2, 1)))
        bg = inverse(BlockGate(block, 2))
        addStep(p, Step(X(2)))
        addStep(p, Step(bg))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0 atol = Δ_Inverse
        @test real(probs[3]) ≈ 0 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0 atol = Δ_Inverse
        @test real(probs[5]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[6]) ≈ 0 atol = Δ_Inverse
        @test real(probs[7]) ≈ 0 atol = Δ_Inverse
        @test real(probs[8]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[3]) ≈ -0.5 atol = Δ_Inverse
        @test imag(probs[4]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[5]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[6]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[7]) ≈ 0.5 atol = Δ_Inverse
        @test imag(probs[8]) ≈ 0 atol = Δ_Inverse
    end

    @testset "fourier 3qX2" begin
        # 01
        p = Program(3)
        f = Fourier(2, 2)
        addStep(p, Step(X(3)))
        addStep(p, Step(f))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0 atol = Δ_Inverse
        @test real(probs[3]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0 atol = Δ_Inverse
        @test real(probs[5]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[6]) ≈ 0 atol = Δ_Inverse
        @test real(probs[7]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[8]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[3]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[4]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[5]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[6]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[7]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[8]) ≈ 0 atol = Δ_Inverse
    end

    @testset "fourierinv 3qX2" begin
        # 01
        p = Program(3)
        f = Fourier(2, 1)
        addStep(p, Step(X(1), X(3)))
        addStep(p, Step(X(3), inverse(f)))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0 atol = Δ_Inverse
        @test real(probs[3]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0 atol = Δ_Inverse
        @test real(probs[5]) ≈ 0 atol = Δ_Inverse
        @test real(probs[6]) ≈ 0 atol = Δ_Inverse
        @test real(probs[7]) ≈ 0 atol = Δ_Inverse
        @test real(probs[8]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ -0.5 atol = Δ_Inverse
        @test imag(probs[3]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[4]) ≈ 0.5 atol = Δ_Inverse
        @test imag(probs[5]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[6]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[7]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[8]) ≈ 0 atol = Δ_Inverse
    end

    @testset "blockinvgate 3qX2" begin
        p = Program(3)
        block = Block("myfourier", 2)
        addStep(block, Step(Fourier(2, 1)))
        bg = inverse(BlockGate(block, 2))
        addStep(p, Step(X(1), X(2)))
        addStep(p, Step(bg))
        addStep(p, Step(X(1)))
        result = runProgram(p)
        probs = getProbability(result)
        @test real(probs[1]) ≈ 0.5 atol = Δ_Inverse
        @test real(probs[2]) ≈ 0 atol = Δ_Inverse
        @test real(probs[3]) ≈ 0 atol = Δ_Inverse
        @test real(probs[4]) ≈ 0 atol = Δ_Inverse
        @test real(probs[5]) ≈ -0.5 atol = Δ_Inverse
        @test real(probs[6]) ≈ 0 atol = Δ_Inverse
        @test real(probs[7]) ≈ 0 atol = Δ_Inverse
        @test real(probs[8]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[1]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[2]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[3]) ≈ -0.5 atol = Δ_Inverse
        @test imag(probs[4]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[5]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[6]) ≈ 0 atol = Δ_Inverse
        @test imag(probs[7]) ≈ 0.5 atol = Δ_Inverse
        @test imag(probs[8]) ≈ 0 atol = Δ_Inverse
    end
end
