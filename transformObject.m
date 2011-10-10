function newObj = transformObject(object, prevx)
        newObj = object;
        
        model = object.model;
        transVec = object.transVector;
        
        % translate back to centre of rotation
        vec = -transVec;
        model = translate(model,vec(1),vec(2),vec(3));
        
        % update to new rotations
        model = rotateX(model,prevx(4));
        model = rotateY(model,prevx(5));
        model = rotateZ(model,prevx(6));
        
        % now translate back and add extra translation
        vec = transVec + prevx(1:3);
        model = translate(model,vec(1),vec(2),vec(3));
        
        newObj.model = model;