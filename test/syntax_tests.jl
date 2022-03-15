
@testset "Syntax Tests" begin

    @testset "simple I Gate" begin
        p = Program(1)
        s = Step(Identity(1))
        @test_throws ErrorException addGate(s, Hadamard(1))
    end

    @testset "add Double Gates" begin
        p = Program(1)
        s = Step(Identity(1))
        @test_throws ErrorException addGate(s, Identity(1))
    end

    @testset "Named Step" begin
        s0 = Step("Hello!")
        s1 = Step("foo", Identity(1))
        s2 = Step(Identity(1), Identity(2))
        # The test will execute if no exception has been thrown
        @test true
    end

    @testset "permutation" begin
        dim = 4
        a = [(i - 1) * dim + j for i = 1:dim, j = 1:dim]

        @test a[1, 1] == 1
        @test a[1, 2] == 2
        @test a[1, 3] == 3
        @test a[2, 1] == 5
        @test a[2, 2] == 6
        @test a[2, 3] == 7

        pg = PermutationGate(1, 2, 3)
        res = permutate(pg, a)

        @test res[1, 1] == 1
        @test res[1, 2] == 3
        @test res[1, 3] == 2
        @test res[2, 1] == 5
        @test res[2, 2] == 7
        @test res[2, 3] == 6
    end
end
