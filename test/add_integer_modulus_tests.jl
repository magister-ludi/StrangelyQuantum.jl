
@testset "AddIntegerModulus" begin
    @testset "testModLimit" begin
        # modulus should be smaller than 2^n
        a0 = AddIntegerModulus(1, 1, 1, 1)
        a1 = AddIntegerModulus(1, 2, 1, 1)
        a2 = AddIntegerModulus(1, 2, 1, 2)
        a3 = AddIntegerModulus(1, 2, 1, 3)
        @test_throws ErrorException a4 = AddIntegerModulus(1, 1, 1, 2)
        @test_throws ErrorException a5 = AddIntegerModulus(1, 2, 1, 4)
    end

    @testset "add1p1m3" begin
        # 1 + 1 mod 3 = 2
        add = 1
        mod = 3
        p = Program(4)
        prep = Step()
        addGates(prep, X(1))  #1
        addStep(p, prep)
        aim = AddIntegerModulus(1, 2, add, mod)
        addStep(p, Step(aim))
        result = runProgram(p)
        q = getQubits(result)
        @test 4 == length(q)
        @test 0 == measure(q[1])
        @test 1 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
    end

    @testset "add2p1m3" begin
        # 2 + 1 mod 3 = 0
        add = 1
        mod = 3
        p = Program(4)
        prep = Step()
        addGates(prep, X(2))  # 2
        addStep(p, prep)
        aim = AddIntegerModulus(1, 2, add, mod)
        addStep(p, Step(aim))
        result = runProgram(p)
        q = getQubits(result)
        @test 4 == length(q)
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
    end

    @testset "min2m1m3" begin
        # 2 - 1 mod 3 = 1
        add = 1
        mod = 3
        p = Program(4)
        prep = Step()
        addGates(prep, X(2))  # 2
        addStep(p, prep)
        aim = inverse(AddIntegerModulus(1, 2, add, mod))
        addStep(p, Step(aim))
        result = runProgram(p)
        q = getQubits(result)
        @test 4 == length(q)
        @test 1 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
    end

    @testset "min1m1m3" begin
        # 1 - 1 mod 3 = 0
        add = 1
        mod = 3
        p = Program(4)
        prep = Step()
        addGates(prep, X(1))  # 1
        addStep(p, prep)
        aim = inverse(AddIntegerModulus(1, 2, add, mod))
        addStep(p, Step(aim))
        result = runProgram(p)
        q = getQubits(result)
        @test 4 == length(q)
        @test 0 == measure(q[1])
        @test 0 == measure(q[2])
        @test 0 == measure(q[3])
        @test 0 == measure(q[4])
    end
end
