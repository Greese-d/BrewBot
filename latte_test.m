function latte_test(robot)
q = robot.model.getpos();
for i = 0:0.05:2*pi
    q(5) = i;
    robot.model.animate(q)
    pause(0.01)
end

end

