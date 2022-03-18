
@testset "Oracle" begin
    @testset "create Oracle Matrix" begin
        matrix = ComplexF64[1 0; 0 1]
        oracle = Oracle(matrix)
        @test true  # Proof that we got this far...
    end

    @testset "identity Oracle" begin
        matrix = ComplexF64[1 0; 0 1]
        oracle = Oracle(matrix)
        p = Program(1, Step(oracle))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 0 == measure(qubits[1])
    end

    @testset "not Oracle" begin
        matrix = ComplexF64[0 1; 1 0]
        oracle = Oracle(matrix)
        p = Program(1, Step(oracle))
        res = runProgram(p)
        qubits = getQubits(res)
        @test 1 == measure(qubits[1])
    end
end
