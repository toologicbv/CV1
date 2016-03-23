function matrix=loadMatrixFromFile(filename)

    foo = load(filename);
    variables = fieldnames(foo);
    matrix = foo.(variables{1});

end % loadMatrixFromFile