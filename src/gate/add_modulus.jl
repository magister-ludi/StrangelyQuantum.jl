
struct AddModulus <: AbstractBlockGate
    block::Block
    idx::Int
    inverse::Bool
    #=
    Add the qubit in the x register and the y register mod nn, result is in x
    x_0 ----- y_0 + x_0
    x_1 ----- y+1 + x_1
    y_0 ----- y_0
    y_1 ----- y_1
    ANC(0)--- ANC(0)
    the qubit following y_1 should be 0 (and will be 0 after this gate)
    qubit at x_1 should be 0 and qubit at y_1 should be 0 (overflow)
    =#
    function AddModulus(x0, x1, y0, y1, nn)
        #y1 = y1 - x0
        #y0 = y0 - x0
        #x1 = x1 - x0
        #x0 = 0
        @assert y0 == x1 + 1
        return new(createBlock(AddModulus, 0, x1 - x0, y0 - x0, y1 - x0, nn), x0, false)
    end
end

function createBlock(::Type{AddModulus}, x0, x1, y0, y1, nn)
    error("Indices used in this function are wrong!")
    answer = Block("AddModulus", y1 - x0 + 2)
    n = x1 - x0
    dim = 2 * (n + 1) + 1

    add = Add(x0, x1, y0, y1)
    addStep(answer, Step(add))

    min = inverse(AddInteger(x0, x1, nn))
    addStep(answer, Step(min))
    addStep(answer, Step(Cnot(x1, dim - 1)))
    addN = AddInteger(x0, x1, nn)
    cbg = AbstractControlledBlockGate(addN, x0, dim - 1)
    addStep(answer, Step(cbg))

    add2 = inverse(Add(x0, x1, y0, y1))
    addStep(answer, Step(add2))
    addStep(answer, Step(X(dim - 1)))

    block = Block(2)
    addStep(block, Step(X(0)))
    cbg2 = AbstractControlledBlockGate(block, dim - 1, x1)
    addStep(answer, Step(cbg2))

    add3 = Add(x0, x1, y0, y1)
    addStep(answer, Step(add3))

    return answer
end

getCaption(::AddModulus) = "A\nD\nD\n"
