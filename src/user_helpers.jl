tern2cart(a, b, c) = (1 / 2 * (2b + c) / (a + b + c), √3 / 2 * (c / (a + b + c)))
tern2cart(vec) = tern2cart(vec[1], vec[2], vec[3])

function cart2tern(x, y)
    c = (2 * y) / √3
    b = x - c / 2
    a = 1 - b - c
    return (a, b, c)
end
cart2tern(array) = cart2tern(array[1], array[2])
