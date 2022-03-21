
@testset "Rotation" begin
    @testset "rotationXTest" begin
        results = [0, 0, 0]
        for i = 1:3
            p = Program(1, Step(RotationX((π / 2) * (i - 1), 1)))
            for _ = 1:100
                res = runProgram(p)
                qubit = getQubits(res)[1]
                if measure(qubit) == 1
                    results[i] += 1
                end
            end
        end
        #@show results
        @test results[1] < 10
        @test results[2] > 30 && results[2] < 70
        @test results[3] > 90
    end

    @testset "rotationYTest" begin
        results = [0, 0, 0]
        for i = 1:3
            p = Program(1, Step(RotationY((π / 2) * (i - 1), 1)))
            for _ = 1:100
                res = runProgram(p)
                qubit = getQubits(res)[1]
                if measure(qubit) == 1
                    results[i] += 1
                end
            end
        end
        @test results[1] < 10
        @test results[2] > 30 && results[2] < 70
        @test results[3] > 90
    end

    @testset "rotationZTest" begin
        results = [0, 0]
        for i = 1:2
            p = Program(1, Step(RotationZ(π * (i - 1), 0)))
            for _ = 1:100
                res = runProgram(p)
                qubit = getQubits(res)[1]
                if measure(qubit) == 1
                    results[i] += 1
                end
            end
        end
        @test results[1] < 10
        @test results[2] < 10
    end
end
