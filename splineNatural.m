function M = splineNatural(n,h,y)
%% Descri��o
% A fun��o splineNatural resolve o sistema de eqau��es lineares
% necess�rio para determinar o valor da sengunda derivada de cada
% um dos n�s do spline natural interpolador, com espa�amento uniforme. 
% A fun��o recebe como input:
%   -n: n�mero de tro�os do polin�mio interpolador
%   -h: espa�amento (uniforme) usado na interpola��o
%   -y: o vetor dos valores da fun��o interpolada em cada n�
% Retorna o vetor M das segundas derivadas em cada um dos n�s

%% Criar matriz spline natural
% Podemos reduzir o problema do spline natural � resolu��o de um 
% sistema de equa��es lineares representado por uma matriz 
% tridiagonal de dimens�es n-1 x n-1 uma vez que M0 = 0 e Mn = n
% (cf. relat�rio)
    
    % Vetor dos n+1 valores das segundas derivadas em cada n�
    M = zeros(n+1,1); 
    % criar a matriz A tridiagonal e B correspondente ao 
    % sistema linear (AM=B) que pretendemos resolver (cf. relat�rio)
    %A = 4*diag(ones(n-1,1),0)+diag(ones(n-2,1),1)+...
                                        %diag(ones(n-2,1),-1);
    B = zeros(n-1,1);
    % introduzir os valores de B a partir do espamento, h, e vetor y 
    % (cf. relat�rio)
    for i = 1:n-1
        B(i) = (6/h^2)*(y(i+2)-2*y(i+1)+y(i));
    end

    % As diagonais t�m de ser passadas com a mesma dimens�o,
    % no entanto, a(1) e c(end), os valores que ficariam 
    % indefinidos n�o s�o usados pelo agoritmo
    M(2:n) = Thomas(ones(n-1,1),4*ones(n-1,1),ones(n-1,1),B);

    
end

