        %% Reset environement + update verticies 
        function obj = resetVertices(obj, hObject)
            % Reset the environment using initialEnvironment method
            [filler, obj.cup, obj.cupLid, obj.milkJug, obj.portafilter] = obj.envSetup.initialEnvironment();
        
            obj.cupVertices = get(obj.cup, 'Vertices');
            obj.cupLidVertices = get(obj.cupLid, 'Vertices');
            obj.milkJugVertices = get(obj.milkJug, 'Vertices');
            obj.portafilterVertices = get(obj.portafilter, 'Vertices');
        
            % Display confirmation
            disp('Environment has been reset and object references updated.');
        end