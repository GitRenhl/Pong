TESTState = Class {__includes = BaseState}

function TESTState:init()
    print("test init")
end
function TESTState:update(dt)
    print("test update", dt)
end
function TESTState:render()
    print("test render")
end
function TESTState:enter(data)
    print("test enter", data)
end
function TESTState:exit()
    print("test exit")
end
