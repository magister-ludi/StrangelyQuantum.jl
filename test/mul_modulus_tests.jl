
@testset "MulModulus" begin
    @testset "mul2x5mod3" begin
        # 2 x 5 mod 3 = 1
        p = Program(6)
        mul = 5
        nn = 3
        prep = Step()
        addGates(prep, X(2))  # 2
        s = Step(MulModulus(1, 2, mul, nn))
        addStep(p, prep)
        addStep(p, s)
        result = runProgram(p)
        q = getQubits(result)

        @test 6 == length(q)
        @test 1 == measure(q[1])  # 1
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])  # clean from here on
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])
        @test 0 == measure(q[6])

    end

    @testset "mul3x5mod6" begin
        # 3 x 5 mod 6 = 3
        p = Program(8)
        mul = 5
        nn = 6
        prep = Step()
        addGates(prep, X(1), X(2))  # 3 in high register
        s = Step(MulModulus(1, 3, mul, nn))
        addStep(p, prep)
        addStep(p, s)
        result = runProgram(p)
        q = getQubits(result)

        @test 8 == length(q)
        @test 1 == measure(q[1])  # q2,q1,q0,q3 should be clean
        @test 1 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
        @test 0 == measure(q[5])  # result in q4,q5,q6,q7
        @test 0 == measure(q[6])
        @test 0 == measure(q[7])
        @test 0 == measure(q[8])
    end
end
