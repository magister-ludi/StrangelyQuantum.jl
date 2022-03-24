
include("person.jl")

function prepareDatabase()
    persons = Person[]
    push!(persons, Person("Alice", 42, "Nigeria"))
    push!(persons, Person("Bob", 36, "Australia"))
    push!(persons, Person("Eve", 85, "USA"))
    push!(persons, Person("Niels", 18, "Greece"))
    push!(persons, Person("Albert", 29, "Mexico"))
    push!(persons, Person("Roger", 29, "Belgium"))
    push!(persons, Person("Marie", 15, "Russia"))
    push!(persons, Person("Janice", 52, "China"))
    return persons
end

@testset "Classic" begin
    @testset "random" begin
        z = 0
        o = 0
        for _ = 1:100
            b = Classic.randomBit()
            if b == 0
                z += 1
            elseif b == 1
                o += 1
            end
        end
        @test z > 10
        @test o > 10
    end

    @testset "s00" begin
        sum = Classic.qsum(0, 0)
        @test 0 == sum
    end

    @testset "s01" begin
        sum = Classic.qsum(0, 1)
        @test 1 == sum
    end

    @testset "s10" begin
        sum = Classic.qsum(1, 0)
        @test 1 == sum
    end

    @testset "s12" begin
        sum = Classic.qsum(1, 2)
        @test 3 == sum
    end

    @testset "s22" begin
        sum = Classic.qsum(2, 2)
        @test 0 == sum
    end

    @testset "s413" begin
        sum = Classic.qsum(4, 13)
        @test 17 == sum
    end

    @testset "quantumSearch" begin
        f29Mexico = p -> ((getAge(p) == 29) && (getCountry(p) == "Mexico")) ? 1 : 0
        for _ = 1:10
            persons = prepareDatabase()
            shuffle!(persons)
            target = Classic.search(f29Mexico, persons)
            @test getAge(target) == 29
            @test getCountry(target) == "Mexico"
        end
    end
end
