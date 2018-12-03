function M = splineClamped(n,h,D,y)
%% Descri��o
% A fun��o splineClamped resolve o sistema de eqau��es lineares 
% necess�rio para determinar o valor da sengunda derivada de cada
% um dos n�s do spline completo interpolador, com espa�amento 
% uniforme. 
% A fun��o recebe como input:
%   -n: n�mero de tro�os do polin�mio interpolador
%   -h: espa�amento (uniforme) usado na interpola��o
%   -D: vetor (2x1) que corresponde �s derivadas da fun��o interpolada
% nos n�s extremos 
%   -y: o vetor dos valores da fun��o interpolada em cada n�
% Retorna o vetor M das segundas derivadas em cada um dos n�s
    
%% Criar matriz spline completo
% Podemos reduzir o problema do spline completo � resolu��o de um 
% sistema de equa��es lineares representado por uma matriz tridiagonal
% de dimens�es n+1 x n+1 (cf. relat�rio)
    
    % criar a matriz A tridiagonal e B correspondente ao sistema 
    % linear (AM=B) que pretendemos resolver (cf. relat�rio)
    % A tem a seguinte representa��o, no entanto, consideremos apenas 
    %as suas digonais por forma a poupar mem�ria
    %A = 4*diag(ones(n+1,1),0)+diag(ones(n,1),1)+diag(ones(n,1),-1);
    %A(1,1:2) = [2 1];
    %A(n+1,n:n+1) = [1 2];
    
    
    % introduzir os valores de B a partir do espamento, h, e vetor y 
    %(cf. relat�rio)
    B = zeros(n+1,1);
    B(1) = (6/h)*((y(2)-y(1))/h-D(1));
    for i = 1:n-1
        B(i+1) = (6/h^2)*(y(i+2)-2*y(i+1)+y(i));
    end
    B(n+1) = (6/h)*(D(2)-(y(n+1)-y(n))/h);
    
    %M = A\B;
    % resolver o sistema de equa��es lineares
    d = 4*ones(n+1,1);
    d(1) = 2;
    d(end) = 2;
    % As diagonais t�m de ser passadas com a mesma dimens�o, 
    % no entanto, a(1) e c(end), os valores que ficariam indefinidos 
    % n�o s�o usados pelo agoritmo
    M = Thomas(ones(n+1,1), d, ones(n+1,1), B);
    

end
