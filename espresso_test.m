function espresso_test(robot, hObject)
q = robot.model.getpos();
for i = 0:0.05:2*pi
    handles = guidata(hObject);
    
    if handles.isStopped
        disp("Proccess interupted by emStop")
        return;
    end

    q(1) = i;
    robot.model.animate(q)
    pause(0.01)
    drawnow;
end

end

