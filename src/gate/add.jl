

"""
    Add(x, x1, 0, y1)
Construct a `Gate` to add the qubit in the x register and the y register
and place the result in the x register.
"""
mutable struct Add <: AbstractBlockGate
    block::Block
    idx::Int
    inverse::Bool
    Add(x0, x1, y0, y1) = new(createBlock(Add, x0, x1, y0, y1), x0, false)
end

function createBlock(::Type{Add}, x0, x1, y0, y1)
    answer = Block("Add", y1 - x0 + 1)
    m = x1 - x0 + 1
    n = y1 - y0 + 1
    addStep(answer, Step(Fourier(m, 1)))
    for i = 1:m
        for j = 1:(1 + m - i)
            cr0 = 2 * m - j - i + 1
            if cr0 < m + n
                s = Step(Cr(i, cr0 + 1, 2, j))
                addStep(answer, s)
            end
        end
    end
    addStep(answer, Step(InvFourier(m, 1)))
    return answer
end

getCaption(::Add) = "A\nD\nD"
