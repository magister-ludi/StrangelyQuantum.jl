
"""
    AddIntegerModulus(x0, x1, a, n)
Create a `Gate` computes `(a+x) % n`, where `x` register
is the content of register x. The result is placed in register x
"""
mutable struct AddIntegerModulus <: AbstractBlockGate
    block::Block
    idx::Int
    inverse::Bool
    function AddIntegerModulus(x0, x1, a, nn)
        n = x1 - x0 + 1
        if nn >= (1 << n)
            error("AddIntegerModules with n = $n but modulus is bigger than max: $nn")
        end
        return new(createBlock(AddIntegerModulus, x0, x1, a, nn), x0, false)
    end
end

function createBlock(::Type{AddIntegerModulus}, x0, x1, a, nn)
    answer = Block("AddIntegerModulus", x1 - x0 + 2)
    n = x1 - x0
    dim = n + 1
    add = AddInteger(x0, x1, a)
    addStep(answer, Step(add))
    min = inverse(AddInteger(x0, x1, nn))
    addStep(answer, Step(min))
    addStep(answer, Step(Cnot(x1, dim + 1)))
    addN = AddInteger(x0, x1, nn)
    cbg = ControlledBlockGate(addN, x0, dim + 1)
    addStep(answer, Step(cbg))

    add2 = inverse(AddInteger(x0, x1, a))
    addStep(answer, Step(add2))

    addStep(answer, Step(X(dim)))
    addStep(answer, Step(Cnot(x1, dim + 1)))
    addStep(answer, Step(X(dim)))

    add3 = AddInteger(x0, x1, a)
    addStep(answer, Step(add3))
    return answer
end
