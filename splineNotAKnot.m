function M = splineNotAKnot(n,h,y)
%% Descri��o
% A fun��o splineNotAKnot resolve o sistema de eqau��es 
% lineares necess�rio para determinar o valor da sengunda derivada
% de cada um dos n�s do spline not a knot interpolador (i.e. com 
% continuidade na terceira derivada nos n�s 1 e n-1), com 
% espa�amento uniforme. 
% A fun��o recebe como input:
%   -n: n�mero de tro�os do polin�mio interpolador
%   -h: espa�amento (uniforme) usado na interpola��o
%   -y: o vetor dos valores da fun��o interpolada em cada n�
% Retorna o vetor M das segundas derivadas em cada um dos n�s

%% Criar matriz spline not a knot
% Podemos reduzir o problema do spline not a knot � resolu��o 
% de um sistema de equa��es lineares representado por uma matriz 
% de dimens�es n+1 x n+1 (cf. relat�rio)

    % criar a matriz A e B correspondente ao sistema de 
    % equa��es lineares (AM=B) que pretendemos resolver 
    % (cf. relat�rio)
    A = 4*diag(ones(n+1,1),0)+diag(ones(n,1),1)+diag(ones(n,1),-1);
    A(1,1:3) = [-1 2 -1];
    A(n+1,n-1:n+1) = [-1 2 -1];
    B = zeros(n+1,1);
    % introduzir os valores de B a partir do espamento, h, e vetor y 
    % (cf. relat�rio)
    for i = 1:n-1
        B(i+1) = (6/h^2)*(y(i+2)-2*y(i+1)+y(i));
    end
    % resolver o sistema de equa��es lineares
    M = A\B;
    
end
