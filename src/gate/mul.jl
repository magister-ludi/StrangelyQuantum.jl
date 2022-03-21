
struct Mul <: AbstractBlockGate
    block::Block
    idx::Int
    inverse::Bool
    #=
    Multiply the qubit in the x register with an integer mul
    x_0 ----- y_0 + x_0
    x_1 ----- y+1 + x_1
    y_0 ----- 0
    y_1 ----- 0
    =#
    Mul(x0, x1, mul) = new(createBlock(Mul, x0, x1, mul), x0, false)
end

function createBlock(::Type{Mul}, x0, x1, mul)
    x1 -= x0 - 1
    x0 = 1
    size = 1 + x1 - x0
    dim = 1 << size
    answer = Block("Mul", 2 * size)
    for i = 1:mul
        add = Add(x0, x1, x1 + 1, x1 + size)
        addStep(answer, Step(add))
    end
    for i = x0:x1
        addStep(answer, Step(Swap(i, i + size)))
    end
    invsteps = getInverseModulus(mul, dim)
    for i = 1:invsteps
        add = inverse(Add(x0, x1, x1 + 1, x1 + size))
        addStep(answer, Step(add))
    end
    return answer
end
