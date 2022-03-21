
mutable struct AddInteger <: AbstractBlockGate
    block::Block
    idx::Int
    inverse::Bool
    #=
    Add the qubit in the x register and the y register, result is in x
    x_0 ----- y_0 + x_0
    x_1 ----- y+1 + x_1
     =#
    AddInteger(x0, x1, num) = new(createBlock(AddInteger, 0, x1 - x0, num), x0, false)
end

function createBlock(::Type{AddInteger}, x0, x1, num)
    m = x1 - x0 + 1
    answer = Block("AddInteger ", m)
    addStep(answer, Step(Fourier(m, 1)))
    pstep = Step()
    for i = 1:m
        mat = ComplexF64[1 0; 0 1]
        for j = 0:(m - i)
            cr0 = m - j - i
            if ((num >> cr0) & 1) == 1
                mat *= getMatrix(R(2, 1 + j, i))
            end
        end
        addGate(pstep, SingleQubitMatrixGate(i, mat))
    end
    addStep(answer, pstep)
    addStep(answer, Step(InvFourier(m, 1)))
    return answer
end

getCaption(::AddInteger) = "A\nD\nD\nI"
