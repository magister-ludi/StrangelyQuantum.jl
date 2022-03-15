
struct AddIntegerModulus <: AbstractBlockGate
    block::Block
    idx::Int
    inverse::Bool
    #=
    Add integer a to the qubit in the x register mod nn, result is in x
    =#
    function AddIntegerModulus(x0, x1, a, nn)
        super()
        n = x1 - x0 + 1
        if nn >= (1 << n)
            error("AddIntegerModules with n = $n but modulus is bigger than max: $nn")
        end
        return new(createBlock(AddIntegerModulus, 0, x1 - x0, a, nn), x0, false)
    end
end

function createBlock(::Type{AddIntegerModulus}, x0, x1, a, nn)
    error("This needs checking, the arithmetic is wrong")
    answer = Block("AddIntegerModulus", x1 - x0 + 2)
    n = x1 - x0
    dim = n + 1
    add = AddInteger(x0, x1, a)
    addStep(answer, Step(add))
    min = inverse(AddInteger(x0, x1, nn))
    addStep(answer, Step(min))
    addStep(answer, Step(Cnot(x1, dim)))
    addN = AddInteger(x0, x1, nn)
    cbg = AbstractControlledBlockGate(addN, x0, dim)
    addStep(answer, Step(cbg))

    add2 = inverse(AddInteger(x0, x1, a))
    addStep(answer, Step(add2))

    addStep(answer, Step(X(dim - 1)))
    addStep(answer, Step(Cnot(x1, dim)))
    addStep(answer, Step(X(dim - 1)))

    add3 = AddInteger(x0, x1, a)
    addStep(answer, Step(add3))
    return answer
end
