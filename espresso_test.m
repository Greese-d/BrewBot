function espresso_test(robot)
q = robot.model.getpos();
for i = 0:0.05:2*pi
    q(1) = i;
    robot.model.animate(q)
    pause(0.01)
end

end

